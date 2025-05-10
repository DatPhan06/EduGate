from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime

class DailyProgressCreate(BaseModel):
    StudentID: int
    Date: date
    Overall: Optional[str] = None
    Attendance: Optional[str] = None
    StudyOutcome: Optional[str] = None
    Reprimand: Optional[str] = None

class DailyProgressResponse(BaseModel):
    DailyID: int
    StudentID: int
    TeacherID: int
    Date: date
    Overall: Optional[str]
    Attendance: Optional[str]
    StudyOutcome: Optional[str]
    Reprimand: Optional[str]

    class Config:
        from_attributes = True

class StudentResponse(BaseModel):
    StudentID: int
    FirstName: str
    LastName: str
    Email: str
    PhoneNumber: Optional[str]
    Address: Optional[str]
    DateOfBirth: Optional[datetime]
    Gender: Optional[str]
    ClassID: Optional[int]
    ClassName: Optional[str]

    class Config:
        from_attributes = True

class ParentChildResponse(BaseModel):
    StudentID: int
    FirstName: str
    LastName: str
    ClassID: Optional[int]
    ClassName: Optional[str]

    class Config:
        from_attributes = True 