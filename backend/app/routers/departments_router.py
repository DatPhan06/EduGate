from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
# Adjust dependency import based on project structure
# from ..dependencies import get_db 
from ..database import get_db # Common pattern
from ..services import department_service
from ..schemas.department_schema import DepartmentRead, DepartmentCreate, DepartmentUpdate
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

@router.delete("/{department_id}/teachers/{teacher_id}", status_code=status.HTTP_200_OK)
def remove_teacher_from_department_route(department_id: int, teacher_id: int, db: Session = Depends(get_db)):
    try:
        department_service.remove_teacher_from_department(db, department_id=department_id, teacher_user_id=teacher_id)
        return {"message": "Teacher removed from department successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error removing teacher from department: {str(e)}"
        )

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

@router.put("/{department_id}", response_model=DepartmentRead)
def update_department_route(department_id: int, department: DepartmentUpdate, db: Session = Depends(get_db)):
    """
    Update an existing department
    """
    try:
        updated_department = department_service.update_department(db, department_id, department)
        if not updated_department:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Department with ID {department_id} not found"
            )
        return updated_department
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating department: {str(e)}"
        )

@router.delete("/{department_id}", status_code=status.HTTP_200_OK)
def delete_department_route(department_id: int, db: Session = Depends(get_db)):
    """
    Delete a department
    """
    try:
        success = department_service.delete_department(db, department_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Department with ID {department_id} not found"
            )
        return {"message": f"Department with ID {department_id} deleted successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting department: {str(e)}"
        )