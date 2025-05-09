from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from sqlalchemy import and_, or_
from fastapi import HTTPException, status
from typing import List, Optional
from ..models.subject_schedule import SubjectSchedule
from ..models.class_subject import ClassSubject
from ..schemas.subject_schedule_schema import SubjectScheduleCreate, SubjectScheduleUpdate

# Get all schedules
def get_schedules(db: Session, skip: int = 0, limit: int = 1000):
    return db.query(SubjectSchedule).offset(skip).limit(limit).all()

# Get schedules by class subject ID
def get_schedules_by_class_subject(db: Session, class_subject_id: int):
    return db.query(SubjectSchedule).filter(SubjectSchedule.ClassSubjectID == class_subject_id).all()

# Get schedule by ID
def get_schedule_by_id(db: Session, schedule_id: int):
    return db.query(SubjectSchedule).filter(SubjectSchedule.SubjectScheduleID == schedule_id).first()

# Check if there's a schedule conflict for a given class
def check_schedule_conflict(db: Session, class_id: int, day: str, start_period: int, 
                           end_period: int, exclude_schedule_id: Optional[int] = None):
    # Get all class subjects for this class
    class_subjects = db.query(ClassSubject).filter(ClassSubject.ClassID == class_id).all()
    
    # If there are no class subjects, there can't be a conflict
    if not class_subjects:
        return False

    # Build a list of class subject IDs
    class_subject_ids = [cs.ClassSubjectID for cs in class_subjects]
    
    # Query for any schedules that overlap
    overlapping_schedules_query = db.query(SubjectSchedule).filter(
        SubjectSchedule.ClassSubjectID.in_(class_subject_ids),
        SubjectSchedule.Day == day,
        or_(
            # Case 1: new schedule starts during an existing schedule
            and_(
                SubjectSchedule.StartPeriod <= start_period,
                SubjectSchedule.EndPeriod >= start_period
            ),
            # Case 2: new schedule ends during an existing schedule
            and_(
                SubjectSchedule.StartPeriod <= end_period,
                SubjectSchedule.EndPeriod >= end_period
            ),
            # Case 3: new schedule completely contains an existing schedule
            and_(
                SubjectSchedule.StartPeriod >= start_period,
                SubjectSchedule.EndPeriod <= end_period
            )
        )
    )
    
    # If we're updating an existing schedule, exclude it from the conflict check
    if exclude_schedule_id:
        overlapping_schedules_query = overlapping_schedules_query.filter(
            SubjectSchedule.SubjectScheduleID != exclude_schedule_id
        )
    
    # Return True if there are any overlapping schedules
    return overlapping_schedules_query.first() is not None

# Create new schedule with conflict checking
def create_schedule(db: Session, schedule: SubjectScheduleCreate):
    # Get class ID for this class subject
    class_subject = db.query(ClassSubject).filter(
        ClassSubject.ClassSubjectID == schedule.ClassSubjectID
    ).first()
    
    if not class_subject:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class subject with ID {schedule.ClassSubjectID} not found"
        )
    
    # Check for schedule conflicts
    if check_schedule_conflict(
        db, 
        class_subject.ClassID,
        schedule.Day, 
        schedule.StartPeriod, 
        schedule.EndPeriod
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Schedule conflict detected: there is already a class scheduled during this time"
        )
    
    # Create new schedule
    db_schedule = SubjectSchedule(
        ClassSubjectID=schedule.ClassSubjectID,
        StartPeriod=schedule.StartPeriod,
        EndPeriod=schedule.EndPeriod,
        Day=schedule.Day
    )
    
    try:
        db.add(db_schedule)
        db.commit()
        db.refresh(db_schedule)
        return db_schedule
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not create schedule due to database constraints: {str(e)}"
        )

# Update existing schedule
def update_schedule(db: Session, schedule_id: int, schedule: SubjectScheduleUpdate):
    db_schedule = get_schedule_by_id(db, schedule_id)
    if not db_schedule:
        return None
    
    # Get class ID for this class subject
    class_subject = db.query(ClassSubject).filter(
        ClassSubject.ClassSubjectID == db_schedule.ClassSubjectID
    ).first()
    
    if not class_subject:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class subject with ID {db_schedule.ClassSubjectID} not found"
        )
    
    # Prepare the values for the conflict check
    day = schedule.Day if schedule.Day is not None else db_schedule.Day
    start_period = schedule.StartPeriod if schedule.StartPeriod is not None else db_schedule.StartPeriod
    end_period = schedule.EndPeriod if schedule.EndPeriod is not None else db_schedule.EndPeriod
    
    # Check for schedule conflicts
    if check_schedule_conflict(
        db, 
        class_subject.ClassID,
        day, 
        start_period, 
        end_period,
        exclude_schedule_id=schedule_id
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Schedule conflict detected: there is already a class scheduled during this time"
        )
    
    # Update fields
    if schedule.StartPeriod is not None:
        db_schedule.StartPeriod = schedule.StartPeriod
    if schedule.EndPeriod is not None:
        db_schedule.EndPeriod = schedule.EndPeriod
    if schedule.Day is not None:
        db_schedule.Day = schedule.Day
    
    try:
        db.commit()
        db.refresh(db_schedule)
        return db_schedule
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not update schedule due to database constraints: {str(e)}"
        )

# Delete schedule
def delete_schedule(db: Session, schedule_id: int):
    db_schedule = get_schedule_by_id(db, schedule_id)
    if not db_schedule:
        return False
    
    try:
        db.delete(db_schedule)
        db.commit()
        return True
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Could not delete schedule: {str(e)}"
        ) 