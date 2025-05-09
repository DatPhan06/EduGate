from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from sqlalchemy.exc import IntegrityError

from ..database import get_db
from ..models.grade import Grade
from ..models.grade_component import GradeComponent
from ..schemas.grade_schema import (
    GradeCreate, GradeUpdate, GradeResponse, 
    GradeComponentCreate, GradeComponentUpdate, GradeComponentResponse
)

router = APIRouter(
    prefix="/grades",
    tags=["grades"],
    responses={404: {"description": "Not found"}}
)


@router.post("/", response_model=GradeResponse, status_code=status.HTTP_201_CREATED)
def create_grade(grade: GradeCreate, db: Session = Depends(get_db)):
    """Create a new grade record with components"""
    try:
        # Create grade record
        db_grade = Grade(
            StudentID=grade.StudentID,
            ClassSubjectID=grade.ClassSubjectID,
            FinalScore=grade.FinalScore,
            Semester=grade.Semester
        )
        db.add(db_grade)
        db.flush()  # Get the GradeID without committing

        # Add grade components
        for component in grade.components:
            db_component = GradeComponent(
                ComponentName=component.ComponentName,
                GradeID=db_grade.GradeID,
                Weight=component.Weight,
                Score=component.Score
            )
            db.add(db_component)

        db.commit()
        db.refresh(db_grade)
        return db_grade
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid grade data. Student or Class Subject may not exist."
        )


@router.get("/{grade_id}", response_model=GradeResponse)
def get_grade(grade_id: int, db: Session = Depends(get_db)):
    """Get grade details by ID"""
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with ID {grade_id} not found"
        )
    return grade


@router.get("/student/{student_id}", response_model=List[GradeResponse])
def get_student_grades(student_id: int, semester: Optional[str] = None, db: Session = Depends(get_db)):
    """Get all grades for a student, optionally filtered by semester"""
    query = db.query(Grade).filter(Grade.StudentID == student_id)
    
    if semester:
        query = query.filter(Grade.Semester == semester)
        
    grades = query.all()
    return grades


@router.put("/{grade_id}", response_model=GradeResponse)
def update_grade(grade_id: int, grade_update: GradeUpdate, db: Session = Depends(get_db)):
    """Update a grade record and optionally add new components"""
    db_grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not db_grade:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with ID {grade_id} not found"
        )

    # Update grade fields
    if grade_update.FinalScore is not None:
        db_grade.FinalScore = grade_update.FinalScore
    if grade_update.Semester is not None:
        db_grade.Semester = grade_update.Semester

    # Add new components if provided
    if grade_update.components:
        for component in grade_update.components:
            db_component = GradeComponent(
                ComponentName=component.ComponentName,
                GradeID=grade_id,
                Weight=component.Weight,
                Score=component.Score
            )
            db.add(db_component)

    db.commit()
    db.refresh(db_grade)
    return db_grade


@router.delete("/{grade_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_grade(grade_id: int, db: Session = Depends(get_db)):
    """Delete a grade and its components"""
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with ID {grade_id} not found"
        )
    
    # SQLAlchemy will handle deletion of related components due to cascade
    db.delete(grade)
    db.commit()
    return None


# Grade component specific endpoints
@router.post("/{grade_id}/components", response_model=GradeComponentResponse)
def add_grade_component(
    grade_id: int, 
    component: GradeComponentCreate, 
    db: Session = Depends(get_db)
):
    """Add a new component to an existing grade"""
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with ID {grade_id} not found"
        )
    
    db_component = GradeComponent(
        ComponentName=component.ComponentName,
        GradeID=grade_id,
        Weight=component.Weight,
        Score=component.Score
    )
    db.add(db_component)
    db.commit()
    db.refresh(db_component)
    return db_component


@router.put("/components/{component_id}", response_model=GradeComponentResponse)
def update_grade_component(
    component_id: int, 
    component_update: GradeComponentUpdate, 
    db: Session = Depends(get_db)
):
    """Update a specific grade component"""
    db_component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
    if not db_component:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade component with ID {component_id} not found"
        )
    
    if component_update.ComponentName is not None:
        db_component.ComponentName = component_update.ComponentName
    if component_update.Weight is not None:
        db_component.Weight = component_update.Weight
    if component_update.Score is not None:
        db_component.Score = component_update.Score
    
    db.commit()
    db.refresh(db_component)
    return db_component


@router.delete("/components/{component_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_grade_component(component_id: int, db: Session = Depends(get_db)):
    """Delete a specific grade component"""
    component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
    if not component:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade component with ID {component_id} not found"
        )
    
    db.delete(component)
    db.commit()
    return None 