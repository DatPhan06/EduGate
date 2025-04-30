from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..base import Base

class Subject(Base):
    __tablename__ = "subjects"

    SubjectID = Column(Integer, primary_key=True, index=True)
    SubjectName = Column(String, unique=True)
    Description = Column(String)

    class_subjects = relationship("ClassSubject", back_populates="subject")