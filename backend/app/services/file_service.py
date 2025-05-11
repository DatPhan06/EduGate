import os
from fastapi import HTTPException, status
from fastapi.responses import FileResponse, StreamingResponse
from typing import Optional
import mimetypes
import aiofiles

def stream_file(file_path: str, file_name: str = None):
    """
    Phục vụ file dưới dạng response để download.
    """
    if not os.path.exists(file_path):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="File not found"
        )
    
    # Xác định MIME type từ file
    content_type, _ = mimetypes.guess_type(file_path)
    if not content_type:
        content_type = "application/octet-stream"  # Default MIME type
    
    # Trả về file dưới dạng response
    return FileResponse(
        path=file_path,
        filename=file_name or os.path.basename(file_path),
        media_type=content_type
    )

async def save_uploaded_file(upload_file, destination_path: str) -> int:
    """
    Lưu file đã upload vào thư mục đích và trả về kích thước file.
    """
    # Đảm bảo thư mục tồn tại
    os.makedirs(os.path.dirname(destination_path), exist_ok=True)
    
    # Lưu file
    contents = await upload_file.read()
    async with aiofiles.open(destination_path, 'wb') as f:
        await f.write(contents)
    
    # Trả về kích thước file
    return os.path.getsize(destination_path) 