from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import datetime
from ..base import Base

class Message(Base):
    __tablename__ = "messages"

    MessageID = Column(Integer, primary_key=True, index=True)
    ConversationID = Column(Integer, ForeignKey("conversations.ConversationID"))
    UserID = Column(Integer, ForeignKey("users.UserID"))
    Content = Column(String, nullable=True)  # Cho phép tin nhắn không có nội dung text (chỉ có file)
    SentAt = Column(DateTime, default=datetime.datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="messages")
    conversation = relationship("Conversation", back_populates="messages")
    
    # Relationship với MessageFile
    message_files = relationship("MessageFile", back_populates="message") 