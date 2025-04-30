from sqlalchemy import Column, Integer, String, DateTime, Enum
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

    student_rnps = relationship("StudentRNP", back_populates="reward_punishment")
    class_rnps = relationship("ClassRNP", back_populates="reward_punishment") 