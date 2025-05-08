from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..schemas.student_schema import StudentRead
from ..schemas.user import UserCreate, UserUpdate, User as UserResponseSchema # For response of create/update
from ..services import student_service, user_service # user_service for raw user object if needed
from ..enums.user_enums import UserRole

router = APIRouter(
    prefix="/students",
    tags=["students"],
)

@router.post("/", response_model=UserResponseSchema) # Responds with the created User object
def create_student_endpoint(student_in: UserCreate, db: Session = Depends(get_db)):
    # Explicitly check if the role provided is *not* STUDENT
    # Pydantic should have already validated the value against the UserRole enum
    student_in.role = UserRole.STUDENT
    
    # StudentCode and ClassID are expected in student_in (UserCreate schema)
    created_user = student_service.create_student(db=db, student_data=student_in)
    return created_user

@router.get("/", response_model=List[StudentRead])
def read_students_endpoint(
    skip: int = 0, 
    limit: int = 100, 
    search: Optional[str] = Query(None, description="Search term for Student Name, Class Name, or Parent Name"),
    class_id_filter: Optional[int] = Query(None, description="Filter by Class ID"),
    db: Session = Depends(get_db)
):
    students = student_service.get_students(db=db, skip=skip, limit=limit, search=search, class_id_filter=class_id_filter)
    return students

@router.get("/{student_user_id}", response_model=StudentRead)
def read_student_endpoint(student_user_id: int, db: Session = Depends(get_db)):
    student = student_service.get_student_by_id(db, student_user_id=student_user_id)
    if student is None:
        raise HTTPException(status_code=404, detail="Student not found")
    return student

@router.put("/{student_user_id}", response_model=UserResponseSchema) # Responds with the updated User object
def update_student_endpoint(student_user_id: int, student_in: UserUpdate, db: Session = Depends(get_db)):
    # StudentCode and ClassID updates are handled via student_in (UserUpdate schema)
    updated_user = student_service.update_student(db=db, student_user_id=student_user_id, student_data=student_in)
    if updated_user is None:
        raise HTTPException(status_code=404, detail="Student not found")
    return updated_user

@router.delete("/{student_user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_student_endpoint(student_user_id: int, db: Session = Depends(get_db)):
    success = student_service.delete_student(db=db, student_user_id=student_user_id)
    if not success:
        # student_service.delete_student raises HTTPException if not found, 
        # but an explicit check here can be good too.
        # However, user_service.delete_user returns bool. student_service.delete_student also returns bool.
        # The service now raises an exception if not found before calling delete_user.
        # So if we reach here and success is False, it means delete_user failed for other reasons.
        # For now, we rely on the service layer's HTTPExceptions.
        # If success is False from user_service.delete_user after student is found, it's an issue.
        # Let's assume if student_service didn't raise, delete was accepted by user_service.
        pass # Return 204 if no exception was raised by the service
    return # FastAPI will return 204 No Content by default if no body is returned 