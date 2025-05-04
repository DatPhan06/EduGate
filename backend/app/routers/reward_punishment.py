from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from .. import schemas, models
from ..database import get_db
from ..services import reward_punishment_service

router = APIRouter(
    prefix="/reward-punishments",
    tags=["Reward & Punishment"],
    responses={404: {"description": "Not found"}},
)

# Dependency for authorization
async def get_current_active_user(db: Session = Depends(get_db)) -> models.User:
    """
    Giả định hàm này được định nghĩa đầy đủ trong module dependencies.
    Tạm thời làm một placeholder để tránh lỗi khi import.
    """
    # Trong thực tế, hàm này sẽ lấy user hiện tại từ token JWT
    # Đây chỉ là placeholder, trong triển khai thực tế bạn sẽ dùng hàm từ dependencies
    return None

async def check_admin_or_teacher(current_user: Optional[models.User] = Depends(get_current_active_user), 
                                db: Session = Depends(get_db)):
    """
    Kiểm tra xem user hiện tại có quyền admin hoặc teacher không
    """
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
        )
    
    # Logic để kiểm tra role
    is_admin = hasattr(current_user, 'administrative_staff') and current_user.administrative_staff is not None
    is_teacher = hasattr(current_user, 'teacher') and current_user.teacher is not None

    if not (is_admin or is_teacher):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Operation not permitted. Requires Admin or Teacher role.",
        )
    return current_user

@router.post("/student", response_model=schemas.StudentRNPRead, status_code=status.HTTP_201_CREATED)
async def create_new_student_reward_punishment(
    rnp_in: schemas.StudentRewardPunishmentCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_admin_or_teacher)
):
    """
    Tạo một khen thưởng/kỷ luật mới cho một học sinh cụ thể.

    - **Permissions**: Admin, Teacher
    """
    try:
        created_student_rnp = reward_punishment_service.create_student_rnp(db=db, rnp_data=rnp_in)
        return created_student_rnp
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        # Log exception if needed
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Could not create student reward/punishment"
        )

@router.post("/class", response_model=schemas.ClassRNPRead, status_code=status.HTTP_201_CREATED)
async def create_new_class_reward_punishment(
    rnp_in: schemas.ClassRewardPunishmentCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_admin_or_teacher)
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
    current_user: models.User = Depends(check_admin_or_teacher)
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
    current_user: models.User = Depends(check_admin_or_teacher)
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