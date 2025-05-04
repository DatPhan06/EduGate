from sqlalchemy.orm import Session
from .. import models, schemas
from typing import List

def create_student_rnp(db: Session, rnp_data: schemas.StudentRewardPunishmentCreate):
    """
    Tạo khen thưởng/kỷ luật mới cho học sinh
    """
    # Kiểm tra học sinh tồn tại
    student = db.query(models.Student).filter(models.Student.StudentID == rnp_data.student_id).first()
    if not student:
        raise ValueError(f"Student with ID {rnp_data.student_id} not found")
    
    # Tạo bản ghi khen thưởng kỷ luật chung
    reward_punishment = models.RewardPunishment(
        Type=rnp_data.type,
        Description=rnp_data.description,
        Date=rnp_data.date,
        IssuerID=rnp_data.issuer_id
    )
    db.add(reward_punishment)
    db.commit()
    db.refresh(reward_punishment)
    
    # Tạo liên kết với học sinh
    student_rnp = models.StudentRNP(
        RecordID=reward_punishment.RecordID,
        StudentID=rnp_data.student_id
    )
    db.add(student_rnp)
    db.commit()
    db.refresh(student_rnp)
    
    return student_rnp

def create_class_rnp(db: Session, rnp_data: schemas.ClassRewardPunishmentCreate):
    """
    Tạo khen thưởng/kỷ luật mới cho lớp học
    """
    # Kiểm tra lớp tồn tại
    class_ = db.query(models.Class).filter(models.Class.ClassID == rnp_data.class_id).first()
    if not class_:
        raise ValueError(f"Class with ID {rnp_data.class_id} not found")
    
    # Tạo bản ghi khen thưởng kỷ luật chung
    reward_punishment = models.RewardPunishment(
        Type=rnp_data.type,
        Description=rnp_data.description,
        Date=rnp_data.date,
        IssuerID=rnp_data.issuer_id
    )
    db.add(reward_punishment)
    db.commit()
    db.refresh(reward_punishment)
    
    # Tạo liên kết với lớp
    class_rnp = models.ClassRNP(
        RecordID=reward_punishment.RecordID,
        ClassID=rnp_data.class_id
    )
    db.add(class_rnp)
    db.commit()
    db.refresh(class_rnp)
    
    return class_rnp

def get_student_rnps(db: Session, student_id: int) -> List[models.StudentRNP]:
    """
    Lấy danh sách tất cả khen thưởng/kỷ luật của học sinh
    """
    # Kiểm tra học sinh tồn tại
    student = db.query(models.Student).filter(models.Student.StudentID == student_id).first()
    if not student:
        raise ValueError(f"Student with ID {student_id} not found")
    
    return db.query(models.StudentRNP).filter(
        models.StudentRNP.StudentID == student_id
    ).all()

def get_class_rnps(db: Session, class_id: int) -> List[models.ClassRNP]:
    """
    Lấy danh sách tất cả khen thưởng/kỷ luật của lớp học
    """
    # Kiểm tra lớp tồn tại
    class_ = db.query(models.Class).filter(models.Class.ClassID == class_id).first()
    if not class_:
        raise ValueError(f"Class with ID {class_id} not found")
    
    return db.query(models.ClassRNP).filter(
        models.ClassRNP.ClassID == class_id
    ).all()