from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from fastapi import HTTPException, status
from ..models.class_post import ClassPost
from ..models.class_ import Class
from ..models.teacher import Teacher
from ..models.student import Student
from ..models.parent_student import ParentStudent
from ..schemas.class_post_schema import ClassPostCreate, ClassPostUpdate, ClassPostRead, ClassPostPagination

def create_class_post(db: Session, post_data: ClassPostCreate, teacher_id: int):
    """Create a new class post if the teacher is the homeroom teacher of the class"""
    # Check if the teacher is the homeroom teacher of the class
    class_obj = db.query(Class).filter(
        Class.ClassID == post_data.ClassID,
        Class.HomeroomTeacherID == teacher_id
    ).first()
    
    if not class_obj:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not the homeroom teacher of this class"
        )
    
    # Create new class post
    db_post = ClassPost(
        Title=post_data.Title,
        Type=post_data.Type,
        Content=post_data.Content,
        EventDate=post_data.EventDate,
        TeacherID=teacher_id,
        ClassID=post_data.ClassID
    )
    
    try:
        db.add(db_post)
        db.commit()
        db.refresh(db_post)
        
        # Add teacher_name and class_name for response
        db_post.teacher_name = db.query(Teacher).filter(
            Teacher.TeacherID == teacher_id
        ).first().user.FirstName + " " + db.query(Teacher).filter(
            Teacher.TeacherID == teacher_id
        ).first().user.LastName
        
        db_post.class_name = class_obj.ClassName
        
        return db_post
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create class post: {str(e)}"
        )

def get_class_post_by_id(db: Session, post_id: int):
    """Get a class post by its ID with teacher and class details"""
    db_post = db.query(ClassPost).filter(ClassPost.PostID == post_id).first()
    
    if not db_post:
        return None
    
    # Add teacher_name
    teacher = db.query(Teacher).filter(Teacher.TeacherID == db_post.TeacherID).first()
    if teacher and teacher.user:
        db_post.teacher_name = f"{teacher.user.FirstName} {teacher.user.LastName}"
    else:
        db_post.teacher_name = "Unknown Teacher"
    
    # Add class_name
    class_obj = db.query(Class).filter(Class.ClassID == db_post.ClassID).first()
    if class_obj:
        db_post.class_name = class_obj.ClassName
    else:
        db_post.class_name = "Unknown Class"
    
    return db_post

def update_class_post(db: Session, post_id: int, post_data: ClassPostUpdate, teacher_id: int):
    """Update a class post if the teacher is the homeroom teacher or the original author"""
    # Get the post
    db_post = db.query(ClassPost).filter(ClassPost.PostID == post_id).first()
    
    if not db_post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class post with ID {post_id} not found"
        )
    
    # Check permissions - must be either original author or current homeroom teacher
    is_author = db_post.TeacherID == teacher_id
    
    class_obj = db.query(Class).filter(
        Class.ClassID == db_post.ClassID,
        Class.HomeroomTeacherID == teacher_id
    ).first()
    
    is_homeroom_teacher = class_obj is not None
    
    if not (is_author or is_homeroom_teacher):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to update this post"
        )
    
    # Update fields if provided
    if post_data.Title is not None:
        db_post.Title = post_data.Title
    if post_data.Type is not None:
        db_post.Type = post_data.Type
    if post_data.Content is not None:
        db_post.Content = post_data.Content
    if post_data.EventDate is not None:
        db_post.EventDate = post_data.EventDate
    
    try:
        db.commit()
        db.refresh(db_post)
        
        # Add teacher_name and class_name for response
        teacher = db.query(Teacher).filter(Teacher.TeacherID == db_post.TeacherID).first()
        if teacher and teacher.user:
            db_post.teacher_name = f"{teacher.user.FirstName} {teacher.user.LastName}"
        
        if class_obj:
            db_post.class_name = class_obj.ClassName
        
        return db_post
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to update class post: {str(e)}"
        )

def delete_class_post(db: Session, post_id: int, teacher_id: int):
    """Delete a class post if the teacher is the homeroom teacher or the original author"""
    db_post = db.query(ClassPost).filter(ClassPost.PostID == post_id).first()
    
    if not db_post:
        return False
    
    # Check permissions - must be either original author or current homeroom teacher
    is_author = db_post.TeacherID == teacher_id
    
    class_obj = db.query(Class).filter(
        Class.ClassID == db_post.ClassID,
        Class.HomeroomTeacherID == teacher_id
    ).first()
    
    is_homeroom_teacher = class_obj is not None
    
    if not (is_author or is_homeroom_teacher):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to delete this post"
        )
    
    try:
        db.delete(db_post)
        db.commit()
        return True
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to delete class post: {str(e)}"
        )

def get_class_posts_for_class(db: Session, class_id: int, skip: int, limit: int, search: Optional[str] = None):
    """Get paginated class posts for a specific class with optional search"""
    # Base query
    query = db.query(ClassPost).filter(ClassPost.ClassID == class_id)
    
    # Apply search if provided
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            (ClassPost.Title.ilike(search_term)) |
            (ClassPost.Content.ilike(search_term))
        )
    
    # Get total count for pagination
    total_count = query.count()
    
    # Apply pagination
    posts = query.order_by(ClassPost.CreatedAt.desc()).offset(skip).limit(limit).all()
    
    # Add teacher_name and class_name for each post
    class_obj = db.query(Class).filter(Class.ClassID == class_id).first()
    class_name = class_obj.ClassName if class_obj else "Unknown Class"
    
    # Get all unique teacher IDs from the posts
    teacher_ids = set(post.TeacherID for post in posts)
    
    # Get teacher information in a single query
    teachers = db.query(Teacher).filter(Teacher.TeacherID.in_(teacher_ids)).all()
    teacher_dict = {teacher.TeacherID: teacher for teacher in teachers}
    
    # Attach teacher_name and class_name to each post
    for post in posts:
        teacher = teacher_dict.get(post.TeacherID)
        if teacher and teacher.user:
            post.teacher_name = f"{teacher.user.FirstName} {teacher.user.LastName}"
        else:
            post.teacher_name = "Unknown Teacher"
        
        post.class_name = class_name
    
    # Create response object
    return ClassPostPagination(
        items=posts,
        total=total_count,
        page=skip // limit + 1,
        size=limit
    )

def get_class_posts_for_teacher(db: Session, teacher_id: int, skip: int, limit: int, search: Optional[str] = None):
    """Get paginated class posts created by a specific teacher with optional search"""
    # Base query
    query = db.query(ClassPost).filter(ClassPost.TeacherID == teacher_id)
    
    # Apply search if provided
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            (ClassPost.Title.ilike(search_term)) |
            (ClassPost.Content.ilike(search_term))
        )
    
    # Get total count for pagination
    total_count = query.count()
    
    # Apply pagination
    posts = query.order_by(ClassPost.CreatedAt.desc()).offset(skip).limit(limit).all()
    
    # Get all unique class IDs from the posts
    class_ids = set(post.ClassID for post in posts)
    
    # Get class information in a single query
    classes = db.query(Class).filter(Class.ClassID.in_(class_ids)).all()
    class_dict = {class_obj.ClassID: class_obj for class_obj in classes}
    
    # Get teacher information
    teacher = db.query(Teacher).filter(Teacher.TeacherID == teacher_id).first()
    teacher_name = f"{teacher.user.FirstName} {teacher.user.LastName}" if teacher and teacher.user else "Unknown Teacher"
    
    # Attach teacher_name and class_name to each post
    for post in posts:
        post.teacher_name = teacher_name
        
        class_obj = class_dict.get(post.ClassID)
        if class_obj:
            post.class_name = class_obj.ClassName
        else:
            post.class_name = "Unknown Class"
    
    # Create response object
    return ClassPostPagination(
        items=posts,
        total=total_count,
        page=skip // limit + 1,
        size=limit
    )

def check_is_homeroom_teacher(db: Session, teacher_id: int, class_id: int):
    """Check if a teacher is the homeroom teacher of a class"""
    return db.query(Class).filter(
        Class.ClassID == class_id,
        Class.HomeroomTeacherID == teacher_id
    ).first() is not None

def check_student_in_class(db: Session, student_id: int, class_id: int):
    """Check if a student belongs to a class"""
    return db.query(Student).filter(
        Student.StudentID == student_id,
        Student.ClassID == class_id
    ).first() is not None

def check_parent_has_student_in_class(db: Session, parent_id: int, class_id: int):
    """Check if a parent has a student in a class"""
    # Find all students linked to the parent
    student_ids = db.query(ParentStudent.StudentID).filter(
        ParentStudent.ParentID == parent_id
    ).all()
    
    student_ids = [id[0] for id in student_ids]  # Extract the IDs from the tuples
    
    # Check if any of the students are in the class
    if not student_ids:
        return False
    
    return db.query(Student).filter(
        Student.StudentID.in_(student_ids),
        Student.ClassID == class_id
    ).first() is not None