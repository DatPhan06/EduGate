from pydantic import BaseModel
from typing import Optional

class DepartmentBase(BaseModel):
    Name: str
    Description: Optional[str] = None

class DepartmentCreate(DepartmentBase):
    pass

class DepartmentRead(DepartmentBase):
    DepartmentID: int
    model_config = {"from_attributes": True} 