from sqlalchemy.orm import Session, aliased
from sqlalchemy import select
from ..models.teacher import Teacher
from ..models.user import User
from ..schemas.teacher_schema import TeacherRead
from typing import List, Optional

def get_teachers(db: Session, skip: int = 0, limit: int = 1000) -> List[TeacherRead]:
    TeacherUser = aliased(User, name="teacher_user_alias")

    results = db.query(
        Teacher.TeacherID,
        TeacherUser.FirstName,
        TeacherUser.LastName,
        Teacher.Degree # Select Degree from Teacher model
    ).join(TeacherUser, Teacher.TeacherID == TeacherUser.UserID)\
    .offset(skip).limit(limit).all()
    
    teachers_read = []
    for row in results:
        name = f"{row.FirstName or ''} {row.LastName or ''}".strip()
        # The query now directly returns Degree from the Teacher table bound to the main query context
        specialization = row.Degree 
        
        teachers_read.append(TeacherRead(
            id=row.TeacherID,
            name=name if name else "N/A",
            specialization=specialization
        ))
    return teachers_read 