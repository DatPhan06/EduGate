from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from ..config import settings
from ..schemas.user import TokenData
from fastapi import Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from .. import models
from ..database import get_db
from ..services import user_service
from ..enums.user_enums import UserRole

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def verify_token(token: str) -> bool:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return True
    except JWTError:
        return False

def get_current_user_email(token: str) -> Optional[str]:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            return None
        token_data = TokenData(email=email)
        return token_data.email
    except JWTError:
        return None

async def get_current_active_user(authorization: str = Header(None), db: Session = Depends(get_db)) -> models.User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    if not authorization or not authorization.startswith("Bearer "):
        raise credentials_exception
    
    token = authorization.split(" ")[1]
    email = get_current_user_email(token)
    if email is None:
        raise credentials_exception
    
    user = user_service.get_user_by_email(db, email=email)
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    return user

# Add the missing functions that class_post_router.py is trying to import
async def get_current_user(authorization: str = Header(None), db: Session = Depends(get_db)):
    """Get the current user regardless of their role"""
    return await get_current_active_user(authorization, db)

async def get_current_teacher(authorization: str = Header(None), db: Session = Depends(get_db)):
    """Get the current user and ensure they are a teacher"""
    user = await get_current_active_user(authorization, db)
    
    if user.role != UserRole.TEACHER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access forbidden: User is not a teacher"
        )
        
    # Get teacher record linked to this user
    teacher = db.query(models.Teacher).filter(models.Teacher.TeacherID == user.UserID).first()
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Teacher record not found"
        )
        
    # Set role for permission checking
    setattr(teacher, "role", "teacher") # Keep this to attach role for permission checks if needed elsewhere
    # also attach all user attributes to teacher object for easier access in router
    for key, value in user.__dict__.items():
        if not hasattr(teacher, key):
            setattr(teacher, key, value)
    return teacher

async def get_current_parent(authorization: str = Header(None), db: Session = Depends(get_db)):
    """Get the current user and ensure they are a parent"""
    user = await get_current_active_user(authorization, db)
    
    if user.role != UserRole.PARENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access forbidden: User is not a parent"
        )
        
    # Get parent record linked to this user
    parent = db.query(models.Parent).filter(models.Parent.ParentID == user.UserID).first()
    if not parent:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Parent record not found"
        )
        
    # Set role for permission checking
    setattr(parent, "role", "parent")
    # also attach all user attributes to parent object for easier access in router
    for key, value in user.__dict__.items():
        if not hasattr(parent, key):
            setattr(parent, key, value)
    return parent

async def get_current_student(authorization: str = Header(None), db: Session = Depends(get_db)):
    """Get the current user and ensure they are a student"""
    user = await get_current_active_user(authorization, db)
    
    if user.role != UserRole.STUDENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access forbidden: User is not a student"
        )
        
    # Get student record linked to this user
    student = db.query(models.Student).filter(models.Student.StudentID == user.UserID).first()
    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Student record not found"
        )
        
    # Set role for permission checking
    setattr(student, "role", "student")
    # also attach all user attributes to student object for easier access in router
    for key, value in user.__dict__.items():
        if not hasattr(student, key):
            setattr(student, key, value)
    return student

async def get_current_admin_staff(authorization: str = Header(None), db: Session = Depends(get_db)):
    """Get the current user and ensure they are an admin staff member"""
    user = await get_current_active_user(authorization, db)
    
    if user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access forbidden: User is not an administrative staff member"
        )
        
    # Get admin record linked to this user
    admin = db.query(models.AdministrativeStaff).filter(models.AdministrativeStaff.AdminID == user.UserID).first()
    if not admin:
        # Nếu không tìm thấy bản ghi admin, tạo một bản ghi mới
        admin = models.AdministrativeStaff(AdminID=user.UserID)
        db.add(admin)
        db.commit()
        db.refresh(admin)
        
    # Set role for permission checking
    setattr(admin, "role", "admin")
    # also attach all user attributes to admin object for easier access in router
    for key, value in user.__dict__.items():
        if not hasattr(admin, key):
            setattr(admin, key, value)
    return admin