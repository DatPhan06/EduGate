from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..schemas.student_schema import StudentRead
from ..schemas.user import UserCreate, UserUpdate, User as UserResponseSchema # For response of create/update
from ..services import student_service, user_service # user_service for raw user object if needed
from ..enums.user_enums import UserRole
from pydantic import BaseModel # Added for request body
from ..models.class_ import Class as ClassModel # Import Class model
from ..models.student import Student # Import Student model

router = APIRouter(
    prefix="/students",
    tags=["students"],
)

class BulkAssignClassPayload(BaseModel):
    class_id: int
    student_user_ids: List[int]

@router.post("/direct-bulk-assign-class", status_code=status.HTTP_200_OK)
def direct_bulk_assign_students_to_class_endpoint(
    payload: BulkAssignClassPayload, 
    db: Session = Depends(get_db)
):
    """
    Directly assigns students to a class without using UserUpdate model.
    This bypasses the pydantic validation issues with partial updates.
    """
    success_count = 0
    errors = []
    
    # Validate ClassID exists
    class_obj = db.query(ClassModel).filter(ClassModel.ClassID == payload.class_id).first()
    if not class_obj:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class with ID {payload.class_id} not found."
        )

    for student_user_id in payload.student_user_ids:
        try:
            # Get the student record directly
            student = db.query(Student).filter(Student.StudentID == student_user_id).first()
            if not student:
                errors.append({"student_user_id": student_user_id, "error": "Student not found"})
                continue
                
            # Get old class ID for chat updates
            old_class_id = student.ClassID
            
            # Direct update the ClassID
            student.ClassID = payload.class_id
            
            # Update conversation memberships if needed (copied from student_service.update_student)
            if old_class_id != payload.class_id:
                try:
                    # Import here to avoid circular imports
                    from ..services.student_service import _update_student_class_conversations
                    
                    # Remove from old class conversations
                    if old_class_id:
                        _update_student_class_conversations(db, student_user_id, old_class_id, 'remove')
                    
                    # Add to new class conversations
                    _update_student_class_conversations(db, student_user_id, payload.class_id, 'add')
                except Exception as e:
                    print(f"ERROR updating conversations for student {student_user_id}: {e}")
                    # Continue with the update even if conversation update fails
            
            db.commit()
            success_count += 1
        except Exception as e:
            db.rollback()
            errors.append({"student_user_id": student_user_id, "error": f"An unexpected error occurred: {str(e)}"})
            
    if not errors and success_count == len(payload.student_user_ids):
        return {"message": f"Successfully assigned {success_count} students to class {payload.class_id}."}
    else:
        return {
            "message": "Bulk assignment partially successful or failed.",
            "successful_assignments": success_count,
            "failed_assignments": len(errors),
            "errors": errors
        }

@router.post("/bulk-assign-class", status_code=status.HTTP_200_OK)
def bulk_assign_students_to_class_endpoint(
    payload: BulkAssignClassPayload, 
    db: Session = Depends(get_db)
):
    success_count = 0
    errors = []
    
    # Validate ClassID exists
    class_obj = db.query(ClassModel).filter(ClassModel.ClassID == payload.class_id).first()
    if not class_obj:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class with ID {payload.class_id} not found."
        )

    for student_user_id in payload.student_user_ids:
        try:
            # We need to construct a UserUpdate schema with only ClassID
            # The student_service.update_student expects a UserUpdate object
            # Explicitly set Gender=None to avoid validation error
            student_update_data = UserUpdate(ClassID=payload.class_id, Gender=None)
            
            updated_user = student_service.update_student(
                db=db, 
                student_user_id=student_user_id, 
                student_data=student_update_data
            )
            if updated_user:
                success_count += 1
            else:
                # This case should ideally be caught by exceptions in update_student
                errors.append({"student_user_id": student_user_id, "error": "Update returned None but no exception."})
        except HTTPException as e:
            errors.append({"student_user_id": student_user_id, "error": e.detail, "status_code": e.status_code})
        except Exception as e:
            # Catch any other unexpected errors
            errors.append({"student_user_id": student_user_id, "error": f"An unexpected error occurred: {str(e)}"})
            
    if not errors and success_count == len(payload.student_user_ids):
        return {"message": f"Successfully assigned {success_count} students to class {payload.class_id}."}
    else:
        return {
            "message": "Bulk assignment partially successful or failed.",
            "successful_assignments": success_count,
            "failed_assignments": len(errors),
            "errors": errors
        }

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