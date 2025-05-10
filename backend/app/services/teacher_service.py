from sqlalchemy.orm import Session, aliased, joinedload
from sqlalchemy import select, and_, join, func
from ..models.teacher import Teacher
from ..models.user import User
from ..models.class_ import Class
from ..models.student import Student
from ..models.subject import Subject
from ..models.class_subject import ClassSubject
from ..models.grade import Grade
from ..models.grade_component import GradeComponent
from ..schemas.teacher_schema import TeacherRead, TeacherUpdate
from ..schemas.student_schema import StudentRead
from ..schemas.grade_schema import GradeComponentCreate
from fastapi import HTTPException, status
from typing import List, Optional, Dict, Any

def get_teachers(db: Session, skip: int = 0, limit: int = 1000, department_id: Optional[int] = None, search: Optional[str] = None) -> List[TeacherRead]:
    TeacherUser = aliased(User, name="teacher_user_alias")

    query = db.query(
        Teacher.TeacherID,
        TeacherUser.FirstName,
        TeacherUser.LastName,
        Teacher.Degree
    ).join(TeacherUser, Teacher.TeacherID == TeacherUser.UserID)

    # Apply department filter if provided
    if department_id:
        query = query.filter(Teacher.DepartmentID == department_id)
    
    # Apply search filter if provided
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            (TeacherUser.FirstName.ilike(search_term)) | 
            (TeacherUser.LastName.ilike(search_term))
        )
    
    results = query.offset(skip).limit(limit).all()
    
    teachers_read = []
    for row in results:
        name = f"{row.FirstName or ''} {row.LastName or ''}".strip()
        # The query now directly returns Degree from the Teacher table bound to the main query context
        specialization = row.Degree 
        
        teachers_read.append(TeacherRead(
            id=row.TeacherID,
            name=name if name else "N/A",
            specialization=specialization
        ))
    return teachers_read

def get_teacher_by_id(db: Session, teacher_id: int) -> Optional[TeacherRead]:
    TeacherUser = aliased(User, name="teacher_user_alias")

    result = db.query(
        Teacher.TeacherID,
        TeacherUser.FirstName,
        TeacherUser.LastName,
        Teacher.Degree
    ).join(TeacherUser, Teacher.TeacherID == TeacherUser.UserID)\
    .filter(Teacher.TeacherID == teacher_id).first()
    
    if not result:
        return None
    
    name = f"{result.FirstName or ''} {result.LastName or ''}".strip()
    
    return TeacherRead(
        id=result.TeacherID,
        name=name if name else "N/A",
        specialization=result.Degree
    )

def update_teacher(db: Session, teacher_id: int, teacher_data: TeacherUpdate) -> TeacherRead:
    # Get teacher from database
    teacher = db.query(Teacher).filter(Teacher.TeacherID == teacher_id).first()
    
    if not teacher:
        return None
    
    # Update teacher fields if provided
    if teacher_data.DepartmentID is not None:
        teacher.DepartmentID = teacher_data.DepartmentID
    if teacher_data.Graduate is not None:
        teacher.Graduate = teacher_data.Graduate
    if teacher_data.Degree is not None:
        teacher.Degree = teacher_data.Degree
    if teacher_data.Position is not None:
        teacher.Position = teacher_data.Position
    
    # Save to database
    db.commit()
    db.refresh(teacher)
    
    # Return updated teacher
    return get_teacher_by_id(db, teacher_id)

def delete_teacher(db: Session, teacher_id: int) -> bool:
    teacher = db.query(Teacher).filter(Teacher.TeacherID == teacher_id).first()
    
    if not teacher:
        return False
    
    # Delete the teacher record
    db.delete(teacher)
    
    # Note: We're not deleting the corresponding User record here
    # In a real application, you might want to either:
    # 1. Delete the User record as well
    # 2. Or mark the User as inactive instead of deleting
    
    db.commit()
    return True

def get_teacher_subjects(db: Session, teacher_id: int) -> List:
    # Get all distinct subjects taught by the teacher
    results = db.query(
        Subject.SubjectID,
        Subject.SubjectName
    ).join(
        ClassSubject, ClassSubject.SubjectID == Subject.SubjectID
    ).filter(
        ClassSubject.TeacherID == teacher_id
    ).distinct().all()
    
    subjects = []
    for row in results:
        subjects.append({
            "id": row.SubjectID,
            "name": row.SubjectName
        })
    
    return subjects

def get_teacher_classes(db: Session, teacher_id: int) -> List:
    # Get all distinct classes taught by the teacher
    class_subjects = db.query(
        ClassSubject.ClassID
    ).filter(
        ClassSubject.TeacherID == teacher_id
    ).distinct().subquery()
    
    # Get class details
    results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel
    ).filter(
        Class.ClassID.in_(select(class_subjects.c.ClassID))
    ).all()
    
    # Also get homeroom classes
    homeroom_results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel
    ).filter(
        Class.HomeroomTeacherID == teacher_id
    ).all()
    
    # Combine results (avoiding duplicates)
    seen_class_ids = set()
    classes = []
    
    for row in results + homeroom_results:
        if row.ClassID not in seen_class_ids:
            seen_class_ids.add(row.ClassID)
            classes.append({
                "id": row.ClassID,
                "name": row.ClassName,
                "grade": row.GradeLevel,
                "is_homeroom": row.ClassID in [r.ClassID for r in homeroom_results]
            })
    
    return classes

def get_teacher_homeroom_classes(db: Session, teacher_id: int) -> List:
    """
    Get classes where the teacher is the homeroom teacher
    """
    results = db.query(
        Class.ClassID,
        Class.ClassName,
        Class.GradeLevel,
        Class.AcademicYear
    ).filter(
        Class.HomeroomTeacherID == teacher_id
    ).all()
    
    classes = []
    for row in results:
        classes.append({
            "id": row.ClassID,
            "name": row.ClassName,
            "grade": row.GradeLevel,
            "academic_year": row.AcademicYear
        })
    
    return classes

def get_homeroom_class_students(db: Session, teacher_id: int, class_id: int) -> List[StudentRead]:
    """
    Get students from a class where the teacher is the homeroom teacher
    """
    # First, verify that the teacher is actually the homeroom teacher for this class
    class_check = db.query(Class).filter(
        Class.ClassID == class_id,
        Class.HomeroomTeacherID == teacher_id
    ).first()
    
    if not class_check:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Teacher is not the homeroom teacher for this class"
        )
    
    # Now get all students in this class
    StudentUser = aliased(User, name="student_user_alias")
    
    query = db.query(
        StudentUser.UserID.label("id"),
        StudentUser.UserID.label("studentId"),
        StudentUser.FirstName.label("student_first_name"),
        StudentUser.LastName.label("student_last_name"),
        StudentUser.Email.label("Email"),
        StudentUser.PhoneNumber.label("PhoneNumber"),
        StudentUser.DOB.label("DOB"),
        StudentUser.Gender.label("Gender"),
        Student.EnrollmentDate.label("EnrollmentDate"),
        Student.ClassID.label("classId"),
        Class.ClassName.label("className"),
        Class.GradeLevel.label("classGrade")
    ).select_from(Student)\
    .join(StudentUser, Student.StudentID == StudentUser.UserID)\
    .join(Class, Student.ClassID == Class.ClassID)\
    .filter(Student.ClassID == class_id)\
    .order_by(StudentUser.LastName, StudentUser.FirstName)
    
    results = query.all()
    
    students = []
    for row in results:
        student_name = f"{row.student_first_name or ''} {row.student_last_name or ''}".strip()
        students.append({
            "id": row.id,
            "studentId": row.studentId,
            "name": student_name if student_name else "N/A",
            "email": row.Email,
            "phoneNumber": row.PhoneNumber,
            "dob": row.DOB,
            "gender": row.Gender,
            "enrollmentDate": row.EnrollmentDate,
            "classId": row.classId,
            "className": row.className,
            "classGrade": row.classGrade
        })
    
    return students

def get_teacher_teaching_subjects(db: Session, teacher_id: int) -> List[Dict[str, Any]]:
    """
    Get all subjects taught by the teacher grouped by class
    """
    # Get all class-subjects taught by the teacher
    results = db.query(
        ClassSubject.ClassSubjectID,
        ClassSubject.ClassID,
        ClassSubject.SubjectID,
        Class.ClassName,
        Class.GradeLevel,
        Subject.SubjectName
    ).join(
        Class, ClassSubject.ClassID == Class.ClassID
    ).join(
        Subject, ClassSubject.SubjectID == Subject.SubjectID
    ).filter(
        ClassSubject.TeacherID == teacher_id
    ).all()
    
    # Group by class
    class_subjects = {}
    for row in results:
        class_id = row.ClassID
        if class_id not in class_subjects:
            class_subjects[class_id] = {
                "class_id": class_id,
                "class_name": row.ClassName,
                "grade_level": row.GradeLevel,
                "subjects": []
            }
        
        class_subjects[class_id]["subjects"].append({
            "class_subject_id": row.ClassSubjectID,
            "subject_id": row.SubjectID,
            "subject_name": row.SubjectName
        })
    
    return list(class_subjects.values())

def check_teacher_class_subject(db: Session, teacher_id: int, class_subject_id: int) -> bool:
    """
    Check if a teacher teaches a specific class-subject
    """
    return db.query(ClassSubject).filter(
        ClassSubject.ClassSubjectID == class_subject_id,
        ClassSubject.TeacherID == teacher_id
    ).first() is not None

def get_students_in_class_subject(db: Session, class_subject_id: int) -> List[Dict[str, Any]]:
    """
    Get all students in a class for a specific subject
    """
    # First get the class ID for this class-subject
    class_subject = db.query(ClassSubject).filter(
        ClassSubject.ClassSubjectID == class_subject_id
    ).first()
    
    if not class_subject:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class-subject not found"
        )
    
    # Get students in this class
    StudentUser = aliased(User, name="student_user_alias")
    
    query = db.query(
        StudentUser.UserID.label("id"),
        StudentUser.UserID.label("studentId"),
        StudentUser.FirstName.label("student_first_name"),
        StudentUser.LastName.label("student_last_name"),
        StudentUser.Email.label("Email"),
        StudentUser.PhoneNumber.label("PhoneNumber"),
        StudentUser.DOB.label("DOB"),
        StudentUser.Gender.label("Gender"),
        Student.EnrollmentDate.label("EnrollmentDate"),
        Student.ClassID.label("classId"),
        Class.ClassName.label("className"),
        Class.GradeLevel.label("classGrade")
    ).select_from(Student)\
    .join(StudentUser, Student.StudentID == StudentUser.UserID)\
    .join(Class, Student.ClassID == Class.ClassID)\
    .filter(Student.ClassID == class_subject.ClassID)\
    .order_by(StudentUser.LastName, StudentUser.FirstName)
    
    results = query.all()
    
    students = []
    for row in results:
        student_name = f"{row.student_first_name or ''} {row.student_last_name or ''}".strip()
        students.append({
            "id": row.id,
            "studentId": row.studentId,
            "name": student_name if student_name else "N/A",
            "email": row.Email,
            "phoneNumber": row.PhoneNumber,
            "dob": row.DOB,
            "gender": row.Gender,
            "enrollmentDate": row.EnrollmentDate,
            "classId": row.classId,
            "className": row.className,
            "classGrade": row.classGrade
        })
    
    return students

def get_student_grades_for_teacher(
    db: Session, 
    teacher_id: int, 
    student_id: int, 
    class_subject_id: Optional[int] = None,
    semester: Optional[str] = None
) -> List[Grade]:
    """
    Get grades for a student in classes/subjects taught by the teacher
    """
    # Get class-subjects taught by this teacher
    if class_subject_id:
        # If specific class-subject provided, check if teacher teaches it
        if not check_teacher_class_subject(db, teacher_id, class_subject_id):
            return []
        class_subjects = [class_subject_id]
    else:
        # Otherwise get all class-subjects taught by this teacher
        class_subjects = db.query(ClassSubject.ClassSubjectID).filter(
            ClassSubject.TeacherID == teacher_id
        ).all()
        class_subjects = [cs[0] for cs in class_subjects]
    
    # Get grades for this student in the class-subjects taught by this teacher
    query = db.query(Grade).options(
        joinedload(Grade.student).joinedload(Student.user),
        joinedload(Grade.class_subject).joinedload(ClassSubject.subject),
        joinedload(Grade.class_subject).joinedload(ClassSubject.class_),
        joinedload(Grade.grade_components)
    ).filter(
        Grade.StudentID == student_id,
        Grade.ClassSubjectID.in_(class_subjects)
    )
    
    if semester:
        query = query.filter(Grade.Semester == semester)
    
    return query.all()

def check_teacher_can_modify_grade(db: Session, teacher_id: int, grade_id: int) -> bool:
    """
    Check if a teacher can modify a specific grade (teaches the class-subject)
    """
    # Get the grade to find the class-subject ID
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        return False
    
    # Check if the teacher teaches this class-subject
    return check_teacher_class_subject(db, teacher_id, grade.ClassSubjectID)

def check_teacher_can_modify_component(db: Session, teacher_id: int, component_id: int) -> bool:
    """
    Check if a teacher can modify a specific grade component
    """
    # Get the component to find the grade ID
    component = db.query(GradeComponent).filter(GradeComponent.ComponentID == component_id).first()
    if not component:
        return False
    
    # Check if the teacher can modify the parent grade
    return check_teacher_can_modify_grade(db, teacher_id, component.GradeID)

def recalculate_final_grade(db: Session, grade_id: int) -> bool:
    """
    Recalculate the final grade based on weighted components
    """
    # Get all components for this grade
    components = db.query(GradeComponent).filter(GradeComponent.GradeID == grade_id).all()
    
    if not components:
        return False
    
    # Calculate weighted average
    total_weight = sum(component.Weight for component in components)
    weighted_sum = sum(component.Score * component.Weight for component in components)
    
    final_score = weighted_sum / total_weight if total_weight > 0 else None
    
    # Update the grade's final score
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        return False
    
    grade.FinalScore = final_score
    db.commit()
    return True

def initialize_standard_grade_components(db: Session, grade_id: int) -> List[GradeComponent]:
    """
    Initialize the standard grade components for Vietnamese high school:
    - 3 components with weight 1
    - 2 components with weight 2
    - 1 component with weight 3
    """
    # Check if grade exists
    grade = db.query(Grade).filter(Grade.GradeID == grade_id).first()
    if not grade:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Grade not found"
        )
    
    # Check if components already exist
    existing_components = db.query(GradeComponent).filter(GradeComponent.GradeID == grade_id).all()
    if existing_components:
        # Remove existing components first
        for component in existing_components:
            db.delete(component)
        db.commit()
    
    # Create the standard components
    components = []
    
    # 3 components with weight 1
    for i in range(1, 4):
        component = GradeComponent(
            ComponentName=f"Điểm hệ số 1 #{i}",
            GradeID=grade_id,
            Weight=1,
            Score=None
        )
        db.add(component)
        components.append(component)
    
    # 2 components with weight 2
    for i in range(1, 3):
        component = GradeComponent(
            ComponentName=f"Điểm hệ số 2 #{i}",
            GradeID=grade_id,
            Weight=2,
            Score=None
        )
        db.add(component)
        components.append(component)
    
    # 1 component with weight 3
    component = GradeComponent(
        ComponentName="Điểm hệ số 3",
        GradeID=grade_id,
        Weight=3,
        Score=None
    )
    db.add(component)
    components.append(component)
    
    db.commit()
    
    # Refresh all components to get their IDs
    for component in components:
        db.refresh(component)
    
    return components 