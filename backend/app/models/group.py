from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Group(Base):
    __tablename__ = "groups"

    GroupID = Column(Integer, primary_key=True, index=True)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    Name = Column(String)
    NumOfParticipation = Column(Integer, default=0)

    events = relationship("Event", back_populates="group")
    user_groups = relationship("UserGroup", back_populates="group") 