from sqlalchemy.orm import Session, aliased
from sqlalchemy import select, and_, join
from ..models.teacher import Teacher
from ..models.user import User
from ..models.class_subject import ClassSubject
from ..models.class_ import Class
from ..models.subject import Subject
from ..schemas.teacher_schema import TeacherRead, TeacherUpdate
from typing import List, Optional

def get_teachers(db: Session, skip: int = 0, limit: int = 1000, department_id: Optional[int] = None, search: Optional[str] = None) -> List[TeacherRead]:
    TeacherUser = aliased(User, name="teacher_user_alias")

    query = db.query(
        Teacher.TeacherID,
        TeacherUser.FirstName,
        TeacherUser.LastName,
        Teacher.Degree
    ).join(TeacherUser, Teacher.TeacherID == TeacherUser.UserID)

    # Apply department filter if provided
    if department_id:
        query = query.filter(Teacher.DepartmentID == department_id)
    
    # Apply search filter if provided
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            (TeacherUser.FirstName.ilike(search_term)) | 
            (TeacherUser.LastName.ilike(search_term))
        )
    
    results = query.offset(skip).limit(limit).all()
    
    teachers_read = []
    for row in results:
        name = f"{row.FirstName or ''} {row.LastName or ''}".strip()
        # The query now directly returns Degree from the Teacher table bound to the main query context
        specialization = row.Degree 
        
        teachers_read.append(TeacherRead(
            id=row.TeacherID,
            name=name if name else "N/A",
            specialization=specialization
        ))
    return teachers_read

def get_teacher_by_id(db: Session, teacher_id: int) -> Optional[TeacherRead]:
    TeacherUser = aliased(User, name="teacher_user_alias")

    result = db.query(
        Teacher.TeacherID,
        TeacherUser.FirstName,
        TeacherUser.LastName,
        Teacher.Degree
    ).join(TeacherUser, Teacher.TeacherID == TeacherUser.UserID)\
    .filter(Teacher.TeacherID == teacher_id).first()
    
    if not result:
        return None
    
    name = f"{result.FirstName or ''} {result.LastName or ''}".strip()
    
    return TeacherRead(
        id=result.TeacherID,
        name=name if name else "N/A",
        specialization=result.Degree
    )

def update_teacher(db: Session, teacher_id: int, teacher_data: TeacherUpdate) -> TeacherRead:
    # Get teacher from database
    teacher = db.query(Teacher).filter(Teacher.TeacherID == teacher_id).first()
    
    if not teacher:
        return None
    
    # Update teacher fields if provided
    if teacher_data.DepartmentID is not None:
        teacher.DepartmentID = teacher_data.DepartmentID
    if teacher_data.Graduate is not None:
        teacher.Graduate = teacher_data.Graduate
    if teacher_data.Degree is not None:
        teacher.Degree = teacher_data.Degree
    if teacher_data.Position is not None:
        teacher.Position = teacher_data.Position
    
    # Save to database
    db.commit()
    db.refresh(teacher)
    
    # Return updated teacher
    return get_teacher_by_id(db, teacher_id)

def delete_teacher(db: Session, teacher_id: int) -> bool:
    teacher = db.query(Teacher).filter(Teacher.TeacherID == teacher_id).first()
    
    if not teacher:
        return False
    
    # Delete the teacher record
    db.delete(teacher)
    
    # Note: We're not deleting the corresponding User record here
    # In a real application, you might want to either:
    # 1. Delete the User record as well
    # 2. Or mark the User as inactive instead of deleting
    
    db.commit()
    return True

def get_teacher_subjects(db: Session, teacher_id: int) -> List:
    # Get all distinct subjects taught by the teacher
    results = db.query(
        Subject.SubjectID,
        Subject.SubjectName
    ).join(
        ClassSubject, ClassSubject.SubjectID == Subject.SubjectID
    ).filter(
        ClassSubject.TeacherID == teacher_id
    ).distinct().all()
    
    subjects = []
    for row in results:
        subjects.append({
            "id": row.SubjectID,
            "name": row.SubjectName
        })
    
    return subjects

def get_teacher_classes(db: Session, teacher_id: int) -> List:
    # Get all distinct classes taught by the teacher
    class_subjects = db.query(
        ClassSubject.ClassID
    ).filter(
        ClassSubject.TeacherID == teacher_id
    ).distinct().subquery()
    
    # Get class details
    results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel
    ).filter(
        Class.ClassID.in_(select(class_subjects.c.ClassID))
    ).all()
    
    # Also get homeroom classes
    homeroom_results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel
    ).filter(
        Class.HomeroomTeacherID == teacher_id
    ).all()
    
    # Combine results (avoiding duplicates)
    seen_class_ids = set()
    classes = []
    
    for row in results + homeroom_results:
        if row.ClassID not in seen_class_ids:
            seen_class_ids.add(row.ClassID)
            classes.append({
                "id": row.ClassID,
                "name": row.ClassName,
                "grade": row.GradeLevel,
                "is_homeroom": row.ClassID in [r.ClassID for r in homeroom_results]
            })
    
    return classes

def get_teacher_homeroom_classes(db: Session, teacher_id: int) -> List:
    """
    Get classes where the teacher is the homeroom teacher
    """
    results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel,
        Class.AcademicYear
    ).filter(
        Class.HomeroomTeacherID == teacher_id
    ).all()
    
    classes = []
    for row in results:
        classes.append({
            "id": row.ClassID,
            "name": row.ClassName,
            "grade": row.GradeLevel,
            "academic_year": row.AcademicYear
        })
    
    return classes 