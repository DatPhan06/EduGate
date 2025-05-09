from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import List, Any

from .. import schemas, models
from ..services import message_service, auth_service # auth_service is already imported for get_current_user_email, now for get_current_active_user
from ..database import get_db
from ..enums.user_enums import UserRole

# Dependency to get the current active user is now imported from auth_service
# Removed local definition of get_current_active_user

# Admin check dependency
async def get_current_active_admin_user(current_user: models.User = Depends(auth_service.get_current_active_user)):
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="The user doesn't have enough privileges")
    return current_user

router = APIRouter(
    prefix="/admin/conversations",
    tags=["Admin - Conversations"],
    dependencies=[Depends(get_current_active_admin_user)]
)

@router.get("", response_model=List[schemas.ConversationRead])
def admin_get_all_conversations(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Admin: Get all conversations with pagination.
    Includes participants and the last message for preview.
    """
    return message_service.get_all_conversations_admin(db=db, skip=skip, limit=limit)

@router.get("/{conversation_id}", response_model=schemas.ConversationRead)
def admin_get_conversation_details(
    conversation_id: int,
    db: Session = Depends(get_db)
):
    """
    Admin: Get detailed information about a specific conversation, including all messages and participants.
    """
    conversation = message_service.get_conversation_details_admin(db=db, conversation_id=conversation_id)
    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found")
    return conversation

@router.put("/{conversation_id}", response_model=schemas.ConversationRead)
def admin_update_conversation(
    conversation_id: int,
    conversation_data: schemas.ConversationUpdateAdmin,
    db: Session = Depends(get_db)
):
    """
    Admin: Update a conversation's details (e.g., name).
    """
    updated_conversation = message_service.update_conversation_admin(db=db, conversation_id=conversation_id, conversation_data=conversation_data)
    if not updated_conversation:
        # This case should be handled by exceptions in the service layer for not found
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found for update")
    return updated_conversation

@router.delete("/{conversation_id}", status_code=status.HTTP_204_NO_CONTENT)
def admin_delete_conversation(
    conversation_id: int,
    db: Session = Depends(get_db)
):
    """
    Admin: Delete a conversation, its participations, and messages.
    """
    success = message_service.delete_conversation_admin(db=db, conversation_id=conversation_id)
    if not success:
        # This case should ideally be covered by exceptions in the service layer
        # For instance, if delete_conversation_admin raises HTTPException for not found or other errors
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to delete conversation")
    return None # Return 204 No Content on success

@router.post("/{conversation_id}/participants", response_model=schemas.ConversationRead)
def admin_add_participants_to_conversation(
    conversation_id: int,
    payload: schemas.ConversationParticipantsUpdate, # Changed from List[int] to the new schema
    db: Session = Depends(get_db)
):
    """
    Admin: Add one or more participants to a conversation.
    The request body should be a Pydantic model: ConversationParticipantsUpdate
    e.g., {"user_ids": [1, 2, 3]}
    """
    message_service.add_participants_to_conversation(db=db, conversation_id=conversation_id, user_ids=payload.user_ids)
    
    updated_conversation = message_service.get_conversation_details_admin(db=db, conversation_id=conversation_id)
    if not updated_conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found after adding participants")
    return updated_conversation

@router.delete("/{conversation_id}/participants", response_model=schemas.ConversationRead)
def admin_remove_participants_from_conversation(
    conversation_id: int,
    payload: schemas.ConversationParticipantsUpdate, # Changed from List[int] to the new schema
    db: Session = Depends(get_db)
):
    """
    Admin: Remove one or more participants from a conversation.
    The request body should be a Pydantic model: ConversationParticipantsUpdate
    e.g., {"user_ids": [1, 2, 3]}
    """
    message_service.remove_participants_from_conversation(db=db, conversation_id=conversation_id, user_ids=payload.user_ids)
    
    updated_conversation = message_service.get_conversation_details_admin(db=db, conversation_id=conversation_id)
    if not updated_conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found after removing participants")
    return updated_conversation

# To use this router, you would include it in your main app.py or similar:
# from .routers import admin_conversation_router
# app.include_router(admin_conversation_router.router) 