from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from ..enums.user_enums import Gender, UserStatus, UserRole

class UserBase(BaseModel):
    FirstName: str
    LastName: str
    Email: EmailStr
    Street: Optional[str] = None
    District: Optional[str] = None
    City: Optional[str] = None
    PhoneNumber: Optional[str] = None
    DOB: Optional[datetime] = None
    PlaceOfBirth: Optional[str] = None
    Gender: Optional[Gender]
    Address: Optional[str] = None
    Status: UserStatus = UserStatus.ACTIVE
    role: Optional[UserRole] = UserRole.STUDENT

    class Config:
        use_enum_values = True

class UserCreate(UserBase):
    Password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    FirstName: Optional[str] = None
    LastName: Optional[str] = None
    Street: Optional[str] = None
    District: Optional[str] = None
    City: Optional[str] = None
    PhoneNumber: Optional[str] = None
    DOB: Optional[datetime] = None
    PlaceOfBirth: Optional[str] = None
    Gender: Optional[Gender]
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

class ChangePassword(BaseModel):
    currentPassword: str
    newPassword: str