from fastapi import APIRouter, Depends, HTTPException, status, Header, Query, File, UploadFile
from sqlalchemy.orm import Session
from typing import List, Optional, Dict, Any
from ..database import get_db
from ..schemas.user import User, UserCreate, UserUpdate, TokenData, ChangePassword
from ..schemas.parent import ParentCreate
from ..services import user_service, auth_service
from ..models import Parent
from ..enums.user_enums import UserRole
from pydantic import BaseModel

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
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
def get_users(
    skip: int = 0, 
    limit: int = 100, 
    role: Optional[UserRole] = Query(None, description="Filter users by role"),
    search: Optional[str] = Query(None, description="Search users by name or email"),
    db: Session = Depends(get_db)
):
    return user_service.get_users(db, skip=skip, limit=limit, role=role, search=search)

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

@router.post("/upload_excel", status_code=status.HTTP_201_CREATED)
def upload_users_excel(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """
    Uploads an Excel file to create multiple users.
    Requires admin privileges.
    The Excel file should have columns matching the UserCreate schema fields.
    Required columns: FirstName, LastName, Email, Password, role.
    Optional columns: PhoneNumber, DOB (YYYY-MM-DD or parsable date string), Gender, Address, Street, District, City, Status,
                      ClassID (for students), DepartmentID (for teachers/admins), Degree, Graduate, Position, Occupation.
    Returns a summary of successfully created users and any errors encountered.
    """
    if not file.filename.endswith(('.xls', '.xlsx')):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid file type. Only .xls and .xlsx files are allowed.")
    
    try:
        results = user_service.create_users_from_excel(db=db, file=file)
        if results["errors"]:
            # Trả về 207 Multi-Status nếu có một số lỗi nhưng một số thành công
            # Hoặc bạn có thể quyết định trả về 400 nếu có bất kỳ lỗi nào
            # Ở đây, chúng ta sẽ trả về 201 với thông tin lỗi nếu có
            return {"message": "User import partially successful", "created_count": results["success_count"], "errors": results["errors"]}
        return {"message": "Users imported successfully", "created_count": results["success_count"]}
    except HTTPException as e:
        # Re-raise HTTPExceptions từ service
        raise e
    except Exception as e:
        # Bắt các lỗi không mong muốn khác từ quá trình xử lý file
        # logger.error(f"Unhandled error during Excel upload: {e}") # Cân nhắc logging
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"An unexpected error occurred while processing the file: {str(e)}") 