from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.department import Department
from ..schemas.department_schema import DepartmentRead

def get_departments(db: Session, skip: int = 0, limit: int = 1000) -> List[DepartmentRead]: # Higher limit for dropdowns
    results = db.query(Department).offset(skip).limit(limit).all()
    # Use model_validate for Pydantic v2
    return [DepartmentRead.model_validate(dept) for dept in results]

def get_department_by_id(db: Session, dept_id: int) -> Optional[Department]:
     return db.query(Department).filter(Department.DepartmentID == dept_id).first() 