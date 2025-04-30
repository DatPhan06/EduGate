from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from enum import Enum

class Gender(str, Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"

class UserStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"

class UserBase(BaseModel):
    FirstName: str
    LastName: str
    Email: EmailStr
    PhoneNumber: Optional[str] = None
    DOB: Optional[datetime] = None
    PlaceOfBirth: Optional[str] = None
    Gender: Optional[Gender] = None
    Address: Optional[str] = None
    Status: UserStatus = UserStatus.ACTIVE

class UserCreate(UserBase):
    Password: str

class UserLogin(BaseModel):
    Email: EmailStr
    Password: str

class UserUpdate(BaseModel):
    FirstName: Optional[str] = None
    LastName: Optional[str] = None
    PhoneNumber: Optional[str] = None
    DOB: Optional[datetime] = None
    PlaceOfBirth: Optional[str] = None
    Gender: Optional[Gender] = None
    Address: Optional[str] = None
    Status: Optional[UserStatus] = None

class User(UserBase):
    UserID: int
    CreatedAt: datetime
    UpdatedAt: datetime

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None 