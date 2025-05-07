from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class SubjectSchedule(Base):
    __tablename__ = "subject_schedules"

    SubjectScheduleID = Column(Integer, primary_key=True, index=True)
    ClassSubjectID = Column(Integer, ForeignKey("class_subjects.ClassSubjectID"))
    StartPeriod = Column(Integer) # Assuming period is an integer like 1, 2, ...
    EndPeriod = Column(Integer)
    Day = Column(String) # E.g., "Monday", "Tuesday", or an Enum if preferred

    # Relationship to ClassSubject
    class_subject = relationship("ClassSubject", back_populates="schedules") 