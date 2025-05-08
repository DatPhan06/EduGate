from pydantic import BaseModel
from typing import Optional, List
from .teacher_schema import TeacherBasicInfo

class DepartmentBase(BaseModel):
    DepartmentName: str
    Description: Optional[str] = None

class DepartmentCreate(DepartmentBase):
    pass

class DepartmentRead(DepartmentBase):
    DepartmentID: int
    teachers: List[TeacherBasicInfo] = []
    model_config = {"from_attributes": True} 