from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from ..models.department import Department
from ..models.teacher import Teacher
from ..models.user import User
from ..schemas.department_schema import DepartmentRead, DepartmentCreate
from ..schemas.teacher_schema import TeacherBasicInfo
from fastapi import HTTPException, status

def get_departments(db: Session, skip: int = 0, limit: int = 1000) -> List[DepartmentRead]:
    departments = db.query(Department).options(joinedload(Department.teachers).joinedload(Teacher.user)).offset(skip).limit(limit).all()
    
    departments_read = []
    for dept in departments:
        teachers_info = []
        for teacher_model in dept.teachers:
            if teacher_model.user:
                teachers_info.append(
                    TeacherBasicInfo(
                        UserID=teacher_model.user.UserID,
                        FirstName=teacher_model.user.FirstName,
                        LastName=teacher_model.user.LastName,
                        Email=teacher_model.user.Email,
                        Position=teacher_model.Position
                    )
                )
        departments_read.append(
            DepartmentRead(
                DepartmentID=dept.DepartmentID,
                DepartmentName=dept.DepartmentName,
                Description=dept.Description,
                teachers=teachers_info
            )
        )
    return departments_read

def get_department_by_id(db: Session, dept_id: int) -> Optional[DepartmentRead]:
    department = db.query(Department).options(
        joinedload(Department.teachers).joinedload(Teacher.user)
    ).filter(Department.DepartmentID == dept_id).first()
    
    if not department:
        return None

    teachers_info = []
    for teacher_model in department.teachers:
        if teacher_model.user:
            teachers_info.append(
                TeacherBasicInfo(
                    UserID=teacher_model.user.UserID,
                    FirstName=teacher_model.user.FirstName,
                    LastName=teacher_model.user.LastName,
                    Email=teacher_model.user.Email,
                    Position=teacher_model.Position
                )
            )
            
    return DepartmentRead(
        DepartmentID=department.DepartmentID,
        DepartmentName=department.DepartmentName,
        Description=department.Description,
        teachers=teachers_info
    )

def add_teacher_to_department(db: Session, department_id: int, teacher_user_id: int) -> Optional[Teacher]:
    department = db.query(Department).filter(Department.DepartmentID == department_id).first()
    if not department:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Department with ID {department_id} not found")

    teacher = db.query(Teacher).join(User, Teacher.TeacherID == User.UserID).filter(User.UserID == teacher_user_id).first()
    if not teacher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Teacher with UserID {teacher_user_id} not found")

    if teacher.DepartmentID == department_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Teacher {teacher.user.FirstName} {teacher.user.LastName} is already in department {department.DepartmentName}")

    teacher.DepartmentID = department_id
    db.commit()
    db.refresh(teacher)
    return teacher

def remove_teacher_from_department(db: Session, department_id: int, teacher_user_id: int) -> Optional[Teacher]:
    department = db.query(Department).filter(Department.DepartmentID == department_id).first()
    teacher = db.query(Teacher).join(User, Teacher.TeacherID == User.UserID).filter(User.UserID == teacher_user_id, Teacher.DepartmentID == department_id).first()
    if not teacher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Teacher with UserID {teacher_user_id} not found in department ID {department_id}")

    teacher.DepartmentID = None
    db.commit()
    db.refresh(teacher)
    return teacher

def create_department(db: Session, department: DepartmentCreate) -> DepartmentRead:
    """
    Create a new department
    """
    # Check if department with the same name already exists
    existing_dept = db.query(Department).filter(Department.DepartmentName == department.DepartmentName).first()
    if existing_dept:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Department with name '{department.DepartmentName}' already exists"
        )
    
    # Create new department
    db_department = Department(
        DepartmentName=department.DepartmentName,
        Description=department.Description
    )
    
    # Add to database
    db.add(db_department)
    db.commit()
    db.refresh(db_department)
    
    # Return the created department
    return DepartmentRead(
        DepartmentID=db_department.DepartmentID,
        DepartmentName=db_department.DepartmentName,
        Description=db_department.Description,
        teachers=[] # New department has no teachers yet
    ) 