from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime

class EventFile(Base):
    __tablename__ = "event_files"

    FileID = Column(Integer, primary_key=True, index=True)
    FileName = Column(String)
    FilePath = Column(String)
    FileSize = Column(Integer)
    ContentType = Column(String)
    SubmittedAt = Column(DateTime, default=datetime.datetime.utcnow)
    EventID = Column(Integer, ForeignKey("events.EventID")) # Assuming EventID is PK in events table

    # Relationship
    event = relationship("Event", back_populates="event_files") 