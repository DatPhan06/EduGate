from sqlalchemy import Column, Integer, String, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class RNPType(enum.Enum):
    REWARD = "reward"
    PUNISHMENT = "punishment"

class RewardPunishment(Base):
    __tablename__ = "reward_punishments"

    RecordID = Column(Integer, primary_key=True, index=True)
    Title = Column(String)
    Type = Column(Enum(RNPType))
    Description = Column(String)
    Date = Column(DateTime)
    Semester = Column(String)
    Week = Column(Integer)

    StudentID = Column(Integer, ForeignKey("students.StudentID"))
    AdminID = Column(Integer, ForeignKey("administrative_staffs.AdminID"))

    student = relationship("Student", back_populates="rewards_and_punishments")
    administrative_staff = relationship("AdministrativeStaff", back_populates="issued_rewards_and_punishments") 