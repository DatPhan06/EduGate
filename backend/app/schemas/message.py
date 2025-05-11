from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

# Schema cho file tin nhắn
class MessageFileBase(BaseModel):
    FileName: str
    FileSize: int
    ContentType: str

class MessageFileCreate(MessageFileBase):
    pass

class MessageFileRead(MessageFileBase):
    FileID: int
    MessageID: int
    SubmittedAt: datetime

    model_config = {
        "from_attributes": True
    }

# Schema cho tin nhắn
class MessageBase(BaseModel):
    Content: Optional[str] = None

class MessageCreate(MessageBase):
    pass

class MessageRead(MessageBase):
    MessageID: int
    UserID: int
    ConversationID: int
    Content: Optional[str] = None
    SentAt: datetime
    message_files: List[MessageFileRead] = []

    model_config = {
        "from_attributes": True
    }

# Các schemas khác cho hội thoại
class ConversationBase(BaseModel):
    Name: Optional[str] = None
    
class ConversationCreate(ConversationBase):
    participant_ids: List[int]

class ConversationUpdateAdmin(ConversationBase):
    pass

# Schema for updating conversation participants
class ConversationParticipantsUpdate(BaseModel):
    user_ids: List[int] = [] # Allow empty list if that's a valid use case

class UserSimple(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: str

    model_config = {
        "from_attributes": True
    }

class ConversationPreview(BaseModel):
    ConversationID: int
    Name: Optional[str] = None
    CreatedAt: datetime
    last_message: Optional[MessageRead] = None
    participants: List[UserSimple] = []

    model_config = {
        "from_attributes": True
    }

class ConversationRead(BaseModel):
    ConversationID: int
    Name: Optional[str] = None
    CreatedAt: datetime
    messages: List[MessageRead] = []
    participants: List[UserSimple] = []

    model_config = {
        "from_attributes": True
    }
