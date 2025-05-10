from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from sqlalchemy.exc import IntegrityError

from ..database import get_db
# Models are now primarily used by the service layer
# from ..models.grade import Grade
# from ..models.grade_component import GradeComponent
# from ..models.student import Student
# from ..models.user import User 
# from ..models.class_subject import ClassSubject
# from ..models.subject import SubjectModel

from ..schemas.grade_schema import (
    GradeCreate, GradeUpdate, GradeResponse, 
    GradeComponentCreate, GradeComponentUpdate, GradeComponentResponse
)
from ..services import grade_service # Import the new service

router = APIRouter(
    prefix="/grades",
    tags=["grades"],
    responses={404: {"description": "Not found"}}
)

@router.get("/", response_model=List[GradeResponse])
def read_grades(
    db: Session = Depends(get_db),
    student_id: Optional[int] = Query(None, description="Filter by student ID"),
    class_subject_id: Optional[int] = Query(None, description="Filter by class-subject ID"),
    semester: Optional[str] = Query(None, description="Filter by semester (e.g., 'Học kỳ 1')")
):
    grades = grade_service.get_all_grades(db, student_id, class_subject_id, semester)
    return grades

@router.post("/", response_model=GradeResponse, status_code=status.HTTP_201_CREATED)
def create_grade(grade: GradeCreate, db: Session = Depends(get_db)):
    try:
        created_grade = grade_service.create_grade_with_components(db, grade_data=grade)
        return created_grade
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid data. Student or Class Subject may not exist, or another integrity constraint violated."
        )
    except Exception as e: # Catch other potential errors from service
        # Log the exception e here if you have logging setup
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )

@router.get("/{grade_id}", response_model=GradeResponse)
def get_grade(grade_id: int, db: Session = Depends(get_db)):
    db_grade = grade_service.get_grade_by_id(db, grade_id=grade_id)
    if db_grade is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with ID {grade_id} not found"
        )
    return db_grade

@router.get("/student/{student_id}", response_model=List[GradeResponse])
def get_student_grades(student_id: int, semester: Optional[str] = None, db: Session = Depends(get_db)):
    grades = grade_service.get_grades_by_student(db, student_id=student_id, semester=semester)
    if not grades: # Depending on if service returns empty list or None for no student found
        # Check if student exists at all might be a good idea if an empty list is a valid response for a student with no grades
        # For now, assume an empty list is a valid response and a 404 is not needed unless student_id itself is invalid
        # (which would typically be caught by FK constraints or specific check for student existence if desired)
        pass # Simply return empty list if no grades found for the student
    return grades

@router.put("/{grade_id}", response_model=GradeResponse)
def update_grade(grade_id: int, grade_update: GradeUpdate, db: Session = Depends(get_db)):
    try:
        updated_grade = grade_service.update_grade_details(db, grade_id=grade_id, grade_update_data=grade_update)
        if updated_grade is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Grade with ID {grade_id} not found for update"
            )
        return updated_grade
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Update failed due to data integrity issues."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred during update: {str(e)}"
        )

@router.delete("/{grade_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_grade(grade_id: int, db: Session = Depends(get_db)):
    try:
        success = grade_service.delete_grade_and_components(db, grade_id=grade_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Grade with ID {grade_id} not found for deletion"
            )
        return None # FastAPI handles 204 No Content response
    except IntegrityError: # Should be rare if cascade delete is set up or no dependent FKs block
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, # Conflict if deletion is blocked
            detail="Cannot delete grade due to existing references or data integrity issues."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred during deletion: {str(e)}"
        )

# Grade component specific endpoints
@router.post("/{grade_id}/components", response_model=GradeComponentResponse)
def add_grade_component(
    grade_id: int, 
    component: GradeComponentCreate, 
    db: Session = Depends(get_db)
):
    try:
        db_component = grade_service.add_component_to_grade(db, grade_id=grade_id, component_data=component)
        if db_component is None: # Parent grade not found
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Parent grade with ID {grade_id} not found to add component"
            )
        return db_component
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to add component due to data integrity issues."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )

@router.get("/{grade_id}/components", response_model=List[GradeComponentResponse])
def get_grade_components(
    grade_id: int,
    db: Session = Depends(get_db)
):
    try:
        # First check if the grade exists
        grade = grade_service.get_grade_by_id(db, grade_id=grade_id)
        if grade is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Grade with ID {grade_id} not found"
            )
        
        # Get components for the grade
        components = grade_service.get_grade_components(db, grade_id=grade_id)
        return components
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )

@router.put("/components/{component_id}", response_model=GradeComponentResponse)
def update_grade_component(
    component_id: int, 
    component_update: GradeComponentUpdate, 
    db: Session = Depends(get_db)
):
    try:
        db_component = grade_service.update_grade_component_details(db, component_id=component_id, component_update_data=component_update)
        if db_component is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Grade component with ID {component_id} not found for update"
            )
        return db_component
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Update failed for component due to data integrity issues."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )

@router.delete("/components/{component_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_grade_component(component_id: int, db: Session = Depends(get_db)):
    try:
        success = grade_service.delete_grade_component_by_id(db, component_id=component_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Grade component with ID {component_id} not found for deletion"
            )
        return None
    except IntegrityError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Cannot delete component due to existing references or data integrity issues."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        ) 