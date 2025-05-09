from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship
from ..base import Base

class Subject(Base):
    __tablename__ = "subjects"

    SubjectID = Column(Integer, primary_key=True, index=True)
    SubjectName = Column(String(255), unique=True, nullable=False)
    Description = Column(Text, nullable=True)

    # Relationships
    class_subjects = relationship("ClassSubject", back_populates="subject", cascade="all, delete-orphan")