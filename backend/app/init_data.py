from sqlalchemy.orm import Session
from .models import User, AdministrativeStaff, Department
from .database import get_db
from .enums.user_enums import Gender, UserStatus, UserRole
import datetime
from datetime import UTC
from passlib.context import CryptContext

# Tạo 1 tài khoản Admin

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def init_data():
    db = next(get_db())
    
    try:
        # Tạo departments
        departments = [
            {"DepartmentID": 1, "DepartmentName": "Hành chính", "Description": "Phòng ban hành chính"},
            {"DepartmentID": 2, "DepartmentName": "Giáo vụ", "Description": "Phòng ban giáo vụ"},
            {"DepartmentID": 3, "DepartmentName": "Tài chính", "Description": "Phòng ban tài chính"}
        ]
        
        for dept in departments:
            if not db.query(Department).filter(Department.DepartmentID == dept["DepartmentID"]).first():
                department = Department(**dept)
                db.add(department)
        
        # Tạo tài khoản Admin
        if not db.query(User).filter(User.Email == "admin@edugate.edu").first():
            admin_user = User(
                UserID=1,
                FirstName="Admin",
                LastName="User",
                Email="admin@edugate.edu",
                Password=pwd_context.hash("admin123"),
                PhoneNumber="0123456789",
                DOB=datetime.datetime(1990, 1, 1),
                Gender=Gender.MALE,
                Address="123 Admin Street",
                Status=UserStatus.ACTIVE,
                role=UserRole.ADMIN
            )
            db.add(admin_user)
            db.flush()
            
            admin_staff = AdministrativeStaff(
                AdminID=admin_user.UserID,
                DepartmentID=1,
                Position="Quản trị viên"
            )
            db.add(admin_staff)

        db.commit()
        print("Initial data created successfully!")
        
    except Exception as e:
        db.rollback()
        print(f"Error creating initial data: {str(e)}")
    finally:
        db.close()

if __name__ == "__main__":
    init_data() 