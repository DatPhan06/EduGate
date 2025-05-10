from fastapi import APIRouter, Depends, HTTPException, status, Header, Query
from sqlalchemy.orm import Session
from typing import List, Optional, Dict, Any
from pydantic import BaseModel

from ..database import get_db
from ..schemas.teacher_schema import TeacherRead, TeacherUpdate
from ..schemas.user import UserCreate
from ..services import teacher_service, user_service, auth_service
from ..enums.user_enums import UserRole

router = APIRouter(
    prefix="/teachers",
    tags=["teachers"],
)

# Define subject response schema
class SubjectResponse(BaseModel):
    id: int
    name: str

# Define class response schema
class ClassResponse(BaseModel):
    id: int
    name: str
    grade: str
    is_homeroom: bool

# Define homeroom class response schema
class HomeroomClassResponse(BaseModel):
    id: int
    name: str
    grade: str
    academic_year: str

@router.get("/", response_model=List[TeacherRead])
def read_teachers_endpoint(
    skip: int = 0, 
    limit: int = 1000, # Default high limit for dropdowns
    department_id: Optional[int] = Query(None, description="Filter teachers by department"),
    search: Optional[str] = Query(None, description="Search teachers by name"),
    db: Session = Depends(get_db)
):
    teachers = teacher_service.get_teachers(db=db, skip=skip, limit=limit)
    return teachers

@router.get("/{teacher_id}", response_model=TeacherRead)
def read_teacher_endpoint(
    teacher_id: int,
    db: Session = Depends(get_db)
):
    teacher = teacher_service.get_teacher_by_id(db=db, teacher_id=teacher_id)
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher not found"
        )
    return teacher

@router.post("/", status_code=status.HTTP_201_CREATED, response_model=TeacherRead)
def create_teacher_endpoint(
    user_data: UserCreate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Authenticate admin/staff
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    
    try:
        # Get current user from token
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin role
        if current_user.role != UserRole.ADMIN and current_user.role != UserRole.STAFF:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to create teachers"
            )
        
        # Create user with teacher role
        user_data.role = UserRole.TEACHER
        new_teacher = user_service.create_user_with_role(db, user_data, UserRole.TEACHER)
        
        return teacher_service.get_teacher_by_id(db, new_teacher.UserID)
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.put("/{teacher_id}", response_model=TeacherRead)
def update_teacher_endpoint(
    teacher_id: int,
    teacher_data: TeacherUpdate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Authenticate admin/staff/teacher
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    
    try:
        # Get current user from token
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has permission (admin/staff or the teacher themselves)
        if current_user.role != UserRole.ADMIN and current_user.role != UserRole.STAFF and current_user.UserID != teacher_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to update this teacher"
            )
        
        # Check if teacher exists
        existing_teacher = teacher_service.get_teacher_by_id(db, teacher_id)
        if not existing_teacher:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Teacher not found"
            )
        
        # Update teacher data
        updated_teacher = teacher_service.update_teacher(db, teacher_id, teacher_data)
        return updated_teacher
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.delete("/{teacher_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_teacher_endpoint(
    teacher_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Authenticate admin
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    
    try:
        # Get current user from token
        email = auth_service.get_current_user_email(token)
        current_user = user_service.get_user_by_email(db, email)
        
        # Check if user has admin role
        if current_user.role != UserRole.ADMIN:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to delete teachers"
            )
        
        # Check if teacher exists
        existing_teacher = teacher_service.get_teacher_by_id(db, teacher_id)
        if not existing_teacher:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Teacher not found"
            )
        
        # Delete teacher
        teacher_service.delete_teacher(db, teacher_id)
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )

@router.get("/{teacher_id}/subjects", response_model=List[SubjectResponse])
def get_teacher_subjects_endpoint(
    teacher_id: int,
    db: Session = Depends(get_db)
):
    # Check if teacher exists
    teacher = teacher_service.get_teacher_by_id(db, teacher_id)
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher not found"
        )
    
    # Get all subjects taught by the teacher
    subjects = teacher_service.get_teacher_subjects(db, teacher_id)
    return subjects

@router.get("/{teacher_id}/classes", response_model=List[ClassResponse])
def get_teacher_classes_endpoint(
    teacher_id: int,
    db: Session = Depends(get_db)
):
    # Check if teacher exists
    teacher = teacher_service.get_teacher_by_id(db, teacher_id)
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher not found"
        )
    
    # Get all classes taught by the teacher
    classes = teacher_service.get_teacher_classes(db, teacher_id)
    return classes

@router.get("/{teacher_id}/homeroom-classes", response_model=List[HomeroomClassResponse])
def get_teacher_homeroom_classes_endpoint(
    teacher_id: int,
    db: Session = Depends(get_db)
):
    """
    Get classes where the teacher is the homeroom teacher
    """
    # Check if teacher exists
    teacher = teacher_service.get_teacher_by_id(db, teacher_id)
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher not found"
        )
    
    # Get all homeroom classes for the teacher
    classes = teacher_service.get_teacher_homeroom_classes(db, teacher_id)
    return classes 