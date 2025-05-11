from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..schemas.class_subject_schema import ClassSubjectCreate, ClassSubjectRead, ClassSubjectUpdate
from ..services import class_subject_service, auth_service, user_service, grade_service
from ..enums.user_enums import UserRole

router = APIRouter(
    prefix="/class-subjects",
    tags=["class-subjects"],
)

@router.get("/", response_model=List[ClassSubjectRead])
def read_class_subjects(
    skip: int = 0, 
    limit: int = 1000,
    db: Session = Depends(get_db)
):
    class_subjects = class_subject_service.get_class_subjects(db, skip, limit)
    return class_subjects

@router.get("/{class_subject_id}", response_model=ClassSubjectRead)
def read_class_subject(
    class_subject_id: int,
    db: Session = Depends(get_db)
):
    class_subject = class_subject_service.get_class_subject_by_id(db, class_subject_id)
    if not class_subject:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class subject not found"
        )
    return class_subject

@router.post("/", response_model=ClassSubjectRead)
def create_class_subject(
    class_subject: ClassSubjectCreate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Check authentication
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    try:
        # Get current user
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin role
        if current_user.role != UserRole.ADMIN:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to create class subjects"
            )
        
        # Create class subject
        created_class_subject = class_subject_service.create_class_subject(db, class_subject)
        return created_class_subject
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.put("/{class_subject_id}", response_model=ClassSubjectRead)
def update_class_subject(
    class_subject_id: int,
    class_subject: ClassSubjectUpdate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Check authentication
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    try:
        # Get current user
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin role
        if current_user.role != UserRole.ADMIN:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to update class subjects"
            )
        
        # Update class subject
        updated_class_subject = class_subject_service.update_class_subject(db, class_subject_id, class_subject)
        if not updated_class_subject:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Class subject not found"
            )
        return updated_class_subject
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.delete("/{class_subject_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_class_subject(
    class_subject_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Check authentication
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    try:
        # Get current user
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin role
        if current_user.role != UserRole.ADMIN:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to delete class subjects"
            )
        
        # Delete class subject
        deleted = class_subject_service.delete_class_subject(db, class_subject_id)
        if not deleted:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Class subject not found"
            )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.post("/{class_subject_id}/initialize-grades", status_code=status.HTTP_201_CREATED)
def initialize_grades_for_class_subject(
    class_subject_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Initialize grade records for all students in a class for both semesters.
    Also creates standard grade components for each grade.
    """
    # Check authentication
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    try:
        # Get current user
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin or teacher role
        if current_user.role != UserRole.ADMIN and current_user.role != UserRole.TEACHER:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to initialize grades"
            )
        
        # Get class subject
        class_subject = class_subject_service.get_class_subject_by_id(db, class_subject_id)
        if not class_subject:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Class subject not found"
            )
        
        # If user is a teacher, check if they teach this class subject
        if current_user.role == UserRole.TEACHER and current_user.UserID != class_subject.TeacherID:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not authorized to initialize grades for this class subject"
            )
        
        # Initialize grades for first semester
        created_grades_sem1 = grade_service.initialize_grades_for_class_subject(
            db, 
            class_subject_id, 
            "Học kỳ 1"
        )
        
        # Initialize grades for second semester
        created_grades_sem2 = grade_service.initialize_grades_for_class_subject(
            db, 
            class_subject_id, 
            "Học kỳ 2"
        )
        
        # Initialize standard components for all created grades
        all_grade_ids = [grade.GradeID for grade in created_grades_sem1 + created_grades_sem2]
        component_result = grade_service.initialize_standard_components_for_grades(db, all_grade_ids)
        
        return {
            "message": "Grade structures initialized successfully",
            "grades_created": len(created_grades_sem1) + len(created_grades_sem2),
            "components_created": component_result["components_created"]
        }
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.post("/initialize-grades-test", status_code=status.HTTP_201_CREATED)
def initialize_grades_for_multiple_class_subjects(
    class_subject_ids: List[int],
    db: Session = Depends(get_db)
):
    """
    Initialize grade records for all students in multiple classes for both semesters.
    Also creates standard grade components for each grade.
    """
    
    try:
        total_grades_created = 0
        total_components_created = 0
        
        for class_subject_id in class_subject_ids:
            # Initialize grades for first semester
            created_grades_sem1 = grade_service.initialize_grades_for_class_subject(
                db, 
                class_subject_id, 
                "Học kỳ 1"
            )
            
            # Initialize grades for second semester
            created_grades_sem2 = grade_service.initialize_grades_for_class_subject(
                db, 
                class_subject_id, 
                "Học kỳ 2"
            )
            
            # Initialize standard components for all created grades
            all_grade_ids = [grade.GradeID for grade in created_grades_sem1 + created_grades_sem2]
            component_result = grade_service.initialize_standard_components_for_grades(db, all_grade_ids)
            
            total_grades_created += len(created_grades_sem1) + len(created_grades_sem2)
            total_components_created += component_result["components_created"]
        
        return {
            "message": "Grade structures initialized successfully",
            "grades_created": total_grades_created,
            "components_created": total_components_created
        }
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.get("/{class_subject_id}/subject", status_code=status.HTTP_200_OK)
def get_subject_from_class_subject(
    class_subject_id: int,
    db: Session = Depends(get_db)
):
    """
    Get subject information from a class subject ID (public access)
    """
    try:
        # Get subject information from class subject ID
        subject_info = class_subject_service.get_subject_by_class_subject_id(db, class_subject_id)
        if not subject_info:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Class subject not found"
            )
        
        return subject_info
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        ) 