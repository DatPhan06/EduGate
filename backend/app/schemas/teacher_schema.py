from pydantic import BaseModel
from typing import Optional

# Schema cơ bản cho thông tin giáo viên
class TeacherBasicInfo(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: Optional[str] = None
    # Bạn có thể thêm các trường khác nếu cần, ví dụ: Position
    Position: Optional[str] = None 

    model_config = {"from_attributes": True}

# Schema for reading/returning teacher information
class TeacherRead(BaseModel):
    id: int # Maps to User.UserID / Teacher.TeacherID
    name: str # Concatenation of User.FirstName and User.LastName
    specialization: Optional[str] = None # Derived from Teacher.Degree or other relevant field

    model_config = {
        "from_attributes": True # Allow ORM mode
    } 

class TeacherCreate(BaseModel): # Thường sẽ là một phần của UserCreate
    pass

class TeacherUpdate(BaseModel): # Thường sẽ là một phần của UserUpdate
    DepartmentID: Optional[int] = None
    Graduate: Optional[str] = None
    Degree: Optional[str] = None
    Position: Optional[str] = None 