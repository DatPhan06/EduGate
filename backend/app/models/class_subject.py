from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime

class ClassSubject(Base):
    __tablename__ = "class_subjects"

    ClassSubjectID = Column(Integer, primary_key=True, index=True)
    TeacherID = Column(Integer, ForeignKey("teachers.TeacherID"))
    ClassID = Column(Integer, ForeignKey("classes.ClassID"))
    SubjectID = Column(Integer, ForeignKey("subjects.SubjectID"))
    Semester = Column(String)
    AcademicYear = Column(String)
    UpdatedAt = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    teacher = relationship("Teacher", back_populates="class_subjects")
    class_ = relationship("Class", back_populates="class_subjects")
    subject = relationship("Subject", back_populates="class_subjects")
    grades = relationship("Grade", back_populates="class_subject")
    schedules = relationship("SubjectSchedule", back_populates="class_subject", cascade="all, delete-orphan") 