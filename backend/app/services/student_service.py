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
from ..services import user_service, message_service, parent_student_service # Import thêm
from ..enums.user_enums import UserRole
from fastapi import HTTPException, status
from ..models import Conversation # Import thêm


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

def get_students(db: Session, skip: int = 0, limit: int = 100, search: Optional[str] = None, class_id_filter: Optional[int] = None, grade_level_filter: Optional[str] = None) -> List[StudentRead]:
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
        
    if grade_level_filter is not None:
        query = query.filter(Class.GradeLevel == grade_level_filter)

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
    
    # Validate that ClassID exists if provided
    if student_data.ClassID:
        class_obj = db.query(Class).filter(Class.ClassID == student_data.ClassID).first()
        if not class_obj:
            raise HTTPException(status_code=400, detail=f"Class with ID {student_data.ClassID} not found.")

    # Create the user and associated student record using user_service
    # user_service.create_user handles the commit
    created_user = user_service.create_user(db=db, user=student_data)

    # Add student to class conversations if ClassID was provided
    if created_user and created_user.student and created_user.student.ClassID:
        try:
             # Gọi hàm helper để thêm vào conversations
            _update_student_class_conversations(db, created_user.UserID, created_user.student.ClassID, 'add')
        except Exception as e:
            # Log lỗi nhưng không raise để không làm fail việc tạo student
            print(f"ERROR adding new student {created_user.UserID} to conversations for class {created_user.student.ClassID}: {e}")

    return created_user

def update_student(db: Session, student_user_id: int, student_data: UserUpdate) -> Optional[User]:
    # Get current student state BEFORE update to check old ClassID
    student_user_before = user_service.get_user_by_id(db, student_user_id)
    if not student_user_before or student_user_before.role != UserRole.STUDENT:
         raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found or user is not a student.")
    old_class_id = student_user_before.student.ClassID if student_user_before.student else None

    # Validate new ClassID if provided
    new_class_id_from_payload = getattr(student_data, 'ClassID', None)
    if new_class_id_from_payload is not None and new_class_id_from_payload != old_class_id:
        class_obj = db.query(Class).filter(Class.ClassID == new_class_id_from_payload).first()
        if not class_obj:
            raise HTTPException(status_code=400, detail=f"Class with ID {new_class_id_from_payload} not found.")

    # Update the user and associated student record using user_service
    # user_service.update_user handles the commit
    updated_user = user_service.update_user(db=db, user_id=student_user_id, user=student_data)

    # Update conversations if ClassID changed
    if updated_user and updated_user.student:
        new_class_id = updated_user.student.ClassID
        if old_class_id != new_class_id:
            try:
                # Remove from old class conversations
                if old_class_id:
                    _update_student_class_conversations(db, updated_user.UserID, old_class_id, 'remove')
                
                # Add to new class conversations
                if new_class_id:
                    _update_student_class_conversations(db, updated_user.UserID, new_class_id, 'add')
            except Exception as e:
                # Log lỗi nhưng không raise để không làm fail việc update student
                print(f"ERROR updating conversations for student {updated_user.UserID} changing class from {old_class_id} to {new_class_id}: {e}")

    return updated_user

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

# --- Helper Function for Conversation Management ---

def _update_student_class_conversations(db: Session, student_user_id: int, class_id: int, action: str):
    """Adds or removes a student and their parents from class conversations."""
    if not class_id:
        return

    # Lấy thông tin lớp để có ClassName
    class_obj = db.query(Class).filter(Class.ClassID == class_id).first()
    if not class_obj:
        print(f"Warning: Class {class_id} not found when updating conversations for student {student_user_id}.")
        return
    class_name = class_obj.ClassName

    # Tìm conversations dựa trên tên quy ước
    student_convo_name = f"Học sinh Lớp {class_name}"
    parent_convo_name = f"Phụ huynh Lớp {class_name}"
    
    student_convo = db.query(Conversation).filter(Conversation.Name == student_convo_name).first()
    parent_convo = db.query(Conversation).filter(Conversation.Name == parent_convo_name).first()

    # Lấy danh sách phụ huynh của học sinh
    parents = parent_student_service.get_parents_for_student(db=db, student_user_id=student_user_id)
    parent_ids = [p.UserID for p in parents]

    try:
        if action == 'add':
            # Thêm học sinh vào student convo
            if student_convo:
                message_service.add_participants_to_conversation(db, student_convo.ConversationID, [student_user_id])
                print(f"Added student {student_user_id} to student conversation '{student_convo_name}'")
            else:
                print(f"Warning: Student conversation '{student_convo_name}' not found.")
            
            # Thêm phụ huynh vào parent convo
            if parent_convo and parent_ids:
                message_service.add_participants_to_conversation(db, parent_convo.ConversationID, parent_ids)
                print(f"Added parents {parent_ids} of student {student_user_id} to parent conversation '{parent_convo_name}'")
            elif not parent_convo:
                print(f"Warning: Parent conversation '{parent_convo_name}' not found.")
            elif not parent_ids:
                print(f"Note: No parents found for student {student_user_id} to add to parent conversation.")

        elif action == 'remove':
            # Xóa học sinh khỏi student convo
            if student_convo:
                message_service.remove_participants_from_conversation(db, student_convo.ConversationID, [student_user_id])
                print(f"Removed student {student_user_id} from student conversation '{student_convo_name}'")
            else:
                print(f"Warning: Student conversation '{student_convo_name}' not found.")

            # Xóa phụ huynh khỏi parent convo
            if parent_convo and parent_ids:
                # Check if the parents have other children in the same class before removing
                for parent_id in parent_ids:
                    # Get all children of this parent
                    parent_students = db.query(ParentStudent).filter(ParentStudent.ParentID == parent_id).all()
                    other_children_in_class = False
                    
                    # Check if any other children are in the same class
                    for ps in parent_students:
                        if ps.StudentID != student_user_id:  # Skip the current student
                            other_student = db.query(Student).filter(Student.StudentID == ps.StudentID).first()
                            if other_student and other_student.ClassID == class_id:
                                other_children_in_class = True
                                break
                    
                    # Only remove parent if they have no other children in the class
                    if not other_children_in_class:
                        message_service.remove_participants_from_conversation(db, parent_convo.ConversationID, [parent_id])
                        print(f"Removed parent {parent_id} from parent conversation '{parent_convo_name}'")
                    else:
                        print(f"Kept parent {parent_id} in parent conversation '{parent_convo_name}' as they have other children in the class")
            elif not parent_convo:
                print(f"Warning: Parent conversation '{parent_convo_name}' not found.")
    except Exception as e:
        # Log lỗi nhưng không raise để không ảnh hưởng đến tiến trình chính (create/update student)
        print(f"ERROR updating conversations for student {student_user_id}, class {class_id}, action {action}: {e}")
        # db.rollback() # Không rollback ở đây vì có thể đang trong transaction của create/update student

# --- End Helper --- 