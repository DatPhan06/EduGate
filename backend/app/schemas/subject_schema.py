from pydantic import BaseModel
from typing import Optional, List

# Base Subject schema with common attributes
class SubjectBase(BaseModel):
    SubjectName: str
    Description: Optional[str] = None

# Schema for creating a new subject
class SubjectCreate(SubjectBase):
    pass

# Schema for updating an existing subject
class SubjectUpdate(BaseModel):
    SubjectName: Optional[str] = None
    Description: Optional[str] = None

# Schema for reading subject data
class SubjectRead(SubjectBase):
    SubjectID: int

    class Config:
        from_attributes = True

# Schema for a basic subject info used in nested responses
class SubjectBasicInfo(BaseModel):
    SubjectID: int
    SubjectName: str

    class Config:
        from_attributes = True 