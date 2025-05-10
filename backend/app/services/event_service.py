from sqlalchemy.orm import Session
from fastapi import HTTPException, UploadFile, status
from typing import List, Optional
from datetime import datetime
import os
import uuid
import shutil

from ..models.event import Event
from ..models.event_file import EventFile
from ..schemas.event_schema import EventCreate, EventUpdate, EventSchema
from ..utils.file_utils import save_file, delete_file

# Constants
UPLOAD_DIR = "uploads/events"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# Create a new event
def create_event(db: Session, event_data: EventCreate, admin_id: int) -> Event:
    try:
        db_event = Event(
            Title=event_data.Title,
            Type=event_data.Type,
            Content=event_data.Content,
            EventDate=event_data.EventDate,
            AdminID=admin_id
        )
        db.add(db_event)
        db.commit()
        db.refresh(db_event)
        return db_event
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error creating event: {str(e)}")

# Get all events with optional filtering
def get_events(db: Session, skip: int = 0, limit: int = 100, 
               event_type: Optional[str] = None, 
               start_date: Optional[datetime] = None,
               end_date: Optional[datetime] = None) -> List[Event]:
    try:
        query = db.query(Event)
        
        # Apply filters if provided
        if event_type:
            query = query.filter(Event.Type == event_type)
        if start_date:
            query = query.filter(Event.EventDate >= start_date)
        if end_date:
            query = query.filter(Event.EventDate <= end_date)
            
        # Order by event date (newest first)
        query = query.order_by(Event.EventDate.desc())
        
        # Apply pagination
        events = query.offset(skip).limit(limit).all()
        return events
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error fetching events: {str(e)}")

# Get a specific event by ID
def get_event_by_id(db: Session, event_id: int) -> Event:
    event = db.query(Event).filter(Event.EventID == event_id).first()
    if not event:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Event with ID {event_id} not found")
    return event

# Update an existing event
def update_event(db: Session, event_id: int, event_data: EventUpdate) -> Event:
    try:
        db_event = get_event_by_id(db, event_id)
        
        # Update event fields if provided in the request
        update_data = event_data.dict(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_event, field, value)
            
        db.commit()
        db.refresh(db_event)
        return db_event
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error updating event: {str(e)}")

# Delete an event and its associated files
def delete_event(db: Session, event_id: int) -> bool:
    try:
        event = get_event_by_id(db, event_id)
        
        # Delete associated files from storage
        for event_file in event.event_files:
            try:
                delete_file(event_file.FilePath)
            except Exception as e:
                print(f"Warning: Error deleting file {event_file.FilePath}: {str(e)}")
                
        # Delete the event from the database (cascade will delete event_files records)
        db.delete(event)
        db.commit()
        return True
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error deleting event: {str(e)}")

# Add a file to an event
def add_event_file(db: Session, event_id: int, file: UploadFile) -> EventFile:
    file_path = None
    try:
        # Verify event exists
        event = get_event_by_id(db, event_id)
        
        # Save file to storage
        file_type = file.content_type
        unique_filename = f"{uuid.uuid4()}_{file.filename}"
        file_path = f"{UPLOAD_DIR}/{unique_filename}"
        
        # Save the file to the specified path
        with open(file_path, "wb") as buffer:
            content = file.file.read()
            buffer.write(content)
            file_size = len(content)
            
        # Create file record in database
        db_file = EventFile(
            EventID=event_id,
            FileName=file.filename,
            FilePath=file_path,
            FileSize=file_size,
            ContentType=file_type
        )
        
        db.add(db_file)
        db.commit()
        db.refresh(db_file)
        return db_file
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        if file_path and os.path.exists(file_path):
            os.remove(file_path)
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error adding file to event: {str(e)}")

# Delete a file from an event
def delete_event_file(db: Session, file_id: int) -> bool:
    try:
        # Find the file record
        file_record = db.query(EventFile).filter(EventFile.FileID == file_id).first()
        if not file_record:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"File with ID {file_id} not found")
            
        # Delete file from storage
        try:
            delete_file(file_record.FilePath)
        except Exception as e:
            print(f"Warning: Error deleting file {file_record.FilePath}: {str(e)}")
            
        # Delete file record from database
        db.delete(file_record)
        db.commit()
        return True
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=f"Error deleting file: {str(e)}")

# Get all files for an event
def get_event_files(db: Session, event_id: int) -> List[EventFile]:
    # Verify event exists
    event = get_event_by_id(db, event_id)
    return event.event_files

# Get a specific file by ID
def get_event_file_by_id(db: Session, file_id: int) -> EventFile:
    file = db.query(EventFile).filter(EventFile.FileID == file_id).first()
    if not file:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"File with ID {file_id} not found")
    return file

# Download a file
def download_event_file(db: Session, file_id: int):
    try:
        # Get file record
        file_record = get_event_file_by_id(db, file_id)
        
        # Check if file exists on disk
        if not os.path.exists(file_record.FilePath):
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, 
                detail=f"File not found on server"
            )
            
        return {
            "file_path": file_record.FilePath,
            "file_name": file_record.FileName,
            "content_type": file_record.ContentType
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail=f"Error downloading file: {str(e)}"
        ) 