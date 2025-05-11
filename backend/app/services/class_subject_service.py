from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status
from typing import List, Optional, Dict, Any
from ..models.class_subject import ClassSubject
from ..models.subject_schedule import SubjectSchedule
from ..models.subject import Subject
from ..models.class_ import Class
from ..schemas.class_subject_schema import ClassSubjectCreate, ClassSubjectUpdate
from ..services import grade_service

# Get all class subjects
def get_class_subjects(db: Session, skip: int = 0, limit: int = 1000):
    return db.query(ClassSubject).offset(skip).limit(limit).all()

# Get class subjects by class ID
def get_class_subjects_by_class(db: Session, class_id: int):
    return db.query(ClassSubject).filter(ClassSubject.ClassID == class_id).all()

# Get class subjects by subject ID
def get_class_subjects_by_subject(db: Session, subject_id: int):
    return db.query(ClassSubject).filter(ClassSubject.SubjectID == subject_id).all()

# Get class subjects by teacher ID
def get_class_subjects_by_teacher(db: Session, teacher_id: int):
    return db.query(ClassSubject).filter(ClassSubject.TeacherID == teacher_id).all()

# Get class subject by ID
def get_class_subject_by_id(db: Session, class_subject_id: int):
    return db.query(ClassSubject).filter(ClassSubject.ClassSubjectID == class_subject_id).first()

# Check if class subject already exists
def check_class_subject_exists(db: Session, class_id: int, subject_id: int, semester: str, academic_year: str):
    return db.query(ClassSubject).filter(
        ClassSubject.ClassID == class_id,
        ClassSubject.SubjectID == subject_id,
        ClassSubject.Semester == semester,
        ClassSubject.AcademicYear == academic_year
    ).first() is not None

# Create new class subject
def create_class_subject(db: Session, class_subject: ClassSubjectCreate):
    # Check if class subject already exists
    if check_class_subject_exists(
        db, 
        class_subject.ClassID, 
        class_subject.SubjectID, 
        class_subject.Semester, 
        class_subject.AcademicYear
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A class subject with the same class, subject, semester, and academic year already exists"
        )
    
    # Create new class subject
    db_class_subject = ClassSubject(
        TeacherID=class_subject.TeacherID,
        ClassID=class_subject.ClassID,
        SubjectID=class_subject.SubjectID,
        Semester=class_subject.Semester,
        AcademicYear=class_subject.AcademicYear
    )
    
    try:
        db.add(db_class_subject)
        db.commit()
        db.refresh(db_class_subject)
        
        # Always initialize grades for all students in the class, for both semesters
        # Initialize for first semester
        first_semester_grades = grade_service.initialize_grades_for_class_subject(
            db, 
            db_class_subject.ClassSubjectID,
            "Học kỳ 1"
        )
        
        # Initialize for second semester
        second_semester_grades = grade_service.initialize_grades_for_class_subject(
            db, 
            db_class_subject.ClassSubjectID,
            "Học kỳ 2"
        )
        
        # Initialize standard grade components for all created grades
        all_grade_ids = [grade.GradeID for grade in first_semester_grades + second_semester_grades]
        if all_grade_ids:
            grade_service.initialize_standard_components_for_grades(db, all_grade_ids)
        
        return db_class_subject
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not create class subject due to database constraints: {str(e)}"
        )

# Update existing class subject
def update_class_subject(db: Session, class_subject_id: int, class_subject: ClassSubjectUpdate):
    db_class_subject = get_class_subject_by_id(db, class_subject_id)
    if not db_class_subject:
        return None
    
    # Remember old values for later
    old_teacher_id = db_class_subject.TeacherID
    old_semester = db_class_subject.Semester
    
    # Update fields
    if class_subject.TeacherID is not None:
        db_class_subject.TeacherID = class_subject.TeacherID
    if class_subject.Semester is not None:
        db_class_subject.Semester = class_subject.Semester
    if class_subject.AcademicYear is not None:
        db_class_subject.AcademicYear = class_subject.AcademicYear
    
    try:
        db.commit()
        db.refresh(db_class_subject)
        
        # Check if anything changed that would warrant creating grade structures
        if old_teacher_id != db_class_subject.TeacherID or old_semester != db_class_subject.Semester:
            # Make sure grade structures exist for both semesters regardless of teacher change
            first_semester_grades = grade_service.initialize_grades_for_class_subject(
                db, 
                db_class_subject.ClassSubjectID,
                "Học kỳ 1"
            )
            
            second_semester_grades = grade_service.initialize_grades_for_class_subject(
                db, 
                db_class_subject.ClassSubjectID,
                "Học kỳ 2"
            )
            
            # Initialize standard grade components for all created grades
            all_grade_ids = [grade.GradeID for grade in first_semester_grades + second_semester_grades]
            if all_grade_ids:
                grade_service.initialize_standard_components_for_grades(db, all_grade_ids)
        
        return db_class_subject
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not update class subject due to database constraints: {str(e)}"
        )

# Delete class subject
def delete_class_subject(db: Session, class_subject_id: int):
    db_class_subject = get_class_subject_by_id(db, class_subject_id)
    if not db_class_subject:
        return False
    
    try:
        db.delete(db_class_subject)
        db.commit()
        return True
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not delete class subject: {str(e)}"
        )

# Get class subject with schedules
def get_class_subject_with_schedules(db: Session, class_subject_id: int):
    db_class_subject = get_class_subject_by_id(db, class_subject_id)
    if not db_class_subject:
        return None
    
    # Load schedules
    db_class_subject.schedules = db.query(SubjectSchedule).filter(
        SubjectSchedule.ClassSubjectID == class_subject_id
    ).all()
    
    return db_class_subject

# Get subject information from class subject ID
def get_subject_by_class_subject_id(db: Session, class_subject_id: int) -> Optional[Dict[str, Any]]:
    """
    Get subject information from a class subject ID
    
    Args:
        db: Database session
        class_subject_id: The ID of the class-subject
        
    Returns:
        Dictionary with subject information or None if not found
    """
    # Get the class subject with the subject loaded
    class_subject = db.query(ClassSubject).options(
        joinedload(ClassSubject.subject),
        joinedload(ClassSubject.class_)
    ).filter(
        ClassSubject.ClassSubjectID == class_subject_id
    ).first()
    
    if not class_subject:
        return None
    
    # Create response with subject information and context
    return {
        "subject_id": class_subject.SubjectID,
        "subject_name": class_subject.subject.SubjectName if class_subject.subject else None,
        "subject_description": class_subject.subject.Description if class_subject.subject else None,
        "class_subject_id": class_subject.ClassSubjectID,
        "class_id": class_subject.ClassID,
        "class_name": class_subject.class_.ClassName if class_subject.class_ else None,
        "semester": class_subject.Semester,
        "academic_year": class_subject.AcademicYear,
        "teacher_id": class_subject.TeacherID
    } 