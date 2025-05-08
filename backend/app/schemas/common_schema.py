from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from ..enums.user_enums import Gender # Assuming enums are accessible

class UserContactDetails(BaseModel):
    Email: Optional[EmailStr] = None
    PhoneNumber: Optional[str] = None

class UserPersonalDetails(BaseModel):
    DOB: Optional[datetime] = None
    PlaceOfBirth: Optional[str] = None
    Gender: Optional[Gender]

class UserAddressDetails(BaseModel):
    Street: Optional[str] = None
    District: Optional[str] = None
    City: Optional[str] = None
    Address: Optional[str] = None # Composite address if available 