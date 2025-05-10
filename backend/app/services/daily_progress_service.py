from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from ..models import DailyProgress, Student, Class, User
from datetime import date

class DailyProgressService:
    @staticmethod
    def get_by_student(db: Session, student_id: int) -> List[DailyProgress]:
        return db.query(DailyProgress).filter(DailyProgress.StudentID == student_id).order_by(DailyProgress.Date.desc()).all()

    @staticmethod
    def get_by_class(db: Session, class_id: int) -> List[DailyProgress]:
        class_ = db.query(Class).filter(Class.ClassID == class_id).first()
        if not class_:
            return []
        student_ids = [s.StudentID for s in class_.students]
        return db.query(DailyProgress).filter(DailyProgress.StudentID.in_(student_ids)).order_by(DailyProgress.Date.desc()).all()

    @staticmethod
    def create_or_update(db: Session, *, student_id: int, teacher_id: int, date_: date, overall: Optional[str], attendance: Optional[str], study_outcome: Optional[str], reprimand: Optional[str]) -> DailyProgress:
        progress = db.query(DailyProgress).filter(
            DailyProgress.StudentID == student_id,
            DailyProgress.Date == date_
        ).first()
        if progress:
            progress.Overall = overall
            progress.Attendance = attendance
            progress.StudyOutcome = study_outcome
            progress.Reprimand = reprimand
            progress.TeacherID = teacher_id
        else:
            progress = DailyProgress(
                StudentID=student_id,
                TeacherID=teacher_id,
                Date=date_,
                Overall=overall,
                Attendance=attendance,
                StudyOutcome=study_outcome,
                Reprimand=reprimand
            )
            db.add(progress)
        db.commit()
        db.refresh(progress)
        return progress

    @staticmethod
    def get_students_by_teacher(db: Session, teacher_id: int) -> List[Student]:
        """Lấy danh sách học sinh của các lớp mà giáo viên là chủ nhiệm"""
        return db.query(Student).join(User).join(Class).filter(
            Class.HomeroomTeacherID == teacher_id
        ).options(
            joinedload(Student.user),
            joinedload(Student.class_)
        ).all()

    @staticmethod
    def get_children_of_parent(db: Session, parent_user_id: int):
        parent = db.query(User).filter(User.UserID == parent_user_id).first()
        if not parent or not hasattr(parent, 'parent'):
            return []
        children = []
        for ps in parent.parent.parent_students:
            student = ps.student
            if student:
                children.append(student)
        return children 