from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import datetime
from ..base import Base

class MessageFile(Base):
    __tablename__ = "message_files"

    FileID = Column(Integer, primary_key=True, index=True)
    FileName = Column(String)
    FileSize = Column(Integer)  # Assuming FileSize is an integer
    ContentType = Column(String)
    SubmittedAt = Column(DateTime, default=datetime.datetime.utcnow)
    MessageID = Column(Integer, ForeignKey("messages.MessageID"))

    # Relationship to Message
    message = relationship("Message", back_populates="message_files") 