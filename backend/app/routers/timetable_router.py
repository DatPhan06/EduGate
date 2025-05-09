from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services.subject_schedule_service import *
from ..services.class_subject_service import *
from ..schemas.subject_schedule_schema import SubjectScheduleRead, SubjectScheduleCreate, SubjectScheduleUpdate
from ..schemas.class_subject_schema import ClassSubjectRead, ClassSubjectCreate, ClassSubjectUpdate, ClassSubjectWithSchedules

router = APIRouter(prefix="/timetable", tags=["timetable"])

# Class Subject endpoints
@router.get("/class-subjects/", response_model=List[ClassSubjectRead])
def read_class_subjects(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    """
    Get all class-subject assignments
    """
    class_subjects = get_class_subjects(db, skip=skip, limit=limit)
    return class_subjects

@router.get("/class-subjects/{class_subject_id}", response_model=ClassSubjectWithSchedules)
def read_class_subject_detail(class_subject_id: int, db: Session = Depends(get_db)):
    """
    Get a specific class-subject assignment with schedules
    """
    class_subject = get_class_subject_with_schedules(db, class_subject_id=class_subject_id)
    if not class_subject:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Class-subject assignment not found")
    return class_subject

@router.get("/classes/{class_id}/subjects", response_model=List[ClassSubjectRead])
def read_class_subjects_by_class(class_id: int, db: Session = Depends(get_db)):
    """
    Get all subjects for a specific class
    """
    class_subjects = get_class_subjects_by_class(db, class_id=class_id)
    return class_subjects

@router.get("/subjects/{subject_id}/classes", response_model=List[ClassSubjectRead])
def read_class_subjects_by_subject(subject_id: int, db: Session = Depends(get_db)):
    """
    Get all classes for a specific subject
    """
    class_subjects = get_class_subjects_by_subject(db, subject_id=subject_id)
    return class_subjects

@router.get("/teachers/{teacher_id}/class-subjects", response_model=List[ClassSubjectRead])
def read_class_subjects_by_teacher(teacher_id: int, db: Session = Depends(get_db)):
    """
    Get all class-subject assignments for a specific teacher
    """
    class_subjects = get_class_subjects_by_teacher(db, teacher_id=teacher_id)
    return class_subjects

@router.post("/class-subjects/", response_model=ClassSubjectRead, status_code=status.HTTP_201_CREATED)
def create_class_subject_route(class_subject: ClassSubjectCreate, db: Session = Depends(get_db)):
    """
    Create a new class-subject assignment
    """
    try:
        created_class_subject = create_class_subject(db, class_subject)
        return created_class_subject
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating class-subject assignment: {str(e)}"
        )

@router.put("/class-subjects/{class_subject_id}", response_model=ClassSubjectRead)
def update_class_subject_route(class_subject_id: int, class_subject: ClassSubjectUpdate, db: Session = Depends(get_db)):
    """
    Update an existing class-subject assignment
    """
    try:
        updated_class_subject = update_class_subject(db, class_subject_id, class_subject)
        if not updated_class_subject:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Class-subject assignment with ID {class_subject_id} not found"
            )
        return updated_class_subject
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating class-subject assignment: {str(e)}"
        )

@router.delete("/class-subjects/{class_subject_id}", status_code=status.HTTP_200_OK)
def delete_class_subject_route(class_subject_id: int, db: Session = Depends(get_db)):
    """
    Delete a class-subject assignment
    """
    try:
        success = delete_class_subject(db, class_subject_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Class-subject assignment with ID {class_subject_id} not found"
            )
        return {"message": f"Class-subject assignment with ID {class_subject_id} deleted successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting class-subject assignment: {str(e)}"
        )

# Schedule endpoints
@router.get("/schedules/", response_model=List[SubjectScheduleRead])
def read_schedules(skip: int = 0, limit: int = 1000, db: Session = Depends(get_db)):
    """
    Get all schedules
    """
    schedules = get_schedules(db, skip=skip, limit=limit)
    return schedules

@router.get("/class-subjects/{class_subject_id}/schedules", response_model=List[SubjectScheduleRead])
def read_schedules_by_class_subject(class_subject_id: int, db: Session = Depends(get_db)):
    """
    Get all schedules for a specific class-subject assignment
    """
    schedules = get_schedules_by_class_subject(db, class_subject_id=class_subject_id)
    return schedules

@router.get("/schedules/{schedule_id}", response_model=SubjectScheduleRead)
def read_schedule_detail(schedule_id: int, db: Session = Depends(get_db)):
    """
    Get a specific schedule by ID
    """
    schedule = get_schedule_by_id(db, schedule_id=schedule_id)
    if not schedule:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Schedule not found")
    return schedule

@router.post("/schedules/", response_model=SubjectScheduleRead, status_code=status.HTTP_201_CREATED)
def create_schedule_route(schedule: SubjectScheduleCreate, db: Session = Depends(get_db)):
    """
    Create a new schedule
    """
    try:
        created_schedule = create_schedule(db, schedule)
        return created_schedule
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating schedule: {str(e)}"
        )

@router.put("/schedules/{schedule_id}", response_model=SubjectScheduleRead)
def update_schedule_route(schedule_id: int, schedule: SubjectScheduleUpdate, db: Session = Depends(get_db)):
    """
    Update an existing schedule
    """
    try:
        updated_schedule = update_schedule(db, schedule_id, schedule)
        if not updated_schedule:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Schedule with ID {schedule_id} not found"
            )
        return updated_schedule
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating schedule: {str(e)}"
        )

@router.delete("/schedules/{schedule_id}", status_code=status.HTTP_200_OK)
def delete_schedule_route(schedule_id: int, db: Session = Depends(get_db)):
    """
    Delete a schedule
    """
    try:
        success = delete_schedule(db, schedule_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Schedule with ID {schedule_id} not found"
            )
        return {"message": f"Schedule with ID {schedule_id} deleted successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting schedule: {str(e)}"
        ) 