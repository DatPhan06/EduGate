from pydantic import BaseModel
from datetime import date
from typing import Optional, List, Union

class RewardPunishmentBase(BaseModel):
    type: str  # "reward" or "punishment"
    description: str
    date: date
    issuer_id: int  # ID của người tạo khen thưởng/kỷ luật (teacher hoặc admin)

class RewardPunishmentCreate(RewardPunishmentBase):
    pass

class RewardPunishmentRead(RewardPunishmentBase):
    RecordID: int
    
    class Config:
        orm_mode = True

# Student RNP schemas
class StudentRewardPunishmentCreate(RewardPunishmentBase):
    student_id: int

class StudentRNPBase(BaseModel):
    StudentRNPID: int
    RecordID: int
    StudentID: int

class StudentRNPRead(StudentRNPBase):
    reward_punishment: RewardPunishmentRead
    
    class Config:
        orm_mode = True

# Class RNP schemas
class ClassRewardPunishmentCreate(RewardPunishmentBase):
    class_id: int

class ClassRNPBase(BaseModel):
    ClassRNPID: int
    RecordID: int
    ClassID: int

class ClassRNPRead(ClassRNPBase):
    reward_punishment: RewardPunishmentRead
    
    class Config:
        orm_mode = True