from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from typing import List, Optional

from ..models.grade import Grade
from ..models.grade_component import GradeComponent
from ..models.student import Student
from ..models.user import User # For student names via relationship
from ..models.class_subject import ClassSubject
from ..models.subject import Subject # Corrected import

from ..schemas.grade_schema import GradeCreate, GradeUpdate, GradeComponentCreate, GradeComponentUpdate

def get_all_grades(db: Session, student_id: Optional[int], class_subject_id: Optional[int], semester: Optional[str]) -> List[Grade]:
    """
    Retrieve grades with optional filters and eager loading for response.
    """
    query = db.query(Grade).options(
        joinedload(Grade.student).joinedload(Student.user), 
        joinedload(Grade.class_subject).joinedload(ClassSubject.subject) # This now refers to the corrected Subject model
        # Add more joinedload as needed if GradeResponse schema requires deeper data
    )

    if student_id is not None:
        query = query.filter(Grade.StudentID == student_id)
    if class_subject_id is not None:
        query = query.filter(Grade.ClassSubjectID == class_subject_id)
    if semester is not None:
        query = query.filter(Grade.Semester == semester)
    
    return query.all()

def create_grade_with_components(db: Session, grade_data: GradeCreate) -> Grade:
    """
    Create a new grade record along with its components.
    Raises IntegrityError if constraints are violated (e.g., non-existent student/class_subject).
    """
    try:
        db_grade = Grade(
            StudentID=grade_data.StudentID,
            ClassSubjectID=grade_data.ClassSubjectID,
            FinalScore=grade_data.FinalScore,
            Semester=grade_data.Semester
        )
        db.add(db_grade)
        db.flush()  # Get GradeID for components before commit

        for component_data in grade_data.components:
            db_component = GradeComponent(
                ComponentName=component_data.ComponentName,
                GradeID=db_grade.GradeID,
                Weight=component_data.Weight,
                Score=component_data.Score
            )
            db.add(db_component)
        
        db.commit()
        db.refresh(db_grade) # Refresh to load relationships, e.g., components for the response
        return db_grade
    except IntegrityError:
        db.rollback()
        raise # Re-raise for the router to handle as an HTTPException

def get_grade_by_id(db: Session, grade_id: int) -> Optional[Grade]:
    """
    Get a specific grade by its ID, with related student, class_subject, and components.
    """
    return db.query(Grade).options(
        joinedload(Grade.student).joinedload(Student.user),
        joinedload(Grade.class_subject).joinedload(ClassSubject.subject),
        joinedload(Grade.grade_components)
    ).filter(Grade.GradeID == grade_id).first()

def get_grades_by_student(db: Session, student_id: int, semester: Optional[str]) -> List[Grade]:
    """
    Get all grades for a specific student, optionally filtered by semester.
    Includes related class_subject and components.
    """
    query = db.query(Grade).filter(Grade.StudentID == student_id)
    if semester:
        query = query.filter(Grade.Semester == semester)
    
    return query.options(
        joinedload(Grade.class_subject).joinedload(ClassSubject.subject),
        joinedload(Grade.grade_components)
        # Student info is already known by student_id, but could be loaded if GradeResponse needs Student object
    ).all()

def update_grade_details(db: Session, grade_id: int, grade_update_data: GradeUpdate) -> Optional[Grade]:
    """
    Update an existing grade's details.
    Adds new components if provided in grade_update_data.components.
    Does not update or delete existing components through this function.
    Returns the updated grade or None if not found.
    Raises IntegrityError for DB constraint issues.
    """
    db_grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not db_grade:
        return None

    if grade_update_data.FinalScore is not None:
        db_grade.FinalScore = grade_update_data.FinalScore
    if grade_update_data.Semester is not None:
        db_grade.Semester = grade_update_data.Semester

    if grade_update_data.components: # Add new components
        for component_data in grade_update_data.components:
            new_component = GradeComponent(
                ComponentName=component_data.ComponentName,
                GradeID=db_grade.GradeID,
                Weight=component_data.Weight,
                Score=component_data.Score
            )
            db.add(new_component)
    
    try:
        db.commit()
        db.refresh(db_grade) # Refresh to get newly added components and updated fields
        # Eager load for response consistency
        db.refresh(db_grade, attribute_names=['student', 'class_subject', 'grade_components']) 
        # Or query again with joinedload if refresh isn't sufficient for deep relations for the response
        updated_grade_for_response = get_grade_by_id(db, grade_id) # Safest way to get full object for response
        return updated_grade_for_response

    except IntegrityError:
        db.rollback()
        raise
    return db_grade


def delete_grade_and_components(db: Session, grade_id: int) -> bool:
    """
    Delete a grade. Associated components should be handled by DB cascade.
    Returns True if deleted, False if not found.
    Raises IntegrityError if deletion violates DB constraints.
    """
    db_grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not db_grade:
        return False
    
    db.delete(db_grade)
    try:
        db.commit()
        return True
    except IntegrityError: # Should not happen often on delete unless FKs block it
        db.rollback()
        raise

# --- Grade Component Services ---

def add_component_to_grade(db: Session, grade_id: int, component_data: GradeComponentCreate) -> Optional[GradeComponent]:
    """
    Add a new component to an existing grade.
    Returns the created component or None if the parent grade doesn't exist.
    Raises IntegrityError for DB constraint issues.
    """
    parent_grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not parent_grade:
        return None 

    db_component = GradeComponent(
        ComponentName=component_data.ComponentName,
        GradeID=grade_id,
        Weight=component_data.Weight,
        Score=component_data.Score
    )
    db.add(db_component)
    try:
        db.commit()
        db.refresh(db_component)
        return db_component
    except IntegrityError:
        db.rollback()
        raise

def update_grade_component_details(db: Session, component_id: int, component_update_data: GradeComponentUpdate) -> Optional[GradeComponent]:
    """
    Update an existing grade component.
    Returns the updated component or None if not found.
    Raises IntegrityError for DB constraint issues.
    """
    db_component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
    if not db_component:
        return None

    if component_update_data.ComponentName is not None:
        db_component.ComponentName = component_update_data.ComponentName
    if component_update_data.Weight is not None:
        db_component.Weight = component_update_data.Weight
    if component_update_data.Score is not None:
        db_component.Score = component_update_data.Score
    
    try:
        db.commit()
        db.refresh(db_component)
        return db_component
    except IntegrityError:
        db.rollback()
        raise

def delete_grade_component_by_id(db: Session, component_id: int) -> bool:
    """
    Delete a specific grade component.
    Returns True if deleted, False if not found.
    Raises IntegrityError if deletion violates DB constraints.
    """
    db_component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
    if not db_component:
        return False
    
    db.delete(db_component)
    try:
        db.commit()
        return True
    except IntegrityError:
        db.rollback()
        raise 