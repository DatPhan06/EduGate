from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class StudentRNP(Base):
    __tablename__ = "student_rnps"

    StudentRNPID = Column(Integer, primary_key=True, index=True)
    RecordID = Column(Integer, ForeignKey("reward_punishments.RecordID"))
    StudentID = Column(Integer, ForeignKey("students.StudentID"))

    reward_punishment = relationship("RewardPunishment", back_populates="student_rnps")
    student = relationship("Student", back_populates="student_rnps") 