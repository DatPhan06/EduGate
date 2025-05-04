from sqlalchemy.orm import Session, joinedload
from ..models import Petition, User, Parent
from ..models.petition import PetitionStatus
from ..schemas.petition import PetitionCreate, PetitionUpdate
from typing import List, Optional
from datetime import datetime
from sqlalchemy import func
import logging

# Thiết lập logging để debug
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

class PetitionService:
    @staticmethod
    def get_petitions_by_parent(
        db: Session,
        parent_id: int,
        page: int = 1,
        size: int = 10
    ) -> tuple[List[Petition], int]:
        """
        Lấy danh sách đơn thỉnh cầu của một phụ huynh cụ thể
        
        Args:
            db (Session): Database session
            parent_id (int): ID của phụ huynh
            page (int): Số trang (mặc định là 1)
            size (int): Số lượng đơn trên mỗi trang (mặc định là 10)
            
        Returns:
            tuple[List[Petition], int]: Danh sách đơn và tổng số đơn
        """
        # Kiểm tra sự tồn tại của parent
        parent = db.query(Parent).filter(Parent.ParentID == parent_id).first()
        if not parent:
            raise ValueError(f"Parent with ID {parent_id} not found")

        # Eager load relationship parent và parent.user
        query = db.query(Petition).options(
            joinedload(Petition.parent).joinedload(Parent.user)
        ).filter(Petition.ParentID == parent_id)
        total = query.count()
        petitions = query.offset((page - 1) * size).limit(size).all()
        return petitions, total

    @staticmethod
    def get_all_petitions(
        db: Session,
        status: Optional[PetitionStatus] = None,
        parent_id: Optional[int] = None,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None,
        page: int = 1,
        size: int = 10
    ) -> tuple[List[Petition], int]:
        """
        Lấy tất cả đơn thỉnh cầu với các bộ lọc tùy chọn
        
        Args:
            db (Session): Database session
            status (Optional[PetitionStatus]): Lọc theo trạng thái đơn
            parent_id (Optional[int]): Lọc theo ID phụ huynh
            start_date (Optional[datetime]): Lọc theo ngày bắt đầu
            end_date (Optional[datetime]): Lọc theo ngày kết thúc
            page (int): Số trang (mặc định là 1)
            size (int): Số lượng đơn trên mỗi trang (mặc định là 10)
            
        Returns:
            tuple[List[Petition], int]: Danh sách đơn và tổng số đơn
        """
        query = db.query(Petition).options(
            joinedload(Petition.parent).joinedload(Parent.user)
        )
        
        if status:
            query = query.filter(Petition.Status == status)
        if parent_id:
            query = query.filter(Petition.ParentID == parent_id)
        if start_date:
            query = query.filter(Petition.SubmittedAt >= start_date)
        if end_date:
            query = query.filter(Petition.SubmittedAt <= end_date)
            
        total = query.count()
        petitions = query.offset((page - 1) * size).limit(size).all()
        return petitions, total

    @staticmethod
    def get_petition_by_id(db: Session, petition_id: int) -> Optional[Petition]:
        """
        Lấy thông tin chi tiết của một đơn thỉnh cầu theo ID
        
        Args:
            db (Session): Database session
            petition_id (int): ID của đơn thỉnh cầu
            
        Returns:
            Optional[Petition]: Đơn thỉnh cầu nếu tìm thấy, None nếu không tìm thấy
        """
        return db.query(Petition).options(
            joinedload(Petition.parent).joinedload(Parent.user)
        ).filter(Petition.PetitionID == petition_id).first()

    @staticmethod
    def create_petition(
        db: Session,
        petition: PetitionCreate,
        parent_id: int
    ) -> Petition:
        """
        Tạo một đơn thỉnh cầu mới
        """
        try:
            # Kiểm tra parent có tồn tại không
            parent = db.query(Parent).filter(Parent.ParentID == parent_id).first()
            if not parent:
                raise ValueError(f"Parent with ID {parent_id} not found")

            db_petition = Petition(
                ParentID=parent_id,
                Title=petition.Title,
                Content=petition.Content,
                Status=PetitionStatus.PENDING,
                SubmittedAt=datetime.utcnow()
            )
            db.add(db_petition)
            db.commit()
            db.refresh(db_petition)
            return db_petition
        except Exception as e:
            db.rollback()
            raise e

    @staticmethod
    def update_petition_status(
        db: Session,
        petition_id: int,
        update: PetitionUpdate,
        admin_id: int
    ) -> Optional[Petition]:
        """
        Cập nhật trạng thái và thông tin của một đơn thỉnh cầu
        
        Args:
            db (Session): Database session
            petition_id (int): ID của đơn thỉnh cầu cần cập nhật
            update (PetitionUpdate): Thông tin cập nhật
            admin_id (int): ID của người quản lý
            
        Returns:
            Optional[Petition]: Đơn thỉnh cầu đã được cập nhật nếu tìm thấy, None nếu không tìm thấy
        """
        petition = db.query(Petition).options(
            joinedload(Petition.parent).joinedload(Parent.user)
        ).filter(Petition.PetitionID == petition_id).first()
        
        if not petition:
            return None
            
        petition.Status = update.Status
        petition.AdminID = admin_id
        petition.Notes = update.Notes
        db.commit()
        db.refresh(petition)
        return petition

    @staticmethod
    def get_petition_statistics(
        db: Session,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None
    ) -> dict:
        """
        Retrieve statistics of petitions by status.

        Args:
            db (Session): Database session
            start_date (Optional[datetime]): Start date for filtering
            end_date (Optional[datetime]): End date for filtering

        Returns:
            dict: Dictionary with count of petitions by status (PENDING, APPROVED, REJECTED)
        """
        logger.debug(f"Querying petition statistics with start_date={start_date}, end_date={end_date}")

        query = db.query(
            Petition.Status,
            func.count(Petition.PetitionID).label('count')
        ).group_by(Petition.Status)

        if start_date:
            logger.debug(f"Filtering SubmittedAt >= {start_date}")
            query = query.filter(Petition.SubmittedAt >= start_date)
        if end_date:
            logger.debug(f"Filtering SubmittedAt <= {end_date}")
            query = query.filter(Petition.SubmittedAt <= end_date)

        results = query.all()
        logger.debug(f"Query results: {results}")

        # Initialize counts for all statuses using string keys
        stats = {
            "PENDING": 0,
            "APPROVED": 0,
            "REJECTED": 0
        }

        # Update counts from query results
        for status, count in results:
            status_str = status.value  # Lấy giá trị chuỗi của enum
            if status_str in stats:
                stats[status_str] = count
            else:
                logger.warning(f"Unexpected status: {status_str}")

        logger.debug(f"Final stats: {stats}")
        return stats