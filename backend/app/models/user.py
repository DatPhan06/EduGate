from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime
import enum

class Gender(enum.Enum):
    MALE = "MALE"
    FEMALE = "FEMALE"
    OTHER = "OTHER"

    def __str__(self):
        return self.value

class UserStatus(enum.Enum):
    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"
    SUSPENDED = "SUSPENDED"

    def __str__(self):
        return self.value

class UserRole(enum.Enum):
    ADMIN = "admin"
    TEACHER = "teacher"
    PARENT = "parent"
    STUDENT = "student"

    def __str__(self):
        return self.value

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
    Gender = Column(Enum(Gender, name='gender', values_callable=lambda x: [e.value for e in x]))
    Address = Column(String)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    UpdatedAt = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)
    Status = Column(Enum(UserStatus, name='userstatus', values_callable=lambda x: [e.value for e in x]), default=UserStatus.ACTIVE)
    role = Column(Enum(UserRole, name='userrole', values_callable=lambda x: [e.value for e in x]), default=UserRole.STUDENT)

    # Relationships
    events = relationship("Event", back_populates="creator")
    messages = relationship("Message", back_populates="user")
    participations = relationship("Participation", back_populates="user")
    user_groups = relationship("UserGroup", back_populates="user")
    administrative_staff = relationship("AdministrativeStaff", back_populates="user", uselist=False)
    teacher = relationship("Teacher", back_populates="user", uselist=False)
    student = relationship("Student", back_populates="user", uselist=False)
    parent = relationship("Parent", back_populates="user", uselist=False) 