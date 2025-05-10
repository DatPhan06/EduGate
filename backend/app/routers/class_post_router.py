from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional, List
from ..database import get_db
from ..services import class_post_service
from ..schemas.class_post_schema import ClassPostCreate, ClassPostRead, ClassPostUpdate, ClassPostPagination
from ..services.auth_service import get_current_user, get_current_teacher, get_current_parent, get_current_student

router = APIRouter(
    prefix="/class-posts",
    tags=["class-posts"],
    responses={404: {"description": "Not found"}},
)

@router.post("/", response_model=ClassPostRead, status_code=status.HTTP_201_CREATED)
async def create_class_post(
    post_data: ClassPostCreate,
    db: Session = Depends(get_db),
    current_teacher = Depends(get_current_teacher)
):
    """
    Create a new class post.
    Only the homeroom teacher of the class can create posts.
    """
    try:
        return class_post_service.create_class_post(db, post_data, current_teacher.TeacherID)
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating class post: {str(e)}"
        )

@router.get("/{post_id}", response_model=ClassPostRead)
async def get_class_post(
    post_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Get a specific class post by ID.
    """
    post = class_post_service.get_class_post_by_id(db, post_id)
    if not post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Class post with ID {post_id} not found"
        )
    
    # Check user permissions (parent/student should be in the class, or teacher should be related to class)
    user_role = getattr(current_user, "role", None)
    
    if user_role == "admin":
        return post  # Admins can see all posts
    
    if user_role == "teacher":
        if current_user.TeacherID == post.TeacherID:
            return post  # Author can see the post
        
        # Check if teacher is homeroom teacher for this class
        if class_post_service.check_is_homeroom_teacher(db, current_user.TeacherID, post.ClassID):
            return post
            
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to view this class post"
        )
    
    elif user_role == "student":
        # Check if student belongs to the class
        if class_post_service.check_student_in_class(db, current_user.StudentID, post.ClassID):
            return post
        
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to view this class post"
        )
    
    elif user_role == "parent":
        # Check if parent has a student in the class
        if class_post_service.check_parent_has_student_in_class(db, current_user.ParentID, post.ClassID):
            return post
        
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to view this class post"
        )
    
    # If we get here, user role is not recognized or doesn't have permission
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You don't have permission to view this class post"
    )

@router.put("/{post_id}", response_model=ClassPostRead)
async def update_class_post(
    post_id: int,
    post_data: ClassPostUpdate,
    db: Session = Depends(get_db),
    current_teacher = Depends(get_current_teacher)
):
    """
    Update a class post.
    Only the original author or the current homeroom teacher can update posts.
    """
    try:
        return class_post_service.update_class_post(db, post_id, post_data, current_teacher.TeacherID)
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating class post: {str(e)}"
        )

@router.delete("/{post_id}", status_code=status.HTTP_200_OK)
async def delete_class_post(
    post_id: int,
    db: Session = Depends(get_db),
    current_teacher = Depends(get_current_teacher)
):
    """
    Delete a class post.
    Only the original author or the current homeroom teacher can delete posts.
    """
    try:
        success = class_post_service.delete_class_post(db, post_id, current_teacher.TeacherID)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Class post with ID {post_id} not found"
            )
        return {"message": f"Class post with ID {post_id} deleted successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting class post: {str(e)}"
        )

@router.get("/class/{class_id}", response_model=ClassPostPagination)
async def get_class_posts_for_class(
    class_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
    page: int = Query(1, gt=0),
    size: int = Query(10, gt=0, le=100),
    search: Optional[str] = None
):
    """
    Get all class posts for a specific class.
    Pagination and search functionality included.
    Anyone can view the posts.
    """
    # Calculate skip parameter for pagination
    skip = (page - 1) * size
    
    # Fetch posts with pagination
    posts = class_post_service.get_class_posts_for_class(db, class_id, skip, size, search)
    return posts

@router.get("/teacher/my-posts", response_model=ClassPostPagination)
async def get_my_class_posts(
    db: Session = Depends(get_db),
    current_teacher = Depends(get_current_teacher),
    page: int = Query(1, gt=0),
    size: int = Query(10, gt=0, le=100),
    search: Optional[str] = None
):
    """
    Get all class posts created by the current teacher.
    Pagination and search functionality included.
    """
    # Calculate skip parameter for pagination
    skip = (page - 1) * size
    
    # Fetch posts with pagination
    posts = class_post_service.get_class_posts_for_teacher(db, current_teacher.TeacherID, skip, size, search)
    return posts