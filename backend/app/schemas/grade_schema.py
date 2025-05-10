from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime


class GradeComponentBase(BaseModel):
    ComponentName: str
    Weight: float
    Score: Optional[float] = None


class GradeComponentCreate(GradeComponentBase):
    pass


class GradeComponentUpdate(BaseModel):
    ComponentName: Optional[str] = None
    Weight: Optional[float] = None
    Score: Optional[float] = None


class GradeComponentResponse(GradeComponentBase):
    ComponentID: int
    GradeID: int
    SubmitDate: datetime

    class Config:
        orm_mode = True


class GradeBase(BaseModel):
    StudentID: int
    ClassSubjectID: int
    FinalScore: Optional[float] = None
    Semester: str


class GradeCreate(GradeBase):
    components: List[GradeComponentCreate] = []


class GradeUpdate(BaseModel):
    FinalScore: Optional[float] = None
    Semester: Optional[str] = None
    components: Optional[List[GradeComponentCreate]] = None


class GradeResponse(GradeBase):
    GradeID: int
    UpdatedAt: datetime
    components: List[GradeComponentResponse] = []

    class Config:
        orm_mode = True 