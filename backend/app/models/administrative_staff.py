from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..base import Base

class AdministrativeStaff(Base):
    __tablename__ = "administrative_staffs"

    AdminID = Column(Integer, ForeignKey("users.UserID"), primary_key=True)
    Note = Column(String, nullable=True)
    # Position = Column(String)
    # DepartmentID = Column(Integer, ForeignKey("departments.DepartmentID"))

    user = relationship("User", back_populates="administrative_staff")
    # department = relationship("Department", back_populates="administrative_staffs")
    petitions = relationship("Petition", back_populates="admin")
    issued_rewards_and_punishments = relationship("RewardPunishment", back_populates="administrative_staff")
    created_events = relationship("Event", back_populates="admin_creator") 