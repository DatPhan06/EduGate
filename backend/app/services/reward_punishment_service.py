from sqlalchemy.orm import Session
from .. import models, schemas
from typing import List
import datetime

def create_reward_punishment(db: Session, rnp_data: schemas.RewardPunishmentCreate) -> models.RewardPunishment:
    """
    Tạo bản ghi khen thưởng/kỷ luật mới.
    Assumes rnp_data contains StudentID, AdminID, Title, Type, Description, Date, Semester, Week.
    """
    # Optional: Kiểm tra StudentID và AdminID tồn tại
    student = db.query(models.Student).filter(models.Student.StudentID == rnp_data.StudentID).first()
    if not student:
        raise ValueError(f"Student with ID {rnp_data.StudentID} not found")
    
    admin_staff = db.query(models.AdministrativeStaff).filter(models.AdministrativeStaff.AdminID == rnp_data.AdminID).first()
    if not admin_staff:
        raise ValueError(f"AdministrativeStaff with ID {rnp_data.AdminID} not found")

    db_reward_punishment = models.RewardPunishment(
        Title=rnp_data.Title,
        Type=rnp_data.Type,
        Description=rnp_data.Description,
        Date=rnp_data.Date if rnp_data.Date else datetime.date.today(), # Example: use today if no date
        Semester=rnp_data.Semester,
        Week=rnp_data.Week,
        StudentID=rnp_data.StudentID,
        AdminID=rnp_data.AdminID
    )
    db.add(db_reward_punishment)
    db.commit()
    db.refresh(db_reward_punishment)
    return db_reward_punishment

def get_rewards_and_punishments_for_student(db: Session, student_id: int) -> List[models.RewardPunishment]:
    """
    Lấy danh sách tất cả khen thưởng/kỷ luật của học sinh.
    """
    student = db.query(models.Student).filter(models.Student.StudentID == student_id).first()
    if not student:
        # Or return empty list: return []
        raise ValueError(f"Student with ID {student_id} not found") 
    
    return db.query(models.RewardPunishment).filter(models.RewardPunishment.StudentID == student_id).all()