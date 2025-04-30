from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Grade(Base):
    __tablename__ = "grades"

    GradeID = Column(Integer, primary_key=True, index=True)
    StudentID = Column(Integer, ForeignKey("students.StudentID"))
    ClassSubjectID = Column(Integer, ForeignKey("class_subjects.ClassSubjectID"))
    FinalScore = Column(Float)
    Semester = Column(String)
    UpdatedAt = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    student = relationship("Student", back_populates="grades")
    class_subject = relationship("ClassSubject", back_populates="grades")
    grade_components = relationship("GradeComponent", back_populates="grade") 