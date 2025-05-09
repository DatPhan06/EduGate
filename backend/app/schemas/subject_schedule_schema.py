from pydantic import BaseModel
from typing import Optional, List
from enum import Enum

# Enum for days of the week
class DayOfWeek(str, Enum):
    MONDAY = "Monday"
    TUESDAY = "Tuesday"
    WEDNESDAY = "Wednesday"
    THURSDAY = "Thursday"
    FRIDAY = "Friday"
    SATURDAY = "Saturday"
    SUNDAY = "Sunday"

# Base SubjectSchedule schema with common attributes
class SubjectScheduleBase(BaseModel):
    ClassSubjectID: int
    StartPeriod: int
    EndPeriod: int
    Day: DayOfWeek

# Schema for creating a new subject schedule
class SubjectScheduleCreate(SubjectScheduleBase):
    pass

# Schema for updating an existing subject schedule
class SubjectScheduleUpdate(BaseModel):
    StartPeriod: Optional[int] = None
    EndPeriod: Optional[int] = None
    Day: Optional[DayOfWeek] = None

# Schema for reading subject schedule data
class SubjectScheduleRead(SubjectScheduleBase):
    SubjectScheduleID: int

    class Config:
        from_attributes = True 