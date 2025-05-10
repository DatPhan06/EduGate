from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from .. import schemas, models
from ..database import get_db
from ..services import reward_punishment_service
from ..services.auth_service import get_current_active_user 
from ..enums.user_enums import UserRole  # Thêm import này

router = APIRouter(
    prefix="/reward-punishments",
    tags=["Reward & Punishment"],
    responses={404: {"description": "Not found"}},
)

async def check_admin(current_user: Optional[models.User] = Depends(get_current_active_user),
                     db: Session = Depends(get_db)):
    """
    Kiểm tra xem user hiện tại có quyền admin không
    """
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated"
        )
    
    # Thay "admin" bằng UserRole.ADMIN để đảm bảo nhất quán với các phần khác
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only administrators can perform this action"
        )
    
    # Lấy admin ID từ current_user
    admin = db.query(models.AdministrativeStaff).filter(
        models.AdministrativeStaff.AdminID == current_user.UserID
    ).first()
    
    if not admin:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Admin profile not found"
        )
    
    return admin.AdminID

async def check_permission_for_student_rnp(
    student_id: int,
    current_user: Optional[models.User] = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Kiểm tra quyền truy cập xem khen thưởng/kỷ luật của học sinh:
    - Admin/Teacher: xem được tất cả
    - Student: chỉ xem được của bản thân
    - Parent: chỉ xem được của con mình
    """
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated"
        )
    
    # Admin và Teacher có thể xem tất cả
    if current_user.role == UserRole.ADMIN or current_user.role == UserRole.TEACHER:
        return True
    
    # Student chỉ xem được của mình
    if current_user.role == UserRole.STUDENT:
        student = db.query(models.Student).filter(
            models.Student.StudentID == current_user.UserID
        ).first()
        
        if not student:
            raise HTTPException(status_code=404, detail="Student profile not found")
            
        if student.StudentID != student_id:
            raise HTTPException(status_code=403, detail="You can only view your own rewards/punishments")
        
        return True
        
    # Parent chỉ xem được của con mình
    if current_user.role == UserRole.PARENT:
        # Kiểm tra xem học sinh có phải là con của phụ huynh này không
        parent_child = db.query(models.ParentStudent).filter(
            models.ParentStudent.ParentID == current_user.UserID,
            models.ParentStudent.StudentID == student_id
        ).first()
        
        if not parent_child:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only view rewards/punishments for your children"
            )
        
        return True
    
    # Các vai trò khác không có quyền xem
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="You don't have permission to view this information"
    )


# Thêm endpoint mới cho phép xem khen thưởng/kỷ luật với kiểm tra phân quyền
@router.get("/student/{student_id}/view", response_model=List[schemas.RewardPunishmentRead])
async def view_student_rewards_punishments(
    student_id: int,
    db: Session = Depends(get_db),
    _: bool = Depends(check_permission_for_student_rnp)
):
    """
    Xem danh sách khen thưởng/kỷ luật của học sinh với phân quyền.
    """
    try:
        # Kiểm tra xem học sinh có tồn tại không
        student = db.query(models.Student).filter(models.Student.StudentID == student_id).first()
        if not student:
            print(f"Student with ID {student_id} not found in view_student_rewards_punishments")
            return []  # Trả về danh sách trống nếu không tìm thấy học sinh
            
        # Sử dụng hàm get_rewards_and_punishments_for_student đã có
        result = reward_punishment_service.get_rewards_and_punishments_for_student(db=db, student_id=student_id)
        if not result:
            print(f"No rewards/punishments found for student ID {student_id}")
            return []
        return result
    except ValueError as e:
        print(f"ValueError in view_student_rewards_punishments: {str(e)}")
        # Trả về danh sách trống thay vì lỗi để frontend không bị crash
        return []
    except Exception as e:
        print(f"Error in view_student_rewards_punishments: {str(e)}")
        import traceback
        traceback.print_exc()
        # Trả về danh sách trống thay vì lỗi để frontend không bị crash
        return []

@router.post("/student", status_code=status.HTTP_201_CREATED)
async def create_student_reward_punishment(
    rnp_in: schemas.StudentRewardPunishmentCreate,
    db: Session = Depends(get_db),
    admin_id: int = Depends(check_admin)
):
    """
    Tạo một khen thưởng/kỷ luật mới cho học sinh.
    
    - **Permissions**: Admin only
    """
    try:
        print(f"Creating reward/punishment with data: {rnp_in}")
        print(f"Admin ID: {admin_id}")
        created_reward_punishment = reward_punishment_service.create_reward_punishment(
            db=db, 
            rnp_data=rnp_in, 
            admin_id=admin_id
        )
        return created_reward_punishment
    except ValueError as e:
        print(f"ValueError in create_student_reward_punishment: {str(e)}")
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # Log exception in detail
        print(f"Exception in create_student_reward_punishment: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail=f"Could not create student reward/punishment: {str(e)}"
        )

@router.post("/class", response_model=schemas.ClassRNPRead, status_code=status.HTTP_201_CREATED)
async def create_new_class_reward_punishment(
    rnp_in: schemas.ClassRewardPunishmentCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_admin)
):
    """
    Tạo một khen thưởng/kỷ luật mới cho một lớp học cụ thể.

    - **Permissions**: Admin, Teacher
    """
    try:
        created_class_rnp = reward_punishment_service.create_class_rnp(db=db, rnp_data=rnp_in)
        return created_class_rnp
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # Log exception if needed
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Could not create class reward/punishment"
        )

@router.get("/student/{student_id}", response_model=List[schemas.StudentRNPRead])
async def get_student_rewards_punishments(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_admin)
):
    """
    Lấy danh sách khen thưởng/kỷ luật của một học sinh.

    - **Permissions**: Admin, Teacher
    """
    try:
        return reward_punishment_service.get_student_rnps(db=db, student_id=student_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Failed to retrieve student rewards/punishments"
        )

@router.get("/class/{class_id}", response_model=List[schemas.ClassRNPRead])
async def get_class_rewards_punishments(
    class_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_admin)
):
    """
    Lấy danh sách khen thưởng/kỷ luật của một lớp học.

    - **Permissions**: Admin, Teacher
    """
    try:
        return reward_punishment_service.get_class_rnps(db=db, class_id=class_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Failed to retrieve class rewards/punishments"
        )
        

@router.get("/me", response_model=List[schemas.RewardPunishmentRead])
async def get_my_rewards_punishments(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_active_user)
):
    """
    Lấy thông tin khen thưởng/kỷ luật của người dùng hiện tại:
    - Nếu là học sinh: lấy của bản thân
    - Nếu là phụ huynh: lấy danh sách của tất cả con
    - Nếu là admin/teacher: trả về lỗi (họ nên dùng endpoint khác)
    """
    try:
        if current_user.role == UserRole.STUDENT:
            return reward_punishment_service.get_rewards_and_punishments_for_student(
                db=db, student_id=current_user.UserID
            )
        
        elif current_user.role == UserRole.PARENT:
            # Lấy danh sách ID của tất cả con
            children = db.query(models.ParentStudent).filter(
                models.ParentStudent.ParentID == current_user.UserID
            ).all()
            
            if not children:
                return []
            
            # Lấy khen thưởng/kỷ luật cho tất cả con
            result = []
            for child in children:
                student_rnps = reward_punishment_service.get_rewards_and_punishments_for_student(
                    db=db, student_id=child.StudentID
                )
                result.extend(student_rnps)
            
            return result
        
        else:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="This endpoint is only for students and parents. Admins and teachers should use the specific student endpoints."
            )
            
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve rewards/punishments: {str(e)}"
        )