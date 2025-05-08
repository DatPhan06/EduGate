from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from ..enums.user_enums import UserStatus # Gender is in UserPersonalDetails
from .common_schema import UserContactDetails, UserPersonalDetails, UserAddressDetails

# Specific student info parts
class StudentCoreInfo(BaseModel):
    id: int
    studentId: int 
    name: str

class StudentAcademicDetails(BaseModel):
    EnrollmentDate: Optional[datetime] = None
    YtDate: Optional[datetime] = None
    classId: Optional[int] = None
    classGrade: Optional[str] = None
    className: Optional[str] = None

class StudentFamilyDetails(BaseModel):
    parentName: Optional[str] = None

# Comprehensive StudentRead schema by inheriting smaller parts
class StudentRead(
    StudentCoreInfo, 
    UserContactDetails, 
    UserPersonalDetails, 
    UserAddressDetails, 
    StudentAcademicDetails, 
    StudentFamilyDetails
):
    Status: Optional[UserStatus] = None # This was in the previous StudentRead, kept here

    model_config = {
        "from_attributes": True,
        "use_enum_values": True
    } 