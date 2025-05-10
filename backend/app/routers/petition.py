from fastapi import APIRouter, Depends, HTTPException, Query, status, Header
from sqlalchemy.orm import Session
from ..database import get_db
from ..services import petition_service, auth_service, user_service
from ..models import Petition, User, Parent
from ..models.petition import PetitionStatus
from ..enums.user_enums import UserRole
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel
from ..schemas.user import User
from ..schemas.petition import (
    PetitionCreate,
    PetitionUpdate,
    PetitionResponse,
    PetitionListResponse,
    PetitionStatisticsResponse
)

router = APIRouter(prefix="/petitions", tags=["petitions"])

# Dependency for authorization
async def get_current_active_user(
    authorization: str = Header(None),
    db: Session = Depends(get_db)
) -> User:
    """
    Lấy thông tin user hiện tại từ token
    """
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token"
        )
    
    token = authorization.split(" ")[1]
    try:
        email = auth_service.get_current_user_email(token)
        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )
        
        user = user_service.get_user_by_email(db, email)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return user
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )

async def check_admin(current_user: Optional[User] = Depends(get_current_active_user), 
                     db: Session = Depends(get_db)):
    """
    Kiểm tra xem user hiện tại có quyền admin không
    """
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
        )
    
    print(f"Checking admin role. Current user role: {current_user.role}")
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Operation not permitted. Requires Admin role.",
        )
    return current_user

async def check_parent(current_user: Optional[User] = Depends(get_current_active_user), 
                      db: Session = Depends(get_db)):
    """
    Kiểm tra xem user hiện tại có quyền parent không
    """
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
        )
    
    print(f"Checking parent role. Current user role: {current_user.role}")
    
    if current_user.role != UserRole.PARENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Operation not permitted. Requires Parent role.",
        )
    return current_user

@router.get("/parent/{parent_id}", response_model=PetitionListResponse)
async def get_petitions_by_parent(
    parent_id: int,
    page: int = Query(1, ge=1, description="Page number, starting from 1"),
    size: int = Query(10, ge=1, le=100, description="Number of items per page"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Retrieve list of petitions for a specific parent.

    Args:
        parent_id: ID of the parent
        page: Page number (default: 1)
        size: Number of items per page (default: 10, max: 100)
        db: Database session
        current_user: Currently authenticated user

    Raises:
        HTTPException: 
            - 403 if user is not authorized
            - 400 if parent is not found
            - 500 for internal server errors

    Returns:
        PetitionListResponse: List of petitions with pagination info
    """
    # Check authorization
    if current_user.role != UserRole.ADMIN and current_user.UserID != parent_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to view these petitions"
        )

    try:
        # Get petitions and total count
        petitions, total = petition_service.PetitionService.get_petitions_by_parent(
            db=db,
            parent_id=parent_id,
            page=page,
            size=size
        )

        # Map petitions to response schema
        petition_responses = [
            PetitionResponse(
                PetitionID=p.PetitionID,
                ParentID=p.ParentID,
                Title=p.Title,
                Content=p.Content,
                Status=p.Status,
                SubmittedAt=p.SubmittedAt,
                AdminID=p.AdminID,
                Response=p.Response,
                parent=User.from_orm(p.parent.user)
            ) for p in petitions if p.parent and p.parent.user
        ]

        return PetitionListResponse(
            items=petition_responses,
            total=total,
            page=page,
            size=size
        )

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve petitions: {str(e)}"
        )

@router.get("/", response_model=PetitionListResponse)
async def get_petitions(
    status: Optional[str] = Query(None, description="Filter by petition status"),
    parent_id: Optional[int] = Query(None, description="Filter by parent ID"),
    start_date: Optional[datetime] = Query(None, description="Filter by start date"),
    end_date: Optional[datetime] = Query(None, description="Filter by end date"),
    page: int = Query(1, ge=1, description="Page number, starting from 1"),
    size: int = Query(10, ge=1, le=100, description="Number of items per page"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Retrieve list of petitions with optional filters (ADMIN only).

    Args:
        status: Filter by petition status (e.g., PENDING, APPROVED)
        parent_id: Filter by parent ID
        start_date: Filter petitions submitted on or after this date
        end_date: Filter petitions submitted on or before this date
        page: Page number (default: 1)
        size: Number of items per page (default: 10, max: 100)
        db: Database session
        current_user: Currently authenticated user

    Raises:
        HTTPException:
            - 403 if user is not an ADMIN
            - 400 for invalid filter parameters
            - 500 for internal server errors

    Returns:
        PetitionListResponse: List of petitions with pagination info
    """
    # Check if user is ADMIN
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only ADMIN can access this endpoint"
        )

    try:
        # Get petitions and total count
        petitions, total = petition_service.PetitionService.get_all_petitions(
            db=db,
            status=status,
            parent_id=parent_id,
            start_date=start_date,
            end_date=end_date,
            page=page,
            size=size
        )

        # Map petitions to PetitionResponse
        petition_responses = [
            PetitionResponse(
                PetitionID=p.PetitionID,
                ParentID=p.ParentID,
                Title=p.Title,
                Content=p.Content,
                Status=p.Status,
                SubmittedAt=p.SubmittedAt,
                AdminID=p.AdminID,
                Response=p.Response,
                parent=User.from_orm(p.parent.user)
            ) for p in petitions if p.parent and p.parent.user
        ]

        return PetitionListResponse(
            items=petition_responses,
            total=total,
            page=page,
            size=size
        )

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve petitions: {str(e)}"
        )

@router.get("/{petition_id}", response_model=PetitionResponse)
async def get_petition(
    petition_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Retrieve detailed information of a specific petition.

    Args:
        petition_id: ID of the petition
        db: Database session
        current_user: Currently authenticated user

    Raises:
        HTTPException:
            - 403 if user is not authorized (not admin or petition owner)
            - 404 if petition is not found
            - 400 for invalid parameters
            - 500 for internal server errors

    Returns:
        PetitionResponse: Detailed information of the petition
    """
    try:
        petition = petition_service.PetitionService.get_petition_by_id(db, petition_id)
        if not petition:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Petition not found")

        # Check authorization: only petition owner or admin
        if current_user.role != UserRole.ADMIN and petition.ParentID != current_user.UserID:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not authorized to view this petition"
            )

        # Map to PetitionResponse
        if not petition.parent or not petition.parent.user:
            raise ValueError("Parent or user information not found for this petition")

        return PetitionResponse(
            PetitionID=petition.PetitionID,
            ParentID=petition.ParentID,
            Title=petition.Title,
            Content=petition.Content,
            Status=petition.Status,
            SubmittedAt=petition.SubmittedAt,
            AdminID=petition.AdminID,
            Response=petition.Response,
            parent=User.from_orm(petition.parent.user)
        )

    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve petition: {str(e)}"
        )

@router.post("/", response_model=PetitionResponse)
async def create_petition(
    petition: PetitionCreate,
    current_user: User = Depends(check_parent),
    db: Session = Depends(get_db)
):
    """
    Tạo một đơn thỉnh cầu mới
    """
    try:
        # Lấy parent từ relationship của user
        if not current_user.parent:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Parent profile not found. Please complete your parent profile first."
            )

        # Tạo petition với ParentID
        db_petition = petition_service.PetitionService.create_petition(
            db=db,
            petition=petition,
            parent_id=current_user.parent.ParentID
        )
        
        # Tạo response object
        response = PetitionResponse(
            PetitionID=db_petition.PetitionID,
            ParentID=db_petition.ParentID,
            Title=db_petition.Title,
            Content=db_petition.Content,
            Status=db_petition.Status,
            SubmittedAt=db_petition.SubmittedAt,
            AdminID=db_petition.AdminID,
            Response=db_petition.Response,
            parent=current_user
        )
        
        return response
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )

@router.put("/{petition_id}", response_model=PetitionResponse)
async def update_petition_status(
    petition_id: int,
    update: PetitionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Update the status of a petition (ADMIN only).

    Args:
        petition_id: ID of the petition to update
        update: Petition update data (status and optional response)
        db: Database session
        current_user: Currently authenticated user

    Raises:
        HTTPException:
            - 403 if user is not an ADMIN
            - 404 if petition is not found
            - 400 for invalid update parameters
            - 500 for internal server errors

    Returns:
        PetitionResponse: Updated petition details
    """
    # Check if user is ADMIN
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only ADMIN can update petitions"
        )

    try:
        petition = petition_service.PetitionService.update_petition_status(
            db=db,
            petition_id=petition_id,
            update=update,
            admin_id=current_user.UserID
        )
        if not petition:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Petition not found")

        # Map to PetitionResponse
        if not petition.parent or not petition.parent.user:
            raise ValueError("Parent or user information not found for this petition")

        return PetitionResponse(
            PetitionID=petition.PetitionID,
            ParentID=petition.ParentID,
            Title=petition.Title,
            Content=petition.Content,
            Status=petition.Status,
            SubmittedAt=petition.SubmittedAt,
            AdminID=petition.AdminID,
            Response=petition.Response,
            parent=User.from_orm(petition.parent.user)
        )

    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Could not update petition: {str(e)}"
        )

@router.get("/statistics/", response_model=PetitionStatisticsResponse)
async def get_petition_statistics(
    start_date: Optional[datetime] = None,
    end_date: Optional[datetime] = None,
    db: Session = Depends(get_db),
    current_user: User= Depends(get_current_active_user)
):
    """
    Retrieve statistics of petitions by status (ADMIN only).

    Args:
        start_date: Start date for filtering petitions (optional)
        end_date: End date for filtering petitions (optional)
        db: Database session
        current_user: Currently authenticated user

    Raises:
        HTTPException:
            - 403 if user is not an ADMIN
            - 400 for invalid date range (e.g., start_date > end_date)
            - 500 for internal server errors

    Returns:
        PetitionStatisticsResponse: Dictionary with count of petitions by status
    """
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only ADMIN can access statistics"
        )

    if start_date and end_date and start_date > end_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="start_date cannot be later than end_date"
        )

    try:
        stats = petition_service.PetitionService.get_petition_statistics(
            db=db,
            start_date=start_date,
            end_date=end_date
        )
        return stats
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve statistics: {str(e)}"
        )