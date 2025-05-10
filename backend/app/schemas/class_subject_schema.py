from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from .subject_schedule_schema import SubjectScheduleRead
from .subject_schema import SubjectBasicInfo

# Base ClassSubject schema with common attributes
class ClassSubjectBase(BaseModel):
    ClassID: int
    SubjectID: int
    Semester: str
    AcademicYear: str

# Schema for creating a new class subject
class ClassSubjectCreate(ClassSubjectBase):
    TeacherID: Optional[int] = None

# Schema for updating an existing class subject
class ClassSubjectUpdate(BaseModel):
    TeacherID: Optional[int] = None
    Semester: Optional[str] = None
    AcademicYear: Optional[str] = None

# Schema for reading class subject data
class ClassSubjectRead(ClassSubjectBase):
    ClassSubjectID: int
    TeacherID: Optional[int] = None
    UpdatedAt: datetime

    class Config:
        orm_mode = True

# Extended schema that includes subject schedules
class ClassSubjectWithSchedules(ClassSubjectRead):
    schedules: List[SubjectScheduleRead] = []
    subject: SubjectBasicInfo

    class Config:
        from_attributes = True 