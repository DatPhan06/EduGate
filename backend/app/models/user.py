from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum, Boolean
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class Gender(enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"

class UserStatus(enum.Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"

class User(Base):
    __tablename__ = "users"

    UserID = Column(Integer, primary_key=True, index=True)
    FirstName = Column(String)
    LastName = Column(String)
    Street = Column(String)
    District = Column(String)
    City = Column(String)
    Email = Column(String, unique=True, index=True)
    Password = Column(String)
    PhoneNumber = Column(String)
    DOB = Column(DateTime)
    PlaceOfBirth = Column(String)
    Gender = Column(Enum(Gender))
    Address = Column(String)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    UpdatedAt = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)
    Status = Column(Enum(UserStatus), default=UserStatus.ACTIVE)

    # Relationships
    events = relationship("Event", back_populates="creator")
    messages = relationship("Message", back_populates="user")
    participations = relationship("Participation", back_populates="user")
    user_groups = relationship("UserGroup", back_populates="user")
    administrative_staff = relationship("AdministrativeStaff", back_populates="user", uselist=False)
    teacher = relationship("Teacher", back_populates="user", uselist=False)
    student = relationship("Student", back_populates="user", uselist=False)
    parent = relationship("Parent", back_populates="user", uselist=False) 