from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class Parent(Base):
    __tablename__ = "parents"

    ParentID = Column(Integer, ForeignKey("users.UserID"), primary_key=True)
    Occupation = Column(String)

    user = relationship("User", back_populates="parent")
    parent_students = relationship("ParentStudent", back_populates="parent")
    petitions = relationship("Petition", back_populates="parent") 