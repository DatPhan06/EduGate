import os
import shutil
import uuid
from fastapi import UploadFile, HTTPException, status

def save_file(file: UploadFile, directory: str) -> str:
    """
    Save an uploaded file to the specified directory.
    
    Args:
        file: The uploaded file
        directory: The directory to save the file in
        
    Returns:
        The path to the saved file
    """
    # Create directory if it doesn't exist
    os.makedirs(directory, exist_ok=True)
    
    # Generate a unique filename to avoid collisions
    unique_filename = f"{uuid.uuid4()}_{file.filename}"
    file_path = os.path.join(directory, unique_filename)
    
    # Save the file
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return file_path
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error saving file: {str(e)}"
        )
        
def delete_file(file_path: str) -> bool:
    """
    Delete a file from the filesystem.
    
    Args:
        file_path: The path to the file to delete
        
    Returns:
        True if the file was deleted, False otherwise
    """
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
            return True
        return False
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting file: {str(e)}"
        )
        
def get_file_size(file_path: str) -> int:
    """
    Get the size of a file in bytes.
    
    Args:
        file_path: The path to the file
        
    Returns:
        The size of the file in bytes
    """
    try:
        return os.path.getsize(file_path)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error getting file size: {str(e)}"
        ) 