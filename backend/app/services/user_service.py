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
from sqlalchemy import or_, func
import pandas as pd
from fastapi import UploadFile
from io import BytesIO
from sqlalchemy.exc import IntegrityError


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

def get_users(db: Session, skip: int = 0, limit: int = 100, role: Optional[UserRole] = None, search: Optional[str] = None):
    query = db.query(User)
    
    if role:
        query = query.filter(User.role == role)
        
    if search:
        search_term = f"%{search.lower()}%"
        query = query.filter(
            or_(
                func.lower(User.FirstName + " " + User.LastName).like(search_term),
                func.lower(User.Email).like(search_term),
                # Add other searchable fields if needed
            )
        )
        
    return query.order_by(User.UserID).offset(skip).limit(limit).all()

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
        from ..models.department import Department

        teacher_department_id = getattr(user, 'DepartmentID', None)

        # If DepartmentID is 0, treat it as None (no department assigned)
        if teacher_department_id == 0:
            teacher_department_id = None

        # Validate if DepartmentID actually exists if it's not None
        if teacher_department_id is not None:
            department = db.query(Department).filter(Department.DepartmentID == teacher_department_id).first()
            if not department:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Department with ID {teacher_department_id} not found."
                )

        db_user.teacher = Teacher(
            TeacherID=db_user.UserID,
            DepartmentID=teacher_department_id,
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

def create_users_from_excel(db: Session, file: UploadFile):
    results = {"success_count": 0, "errors": []}
    try:
        contents = file.file.read()
        # Đọc cột PhoneNumber và ClassID, DepartmentID như string để tránh pandas nhận dạng sai
        # ClassID và DepartmentID sẽ được chuyển thành int sau nếu có giá trị
        df = pd.read_excel(BytesIO(contents), dtype={
            'PhoneNumber': str, 
            'ClassID': str,
            'DepartmentID': str
        })

        # Xử lý các giá trị NaN/NaT thành None hoặc giá trị mặc định nếu cần
        df = df.where(pd.notnull(df), None) # Chuyển NaN/NaT của pandas thành None của Python

        for index, row in df.iterrows():
            user_data_dict = row.to_dict()
            
            phone_number = user_data_dict.get("PhoneNumber")
            if phone_number is not None:
                phone_number = str(phone_number).strip() # Đảm bảo là string và loại bỏ khoảng trắng
                if phone_number.lower() == 'nan' or phone_number == '': # Xử lý thêm trường hợp 'nan' string
                    phone_number = None
            
            dob_val = user_data_dict.get("DOB")
            dob_iso = None
            if pd.notna(dob_val) and dob_val:
                try:
                    # Chuyển đổi sang datetime, sau đó lấy date và định dạng ISO
                    dob_iso = pd.to_datetime(dob_val).date().isoformat()
                except ValueError:
                    results["errors"].append(f"Row {index + 2} (Email: {user_data_dict.get('Email')}, DOB: '{dob_val}'): Invalid date format.")
                    continue # Bỏ qua dòng này nếu ngày không hợp lệ
            
            role_str = user_data_dict.get("role")
            if role_str:
                role_str = str(role_str).lower().strip()

            class_id_str = user_data_dict.get("ClassID")
            class_id = None
            if class_id_str and str(class_id_str).strip() and role_str == UserRole.STUDENT.value:
                try:
                    class_id = int(float(str(class_id_str).strip())) # Chuyển qua float rồi int để xử lý "1.0"
                except ValueError:
                    results["errors"].append(f"Row {index + 2} (Email: {user_data_dict.get('Email')}, ClassID: '{class_id_str}'): Invalid ClassID format.")
                    continue

            department_id_str = user_data_dict.get("DepartmentID")
            department_id = None
            if department_id_str and str(department_id_str).strip() and role_str in [UserRole.TEACHER.value, UserRole.ADMIN.value]:
                try:
                    department_id = int(float(str(department_id_str).strip()))
                except ValueError:
                    results["errors"].append(f"Row {index + 2} (Email: {user_data_dict.get('Email')}, DepartmentID: '{department_id_str}'): Invalid DepartmentID format.")
                    continue

            user_payload = {
                "FirstName": user_data_dict.get("FirstName"),
                "LastName": user_data_dict.get("LastName"),
                "Email": user_data_dict.get("Email"),
                "Password": user_data_dict.get("Password"),
                "PhoneNumber": phone_number,
                "DOB": dob_iso,
                "Gender": user_data_dict.get("Gender"),
                "Address": user_data_dict.get("Address"),
                "Street": user_data_dict.get("Street"),
                "District": user_data_dict.get("District"),
                "City": user_data_dict.get("City"),
                "Status": user_data_dict.get("Status", "ACTIVE"),
                "role": role_str,
                "ClassID": class_id,
                "DepartmentID": department_id,
                "Degree": user_data_dict.get("Degree") if role_str == UserRole.TEACHER.value else None,
                "Graduate": user_data_dict.get("Graduate") if role_str == UserRole.TEACHER.value else None,
                "Position": user_data_dict.get("Position") if role_str in [UserRole.TEACHER.value, UserRole.ADMIN.value] else None,
                "Occupation": user_data_dict.get("Occupation") if role_str == UserRole.PARENT.value else None,
            }

            if not all([user_payload["FirstName"], user_payload["LastName"], user_payload["Email"], user_payload["Password"], user_payload["role"]]):
                results["errors"].append(f"Row {index + 2} (Email: {user_payload.get('Email', 'N/A')}): Missing required fields (FirstName, LastName, Email, Password, role).")
                continue
            
            try:
                user_payload["role"] = UserRole(user_payload["role"]) # role đã được lower() và strip()
            except ValueError:
                results["errors"].append(f"Row {index + 2} (Email: {user_payload.get('Email', 'N/A')}): Invalid role '{user_payload['role']}'.")
                continue

            try:
                user_create_schema = UserCreate(**user_payload)
                create_user(db=db, user=user_create_schema)
                results["success_count"] += 1
            except HTTPException as e:
                db.rollback()
                results["errors"].append(f"Row {index + 2} (Email: {user_payload.get('Email', 'N/A')}): {e.detail}")
            except IntegrityError as e:
                db.rollback()
                results["errors"].append(f"Row {index + 2} (Email: {user_payload.get('Email', 'N/A')}): Database integrity error - {e.orig}")
            except Exception as e:
                db.rollback()
                error_detail = str(e)
                if hasattr(e, 'errors') and callable(e.errors):
                    try:
                        pydantic_errors = e.errors()
                        error_messages = []
                        for error in pydantic_errors:
                            field = " -> ".join(map(str, error['loc']))
                            msg = error['msg']
                            error_messages.append(f"Field '{field}': {msg}")
                        error_detail = "; ".join(error_messages)
                    except Exception: # noqa
                        pass # Giữ lại str(e) mặc định
                results["errors"].append(f"Row {index + 2} (Email: {user_payload.get('Email', 'N/A')}): An unexpected error occurred - {error_detail}")

    except pd.errors.EmptyDataError:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="The uploaded Excel file is empty.")
    except Exception as e:
        # Log a generic error for debugging
        # logger.error(f"Error processing Excel file: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Failed to process Excel file: {str(e)}")
    
    return results 