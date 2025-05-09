from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..base import Base

class Department(Base):
    __tablename__ = "departments"

    DepartmentID = Column(Integer, primary_key=True, index=True, autoincrement=True)
    DepartmentName = Column(String, unique=True)
    Description = Column(String)

    teachers = relationship("Teacher", back_populates="department")
    # Ensuring no administrative_staffs relationship is defined here
    # administrative_staffs = relationship("AdministrativeStaff", back_populates="department") # This line should NOT exist or be commented out 