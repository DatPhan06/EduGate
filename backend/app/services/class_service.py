from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, select
from ..models.class_ import Class
from ..models.user import User
from ..models.teacher import Teacher
from ..models.student import Student
from ..schemas.class_schema import ClassCreate, ClassUpdate, ClassRead
from typing import List, Optional
from fastapi import HTTPException, status
from ..services import user_service, message_service
from ..schemas.message import ConversationCreate

def get_class(db: Session, class_id: int) -> Optional[Class]:
    return db.query(Class).options(
        joinedload(Class.homeroom_teacher).joinedload(Teacher.user),
        joinedload(Class.students)
    ).filter(Class.ClassID == class_id).first()

def get_classes(db: Session, skip: int = 0, limit: int = 100, search: Optional[str] = None) -> List[ClassRead]:
    query = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel,
        Class.AcademicYear,
        Class.HomeroomTeacherID,
        User.FirstName.label("teacher_first_name"),
        User.LastName.label("teacher_last_name"),
        func.count(Student.StudentID).label("total_students")
    ).outerjoin(Teacher, Class.HomeroomTeacherID == Teacher.TeacherID)\
    .outerjoin(User, Teacher.TeacherID == User.UserID)\
    .outerjoin(Student, Class.ClassID == Student.ClassID)\
    .group_by(
        Class.ClassID, 
        Class.ClassName, 
        Class.GradeLevel, 
        Class.AcademicYear, 
        Class.HomeroomTeacherID,
        User.FirstName,
        User.LastName
    )

    if search:
        search_term = f"%{search.lower()}%"
        query = query.filter(
            (func.lower(Class.ClassName).like(search_term)) |
            (func.lower(Class.GradeLevel).like(search_term)) |
            (func.lower(Class.AcademicYear).like(search_term)) |
            (func.lower(User.FirstName + " " + User.LastName).like(search_term))
        )

    results = query.offset(skip).limit(limit).all()
    
    classes_read = []
    for row in results:
        teacher_name = None
        if row.teacher_first_name and row.teacher_last_name:
            teacher_name = f"{row.teacher_first_name} {row.teacher_last_name}"
        elif row.teacher_first_name: # Handle case where only first name might exist
             teacher_name = row.teacher_first_name
        elif row.teacher_last_name: # Handle case where only last name might exist
             teacher_name = row.teacher_last_name

        classes_read.append(ClassRead(
            ClassID=row.ClassID,
            ClassName=row.ClassName,
            GradeLevel=row.GradeLevel,
            AcademicYear=row.AcademicYear,
            HomeroomTeacherID=row.HomeroomTeacherID,
            teacherName=teacher_name,
            totalStudents=row.total_students
        ))
    return classes_read

def create_class(db: Session, class_data: ClassCreate) -> ClassRead:
    # Check if HomeroomTeacherID exists if provided
    if class_data.HomeroomTeacherID:
        teacher = db.query(Teacher).filter(Teacher.TeacherID == class_data.HomeroomTeacherID).first()
        if not teacher:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Homeroom Teacher with ID {class_data.HomeroomTeacherID} not found."
            )
    
    # Tạo đối tượng Class từ dữ liệu
    db_class = Class(
        ClassName=class_data.ClassName,
        GradeLevel=class_data.GradeLevel,
        AcademicYear=class_data.AcademicYear,
        HomeroomTeacherID=class_data.HomeroomTeacherID,
        # Note: teacherName và totalStudents thường là computed/derived fields,
        # không nên lưu trực tiếp vào DB trừ khi có lý do đặc biệt.
        # Chúng sẽ được tính toán khi đọc dữ liệu.
    )
    
    db.add(db_class)
    
    try:
        db.commit()
        db.refresh(db_class)
        
        # --- Tự động tạo Conversations --- 
        if db_class.HomeroomTeacherID:
            teacher_id = db_class.HomeroomTeacherID
            class_name = db_class.ClassName
            
            # Tạo conversation cho Phụ huynh
            try:
                parent_convo_name = f"Phụ huynh Lớp {class_name}"
                parent_convo_data = ConversationCreate(Name=parent_convo_name, participant_ids=[teacher_id])
                message_service.create_conversation(db=db, conversation_data=parent_convo_data, current_user_id=teacher_id)
                # print(f"Created parent conversation for class {db_class.ClassID}") # Optional log
            except Exception as e:
                # Log lỗi tạo conversation phụ huynh, nhưng không rollback việc tạo lớp
                print(f"ERROR creating parent conversation for class {db_class.ClassID}: {e}")
                # logger.error(f"Error creating parent conversation for class {db_class.ClassID}: {e}")
            
            # Tạo conversation cho Học sinh
            try:
                student_convo_name = f"Học sinh Lớp {class_name}"
                student_convo_data = ConversationCreate(Name=student_convo_name, participant_ids=[teacher_id])
                message_service.create_conversation(db=db, conversation_data=student_convo_data, current_user_id=teacher_id)
                # print(f"Created student conversation for class {db_class.ClassID}") # Optional log
            except Exception as e:
                # Log lỗi tạo conversation học sinh
                print(f"ERROR creating student conversation for class {db_class.ClassID}: {e}")
                # logger.error(f"Error creating student conversation for class {db_class.ClassID}: {e}")
        # -------------------------------------

        # Trả về đối tượng ClassRead (có thể cần lấy lại thông tin đầy đủ)
        created_class_read = get_class(db=db, class_id=db_class.ClassID)
        if not created_class_read:
             # Fallback nếu get_class_by_id thất bại (ít khả năng)
             return ClassRead.model_validate(db_class) 
        return created_class_read
        
    except Exception as e:
        db.rollback()
        # Log lỗi cụ thể hơn nếu cần
        print(f"ERROR creating class: {e}") 
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Could not create class")

def update_class(db: Session, class_id: int, class_in: ClassUpdate) -> Optional[Class]:
    db_class = db.query(Class).filter(Class.ClassID == class_id).first()
    if not db_class:
        return None
    
    update_data = class_in.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_class, key, value)
    
    db.add(db_class)
    db.commit()
    db.refresh(db_class)
    return db_class

def delete_class(db: Session, class_id: int) -> Optional[Class]:
    db_class = db.query(Class).filter(Class.ClassID == class_id).first()
    if not db_class:
        return None
    
    # Optionally, handle students in the class (e.g., set their ClassID to null or prevent deletion if students exist)
    # For now, just deleting the class
    
    db.delete(db_class)
    db.commit()
    return db_class 