from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class Teacher(Base):
    __tablename__ = "teachers"

    TeacherID = Column(Integer, ForeignKey("users.UserID"), primary_key=True)
    DepartmentID = Column(Integer, ForeignKey("departments.DepartmentID"), nullable=True)
    Graduate = Column(String)
    Degree = Column(String)
    Position = Column(String)

    user = relationship("User", back_populates="teacher")
    department = relationship("Department", back_populates="teachers")
    class_subjects = relationship("ClassSubject", back_populates="teacher")
    homeroom_classes = relationship("Class", back_populates="homeroom_teacher")
    class_posts = relationship("ClassPost", back_populates="teacher")
    daily_progress_reports = relationship("DailyProgress", back_populates="teacher")
