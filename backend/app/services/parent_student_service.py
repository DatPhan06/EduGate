from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from typing import List

from ..models.parent_student import ParentStudent
from ..models.user import User
from ..models.parent import Parent
from ..models.student import Student
from ..models.class_ import Class
from ..enums.user_enums import UserRole
from ..schemas.parent_student_schema import ParentBasicInfo, StudentBasicInfo

def link_parent_to_student(db: Session, student_user_id: int, parent_user_id: int) -> ParentStudent:
    # Validate student exists and is a student
    student_user = db.query(User).filter(User.UserID == student_user_id, User.role == UserRole.STUDENT).first()
    if not student_user or not student_user.student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

    # Validate parent exists and is a parent
    parent_user = db.query(User).filter(User.UserID == parent_user_id, User.role == UserRole.PARENT).first()
    if not parent_user or not parent_user.parent:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Parent not found")

    # Check if link already exists
    existing_link = db.query(ParentStudent).filter(
        ParentStudent.StudentID == student_user_id,
        ParentStudent.ParentID == parent_user_id
    ).first()
    if existing_link:
        # Or just return the existing link silently
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Parent already linked to this student")

    # Create link
    new_link = ParentStudent(StudentID=student_user_id, ParentID=parent_user_id)
    db.add(new_link)
    db.commit()
    db.refresh(new_link)
    return new_link

def unlink_parent_from_student(db: Session, student_user_id: int, parent_user_id: int) -> bool:
    link = db.query(ParentStudent).filter(
        ParentStudent.StudentID == student_user_id,
        ParentStudent.ParentID == parent_user_id
    ).first()

    if not link:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Link between parent and student not found")

    db.delete(link)
    db.commit()
    return True

def get_parents_for_student(db: Session, student_user_id: int) -> List[ParentBasicInfo]:
    # Validate student exists
    student_user = db.query(User).filter(User.UserID == student_user_id, User.role == UserRole.STUDENT).first()
    if not student_user:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

    # Query linked parents
    parent_links = db.query(ParentStudent).filter(ParentStudent.StudentID == student_user_id).all()
    parent_ids = [link.ParentID for link in parent_links]

    if not parent_ids:
        return []

    parents = db.query(
        User.UserID, User.FirstName, User.LastName, User.Email
    ).filter(User.UserID.in_(parent_ids), User.role == UserRole.PARENT).all()

    # Use model_validate for Pydantic v2
    return [ParentBasicInfo.model_validate(p) for p in parents]

def get_students_for_parent(db: Session, parent_user_id: int) -> List[StudentBasicInfo]:
     # Validate parent exists
    parent_user = db.query(User).filter(User.UserID == parent_user_id, User.role == UserRole.PARENT).first()
    if not parent_user:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Parent not found")

    # Query linked students and their classes
    student_links = db.query(ParentStudent).filter(ParentStudent.ParentID == parent_user_id).all()
    student_ids = [link.StudentID for link in student_links]

    if not student_ids:
        return []

    students_with_class = db.query(
        User.UserID, User.FirstName, User.LastName, User.Email, Class.ClassName
    ).select_from(User)\
     .join(Student, User.UserID == Student.StudentID)\
     .outerjoin(Class, Student.ClassID == Class.ClassID)\
     .filter(User.UserID.in_(student_ids), User.role == UserRole.STUDENT)\
     .all()
    
    # Use model_validate for Pydantic v2
    return [StudentBasicInfo.model_validate(s) for s in students_with_class] 