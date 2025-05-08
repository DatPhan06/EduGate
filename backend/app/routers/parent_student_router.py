from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services import parent_student_service
from ..schemas.parent_student_schema import ParentStudentLink, ParentBasicInfo, StudentBasicInfo

# This router manages the links between parents and students
router = APIRouter(tags=["parent-student-links"])

# Link a parent to a student
@router.post("/students/{student_user_id}/parents", status_code=status.HTTP_201_CREATED)
def link_parent(student_user_id: int, link_data: ParentStudentLink, db: Session = Depends(get_db)):
    parent_student_service.link_parent_to_student(db, student_user_id, link_data.parent_user_id)
    return {"message": "Parent linked successfully"}

# Unlink a parent from a student
@router.delete("/students/{student_user_id}/parents/{parent_user_id}", status_code=status.HTTP_204_NO_CONTENT)
def unlink_parent(student_user_id: int, parent_user_id: int, db: Session = Depends(get_db)):
    success = parent_student_service.unlink_parent_from_student(db, student_user_id, parent_user_id)
    if not success:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Link not found or failed to delete")
    return

# Get all parents linked to a specific student
@router.get("/students/{student_user_id}/parents", response_model=List[ParentBasicInfo])
def get_student_parents(student_user_id: int, db: Session = Depends(get_db)):
    return parent_student_service.get_parents_for_student(db, student_user_id)

# Get all students linked to a specific parent
@router.get("/parents/{parent_user_id}/students", response_model=List[StudentBasicInfo])
def get_parent_students(parent_user_id: int, db: Session = Depends(get_db)):
    return parent_student_service.get_students_for_parent(db, parent_user_id) 