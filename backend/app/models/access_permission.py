from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class AccessPermission(Base):
    __tablename__ = "access_permissions"

    AccessID = Column(Integer, primary_key=True, index=True)
    Name = Column(String)
    Description = Column(String)
    UserID = Column(Integer, ForeignKey("users.UserID"))

    # Relationship to User
    user = relationship("User", back_populates="access_permissions") 