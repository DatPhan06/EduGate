from sqlalchemy import Column, Integer, String, ForeignKey, Enum
from sqlalchemy.orm import relationship
from ..base import Base
import enum

class RelationshipType(enum.Enum):
    FATHER = "father"
    MOTHER = "mother"
    GUARDIAN = "guardian"

class ParentStudent(Base):
    __tablename__ = "parent_students"

    RelationshipID = Column(Integer, primary_key=True, index=True)
    Relationship = Column(Enum(RelationshipType))
    ParentID = Column(Integer, ForeignKey("parents.ParentID"))
    StudentID = Column(Integer, ForeignKey("students.StudentID"))

    parent = relationship("Parent", back_populates="parent_students")
    student = relationship("Student", back_populates="parent_students")