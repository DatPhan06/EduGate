from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..schemas.teacher_schema import TeacherRead
from ..services import teacher_service

router = APIRouter(
    prefix="/teachers",
    tags=["teachers"],
)

@router.get("/", response_model=List[TeacherRead])
def read_teachers_endpoint(
    skip: int = 0, 
    limit: int = 1000, # Default high limit for dropdowns
    db: Session = Depends(get_db)
):
    teachers = teacher_service.get_teachers(db=db, skip=skip, limit=limit)
    return teachers 