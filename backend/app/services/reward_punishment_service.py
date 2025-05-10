from sqlalchemy.orm import Session
from .. import models, schemas
from typing import List
import datetime
from ..models.reward_punishment import RNPType  # Thêm dòng này

def create_reward_punishment(db: Session, rnp_data: schemas.RewardPunishmentCreate, admin_id: int) -> models.RewardPunishment:
    """
    Tạo bản ghi khen thưởng/kỷ luật mới cho học sinh.
    Chỉ admin mới có quyền tạo và chỉ tạo cho học sinh.
    """
    # Kiểm tra xem student_id có tồn tại không
    student = db.query(models.Student).filter(models.Student.StudentID == rnp_data.student_id).first()
    if not student:
        raise ValueError(f"Student with ID {rnp_data.student_id} not found")
    
    # Kiểm tra xem admin_id có tồn tại không
    admin_staff = db.query(models.AdministrativeStaff).filter(models.AdministrativeStaff.AdminID == admin_id).first()
    if not admin_staff:
        raise ValueError(f"AdministrativeStaff with ID {admin_id} not found")

    # Chuyển đổi chuỗi type thành enum RNPType
    if rnp_data.type.upper() == "REWARD":
        type_enum = RNPType.REWARD
    elif rnp_data.type.upper() == "PUNISHMENT":
        type_enum = RNPType.PUNISHMENT
    else:
        raise ValueError(f"Invalid reward/punishment type: {rnp_data.type}. Must be 'REWARD' or 'PUNISHMENT'")

    # Sử dụng tên trường phù hợp với frontend
    db_reward_punishment = models.RewardPunishment(
        Title=rnp_data.title if hasattr(rnp_data, 'title') else "Reward/Punishment Record",  # Giá trị mặc định
        Type=type_enum,  # Sử dụng enum thay vì chuỗi
        Description=rnp_data.description,
        Date=rnp_data.date if rnp_data.date else datetime.date.today(),
        Semester=rnp_data.semester if hasattr(rnp_data, 'semester') else None,
        Week=rnp_data.week if hasattr(rnp_data, 'week') else None,
        StudentID=rnp_data.student_id,
        AdminID=admin_id
    )
    db.add(db_reward_punishment)
    db.commit()
    db.refresh(db_reward_punishment)
    return db_reward_punishment

def get_rewards_and_punishments_for_student(db: Session, student_id: int) -> List[models.RewardPunishment]:
    """
    Lấy danh sách tất cả khen thưởng/kỷ luật của học sinh.
    Trả về list rỗng nếu học sinh không tồn tại hoặc không có khen thưởng/kỷ luật.
    """
    try:
        # Kiểm tra học sinh tồn tại
        student = db.query(models.Student).filter(models.Student.StudentID == student_id).first()
        if not student:
            # Trả về danh sách trống thay vì ném lỗi
            print(f"Warning: Student with ID {student_id} not found, returning empty list")
            return []
        
        # Query các bản ghi khen thưởng/kỷ luật
        return db.query(models.RewardPunishment).filter(models.RewardPunishment.StudentID == student_id).all()
    except Exception as e:
        print(f"Error in get_rewards_and_punishments_for_student: {str(e)}")
        # Trả về danh sách trống để tránh lỗi
        return []