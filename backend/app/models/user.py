from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
from ..enums.user_enums import Gender, UserStatus, UserRole
import datetime

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
    access_permissions = relationship("AccessPermission", back_populates="user")
    messages = relationship("Message", back_populates="user")
    participations = relationship("Participation", back_populates="user")
    administrative_staff = relationship("AdministrativeStaff", back_populates="user", uselist=False)
    teacher = relationship("Teacher", back_populates="user", uselist=False)
    student = relationship("Student", back_populates="user", uselist=False)
    parent = relationship("Parent", back_populates="user", uselist=False) 