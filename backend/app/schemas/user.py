from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional, Union
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
    
    # Fields for Student
    ClassID: Optional[int] = None
    YtDate: Optional[datetime] = None
    
    # Fields for Teacher
    DepartmentID: Optional[int] = None
    Graduate: Optional[str] = None
    Degree: Optional[str] = None
    Position: Optional[str] = None
    
    # Fields for Parent
    Occupation: Optional[str] = None

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
    
    # Fields for Student
    ClassID: Optional[int] = None
    YtDate: Optional[datetime] = None
    
    # Fields for Teacher
    DepartmentID: Optional[int] = None
    Graduate: Optional[str] = None
    Degree: Optional[str] = None
    Position: Optional[str] = None
    
    # Fields for Parent
    Occupation: Optional[str] = None

    class Config:
        use_enum_values = True

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