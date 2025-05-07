from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class Participation(Base):
    __tablename__ = "participations"

    ParticipationID = Column(Integer, primary_key=True, index=True)
    ConversationID = Column(Integer, ForeignKey("conversations.ConversationID"))
    UserID = Column(Integer, ForeignKey("users.UserID"))
    JoinedAt = Column(DateTime, default=datetime.datetime.utcnow)

    conversation = relationship("Conversation", back_populates="participations")
    user = relationship("User", back_populates="participations") 