from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class Role(enum.Enum):
    ADMIN = "admin"
    MEMBER = "member"

class UserGroup(Base):
    __tablename__ = "user_groups"

    UserGroupID = Column(Integer, primary_key=True, index=True)
    UserID = Column(Integer, ForeignKey("users.UserID"))
    GroupID = Column(Integer, ForeignKey("groups.GroupID"))
    Role = Column(Enum(Role), default=Role.MEMBER)
    JoinedAt = Column(DateTime, default=datetime.datetime.utcnow)

    user = relationship("User", back_populates="user_groups")
    group = relationship("Group", back_populates="user_groups") 