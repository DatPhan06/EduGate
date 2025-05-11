from sqlalchemy.orm import Session, joinedload
from sqlalchemy import desc, or_, func
from typing import List, Optional
import datetime

from .. import models, schemas
from ..models import User, Conversation, Message, Participation
from fastapi import HTTPException, status

def get_user_conversations(db: Session, user_id: int) -> List[schemas.ConversationPreview]:
    """
    Retrieves all conversations for a given user, ordered by the most recent message.
    Includes the last message and participants for preview.
    """
    participations = db.query(models.Participation).filter(models.Participation.UserID == user_id).all()
    conversation_ids = [p.ConversationID for p in participations]

    conversations = db.query(models.Conversation)\
        .filter(models.Conversation.ConversationID.in_(conversation_ids))\
        .options(
            joinedload(models.Conversation.participations).joinedload(models.Participation.user),
            joinedload(models.Conversation.messages).joinedload(models.Message.user) # Eager load users for messages
        )\
        .order_by(desc(models.Conversation.CreatedAt))\
        .all()  # Use CreatedAt for sorting

    previews = []
    for conv in conversations:
        last_msg = db.query(models.Message)\
            .filter(models.Message.ConversationID == conv.ConversationID)\
            .order_by(desc(models.Message.SentAt))\
            .first()
        
        participants_schemas = [schemas.UserSimple.from_orm(part.user) for part in conv.participations]

        previews.append(schemas.ConversationPreview(
            ConversationID=conv.ConversationID,
            Name=conv.Name,
            CreatedAt=conv.CreatedAt,  # Use CreatedAt 
            last_message=schemas.MessageRead.from_orm(last_msg) if last_msg else None,
            participants=participants_schemas
        ))
    return previews

def create_conversation(db: Session, conversation_data: schemas.ConversationCreate, current_user_id: int) -> schemas.ConversationRead:
    """
    Creates a new conversation and adds participants.
    The current_user_id is automatically added to participant_ids if not present.
    """
    participant_ids = set(conversation_data.participant_ids)
    participant_ids.add(current_user_id) # Ensure creator is a participant

    # Comment out or remove the check for minimum participants
    # if len(participant_ids) < 2:
    #     raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A conversation needs at least two participants.")

    # Check if a conversation with the exact same set of participants (excluding one-on-one names) already exists
    # For group chats (more than 2 people), or if a name is provided, allow creation.
    # For 1-on-1 chats without a name, check for existing.
    if len(participant_ids) == 2 and not conversation_data.Name:
        # Query for conversations involving both users
        user1_id = current_user_id
        user2_id = list(participant_ids - {current_user_id})[0]

        existing_conversation = db.query(Conversation) \
            .join(Participation, Conversation.ConversationID == Participation.ConversationID) \
            .filter(Conversation.Name == None) \
            .filter(or_(
                (Participation.UserID == user1_id),
                (Participation.UserID == user2_id)
            )) \
            .group_by(Conversation.ConversationID) \
            .having(func.count(Participation.UserID) == 2) \
            .first()

        # Further check if this conversation specifically contains *only* these two users
        if existing_conversation:
            actual_participants = {p.UserID for p in existing_conversation.participations}
            if actual_participants == {user1_id, user2_id}:
                 # Optionally, you could return the existing conversation instead of raising an error
                 # return get_conversation(db, existing_conversation.ConversationID, current_user_id)
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="A 1-on-1 conversation with this user already exists."
                )


    db_conversation = models.Conversation(
        Name=conversation_data.Name,
        NumOfParticipation=len(participant_ids),
    )
    db.add(db_conversation)
    db.flush() # To get ConversationID

    for user_id_to_add in participant_ids:
        user = db.query(models.User).filter(models.User.UserID == user_id_to_add).first()
        if not user:
            db.rollback()
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"User with ID {user_id_to_add} not found.")
        db_participation = models.Participation(
            ConversationID=db_conversation.ConversationID,
            UserID=user_id_to_add
        )
        db.add(db_participation)
    
    db.commit()
    db.refresh(db_conversation)
    
    # Eagerly load participants for the response
    db_conversation = db.query(models.Conversation).options(joinedload(models.Conversation.participations).joinedload(models.Participation.user)).filter(models.Conversation.ConversationID == db_conversation.ConversationID).one()
    
    participants_schemas = [schemas.UserSimple.from_orm(part.user) for part in db_conversation.participations]
    
    return schemas.ConversationRead(
        ConversationID=db_conversation.ConversationID,
        Name=db_conversation.Name,
        CreatedAt=db_conversation.CreatedAt,
        messages=[], # No messages yet
        participants=participants_schemas
    )

def get_conversation(db: Session, conversation_id: int, user_id: int) -> Optional[schemas.ConversationRead]:
    """
    Retrieves a specific conversation by its ID, including all messages and participants.
    Ensures the requesting user is a participant.
    """
    conversation = db.query(models.Conversation)\
        .options(
            joinedload(models.Conversation.messages).joinedload(models.Message.user), # Eager load user for each message
            joinedload(models.Conversation.participations).joinedload(models.Participation.user) # Eager load user for each participant
        )\
        .filter(models.Conversation.ConversationID == conversation_id)\
        .first()

    if not conversation:
        return None

    is_participant = db.query(models.Participation)\
        .filter(models.Participation.ConversationID == conversation_id, models.Participation.UserID == user_id)\
        .first()

    if not is_participant:
        return None # Or raise HTTPException for unauthorized access

    # Sort messages by SentAt to ensure chronological ordering
    conversation.messages.sort(key=lambda m: m.SentAt)

    participants_schemas = [schemas.UserSimple.from_orm(part.user) for part in conversation.participations]
    messages_schemas = [schemas.MessageRead.from_orm(msg) for msg in conversation.messages]
    
    return schemas.ConversationRead(
        ConversationID=conversation.ConversationID,
        Name=conversation.Name,
        CreatedAt=conversation.CreatedAt,
        messages=messages_schemas,
        participants=participants_schemas
    )

def create_message(db: Session, conversation_id: int, message_data: schemas.MessageCreate, user_id: int) -> schemas.MessageRead:
    """
    Creates a new message in a given conversation by a user.
    """
    # Check if user is part of the conversation
    participation = db.query(models.Participation).filter(
        models.Participation.ConversationID == conversation_id,
        models.Participation.UserID == user_id
    ).first()

    if not participation:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User not part of this conversation.")

    conversation = db.query(models.Conversation).filter(models.Conversation.ConversationID == conversation_id).first()
    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found.")

    db_message = models.Message(
        ConversationID=conversation_id,
        UserID=user_id,
        Content=message_data.Content,
        SentAt=datetime.datetime.utcnow() # Explicitly set SentAt
    )
    db.add(db_message)
    
    # Note: We can't update UpdatedAt as it doesn't exist in the database
    
    db.commit()
    db.refresh(db_message)
    
    # Eager load user for the message response
    db_message = db.query(models.Message).options(joinedload(models.Message.user)).filter(models.Message.MessageID == db_message.MessageID).one()

    return schemas.MessageRead.from_orm(db_message)

# get_messages_for_conversation is implicitly handled by get_conversation which eager loads messages.
# If a separate endpoint for just messages is needed, it can be added.

# Helper to get user by ID (can be moved to user_service if not already there)
def get_user_by_id(db: Session, user_id: int) -> Optional[models.User]:
    return db.query(models.User).filter(models.User.UserID == user_id).first()

def add_participants_to_conversation(db: Session, conversation_id: int, user_ids: List[int]):
    conversation = db.query(Conversation).filter(Conversation.ConversationID == conversation_id).first()
    if not conversation:
        print(f"Warning: Conversation {conversation_id} not found when trying to add participants.")
        # Hoặc raise HTTPException
        # raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found")
        return

    existing_participant_ids = {p.UserID for p in conversation.participations}
    added_count = 0
    for user_id in user_ids:
        if user_id not in existing_participant_ids:
            # Kiểm tra user có tồn tại không (tùy chọn, có thể bỏ qua nếu chắc chắn user_id hợp lệ)
            user = db.query(User).filter(User.UserID == user_id).first()
            if user:
                db_participation = Participation(
                    ConversationID=conversation.ConversationID,
                    UserID=user_id
                )
                db.add(db_participation)
                added_count += 1
            else:
                print(f"Warning: User {user_id} not found when trying to add to conversation {conversation_id}.")

    if added_count > 0:
        # Cập nhật số lượng thành viên (nếu cần)
        conversation.NumOfParticipation = len(existing_participant_ids) + added_count
        db.commit()
    # Không cần refresh ở đây trừ khi muốn trả về thông tin mới

def remove_participants_from_conversation(db: Session, conversation_id: int, user_ids: List[int]):
    participations_to_delete = db.query(Participation).filter(
        Participation.ConversationID == conversation_id,
        Participation.UserID.in_(user_ids)
    ).all()

    if not participations_to_delete:
        # print(f"Warning: No participants found to remove from conversation {conversation_id} for user IDs {user_ids}")
        return # Không có gì để xóa
    
    conversation = db.query(Conversation).filter(Conversation.ConversationID == conversation_id).first()
    num_removed = 0
    for participation in participations_to_delete:
        db.delete(participation)
        num_removed += 1
        
    if num_removed > 0 and conversation:
        # Cập nhật số lượng thành viên (nếu cần)
        current_participants = db.query(Participation.UserID).filter(Participation.ConversationID == conversation_id).count()
        conversation.NumOfParticipation = current_participants
        db.commit()

# --- Admin Conversation Management Functions ---

def get_all_conversations_admin(db: Session, skip: int = 0, limit: int = 100) -> List[schemas.ConversationRead]:
    """
    Retrieves all conversations, intended for Admin use.
    Includes participants and a snippet of the last message for preview.
    """
    conversations = db.query(models.Conversation)\
        .options(
            joinedload(models.Conversation.participations).joinedload(models.Participation.user),
            # Optionally load last message if needed for an admin preview
            # joinedload(models.Conversation.messages) # This would load ALL messages, be careful
        )\
        .order_by(desc(models.Conversation.CreatedAt))\
        .offset(skip)\
        .limit(limit)\
        .all()

    results = []
    for conv in conversations:
        # Fetch last message separately to avoid loading all messages for all conversations
        last_msg_obj = db.query(models.Message)\
            .filter(models.Message.ConversationID == conv.ConversationID)\
            .order_by(desc(models.Message.SentAt))\
            .first()
        
        participants_schemas = [schemas.UserSimple.from_orm(part.user) for part in conv.participations]
        
        # For admin view, we might use ConversationRead directly or a specialized AdminConversationRead
        # For now, adapting to ConversationRead, messages will be empty unless explicitly fetched by get_conversation_details_admin
        results.append(schemas.ConversationRead(
            ConversationID=conv.ConversationID,
            Name=conv.Name,
            CreatedAt=conv.CreatedAt,
            messages=[schemas.MessageRead.from_orm(last_msg_obj)] if last_msg_obj else [], # Show only last message in this list view
            participants=participants_schemas
        ))
    return results

def get_conversation_details_admin(db: Session, conversation_id: int) -> Optional[schemas.ConversationRead]:
    """
    Retrieves a specific conversation by its ID, including all messages and participants.
    Admin version: Does not check for user participation.
    """
    conversation = db.query(models.Conversation)\
        .options(
            joinedload(models.Conversation.messages).joinedload(models.Message.user),
            joinedload(models.Conversation.participations).joinedload(models.Participation.user)
        )\
        .filter(models.Conversation.ConversationID == conversation_id)\
        .first()

    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found")

    conversation.messages.sort(key=lambda m: m.SentAt) # Ensure chronological order

    participants_schemas = [schemas.UserSimple.from_orm(part.user) for part in conversation.participations]
    messages_schemas = [schemas.MessageRead.from_orm(msg) for msg in conversation.messages]
    
    return schemas.ConversationRead(
        ConversationID=conversation.ConversationID,
        Name=conversation.Name,
        CreatedAt=conversation.CreatedAt,
        messages=messages_schemas,
        participants=participants_schemas
    )

def update_conversation_admin(db: Session, conversation_id: int, conversation_data: schemas.ConversationUpdateAdmin) -> Optional[schemas.ConversationRead]:
    """
    Updates a conversation's details (e.g., name). Admin version.
    """
    db_conversation = db.query(models.Conversation).filter(models.Conversation.ConversationID == conversation_id).first()
    if not db_conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found")

    if conversation_data.Name is not None:
        db_conversation.Name = conversation_data.Name
    
    db.commit()
    db.refresh(db_conversation)
    
    # Return the updated conversation details, similar to get_conversation_details_admin
    return get_conversation_details_admin(db=db, conversation_id=db_conversation.ConversationID)

def delete_conversation_admin(db: Session, conversation_id: int) -> bool:
    """
    Deletes a conversation, its participations, and its messages. Admin version.
    Returns True if deletion was successful, False otherwise.
    """
    db_conversation = db.query(models.Conversation).filter(models.Conversation.ConversationID == conversation_id).first()
    if not db_conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found")

    try:
        # Delete participations first to avoid FK constraint issues if not cascaded from Conversation
        db.query(models.Participation).filter(models.Participation.ConversationID == conversation_id).delete(synchronize_session=False)
        
        # Delete messages as cascade delete is not set on the relationship
        db.query(models.Message).filter(models.Message.ConversationID == conversation_id).delete(synchronize_session=False)

        db.delete(db_conversation)
        db.commit()
        return True
    except Exception as e:
        db.rollback()
        print(f"Error deleting conversation {conversation_id}: {e}") # Log error
        # Consider raising a specific HTTPException for deletion failure
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Could not delete conversation: {e}")

def update_conversation(db: Session, conversation_id: int, conversation_data: schemas.ConversationBase, user_id: int) -> Optional[schemas.ConversationRead]:
    """
    Updates a conversation's details (currently just the name).
    Ensures the requesting user is a participant in the conversation.
    
    Args:
        db: Database session
        conversation_id: ID of the conversation to update
        conversation_data: Data to update (currently only Name)
        user_id: ID of the user making the update
        
    Returns:
        Updated conversation or None if conversation not found or user not authorized
    """
    # Check if user is part of the conversation
    participation = db.query(models.Participation).filter(
        models.Participation.ConversationID == conversation_id,
        models.Participation.UserID == user_id
    ).first()

    if not participation:
        return None  # User not part of conversation

    # Get the conversation
    conversation = db.query(models.Conversation).filter(
        models.Conversation.ConversationID == conversation_id
    ).first()

    if not conversation:
        return None  # Conversation not found

    # Update conversation name
    conversation.Name = conversation_data.Name
    
    db.commit()
    db.refresh(conversation)
    
    # Return full conversation details with participants and messages
    return get_conversation(db, conversation_id, user_id)
