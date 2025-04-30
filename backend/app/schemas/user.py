from pydantic import BaseModel, EmailStr
from typing import Optional, Union
from datetime import datetime
from enum import Enum

class Gender(str, Enum):
    MALE = "MALE"
    FEMALE = "FEMALE"
    OTHER = "OTHER"

    def __str__(self):
        return self.value

class UserStatus(str, Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"
    SUSPENDED = "SUSPENDED"

    def __str__(self):
        return self.value

class UserRole(str, Enum):
    ADMIN = "admin"
    TEACHER = "teacher"
    PARENT = "parent"
    STUDENT = "student"

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