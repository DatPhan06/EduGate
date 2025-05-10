from fastapi import APIRouter, Depends, HTTPException, status, Header, Query
from sqlalchemy.orm import Session
from typing import List, Optional, Dict, Any, Union
from pydantic import BaseModel, Field

from ..database import get_db
from ..schemas.teacher_schema import TeacherRead, TeacherUpdate
from ..schemas.user import UserCreate
from ..services import teacher_service, user_service, auth_service, grade_service
from ..enums.user_enums import UserRole
from ..schemas.grade_schema import GradeComponentCreate, GradeComponentUpdate, GradeComponentResponse, GradeResponse

router = APIRouter(
    prefix="/teachers",
    tags=["teachers"],
    responses={404: {"description": "Not found"}}
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

# Define student response schema
class StudentResponse(BaseModel):
    id: int
    studentId: int
    name: str
    email: Optional[str] = None
    phoneNumber: Optional[str] = None
    dob: Optional[Any] = None
    gender: Optional[str] = None
    enrollmentDate: Optional[Any] = None
    classId: Optional[int] = None
    className: Optional[str] = None
    classGrade: Optional[str] = None

# Define class-subject response schema 
class ClassSubjectResponse(BaseModel):
    class_id: int
    class_name: str
    grade_level: str
    subject_id: int
    subject_name: str
    class_subject_id: int

# Define class with subjects response
class ClassWithSubjectsResponse(BaseModel):
    class_id: int
    class_name: str
    grade_level: str
    subjects: List[Dict[str, Any]]

# Define response schema for homeroom class grades
class HomeroomClassGradesResponse(BaseModel):
    student_id: int
    student_name: str
    grades: List[GradeResponse]

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
    # Authenticate admin/teacher
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
        
        # Check if user has permission (admin or the teacher themselves)
        if current_user.role != UserRole.ADMIN and current_user.UserID != teacher_id:
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

@router.get("/{teacher_id}/homeroom-classes/{class_id}/students", response_model=List[StudentResponse])
def get_homeroom_class_students_endpoint(
    teacher_id: int,
    class_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Get students from a class where the teacher is the homeroom teacher
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            current_user.role != UserRole.TEACHER):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # If teacher, ensure they're accessing their own data
        if current_user.role == UserRole.TEACHER and current_user.UserID != teacher_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teachers can only access their own class data"
            )
        
        # Get students in the homeroom class
        students = teacher_service.get_homeroom_class_students(db, teacher_id, class_id)
        return students
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

# New grade management endpoints for teachers

@router.get("/{teacher_id}/teaching-subjects", response_model=List[Dict[str, Any]])
def get_teacher_teaching_subjects(
    teacher_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Get all subjects taught by the teacher in different classes
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Get subjects taught by the teacher grouped by class
        subjects = teacher_service.get_teacher_teaching_subjects(db, teacher_id)
        return subjects
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.get("/{teacher_id}/class-subjects/{class_subject_id}/students", response_model=List[Dict[str, Any]])
def get_students_in_class_subject(
    teacher_id: int,
    class_subject_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Get all students in a class for a subject taught by the teacher
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Check if the teacher teaches this class-subject
        if not teacher_service.check_teacher_class_subject(db, teacher_id, class_subject_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher does not teach this class-subject"
            )
        
        # Get all students in the class for this subject
        students = teacher_service.get_students_in_class_subject(db, class_subject_id)
        return students
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.get("/{teacher_id}/students/{student_id}/grades", response_model=List[GradeResponse])
def get_student_grades_for_teacher(
    teacher_id: int,
    student_id: int,
    class_subject_id: Optional[int] = Query(None),
    semester: Optional[str] = Query(None),
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Get grades for a student in classes/subjects taught by the teacher
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # If class_subject_id provided, check if teacher teaches this class-subject
        if class_subject_id and not teacher_service.check_teacher_class_subject(db, teacher_id, class_subject_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher does not teach this class-subject"
            )
        
        # Get student grades for subjects taught by the teacher
        grades = teacher_service.get_student_grades_for_teacher(db, teacher_id, student_id, class_subject_id, semester)
        return grades
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.post("/{teacher_id}/grades/components", response_model=GradeComponentResponse)
def create_grade_component(
    teacher_id: int,
    component_data: GradeComponentCreate,
    grade_id: int = Query(..., description="ID of the grade to add component to"),
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Add a new grade component for a student
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Check if the teacher can modify this grade (teaches this class-subject)
        if not teacher_service.check_teacher_can_modify_grade(db, teacher_id, grade_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher is not authorized to modify this grade"
            )
        
        # Add the grade component
        component = grade_service.add_component_to_grade(db, grade_id, component_data)
        if not component:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Grade not found"
            )
        
        # Recalculate final grade after adding component
        teacher_service.recalculate_final_grade(db, grade_id)
        
        return component
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.put("/{teacher_id}/grades/components/{component_id}", response_model=GradeComponentResponse)
def update_grade_component(
    teacher_id: int,
    component_id: int,
    component_update: GradeComponentUpdate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Update a grade component (e.g., change score)
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Check if the teacher can modify this component (teaches this class-subject)
        if not teacher_service.check_teacher_can_modify_component(db, teacher_id, component_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher is not authorized to modify this grade component"
            )
        
        # Update the grade component
        component = grade_service.update_grade_component_details(db, component_id, component_update)
        if not component:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Grade component not found"
            )
        
        # Get the grade ID from the component to recalculate final grade
        grade_id = component.GradeID
        teacher_service.recalculate_final_grade(db, grade_id)
        
        return component
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.delete("/{teacher_id}/grades/components/{component_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_grade_component(
    teacher_id: int,
    component_id: int,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Delete a grade component
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Check if the teacher can modify this component (teaches this class-subject)
        component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
        if not component:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Grade component not found"
            )
        
        grade_id = component.GradeID
        
        if not teacher_service.check_teacher_can_modify_component(db, teacher_id, component_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher is not authorized to modify this grade component"
            )
        
        # Delete the grade component
        success = grade_service.delete_grade_component_by_id(db, component_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Grade component not found"
            )
        
        # Recalculate final grade after deleting component
        teacher_service.recalculate_final_grade(db, grade_id)
        
        return None
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.post("/{teacher_id}/initialize-grade-components", status_code=status.HTTP_201_CREATED)
def initialize_grade_components(
    teacher_id: int,
    grade_id: int = Query(..., description="ID of the grade to add components to"),
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Initialize standard grade components for Vietnamese high school:
    - 3 components with weight 1
    - 2 components with weight 2
    - 1 component with weight 3
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            (current_user.role != UserRole.TEACHER or current_user.UserID != teacher_id)):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # Check if the teacher can modify this grade (teaches this class-subject)
        if not teacher_service.check_teacher_can_modify_grade(db, teacher_id, grade_id):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher is not authorized to modify this grade"
            )
        
        # Initialize standard components
        components = teacher_service.initialize_standard_grade_components(db, grade_id)
        
        return {"message": "Grade components initialized successfully", "count": len(components)}
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        )

@router.get("/{teacher_id}/homeroom-classes/{class_id}/grades", response_model=List[Dict[str, Any]])
def get_homeroom_class_grades_endpoint(
    teacher_id: int,
    class_id: int,
    semester: Optional[str] = Query(None, description="Filter by semester (e.g., 'HK1' or 'HK2')"),
    academic_year: Optional[str] = Query(None, description="Filter by academic year (e.g., '2023-2024')"),
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Get grades for all students in a class where the teacher is the homeroom teacher
    """
    # Authenticate user
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
        
        # Check if user has permission (admin or the teacher themselves)
        if (current_user.role != UserRole.ADMIN and 
            current_user.role != UserRole.TEACHER):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to access this resource"
            )
        
        # If teacher, ensure they're accessing their own data
        if current_user.role == UserRole.TEACHER and current_user.UserID != teacher_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teachers can only access their own class data"
            )
        
        # First, verify that the teacher is actually the homeroom teacher for this class
        class_check = teacher_service.verify_homeroom_teacher(db, teacher_id, class_id)
        if not class_check:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Teacher is not the homeroom teacher for this class"
            )
        
        # Get students in the class
        students = teacher_service.get_homeroom_class_students(db, teacher_id, class_id)
        
        # Get grades for all students in the class
        result = []
        for student in students:
            # Get all grades for this student
            student_grades = grade_service.get_student_grades(db, student["id"], semester, academic_year)
            
            # Create a response object for each student with their grades
            student_data = {
                "student_id": student["id"],
                "student_name": student["name"],
                "grades": student_grades
            }
            
            result.append(student_data)
        
        return result
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An error occurred: {str(e)}"
        ) 