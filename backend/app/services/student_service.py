from sqlalchemy.orm import Session, joinedload, aliased
from sqlalchemy import func, select
from typing import List, Optional

from ..models.user import User
from ..models.student import Student
from ..models.class_ import Class
from ..models.parent import Parent
from ..models.parent_student import ParentStudent
from ..schemas.student_schema import StudentRead
from ..schemas.user import UserCreate, UserUpdate # For create/update operations
from ..services import user_service # To use create_user and update_user
from ..enums.user_enums import UserRole
from fastapi import HTTPException, status


def _get_student_details_query(db: Session):
    ParentUser = aliased(User, name="parent_user_details_alias")
    StudentUserQueryAlias = aliased(User, name="student_user_details_alias") # Alias for use within this query function

    return db.query(
        StudentUserQueryAlias.UserID.label("id"),
        StudentUserQueryAlias.UserID.label("studentId"),
        StudentUserQueryAlias.FirstName.label("student_first_name"),
        StudentUserQueryAlias.LastName.label("student_last_name"),
        Student.ClassID.label("classId"),
        Class.ClassName.label("className"),
        ParentUser.FirstName.label("parent_first_name"),
        ParentUser.LastName.label("parent_last_name")
    ).select_from(Student)\
    .join(StudentUserQueryAlias, Student.StudentID == StudentUserQueryAlias.UserID)\
    .outerjoin(Class, Student.ClassID == Class.ClassID)\
    .outerjoin(ParentStudent, Student.StudentID == ParentStudent.StudentID)\
    .outerjoin(Parent, ParentStudent.ParentID == Parent.ParentID)\
    .outerjoin(ParentUser, Parent.ParentID == ParentUser.UserID)

def _format_student_read(row) -> StudentRead:
    student_name = f"{row.student_first_name or ''} {row.student_last_name or ''}".strip()
    # Bỏ parent_name
    # parent_name = None
    # if row.parent_first_name or row.parent_last_name:
    #     parent_name = f"{row.parent_first_name or ''} {row.parent_last_name or ''}".strip()
    
    return StudentRead(
        id=row.id,
        studentId=row.studentId,
        name=student_name if student_name else "N/A",
        Email=getattr(row, 'Email', None),
        PhoneNumber=getattr(row, 'PhoneNumber', None),
        DOB=getattr(row, 'DOB', None),
        PlaceOfBirth=getattr(row, 'PlaceOfBirth', None),
        Gender=getattr(row, 'Gender', None),
        Street=getattr(row, 'Street', None),
        District=getattr(row, 'District', None),
        City=getattr(row, 'City', None),
        Address=getattr(row, 'Address', None),
        Status=getattr(row, 'Status', None),
        EnrollmentDate=getattr(row, 'EnrollmentDate', None),
        YtDate=getattr(row, 'YtDate', None),
        classId=row.classId,
        className=row.className,
        classGrade=getattr(row, 'classGrade', None)
        # Bỏ parentName=parent_name
    )

def get_students(db: Session, skip: int = 0, limit: int = 100, search: Optional[str] = None, class_id_filter: Optional[int] = None) -> List[StudentRead]:
    StudentUser = aliased(User, name="student_user_alias")
    
    # Bỏ join với Parent và ParentStudent ở đây
    query = db.query(
        StudentUser.UserID.label("id"),
        StudentUser.UserID.label("studentId"),
        StudentUser.FirstName.label("student_first_name"),
        StudentUser.LastName.label("student_last_name"),
        StudentUser.Email.label("Email"),
        StudentUser.PhoneNumber.label("PhoneNumber"),
        StudentUser.DOB.label("DOB"),
        StudentUser.PlaceOfBirth.label("PlaceOfBirth"),
        StudentUser.Gender.label("Gender"),
        StudentUser.Street.label("Street"),
        StudentUser.District.label("District"),
        StudentUser.City.label("City"),
        StudentUser.Address.label("Address"),
        StudentUser.Status.label("Status"),
        Student.EnrollmentDate.label("EnrollmentDate"),
        Student.YtDate.label("YtDate"),
        Student.ClassID.label("classId"),
        Class.GradeLevel.label("classGrade"),
        Class.ClassName.label("className")
        # Bỏ parent_first_name, parent_last_name
    ).select_from(Student)\
    .join(StudentUser, Student.StudentID == StudentUser.UserID)\
    .outerjoin(Class, Student.ClassID == Class.ClassID)
    # Bỏ các join liên quan đến Parent/ParentStudent
    # .outerjoin(ParentStudent, Student.StudentID == ParentStudent.StudentID)\
    # .outerjoin(Parent, ParentStudent.ParentID == Parent.ParentID)\
    # .outerjoin(ParentUser, Parent.ParentID == ParentUser.UserID)

    if class_id_filter is not None:
        query = query.filter(Student.ClassID == class_id_filter)

    if search:
        search_term = f"%{search.lower()}%"
        query = query.filter(
            (func.lower(StudentUser.FirstName + " " + StudentUser.LastName).like(search_term)) |
            (func.lower(Class.ClassName).like(search_term))
        )

    results = query.order_by(StudentUser.UserID).offset(skip).limit(limit).all()
    return [_format_student_read(row) for row in results]

def get_student_by_id(db: Session, student_user_id: int) -> Optional[StudentRead]:
    StudentUser = aliased(User, name="student_user_single_alias")
    
    # Bỏ join với Parent và ParentStudent
    query = db.query(
        StudentUser.UserID.label("id"),
        StudentUser.UserID.label("studentId"),
        StudentUser.FirstName.label("student_first_name"),
        StudentUser.LastName.label("student_last_name"),
        StudentUser.Email.label("Email"),
        StudentUser.PhoneNumber.label("PhoneNumber"),
        StudentUser.DOB.label("DOB"),
        StudentUser.PlaceOfBirth.label("PlaceOfBirth"),
        StudentUser.Gender.label("Gender"),
        StudentUser.Street.label("Street"),
        StudentUser.District.label("District"),
        StudentUser.City.label("City"),
        StudentUser.Address.label("Address"),
        StudentUser.Status.label("Status"),
        Student.EnrollmentDate.label("EnrollmentDate"),
        Student.YtDate.label("YtDate"),
        Student.ClassID.label("classId"),
        Class.GradeLevel.label("classGrade"),
        Class.ClassName.label("className")
        # Bỏ parent_first_name, parent_last_name
    ).select_from(Student)\
    .join(StudentUser, Student.StudentID == StudentUser.UserID)\
    .outerjoin(Class, Student.ClassID == Class.ClassID).filter(StudentUser.UserID == student_user_id)
    
    row = query.first()
    return _format_student_read(row) if row else None


def create_student(db: Session, student_data: UserCreate) -> User:
    # Ensure role is set to student
    student_data.role = UserRole.STUDENT
    # StudentCode should be part of student_data as per UserCreate schema update
    # ClassID also part of student_data
    
    # Validate that ClassID exists if provided
    if student_data.ClassID:
        class_obj = db.query(Class).filter(Class.ClassID == student_data.ClassID).first()
        if not class_obj:
            raise HTTPException(status_code=400, detail=f"Class with ID {student_data.ClassID} not found.")

    return user_service.create_user(db=db, user=student_data)

def update_student(db: Session, student_user_id: int, student_data: UserUpdate) -> Optional[User]:
    # StudentCode and ClassID updates are handled by user_service.update_user
    # due to schema modifications
    
    # Validate that ClassID exists if provided and changed
    if student_data.ClassID is not None:
        student_user = user_service.get_user_by_id(db, student_user_id)
        if not student_user or not student_user.student:
            raise HTTPException(status_code=404, detail="Student not found")
        
        if student_user.student.ClassID != student_data.ClassID:
            class_obj = db.query(Class).filter(Class.ClassID == student_data.ClassID).first()
            if not class_obj:
                raise HTTPException(status_code=400, detail=f"Class with ID {student_data.ClassID} not found.")

    return user_service.update_user(db=db, user_id=student_user_id, user=student_data)

def delete_student(db: Session, student_user_id: int) -> bool:
    # user_service.delete_user should handle deleting the User and associated Student record (due to cascade or explicit logic)
    # Verify if user_service.delete_user is sufficient or if Student needs to be deleted first.
    # For now, assuming user_service.delete_user handles it.
    # Before deleting, ensure the student has no FK constraints that would prevent deletion (e.g. grades)
    # It's often better to deactivate (set Status to INACTIVE) than to hard delete.
    
    # First, check if the user is indeed a student
    user = user_service.get_user_by_id(db, student_user_id)
    if not user or user.role != UserRole.STUDENT:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found or user is not a student.")

    # Call user_service to delete (this might need adjustment based on its implementation)
    # If delete_user just removes User, and Student has FK to UserID, then Student should be removed first or by cascade.
    # Let's assume cascade or User service handles it.
    
    # Consider implications: what happens to student's grades, attendance, etc.?
    # For now, a direct deletion via user_service
    return user_service.delete_user(db=db, user_id=student_user_id)

# The following functions are removed as they are handled by parent_student_service.py
# def get_linked_parents(db: Session, student_id: int) -> List[UserSchema]:
# ...
# def unlink_parent_student(db: Session, student_id: int, parent_id: int) -> bool:
# ... 