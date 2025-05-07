from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class Class(Base):
    __tablename__ = "classes"

    ClassID = Column(Integer, primary_key=True, index=True)
    ClassName = Column(String)
    GradeLevel = Column(String)
    AcademicYear = Column(String)
    HomeroomTeacherID = Column(Integer, ForeignKey("teachers.TeacherID"))

    students = relationship("Student", back_populates="class_")
    class_subjects = relationship("ClassSubject", back_populates="class_")
    homeroom_teacher = relationship("Teacher", foreign_keys=[HomeroomTeacherID], back_populates="homeroom_classes")
    class_posts = relationship("ClassPost", back_populates="class_") 