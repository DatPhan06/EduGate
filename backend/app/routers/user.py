from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..schemas.user import User, UserCreate, UserUpdate, TokenData, ChangePassword
from ..schemas.parent import ParentCreate
from ..services import user_service, auth_service
from ..models import Parent
from ..enums.user_enums import UserRole
from pydantic import BaseModel

router = APIRouter(
    prefix="/users",
    tags=["users"]
)

@router.post("/register", response_model=User)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    return user_service.create_user(db, user)

@router.get("/me", response_model=User)
async def get_current_user(
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Kiểm tra token
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    # Lấy token từ header
    token = authorization.split(" ")[1]
    
    try:
        # Xác thực token và lấy email
        email = auth_service.get_current_user_email(token)
        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )
        
        # Lấy thông tin user từ email
        user = user_service.get_user_by_email(db, email)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return user
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )

@router.get("/", response_model=List[User])
def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return user_service.get_users(db, skip, limit)

@router.get("/{user_id}", response_model=User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = user_service.get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user

@router.put("/{user_id}", response_model=User)
def update_user(user_id: int, user: UserUpdate, db: Session = Depends(get_db)):
    return user_service.update_user(db, user_id, user)

@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    return user_service.delete_user(db, user_id) 

@router.post("/change-password")
async def change_password(
    password_data: ChangePassword,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    # Kiểm tra token
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    # Lấy token từ header
    token = authorization.split(" ")[1]
    
    try:
        # Xác thực token và lấy email
        email = auth_service.get_current_user_email(token)
        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )
        
        # Lấy thông tin user từ email
        user = user_service.get_user_by_email(db, email)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Kiểm tra mật khẩu hiện tại
        if not auth_service.verify_password(password_data.currentPassword, user.Password):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Current password is incorrect"
            )
        
        # Cập nhật mật khẩu mới
        hashed_password = auth_service.get_password_hash(password_data.newPassword)
        user.Password = hashed_password
        db.commit()
        
        return {"message": "Password changed successfully"}
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        ) 

@router.post("/create-parent-profile")
async def create_parent_profile(
    profile: ParentCreate,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    """
    Tạo profile parent cho user hiện tại
    """
    # Kiểm tra token
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    # Lấy token từ header
    token = authorization.split(" ")[1]
    
    try:
        # Xác thực token và lấy email
        email = auth_service.get_current_user_email(token)
        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )
        
        # Lấy thông tin user từ email
        user = user_service.get_user_by_email(db, email)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Kiểm tra role
        if user.role != UserRole.PARENT:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only parent users can create parent profile"
            )
        
        # Kiểm tra đã có profile chưa
        if user.parent:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Parent profile already exists"
            )
        
        # Tạo profile parent mới
        parent = Parent(
            ParentID=user.UserID,
            Occupation=profile.Occupation
        )
        db.add(parent)
        db.commit()
        db.refresh(parent)
        
        return {"message": "Parent profile created successfully"}
        
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        ) 