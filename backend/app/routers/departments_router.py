from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
# Adjust dependency import based on project structure
# from ..dependencies import get_db 
from ..database import get_db # Common pattern
from ..services import department_service
from ..schemas.department_schema import DepartmentRead

router = APIRouter(prefix="/departments", tags=["departments"])

@router.get("/", response_model=List[DepartmentRead])
def read_departments(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    departments = department_service.get_departments(db, skip=skip, limit=limit)
    return departments 