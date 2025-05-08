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

    if len(participant_ids) < 2:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A conversation needs at least two participants.")

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
