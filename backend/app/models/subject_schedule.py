from sqlalchemy import Column, Integer, String, ForeignKey, CheckConstraint
from sqlalchemy.orm import relationship
from ..base import Base

class SubjectSchedule(Base):
    __tablename__ = "subject_schedules"

    SubjectScheduleID = Column(Integer, primary_key=True, index=True)
    ClassSubjectID = Column(Integer, ForeignKey("class_subjects.ClassSubjectID"), nullable=False)
    StartPeriod = Column(Integer, nullable=False) # Period number (1-12)
    EndPeriod = Column(Integer, nullable=False)   # Period number (1-12)
    Day = Column(String(20), nullable=False)      # E.g., "Monday", "Tuesday", etc.

    # Add constraints to validate data
    __table_args__ = (
        CheckConstraint('"StartPeriod" > 0 AND "StartPeriod" <= 12', name='check_start_period'),
        CheckConstraint('"EndPeriod" > 0 AND "EndPeriod" <= 12', name='check_end_period'),
        CheckConstraint('"EndPeriod" >= "StartPeriod"', name='check_period_order'),
        # Sửa đây - thêm dấu ngoặc kép cho "Day"
        CheckConstraint(
            '"Day" IN (\'Monday\', \'Tuesday\', \'Wednesday\', \'Thursday\', \'Friday\', \'Saturday\', \'Sunday\')', 
            name='check_valid_day'
        ),
    )

    # Relationship to ClassSubject
    class_subject = relationship("ClassSubject", back_populates="schedules") 