from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..base import Base

class Department(Base):
    __tablename__ = "departments"

    DepartmentID = Column(Integer, primary_key=True, index=True)
    DepartmentName = Column(String, unique=True)
    Description = Column(String)

    administrative_staffs = relationship("AdministrativeStaff", back_populates="department")
    teachers = relationship("Teacher", back_populates="department") 