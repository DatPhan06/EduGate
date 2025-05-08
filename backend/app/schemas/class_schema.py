from pydantic import BaseModel
from typing import Optional, List

# Base schema for Class
class ClassBase(BaseModel):
    ClassName: str
    GradeLevel: str
    AcademicYear: str
    HomeroomTeacherID: Optional[int] = None

# Schema for creating a new class
class ClassCreate(ClassBase):
    pass

# Schema for updating an existing class (all fields optional)
class ClassUpdate(BaseModel):
    ClassName: Optional[str] = None
    GradeLevel: Optional[str] = None
    AcademicYear: Optional[str] = None
    HomeroomTeacherID: Optional[int] = None

# Schema for reading/returning class information
class ClassRead(ClassBase):
    ClassID: int
    teacherName: Optional[str] = None
    totalStudents: int = 0

    model_config = {
        "from_attributes": True
    }

class ClassReadWithOptionalTeacher(ClassBase):
    ClassID: int
    teacherName: Optional[str] = None # To handle cases where teacher might not be found or is null
    totalStudents: int = 0
    
    model_config = {
        "from_attributes": True
    } 