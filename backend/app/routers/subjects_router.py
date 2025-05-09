from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services.subject_service import *
from ..schemas.subject_schema import SubjectRead, SubjectCreate, SubjectUpdate

router = APIRouter(prefix="/subjects", tags=["subjects"])

@router.get("/", response_model=List[SubjectRead])
def read_subjects(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    """
    Get all subjects
    """
    subjects = get_subjects(db, skip=skip, limit=limit)
    return subjects

@router.get("/{subject_id}", response_model=SubjectRead)
def read_subject_detail(subject_id: int, db: Session = Depends(get_db)):
    """
    Get a specific subject by ID
    """
    subject = get_subject_by_id(db, subject_id=subject_id)
    if not subject:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Subject not found")
    return subject

@router.post("/", response_model=SubjectRead, status_code=status.HTTP_201_CREATED)
def create_subject_route(subject: SubjectCreate, db: Session = Depends(get_db)):
    """
    Create a new subject
    """
    try:
        created_subject = create_subject(db, subject)
        return created_subject
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating subject: {str(e)}"
        )

@router.put("/{subject_id}", response_model=SubjectRead)
def update_subject_route(subject_id: int, subject: SubjectUpdate, db: Session = Depends(get_db)):
    """
    Update an existing subject
    """
    try:
        updated_subject = update_subject(db, subject_id, subject)
        if not updated_subject:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Subject with ID {subject_id} not found"
            )
        return updated_subject
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating subject: {str(e)}"
        )

@router.delete("/{subject_id}", status_code=status.HTTP_200_OK)
def delete_subject_route(subject_id: int, db: Session = Depends(get_db)):
    """
    Delete a subject
    """
    try:
        success = delete_subject(db, subject_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Subject with ID {subject_id} not found"
            )
        return {"message": f"Subject with ID {subject_id} deleted successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting subject: {str(e)}"
        ) 