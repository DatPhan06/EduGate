from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class Role(enum.Enum):
    ADMIN = "admin"
    MEMBER = "member"

class Participation(Base):
    __tablename__ = "participations"

    ParticipationID = Column(Integer, primary_key=True, index=True)
    ConversationID = Column(Integer, ForeignKey("conversations.ConversationID"))
    UserID = Column(Integer, ForeignKey("users.id"))
    Role = Column(Enum(Role), default=Role.MEMBER)
    JoinedAt = Column(DateTime, default=datetime.datetime.utcnow)

    conversation = relationship("Conversation", back_populates="participations")
    user = relationship("User", back_populates="participations") 