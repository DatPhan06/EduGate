from pydantic import BaseModel
from typing import List, Optional
import datetime

# Schema for User in Message/Conversation context
class UserSimple(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: str

    model_config = {
        "from_attributes": True
    }

# Message Schemas
class MessageBase(BaseModel):
    Content: str

class MessageCreate(MessageBase):
    pass

class MessageRead(MessageBase):
    MessageID: int
    UserID: int
    SentAt: datetime.datetime
    user: Optional[UserSimple] # Include basic user info

    model_config = {
        "from_attributes": True
    }

# Conversation Schemas
class ConversationBase(BaseModel):
    Name: Optional[str] = None

class ConversationCreate(ConversationBase):
    participant_ids: List[int] # List of UserIDs to be in the conversation

class ConversationRead(ConversationBase):
    ConversationID: int
    CreatedAt: datetime.datetime
    messages: List[MessageRead] = []
    participants: List[UserSimple] = [] # List of users participating

    model_config = {
        "from_attributes": True
    }

class ConversationPreview(ConversationBase):
    ConversationID: int
    CreatedAt: datetime.datetime
    last_message: Optional[MessageRead] = None
    participants: List[UserSimple] = []

    model_config = {
        "from_attributes": True
    }
