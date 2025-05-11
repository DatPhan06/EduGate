from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from sqlalchemy import func
from fastapi import HTTPException, status
from typing import List, Optional
from ..models.subject import Subject
from ..schemas.subject_schema import SubjectCreate, SubjectUpdate

# Get all subjects
def get_subjects(db: Session, skip: int = 0, limit: int = 1000):
    return db.query(Subject).offset(skip).limit(limit).all()

# Get subject by ID
def get_subject_by_id(db: Session, subject_id: int):
    return db.query(Subject).filter(Subject.SubjectID == subject_id).first()

# Get subject by name (case-insensitive)
def get_subject_by_name(db: Session, subject_name: str):
    return db.query(Subject).filter(func.lower(Subject.SubjectName) == func.lower(subject_name)).first()

# Create new subject
def create_subject(db: Session, subject: SubjectCreate):
    # Check if subject already exists
    existing_subject = get_subject_by_name(db, subject.SubjectName)
    if existing_subject:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Subject with name '{subject.SubjectName}' already exists"
        )
    
    # Create new subject
    db_subject = Subject(
        SubjectName=subject.SubjectName,
        Description=subject.Description
    )
    
    try:
        db.add(db_subject)
        db.commit()
        db.refresh(db_subject)
        return db_subject
    except IntegrityError as e:
        db.rollback()
        print(f"Original IntegrityError: {e.orig}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Could not create subject due to database constraints. Check server logs for more details."
        )

# Update existing subject
def update_subject(db: Session, subject_id: int, subject: SubjectUpdate):
    db_subject = get_subject_by_id(db, subject_id)
    if not db_subject:
        return None
    
    # Update only provided fields
    if subject.SubjectName is not None:
        # Check if the new name already exists for another subject
        existing_subject = get_subject_by_name(db, subject.SubjectName)
        if existing_subject and existing_subject.SubjectID != subject_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Subject with name '{subject.SubjectName}' already exists"
            )
        db_subject.SubjectName = subject.SubjectName
    
    if subject.Description is not None:
        db_subject.Description = subject.Description
    
    try:
        db.commit()
        db.refresh(db_subject)
        return db_subject
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Could not update subject due to database constraints"
        )

# Delete subject
def delete_subject(db: Session, subject_id: int):
    db_subject = get_subject_by_id(db, subject_id)
    if not db_subject:
        return False
    
    try:
        db.delete(db_subject)
        db.commit()
        return True
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot delete subject that is still referenced by other entities"
        ) 