from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Student(Base):
    __tablename__ = "students"

    StudentID = Column(Integer, ForeignKey("users.UserID"), primary_key=True)
    ClassID = Column(Integer, ForeignKey("classes.ClassID"))
    EnrollmentDate = Column(DateTime, default=datetime.datetime.utcnow)
    YtDate = Column(DateTime, nullable=True)  # Assuming this is YUDate, please clarify

    user = relationship("User", back_populates="student")
    class_ = relationship("Class", back_populates="students")
    parent_students = relationship("ParentStudent", back_populates="student")
    grades = relationship("Grade", back_populates="student")
    daily_progress_reports = relationship("DailyProgress", back_populates="student")
    rewards_and_punishments = relationship("RewardPunishment", back_populates="student") 