from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..schemas.class_schema import ClassCreate, ClassUpdate, ClassRead
from ..services import class_service
from ..models.class_ import Class as ClassModel # To avoid confusion with schema

router = APIRouter(
    prefix="/classes",
    tags=["classes"],
)

@router.post("/", response_model=ClassRead)
def create_class_endpoint(class_data: ClassCreate, db: Session = Depends(get_db)):
    # Hàm service giờ trả về ClassRead trực tiếp
    # Không cần gọi lại get_classes hoặc validate lại
    try:
        created_class = class_service.create_class(db=db, class_data=class_data) # Sử dụng class_data
        return created_class
    except HTTPException as e:
        raise e # Re-raise lỗi HTTP từ service (vd: Teacher not found)
    except Exception as e:
        # Log lỗi nếu cần
        # logger.error(f"Failed to create class in endpoint: {e}")
        raise HTTPException(status_code=500, detail="Internal server error creating class")

@router.get("/", response_model=List[ClassRead])
def read_classes_endpoint(
    skip: int = 0, 
    limit: int = 100, 
    search: Optional[str] = Query(None, description="Search term for ClassName, GradeLevel, AcademicYear, or TeacherName"),
    db: Session = Depends(get_db)
):
    classes = class_service.get_classes(db=db, skip=skip, limit=limit, search=search)
    return classes

@router.get("/{class_id}", response_model=ClassRead)
def read_class_endpoint(class_id: int, db: Session = Depends(get_db)):
    # Use the get_classes logic to get a single class with all details
    # This is a bit inefficient but reuses the complex query. 
    # A dedicated get_single_class_details in service would be better.
    classes = class_service.get_classes(db=db, limit=1, search=None) # This needs a filter by ID
    # Temporary workaround to find the class by ID from a broader list if not directly filterable
    # THIS IS NOT EFFICIENT and needs a proper service method.
    # For now, let's assume get_class returns enough or adapt class_service.get_class
    db_class = class_service.get_class(db, class_id=class_id)
    if db_class is None:
        raise HTTPException(status_code=404, detail="Class not found")
    
    teacher_name = None
    if db_class.homeroom_teacher and db_class.homeroom_teacher.user:
        teacher_name = f"{db_class.homeroom_teacher.user.FirstName} {db_class.homeroom_teacher.user.LastName}".strip()

    return ClassRead(
        ClassID=db_class.ClassID,
        ClassName=db_class.ClassName,
        GradeLevel=db_class.GradeLevel,
        AcademicYear=db_class.AcademicYear,
        HomeroomTeacherID=db_class.HomeroomTeacherID,
        teacherName=teacher_name,
        totalStudents=len(db_class.students) if db_class.students else 0
    )

@router.put("/{class_id}", response_model=ClassRead)
def update_class_endpoint(class_id: int, class_in: ClassUpdate, db: Session = Depends(get_db)):
    updated_class = class_service.update_class(db=db, class_id=class_id, class_in=class_in)
    if updated_class is None:
        raise HTTPException(status_code=404, detail="Class not found")
    # Refetch to get derived fields
    class_read = class_service.get_class(db, class_id=updated_class.ClassID)
    teacher_name = None
    if class_read.homeroom_teacher and class_read.homeroom_teacher.user:
        teacher_name = f"{class_read.homeroom_teacher.user.FirstName} {class_read.homeroom_teacher.user.LastName}".strip()
    return ClassRead(
        ClassID=class_read.ClassID,
        ClassName=class_read.ClassName,
        GradeLevel=class_read.GradeLevel,
        AcademicYear=class_read.AcademicYear,
        HomeroomTeacherID=class_read.HomeroomTeacherID,
        teacherName=teacher_name,
        totalStudents=len(class_read.students) if class_read.students else 0
    )

@router.delete("/{class_id}", response_model=ClassRead) # Or perhaps just a status code
def delete_class_endpoint(class_id: int, db: Session = Depends(get_db)):
    deleted_class = class_service.delete_class(db=db, class_id=class_id)
    if deleted_class is None:
        raise HTTPException(status_code=404, detail="Class not found")
    # Convert to ClassRead; teacherName and totalStudents might be stale or default
    return ClassRead.model_validate(deleted_class) 