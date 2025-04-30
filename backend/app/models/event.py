from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class TargetScope(enum.Enum):
    PUBLIC = "public"
    PRIVATE = "private"
    GROUP = "group"

class Event(Base):
    __tablename__ = "events"

    EventID = Column(Integer, primary_key=True, index=True)
    Creator_ID = Column(Integer, ForeignKey("users.id"))
    GroupID = Column(Integer, ForeignKey("groups.GroupID"), nullable=True)
    Title = Column(String, index=True)
    Content = Column(String)
    EventDate = Column(DateTime)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    TargetScope = Column(Enum(TargetScope))

    creator = relationship("User", back_populates="events")
    group = relationship("Group", back_populates="events") 