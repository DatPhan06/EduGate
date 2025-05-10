from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class ClassPostBase(BaseModel):
    """Base schema for class posts with common attributes"""
    Title: str
    Type: str
    Content: str
    EventDate: Optional[datetime] = None

class ClassPostCreate(ClassPostBase):
    """Schema for creating a new class post"""
    ClassID: int

class ClassPostUpdate(BaseModel):
    """Schema for updating an existing class post"""
    Title: Optional[str] = None
    Type: Optional[str] = None
    Content: Optional[str] = None
    EventDate: Optional[datetime] = None

class ClassPostRead(ClassPostBase):
    """Schema for reading class post data"""
    PostID: int
    TeacherID: int
    ClassID: int
    CreatedAt: datetime
    
    # Additional fields for API response
    teacher_name: Optional[str] = None
    class_name: Optional[str] = None
    
    class Config:
        from_attributes = True

class ClassPostPagination(BaseModel):
    """Schema for paginated response of class posts"""
    items: List[ClassPostRead]
    total: int
    page: int
    size: int