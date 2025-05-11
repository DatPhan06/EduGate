from fastapi import APIRouter, Depends, HTTPException, status, Header, File, UploadFile, Form
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from typing import List, Optional
import os

from .. import schemas, services, models
from ..database import get_db
from ..services.auth_service import get_current_active_user # Import a centralized function

router = APIRouter(
    prefix="/messaging",
    tags=["messaging"],
    responses={404: {"description": "Not found"}},
)

@router.get("/conversations", response_model=List[schemas.ConversationPreview])
def get_my_conversations(
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Get all conversations for the currently authenticated user.
    """
    return services.message_service.get_user_conversations(db, user_id=current_user.UserID)

@router.post("/conversations", response_model=schemas.ConversationRead, status_code=status.HTTP_201_CREATED)
def create_new_conversation(
    conversation_data: schemas.ConversationCreate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Create a new conversation.
    The current user will automatically be added as a participant.
    `participant_ids` in the request body should be a list of other UserIDs.
    """
    return services.message_service.create_conversation(db, conversation_data=conversation_data, current_user_id=current_user.UserID)

@router.get("/conversations/{conversation_id}", response_model=schemas.ConversationRead)
def get_single_conversation(
    conversation_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Get a specific conversation by its ID, including messages.
    Ensures the current user is a participant.
    """
    conversation = services.message_service.get_conversation(db, conversation_id=conversation_id, user_id=current_user.UserID)
    if not conversation:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversation not found or access denied.")
    return conversation

@router.put("/conversations/{conversation_id}", response_model=schemas.ConversationRead)
def update_conversation(
    conversation_id: int,
    conversation_data: schemas.ConversationBase,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Update a conversation's details.
    Currently only supports changing the conversation name.
    Ensures the current user is a participant.
    """
    updated_conversation = services.message_service.update_conversation(
        db, 
        conversation_id=conversation_id, 
        conversation_data=conversation_data, 
        user_id=current_user.UserID
    )
    
    if not updated_conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Conversation not found or access denied."
        )
    
    return updated_conversation

@router.post("/conversations/{conversation_id}/messages", response_model=schemas.MessageRead, status_code=status.HTTP_201_CREATED)
async def send_message_to_conversation(
    conversation_id: int,
    Content: Optional[str] = Form(None),
    files: List[UploadFile] = File([]),
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Send a message to a specific conversation.
    Supports text content and/or file attachments.
    Ensures the current user is a participant.
    """
    # Kiểm tra xem có ít nhất một trong 2 loại nội dung: text hoặc file
    if Content is None and len(files) == 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Message must contain either text content or file attachments."
        )
    
    # Tạo message_data từ Content (nếu có)
    message_data = schemas.MessageCreate(Content=Content)
    
    # Gọi service để tạo tin nhắn với files
    return await services.message_service.create_message_with_files(
        db, 
        conversation_id=conversation_id, 
        message_data=message_data, 
        user_id=current_user.UserID,
        files=files
    )

# Thêm endpoint để xem file đính kèm
@router.get("/files/{file_id}")
async def get_message_file(
    file_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Get a file attached to a message.
    Ensures the current user is a participant in the conversation containing the message.
    """
    file_data = await services.message_service.get_message_file(
        db, 
        file_id=file_id, 
        user_id=current_user.UserID
    )
    
    if not file_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="File not found or access denied."
        )
    
    file_path = os.path.join("uploads", "messages", str(file_id), file_data.FileName)
    
    if not os.path.exists(file_path):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="File not found on server."
        )
    
    return FileResponse(
        path=file_path,
        filename=file_data.FileName,
        media_type=file_data.ContentType or "application/octet-stream"
    )

# Endpoint to get a list of users (simplified for messaging)
# This might already exist in user_router, but a focused one can be useful.
@router.get("/users", response_model=List[schemas.UserSimple])
def get_all_users_for_messaging(
    skip: int = 0, 
    limit: int = 100, 
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_active_user) # Ensure only logged-in users can fetch user list
):
    """
    Get a list of users to potentially start conversations with.
    Excludes the current user from the list.
    """
    users = db.query(models.User).filter(models.User.UserID != current_user.UserID).offset(skip).limit(limit).all()
    return users

# Thêm endpoint đơn giản để tải file trực tiếp từ thư mục uploads
@router.get("/files/{file_id}/download", include_in_schema=True)
async def download_message_file(file_id: int, db: Session = Depends(get_db)):
    """
    Tải file đính kèm của tin nhắn mà không cần xác thực.
    Chỉ sử dụng cho mục đích demo.
    """
    # Lấy thông tin file từ database
    file = db.query(models.MessageFile).filter(models.MessageFile.FileID == file_id).first()
    if not file:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="File not found."
        )
    
    # Tạo đường dẫn đến file
    file_path = os.path.join("uploads", "messages", str(file_id), file.FileName)
    
    # Kiểm tra sự tồn tại của file
    if not os.path.exists(file_path):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="File not found on server."
        )
    
    # Trả về file
    return FileResponse(
        path=file_path,
        filename=file.FileName,
        media_type=file.ContentType or "application/octet-stream"
    )
