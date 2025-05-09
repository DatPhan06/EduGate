from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException, status
from typing import List, Optional
from ..models.class_subject import ClassSubject
from ..models.subject_schedule import SubjectSchedule
from ..schemas.class_subject_schema import ClassSubjectCreate, ClassSubjectUpdate

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