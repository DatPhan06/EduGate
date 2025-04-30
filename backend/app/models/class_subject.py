from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class ClassSubject(Base):
    __tablename__ = "class_subjects"

    ClassSubjectID = Column(Integer, primary_key=True, index=True)
    TeacherID = Column(Integer, ForeignKey("teachers.TeacherID"))
    ClassID = Column(Integer, ForeignKey("classes.ClassID"))
    SubjectID = Column(Integer, ForeignKey("subjects.SubjectID"))
    Semester = Column(String)
    AcademicYear = Column(String)

    teacher = relationship("Teacher", back_populates="class_subjects")
    class_ = relationship("Class", back_populates="class_subjects")
    subject = relationship("Subject", back_populates="class_subjects")
    grades = relationship("Grade", back_populates="class_subject") 