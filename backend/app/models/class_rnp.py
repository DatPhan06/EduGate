from sqlalchemy import Column, Integer, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class ClassRNP(Base):
    __tablename__ = "class_rnps"

    ClassRNPID = Column(Integer, primary_key=True, index=True)
    ClassID = Column(Integer, ForeignKey("classes.ClassID"))
    RecordID = Column(Integer, ForeignKey("reward_punishments.RecordID"))

    class_ = relationship("Class", back_populates="class_rnps")
    reward_punishment = relationship("RewardPunishment", back_populates="class_rnps") 