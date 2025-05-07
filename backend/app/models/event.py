from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Event(Base):
    __tablename__ = "events"

    EventID = Column(Integer, primary_key=True, index=True)
    Title = Column(String, index=True)
    Type = Column(String)
    Content = Column(Text)
    EventDate = Column(DateTime)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    AdminID = Column(Integer, ForeignKey("administrative_staffs.AdminID"))

    admin_creator = relationship("AdministrativeStaff", back_populates="created_events")
    event_files = relationship("EventFile", back_populates="event", cascade="all, delete-orphan")

    # Removed old relationships:
    # Creator_ID = Column(Integer, ForeignKey("users.UserID"))
    # GroupID = Column(Integer, ForeignKey("groups.GroupID"), nullable=True)
    # TargetScope = Column(Enum(TargetScope))
    # creator = relationship("User", back_populates="events")
    # group = relationship("Group", back_populates="events") 