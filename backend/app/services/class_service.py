from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, select
from ..models.class_ import Class
from ..models.user import User
from ..models.teacher import Teacher
from ..models.student import Student
from ..schemas.class_schema import ClassCreate, ClassUpdate, ClassRead
from typing import List, Optional

def get_class(db: Session, class_id: int) -> Optional[Class]:
    return db.query(Class).options(
        joinedload(Class.homeroom_teacher).joinedload(Teacher.user),
        joinedload(Class.students)
    ).filter(Class.ClassID == class_id).first()

def get_classes(db: Session, skip: int = 0, limit: int = 100, search: Optional[str] = None) -> List[ClassRead]:
    query = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel,
        Class.AcademicYear,
        Class.HomeroomTeacherID,
        User.FirstName.label("teacher_first_name"),
        User.LastName.label("teacher_last_name"),
        func.count(Student.StudentID).label("total_students")
    ).outerjoin(Teacher, Class.HomeroomTeacherID == Teacher.TeacherID)\
    .outerjoin(User, Teacher.TeacherID == User.UserID)\
    .outerjoin(Student, Class.ClassID == Student.ClassID)\
    .group_by(
        Class.ClassID, 
        Class.ClassName, 
        Class.GradeLevel, 
        Class.AcademicYear, 
        Class.HomeroomTeacherID,
        User.FirstName,
        User.LastName
    )

    if search:
        search_term = f"%{search.lower()}%"
        query = query.filter(
            (func.lower(Class.ClassName).like(search_term)) |
            (func.lower(Class.GradeLevel).like(search_term)) |
            (func.lower(Class.AcademicYear).like(search_term)) |
            (func.lower(User.FirstName + " " + User.LastName).like(search_term))
        )

    results = query.offset(skip).limit(limit).all()
    
    classes_read = []
    for row in results:
        teacher_name = None
        if row.teacher_first_name and row.teacher_last_name:
            teacher_name = f"{row.teacher_first_name} {row.teacher_last_name}"
        elif row.teacher_first_name: # Handle case where only first name might exist
             teacher_name = row.teacher_first_name
        elif row.teacher_last_name: # Handle case where only last name might exist
             teacher_name = row.teacher_last_name

        classes_read.append(ClassRead(
            ClassID=row.ClassID,
            ClassName=row.ClassName,
            GradeLevel=row.GradeLevel,
            AcademicYear=row.AcademicYear,
            HomeroomTeacherID=row.HomeroomTeacherID,
            teacherName=teacher_name,
            totalStudents=row.total_students
        ))
    return classes_read

def create_class(db: Session, class_in: ClassCreate) -> Class:
    db_class = Class(
        ClassName=class_in.ClassName,
        GradeLevel=class_in.GradeLevel,
        AcademicYear=class_in.AcademicYear,
        HomeroomTeacherID=class_in.HomeroomTeacherID
    )
    db.add(db_class)
    db.commit()
    db.refresh(db_class)
    return db_class

def update_class(db: Session, class_id: int, class_in: ClassUpdate) -> Optional[Class]:
    db_class = db.query(Class).filter(Class.ClassID == class_id).first()
    if not db_class:
        return None
    
    update_data = class_in.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_class, key, value)
    
    db.add(db_class)
    db.commit()
    db.refresh(db_class)
    return db_class

def delete_class(db: Session, class_id: int) -> Optional[Class]:
    db_class = db.query(Class).filter(Class.ClassID == class_id).first()
    if not db_class:
        return None
    
    # Optionally, handle students in the class (e.g., set their ClassID to null or prevent deletion if students exist)
    # For now, just deleting the class
    
    db.delete(db_class)
    db.commit()
    return db_class 