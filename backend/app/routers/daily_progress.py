from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..models import Student, Class, User
from ..schemas.daily_progress import DailyProgressCreate, DailyProgressResponse, StudentResponse, ParentChildResponse
from ..services import auth_service, user_service
from ..services.daily_progress_service import DailyProgressService
from ..enums.user_enums import UserRole

router = APIRouter(prefix="/daily-progress", tags=["daily-progress"])

# Dependency: Lấy user hiện tại từ token
async def get_current_active_user(
    authorization: str = Header(None),
    db: Session = Depends(get_db)
) -> User:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication token")
    token = authorization.split(" ")[1]
    try:
        email = auth_service.get_current_user_email(token)
        user = user_service.get_user_by_email(db, email)
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
        return user
    except Exception:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Could not validate credentials")

# 1. Xem sổ liên lạc của học sinh
@router.get("/student/{student_id}", response_model=List[DailyProgressResponse])
def get_daily_progress_by_student(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    student = db.query(Student).filter(Student.StudentID == student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    if current_user.role == UserRole.STUDENT and current_user.UserID != student_id:
        raise HTTPException(status_code=403, detail="Not allowed")
    if current_user.role == UserRole.PARENT:
        is_parent = any(ps.StudentID == student_id for ps in current_user.parent.parent_students)
        if not is_parent:
            raise HTTPException(status_code=403, detail="Not allowed")
    if current_user.role == UserRole.TEACHER:
        if not (student.class_ and student.class_.HomeroomTeacherID == current_user.UserID):
            raise HTTPException(status_code=403, detail="Not allowed")
    progress_list = DailyProgressService.get_by_student(db, student_id)
    return [DailyProgressResponse.from_orm(p) for p in progress_list]

# 2. Xem sổ liên lạc của cả lớp (chỉ homeroom teacher)
@router.get("/class/{class_id}", response_model=List[DailyProgressResponse])
def get_daily_progress_by_class(
    class_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    class_ = db.query(Class).filter(Class.ClassID == class_id).first()
    if not class_:
        raise HTTPException(status_code=404, detail="Class not found")
    if current_user.role != UserRole.TEACHER or class_.HomeroomTeacherID != current_user.UserID:
        raise HTTPException(status_code=403, detail="Not allowed")
    progress_list = DailyProgressService.get_by_class(db, class_id)
    return [DailyProgressResponse.from_orm(p) for p in progress_list]

# 3. Nhập/cập nhật sổ liên lạc cho học sinh (chỉ homeroom teacher)
@router.post("/", response_model=DailyProgressResponse)
def create_or_update_daily_progress(
    data: DailyProgressCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    student = db.query(Student).filter(Student.StudentID == data.StudentID).first()
    if not student or not student.class_:
        raise HTTPException(status_code=404, detail="Student or class not found")
    if current_user.role != UserRole.TEACHER or student.class_.HomeroomTeacherID != current_user.UserID:
        raise HTTPException(status_code=403, detail="Not allowed")
    progress = DailyProgressService.create_or_update(
        db,
        student_id=data.StudentID,
        teacher_id=current_user.UserID,
        date_=data.Date,
        overall=data.Overall,
        attendance=data.Attendance,
        study_outcome=data.StudyOutcome,
        reprimand=data.Reprimand
    )
    return DailyProgressResponse.from_orm(progress)

# 4. Lấy danh sách học sinh của các lớp mà giáo viên là chủ nhiệm
@router.get("/teacher/students", response_model=List[StudentResponse])
def get_teacher_students(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    if current_user.role != UserRole.TEACHER:
        raise HTTPException(status_code=403, detail="Only teachers can access this endpoint")
    
    students = DailyProgressService.get_students_by_teacher(db, current_user.UserID)
    return [
        StudentResponse(
            StudentID=student.StudentID,
            FirstName=student.user.FirstName,
            LastName=student.user.LastName,
            Email=student.user.Email,
            PhoneNumber=student.user.PhoneNumber,
            Address=student.user.Address,
            DateOfBirth=student.user.DOB,
            Gender=student.user.Gender.value if student.user.Gender else None,
            ClassID=student.ClassID,
            ClassName=student.class_.ClassName if student.class_ else None
        ) for student in students
    ]

@router.get("/parent/children", response_model=List[ParentChildResponse])
def get_parent_children(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    if current_user.role != UserRole.PARENT:
        raise HTTPException(status_code=403, detail="Only parents can access this endpoint")
    children = DailyProgressService.get_children_of_parent(db, current_user.UserID)
    return [
        ParentChildResponse(
            StudentID=student.StudentID,
            FirstName=student.user.FirstName,
            LastName=student.user.LastName,
            ClassID=student.ClassID,
            ClassName=student.class_.ClassName if student.class_ else None
        ) for student in children
    ] 