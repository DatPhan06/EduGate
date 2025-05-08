from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime

# Base schema for Class
class ClassBase(BaseModel):
    ClassName: str = Field(..., description="Tên lớp")
    GradeLevel: str = Field(..., description="Khối lớp")
    AcademicYear: str = Field(..., description="Năm học")
    HomeroomTeacherID: Optional[int] = Field(None, description="ID của giáo viên chủ nhiệm")

# Schema for class creation
class ClassCreate(ClassBase):
    pass

# Schema for class update
class ClassUpdate(BaseModel):
    ClassName: Optional[str] = Field(None, description="Tên lớp")
    GradeLevel: Optional[str] = Field(None, description="Khối lớp")
    AcademicYear: Optional[str] = Field(None, description="Năm học")
    HomeroomTeacherID: Optional[int] = Field(None, description="ID của giáo viên chủ nhiệm")

# Schema for class response
class ClassResponse(ClassBase):
    ClassID: int = Field(..., description="ID của lớp")
    TeacherName: Optional[str] = Field(None, description="Tên giáo viên chủ nhiệm")
    StudentCount: int = Field(0, description="Số lượng học sinh trong lớp")

    class Config:
        orm_mode = True

# Schema for student in class
class StudentInClass(BaseModel):
    StudentID: int = Field(..., description="ID của học sinh")
    UserID: int = Field(..., description="ID của người dùng")
    Name: str = Field(..., description="Tên học sinh")
    Email: Optional[str] = Field(None, description="Email của học sinh")
    EnrollmentDate: datetime = Field(..., description="Ngày nhập học")

    class Config:
        orm_mode = True

# Schema for paginated class list response
class ClassListResponse(BaseModel):
    total: int = Field(..., description="Tổng số lớp")
    page: int = Field(..., description="Trang hiện tại")
    size: int = Field(..., description="Số lượng lớp mỗi trang")
    items: List[ClassResponse] = Field(..., description="Danh sách lớp")

# Schema for teacher information
class TeacherInfo(BaseModel):
    TeacherID: int = Field(..., description="ID của giáo viên")
    UserID: int = Field(..., description="ID của người dùng")
    Name: str = Field(..., description="Tên giáo viên")
    Email: Optional[str] = Field(None, description="Email của giáo viên")
    Department: Optional[str] = Field(None, description="Bộ môn")
    Position: Optional[str] = Field(None, description="Chức vụ")

    class Config:
        orm_mode = True

# Schema for adding/removing student from class
class StudentClassAssignment(BaseModel):
    StudentID: int = Field(..., description="ID của học sinh")
    ClassID: int = Field(..., description="ID của lớp")

# Schema for detailed class info with students
class ClassWithStudents(ClassResponse):
    students: List[StudentInClass] = Field([], description="Danh sách học sinh trong lớp")

    class Config:
        orm_mode = True 