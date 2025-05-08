from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime

# Base schema for Student
class StudentBase(BaseModel):
    UserID: int = Field(..., description="ID của người dùng")
    ClassID: Optional[int] = Field(None, description="ID của lớp học")

# Schema for student creation
class StudentCreate(StudentBase):
    pass

# Schema for student update
class StudentUpdate(BaseModel):
    ClassID: Optional[int] = Field(None, description="ID của lớp học")
    EnrollmentDate: Optional[datetime] = Field(None, description="Ngày nhập học")

# Schema for student response
class StudentResponse(StudentBase):
    StudentID: int = Field(..., description="ID của học sinh")
    Name: str = Field(..., description="Tên học sinh")
    Email: Optional[str] = Field(None, description="Email của học sinh")
    ClassName: Optional[str] = Field(None, description="Tên lớp")
    EnrollmentDate: datetime = Field(..., description="Ngày nhập học")
    ParentName: Optional[str] = Field(None, description="Tên phụ huynh")

    class Config:
        orm_mode = True

# Schema for student detailed info
class StudentDetail(StudentResponse):
    GradeLevel: Optional[str] = Field(None, description="Khối lớp")
    AcademicYear: Optional[str] = Field(None, description="Năm học")
    HomeroomTeacher: Optional[str] = Field(None, description="Giáo viên chủ nhiệm")

    class Config:
        orm_mode = True

# Schema for parent of student
class ParentInfo(BaseModel):
    ParentID: int = Field(..., description="ID của phụ huynh")
    UserID: int = Field(..., description="ID của người dùng")
    Name: str = Field(..., description="Tên phụ huynh")
    Email: Optional[str] = Field(None, description="Email của phụ huynh")
    Phone: Optional[str] = Field(None, description="Số điện thoại")
    Relationship: Optional[str] = Field(None, description="Mối quan hệ với học sinh")

    class Config:
        orm_mode = True

# Schema for student with parent info
class StudentWithParent(StudentResponse):
    parents: List[ParentInfo] = Field([], description="Danh sách phụ huynh")

    class Config:
        orm_mode = True

# Schema for paginated student list response
class StudentListResponse(BaseModel):
    total: int = Field(..., description="Tổng số học sinh")
    page: int = Field(..., description="Trang hiện tại")
    size: int = Field(..., description="Số lượng học sinh mỗi trang")
    items: List[StudentResponse] = Field(..., description="Danh sách học sinh") 