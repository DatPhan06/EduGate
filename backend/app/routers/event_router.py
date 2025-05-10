from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime

from ..database import get_db
from ..models.event import Event
from ..models.event_file import EventFile
from ..schemas.event_schema import EventCreate, EventUpdate, EventSchema, EventListSchema, EventFileSchema, EventWithFilesSchema
from ..services import event_service
from ..services.auth_service import get_current_admin_staff

router = APIRouter(prefix="/events", tags=["events"])

# Create a new event
@router.post("/", response_model=EventSchema, status_code=status.HTTP_201_CREATED)
async def create_event(
    event_data: EventCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(get_current_admin_staff)
):
    """
    Create a new event (requires admin permissions)
    """
    return event_service.create_event(db, event_data, current_admin.AdminID)

# Get all events with optional filtering
@router.get("/", response_model=EventListSchema)
async def get_events(
    skip: int = 0,
    limit: int = 100,
    event_type: Optional[str] = None,
    start_date: Optional[datetime] = Query(None),
    end_date: Optional[datetime] = Query(None),
    db: Session = Depends(get_db)
):
    """
    Get a list of events with optional filtering by type and date range
    """
    events = event_service.get_events(
        db, skip=skip, limit=limit, 
        event_type=event_type, 
        start_date=start_date,
        end_date=end_date
    )
    return {"data": events, "count": len(events), "skip": skip, "limit": limit}

# Get a specific event by ID with its files
@router.get("/{event_id}", response_model=EventWithFilesSchema)
async def get_event(event_id: int, db: Session = Depends(get_db)):
    """
    Get details of a specific event by ID including its attached files
    """
    return event_service.get_event_by_id(db, event_id)

# Update an existing event
@router.put("/{event_id}", response_model=EventSchema)
async def update_event(
    event_id: int,
    event_data: EventUpdate,
    db: Session = Depends(get_db),
    current_admin = Depends(get_current_admin_staff)
):
    """
    Update an existing event (requires admin permissions)
    """
    return event_service.update_event(db, event_id, event_data)

# Delete an event
@router.delete("/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_event(
    event_id: int,
    db: Session = Depends(get_db),
    current_admin = Depends(get_current_admin_staff)
):
    """
    Delete an event and all its associated files (requires admin permissions)
    """
    event_service.delete_event(db, event_id)
    return {"detail": "Event deleted successfully"}

# Add a file to an event
@router.post("/{event_id}/files", response_model=EventFileSchema)
async def add_file_to_event(
    event_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin = Depends(get_current_admin_staff)
):
    """
    Add a file attachment to an event (requires admin permissions)
    """
    return event_service.add_event_file(db, event_id, file)

# Get all files for an event
@router.get("/{event_id}/files", response_model=List[EventFileSchema])
async def get_event_files(event_id: int, db: Session = Depends(get_db)):
    """
    Get all files attached to a specific event
    """
    return event_service.get_event_files(db, event_id)

# Delete a file from an event
@router.delete("/{event_id}/files/{file_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_file_from_event(
    event_id: int,
    file_id: int,
    db: Session = Depends(get_db),
    current_admin = Depends(get_current_admin_staff)
):
    """
    Delete a file attachment from an event (requires admin permissions)
    """
    event_service.delete_event_file(db, file_id)
    return {"detail": "File deleted successfully"} 