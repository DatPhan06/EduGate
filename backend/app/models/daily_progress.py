from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text, Date
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class DailyProgress(Base):
    __tablename__ = "daily_progress"

    DailyID = Column(Integer, primary_key=True, index=True)
    Overall = Column(Text) # Assuming Overall can be a longer text
    Attendance = Column(String) # Consider Enum or specific format
    StudyOutcome = Column(Text) # Assuming StudyOutcome can be a longer text
    Reprimand = Column(Text, nullable=True) # Assuming Reprimand can be a longer text and is optional
    Date = Column(Date) # Using Date type for the report date
    
    TeacherID = Column(Integer, ForeignKey("teachers.TeacherID"))
    StudentID = Column(Integer, ForeignKey("students.StudentID")) # Assuming students table and StudentID PK

    # Relationships
    teacher = relationship("Teacher", back_populates="daily_progress_reports")
    student = relationship("Student", back_populates="daily_progress_reports")

# Add back_populates to Teacher and Student models later
# Teacher model: daily_progress_reports = relationship("DailyProgress", back_populates="teacher")
# Student model: daily_progress_reports = relationship("DailyProgress", back_populates="student") 