from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from ..models.petition import PetitionStatus
from .user import User

# Schema User tối giản cho PetitionResponse
class UserPetition(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: str

    model_config = {
        "from_attributes": True
    }

class PetitionBase(BaseModel):
    Title: str
    Content: str
    Status: PetitionStatus = PetitionStatus.PENDING
    Response: Optional[str] = None

    model_config = {
        "use_enum_values": True
    }

class PetitionCreate(BaseModel):
    Title: str
    Content: str

    model_config = {
        "use_enum_values": True
    }

class PetitionUpdate(BaseModel):
    Status: PetitionStatus
    Response: Optional[str] = None

    model_config = {
        "use_enum_values": True
    }

class PetitionInDB(PetitionBase):
    PetitionID: int
    ParentID: int
    AdminID: Optional[int] = None
    SubmittedAt: datetime

    model_config = {
        "from_attributes": True
    }

class PetitionFileResponse(BaseModel):
    FileID: int
    FileName: str
    FileUrl: str
    FileSize: Optional[int] = None
    ContentType: str

    model_config = {
        "from_attributes": True
    }

class PetitionResponse(PetitionBase):
    PetitionID: int
    ParentID: int
    Status: PetitionStatus
    SubmittedAt: datetime
    AdminID: Optional[int] = None
    Response: Optional[str] = None
    parent: User
    petition_files: List[PetitionFileResponse] = []

    model_config = {
        "from_attributes": True
    }

class PetitionListResponse(BaseModel):
    items: List[PetitionResponse]
    total: int
    page: int
    size: int

class PetitionStatisticsResponse(BaseModel):
    PENDING: int
    APPROVED: int
    REJECTED: int