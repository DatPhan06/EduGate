from sqlalchemy.orm import Session
from fastapi import HTTPException, status, Depends
from datetime import datetime, timedelta
from ..models.user import User
from ..schemas.user import UserCreate, UserUpdate
from passlib.context import CryptContext
from jose import JWTError, jwt
from typing import Optional
from ..config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_user_by_email(db: Session, email: str) -> Optional[User]:
    return db.query(User).filter(User.Email == email).first()

def get_user_by_id(db: Session, user_id: int) -> Optional[User]:
    return db.query(User).filter(User.UserID == user_id).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(User).offset(skip).limit(limit).all()

def create_user(db: Session, user: UserCreate) -> User:
    # Kiểm tra email đã tồn tại chưa
    db_user = get_user_by_email(db, email=user.Email)
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Hash password
    hashed_password = pwd_context.hash(user.Password)
    
    # Tạo user mới
    db_user = User(
        FirstName=user.FirstName,
        LastName=user.LastName,
        Email=user.Email,
        Password=hashed_password,
        PhoneNumber=user.PhoneNumber,
        DOB=user.DOB,
        PlaceOfBirth=user.PlaceOfBirth,
        Gender=user.Gender,
        Address=user.Address,
        Status=user.Status
    )
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user(db: Session, user_id: int, user: UserUpdate) -> User:
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Cập nhật các trường được cung cấp
    for field, value in user.dict(exclude_unset=True).items():
        setattr(db_user, field, value)
    
    db_user.UpdatedAt = datetime.utcnow()
    db.commit()
    db.refresh(db_user)
    return db_user

def delete_user(db: Session, user_id: int) -> bool:
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    db.delete(db_user)
    db.commit()
    return True

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def authenticate_user(db: Session, email: str, password: str) -> Optional[User]:
    user = get_user_by_email(db, email)
    if not user:
        return None
    if not verify_password(password, user.Password):
        return None
    return user

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=7)  # Token hết hạn sau 7 ngày
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def login_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)
    if not user or not pwd_context.verify(password, user.Password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    return user

def get_current_user(token: str, db: Session) -> Optional[User]:
    payload = verify_token(token)
    if not payload:
        return None
    
    email = payload.get("sub")
    if not email:
        return None
    
    return get_user_by_email(db, email)

def verify_token(token: str) -> Optional[dict]:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None 