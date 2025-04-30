from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Message(Base):
    __tablename__ = "messages"

    MessageID = Column(Integer, primary_key=True, index=True)
    ConversationID = Column(Integer, ForeignKey("conversations.ConversationID"))
    Content = Column(String)
    SentAt = Column(DateTime, default=datetime.datetime.utcnow)
    UserID = Column(Integer, ForeignKey("users.id"))

    conversation = relationship("Conversation", back_populates="messages")
    user = relationship("User", back_populates="messages") 