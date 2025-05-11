from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from typing import List

from ..models.parent_student import ParentStudent
from ..models.user import User
from ..models.parent import Parent
from ..models.student import Student
from ..models.class_ import Class
from ..models.conversation import Conversation
from ..enums.user_enums import UserRole
from ..schemas.parent_student_schema import ParentBasicInfo, StudentBasicInfo
from ..services import message_service

def _update_parent_class_chat(db: Session, parent_user_id: int, class_id: int, action: str):
    """Helper function to add or remove a parent from the class parent chat group."""
    if not class_id:
        print(f"Warning: No class ID provided when updating parent chat for parent {parent_user_id}")
        return
        
    # Get class name
    class_obj = db.query(Class).filter(Class.ClassID == class_id).first()
    if not class_obj:
        print(f"Warning: Class {class_id} not found when updating parent chat for parent {parent_user_id}")
        return
        
    class_name = class_obj.ClassName
    parent_convo_name = f"Phụ huynh Lớp {class_name}"
    
    # Find the parent conversation
    parent_convo = db.query(Conversation).filter(Conversation.Name == parent_convo_name).first()
    if not parent_convo:
        print(f"Warning: Parent conversation '{parent_convo_name}' not found")
        return
        
    try:
        if action == 'add':
            # Add parent to the conversation
            message_service.add_participants_to_conversation(db, parent_convo.ConversationID, [parent_user_id])
            print(f"Added parent {parent_user_id} to parent conversation '{parent_convo_name}'")
        elif action == 'remove':
            # Check if the parent has other children in the same class before removing
            other_children_in_class = False
            
            parent_students = db.query(ParentStudent).filter(ParentStudent.ParentID == parent_user_id).all()
            for ps in parent_students:
                student = db.query(Student).filter(Student.StudentID == ps.StudentID).first()
                if student and student.ClassID == class_id:
                    other_children_in_class = True
                    break
                    
            # Only remove if no other children in the class
            if not other_children_in_class:
                message_service.remove_participants_from_conversation(db, parent_convo.ConversationID, [parent_user_id])
                print(f"Removed parent {parent_user_id} from parent conversation '{parent_convo_name}'")
            else:
                print(f"Kept parent {parent_user_id} in parent conversation '{parent_convo_name}' as they have other children in the class")
    except Exception as e:
        print(f"ERROR updating parent chat for parent {parent_user_id}, class {class_id}, action {action}: {e}")
        
def link_parent_to_student(db: Session, student_user_id: int, parent_user_id: int) -> ParentStudent:
    # Validate student exists and is a student
    student_user = db.query(User).filter(User.UserID == student_user_id, User.role == UserRole.STUDENT).first()
    if not student_user or not student_user.student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

    # Validate parent exists and is a parent
    parent_user = db.query(User).filter(User.UserID == parent_user_id, User.role == UserRole.PARENT).first()
    if not parent_user or not parent_user.parent:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Parent not found")

    # Check if link already exists
    existing_link = db.query(ParentStudent).filter(
        ParentStudent.StudentID == student_user_id,
        ParentStudent.ParentID == parent_user_id
    ).first()
    if existing_link:
        # Or just return the existing link silently
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Parent already linked to this student")

    # Create link
    new_link = ParentStudent(StudentID=student_user_id, ParentID=parent_user_id)
    db.add(new_link)
    db.commit()
    db.refresh(new_link)
    
    # Add parent to class parent chat if student is in a class
    student = db.query(Student).filter(Student.StudentID == student_user_id).first()
    if student and student.ClassID:
        try:
            _update_parent_class_chat(db, parent_user_id, student.ClassID, 'add')
        except Exception as e:
            print(f"ERROR adding parent {parent_user_id} to class chat for student {student_user_id}: {e}")
    
    return new_link

def unlink_parent_from_student(db: Session, student_user_id: int, parent_user_id: int) -> bool:
    # Find the student's class before unlinking
    student = db.query(Student).filter(Student.StudentID == student_user_id).first()
    class_id = student.ClassID if student else None
    
    link = db.query(ParentStudent).filter(
        ParentStudent.StudentID == student_user_id,
        ParentStudent.ParentID == parent_user_id
    ).first()

    if not link:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Link between parent and student not found")

    db.delete(link)
    db.commit()
    
    # Remove parent from class parent chat if needed
    if class_id:
        try:
            _update_parent_class_chat(db, parent_user_id, class_id, 'remove')
        except Exception as e:
            print(f"ERROR removing parent {parent_user_id} from class chat after unlinking from student {student_user_id}: {e}")
    
    return True

def get_parents_for_student(db: Session, student_user_id: int) -> List[ParentBasicInfo]:
    # Validate student exists
    student_user = db.query(User).filter(User.UserID == student_user_id, User.role == UserRole.STUDENT).first()
    if not student_user:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")

    # Query linked parents
    parent_links = db.query(ParentStudent).filter(ParentStudent.StudentID == student_user_id).all()
    parent_ids = [link.ParentID for link in parent_links]

    if not parent_ids:
        return []

    parents = db.query(
        User.UserID, User.FirstName, User.LastName, User.Email
    ).filter(User.UserID.in_(parent_ids), User.role == UserRole.PARENT).all()

    # Use model_validate for Pydantic v2
    return [ParentBasicInfo.model_validate(p) for p in parents]

def get_students_for_parent(db: Session, parent_user_id: int) -> List[StudentBasicInfo]:
     # Validate parent exists
    parent_user = db.query(User).filter(User.UserID == parent_user_id, User.role == UserRole.PARENT).first()
    if not parent_user:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Parent not found")

    # Query linked students and their classes
    student_links = db.query(ParentStudent).filter(ParentStudent.ParentID == parent_user_id).all()
    student_ids = [link.StudentID for link in student_links]

    if not student_ids:
        return []

    students_with_class = db.query(
        User.UserID, User.FirstName, User.LastName, User.Email, Class.ClassName
    ).select_from(User)\
     .join(Student, User.UserID == Student.StudentID)\
     .outerjoin(Class, Student.ClassID == Class.ClassID)\
     .filter(User.UserID.in_(student_ids), User.role == UserRole.STUDENT)\
     .all()
    
    # Use model_validate for Pydantic v2
    return [StudentBasicInfo.model_validate(s) for s in students_with_class] 