from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base
import datetime

class GradeComponent(Base):
    __tablename__ = "grade_components"

    ComponentID = Column(Integer, primary_key=True, index=True)
    ComponentName = Column(String)
    GradeID = Column(Integer, ForeignKey("grades.GradeID"))
    Weight = Column(Float)
    Score = Column(Float)
    SubmitDate = Column(DateTime, default=datetime.datetime.utcnow)

    grade = relationship("Grade", back_populates="grade_components") 