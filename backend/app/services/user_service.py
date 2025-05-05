from sqlalchemy.orm import Session
from fastapi import HTTPException, status, Depends
from datetime import datetime, timedelta
from ..models.user import User
from ..schemas.user import UserCreate, UserUpdate, UserLogin, TokenData
from ..enums.user_enums import UserRole, Gender, UserStatus
from jose import JWTError, jwt
from typing import Optional
from ..config import settings
from ..services import auth_service


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

def get_user_by_email(db: Session, email: str) -> Optional[User]:
    return db.query(User).filter(User.Email == email).first()

def get_user_by_id(db: Session, user_id: int) -> Optional[User]:
    return db.query(User).filter(User.UserID == user_id).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(User).offset(skip).limit(limit).all()

def create_user(db: Session, user: UserCreate):
    # Check if user already exists
    db_user = get_user_by_email(db, email=user.Email)
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Hash password
    hashed_password = auth_service.get_password_hash(user.Password)
    
    # Create new user with role
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
        Status=user.Status,
        role=user.role or 'student'  # Set default role if not provided
    )
    
    # First add and flush to get the UserID
    db.add(db_user)
    db.flush()
    
    # Now create role-specific records with the generated UserID
    if user.role == 'student':
        from ..models.student import Student
        db_user.student = Student(
            StudentID=db_user.UserID,
            ClassID=getattr(user, 'ClassID', None),
            EnrollmentDate=datetime.utcnow(),
            YtDate=getattr(user, 'YtDate', None)
        )
    elif user.role == 'teacher':
        from ..models.teacher import Teacher
        db_user.teacher = Teacher(
            TeacherID=db_user.UserID,
            DepartmentID=getattr(user, 'DepartmentID', None),
            Graduate=getattr(user, 'Graduate', None),
            Degree=getattr(user, 'Degree', None),
            Position=getattr(user, 'Position', None)
        )
    elif user.role == 'parent':
        from ..models.parent import Parent
        db_user.parent = Parent(
            ParentID=db_user.UserID,
            Occupation=getattr(user, 'Occupation', None)
        )
    elif user.role == 'admin':
        from ..models.administrative_staff import AdministrativeStaff
        db_user.administrative_staff = AdministrativeStaff(
            AdminID=db_user.UserID,
            DepartmentID=getattr(user, 'DepartmentID', None),
            Position=getattr(user, 'Position', None)
        )
    
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user(db: Session, user_id: int, user: UserUpdate) -> Optional[User]:
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        return None
    
    # Update the base user fields
    update_data = user.dict(exclude_unset=True, exclude_none=True)
    
    # Handle Enum conversion for Gender and Status
    if 'Gender' in update_data and update_data['Gender'] is not None:
        try:
            update_data['Gender'] = Gender(update_data['Gender'])
        except ValueError:
            # Invalid enum value, remove it
            update_data.pop('Gender')
    
    if 'Status' in update_data and update_data['Status'] is not None:
        try:
            update_data['Status'] = UserStatus(update_data['Status'])
        except ValueError:
            # Invalid enum value, remove it
            update_data.pop('Status')
    
    # Extract role-specific fields
    student_fields = {}
    teacher_fields = {}
    parent_fields = {}
    admin_fields = {}
    
    # Student fields
    if 'ClassID' in update_data:
        student_fields['ClassID'] = update_data.pop('ClassID')
    if 'YtDate' in update_data:
        student_fields['YtDate'] = update_data.pop('YtDate')
        
    # Teacher fields
    if 'DepartmentID' in update_data and db_user.role == 'teacher':
        teacher_fields['DepartmentID'] = update_data.pop('DepartmentID')
    if 'Graduate' in update_data:
        teacher_fields['Graduate'] = update_data.pop('Graduate')
    if 'Degree' in update_data:
        teacher_fields['Degree'] = update_data.pop('Degree')
    if 'Position' in update_data and db_user.role == 'teacher':
        teacher_fields['Position'] = update_data.pop('Position')
        
    # Parent fields
    if 'Occupation' in update_data:
        parent_fields['Occupation'] = update_data.pop('Occupation')
        
    # Admin fields
    if 'DepartmentID' in update_data and db_user.role == 'admin':
        admin_fields['DepartmentID'] = update_data.pop('DepartmentID')
    if 'Position' in update_data and db_user.role == 'admin':
        admin_fields['Position'] = update_data.pop('Position')
    
    # Update main user fields
    for key, value in update_data.items():
        setattr(db_user, key, value)
    
    # Update role-specific fields
    if db_user.student and student_fields:
        for key, value in student_fields.items():
            setattr(db_user.student, key, value)
    
    if db_user.teacher and teacher_fields:
        for key, value in teacher_fields.items():
            setattr(db_user.teacher, key, value)
    
    if db_user.parent and parent_fields:
        for key, value in parent_fields.items():
            setattr(db_user.parent, key, value)
    
    if db_user.administrative_staff and admin_fields:
        for key, value in admin_fields.items():
            setattr(db_user.administrative_staff, key, value)
    
    db.commit()
    db.refresh(db_user)
    return db_user

def delete_user(db: Session, user_id: int) -> bool:
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        return False
    
    db.delete(db_user)
    db.commit()
    return True

def login_user(db: Session, email: str, password: str) -> Optional[User]:
    user = get_user_by_email(db, email)
    if not user:
        return None
    if not auth_service.verify_password(password, user.Password):
        return None
    return user

def get_current_user(token: str, db: Session) -> Optional[User]:
    payload = verify_token(token)
    if not payload:
        return None
    
    email = payload.get("sub")
    if not email:
        return None
    
    return get_user_by_email(db, email) 