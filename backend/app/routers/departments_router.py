from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
# Adjust dependency import based on project structure
# from ..dependencies import get_db 
from ..database import get_db # Common pattern
from ..services import department_service
from ..schemas.department_schema import DepartmentRead, DepartmentCreate
from ..schemas.teacher_schema import TeacherBasicInfo
from pydantic import BaseModel

# Request model for adding teacher to department
class AssignTeacherPayload(BaseModel):
    teacher_user_id: int

router = APIRouter(prefix="/departments", tags=["departments"])

@router.get("/", response_model=List[DepartmentRead])
def read_departments(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    departments = department_service.get_departments(db, skip=skip, limit=limit)
    return departments

@router.get("/{department_id}", response_model=DepartmentRead)
def read_department_detail(department_id: int, db: Session = Depends(get_db)):
    department = department_service.get_department_by_id(db, dept_id=department_id)
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Department not found")
    return department

# Endpoint để lấy danh sách giáo viên trong một phòng ban cụ thể
# Thực ra, thông tin này đã có trong GET /{department_id} nếu DepartmentRead đã bao gồm teachers
# Nhưng nếu muốn một endpoint riêng biệt chỉ trả về danh sách giáo viên thì có thể làm như sau:
@router.get("/{department_id}/teachers", response_model=List[TeacherBasicInfo])
def get_teachers_in_department_route(department_id: int, db: Session = Depends(get_db)):
    department = department_service.get_department_by_id(db, dept_id=department_id)
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Department not found")
    return department.teachers

@router.post("/{department_id}/teachers", status_code=status.HTTP_200_OK)
def add_teacher_to_department_route(department_id: int, payload: AssignTeacherPayload, db: Session = Depends(get_db)):
    try:
        updated_teacher = department_service.add_teacher_to_department(db, department_id=department_id, teacher_user_id=payload.teacher_user_id)
        if updated_teacher and updated_teacher.user:
            return TeacherBasicInfo(
                UserID=updated_teacher.user.UserID,
                FirstName=updated_teacher.user.FirstName,
                LastName=updated_teacher.user.LastName,
                Email=updated_teacher.user.Email,
                Position=updated_teacher.Position
            )
        return {"message": "Teacher added to department successfully, but no detailed info returned."}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.delete("/{department_id}/teachers/{teacher_user_id}", status_code=status.HTTP_204_NO_CONTENT)
def remove_teacher_from_department_route(department_id: int, teacher_user_id: int, db: Session = Depends(get_db)):
    try:
        department_service.remove_teacher_from_department(db, department_id=department_id, teacher_user_id=teacher_user_id)
        return
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

@router.post("/", response_model=DepartmentRead, status_code=status.HTTP_201_CREATED)
def create_department_route(department: DepartmentCreate, db: Session = Depends(get_db)):
    """
    Create a new department
    """
    try:
        created_department = department_service.create_department(db, department)
        return created_department
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating department: {str(e)}"
        ) 