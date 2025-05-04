from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..base import Base
import datetime
import enum

class PetitionStatus(enum.Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"

class Petition(Base):
    __tablename__ = "petitions"

    PetitionID = Column(Integer, primary_key=True, index=True)
    ParentID = Column(Integer, ForeignKey("parents.ParentID"))
    AdminID = Column(Integer, ForeignKey("administrative_staffs.AdminID"), nullable=True)
    Title = Column(String)
    Content = Column(String)
    Status = Column(Enum(PetitionStatus), default=PetitionStatus.PENDING)
    SubmittedAt = Column(DateTime, default=datetime.datetime.utcnow)
    Notes = Column(String, nullable=True)

    parent = relationship("Parent", back_populates="petitions")
    admin = relationship("AdministrativeStaff", back_populates="petitions") 