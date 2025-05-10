from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from .common_schema import ResponseSchema

# Base Schema for Event with common attributes
class EventBase(BaseModel):
    Title: str
    Type: str
    Content: Optional[str] = None
    EventDate: datetime

# Schema for creating a new Event
class EventCreate(EventBase):
    pass

# Schema for updating an existing Event
class EventUpdate(BaseModel):
    Title: Optional[str] = None
    Type: Optional[str] = None
    Content: Optional[str] = None
    EventDate: Optional[datetime] = None

# Schema for Event response with all details
class EventSchema(EventBase):
    EventID: int
    AdminID: int
    CreatedAt: datetime

    class Config:
        from_attributes = True

# Schema for Event list response
class EventListSchema(ResponseSchema):
    data: List[EventSchema] = []

# Schema for Event file
class EventFileSchema(BaseModel):
    FileID: int
    EventID: int
    FileName: str
    FilePath: str
    FileSize: Optional[int] = None
    ContentType: Optional[str] = None
    SubmittedAt: datetime

    class Config:
        from_attributes = True

# Schema for Event with attached files
class EventWithFilesSchema(EventSchema):
    event_files: List[EventFileSchema] = []

    class Config:
        from_attributes = True 