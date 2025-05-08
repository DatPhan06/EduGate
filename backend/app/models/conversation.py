from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Conversation(Base):
    __tablename__ = "conversations"

    ConversationID = Column(Integer, primary_key=True, index=True)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    Name = Column(String)
    NumOfParticipation = Column(Integer, default=0)

    messages = relationship("Message", back_populates="conversation")
    participations = relationship("Participation", back_populates="conversation")