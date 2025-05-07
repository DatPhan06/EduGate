from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime

class PostFile(Base):
    __tablename__ = "post_files"

    FileID = Column(Integer, primary_key=True, index=True)
    FileName = Column(String)
    FilePath = Column(String)
    FileSize = Column(Integer)
    ContentType = Column(String)
    SubmittedAt = Column(DateTime, default=datetime.datetime.utcnow)
    PostID = Column(Integer, ForeignKey("class_posts.PostID"))

    # Relationship
    class_post = relationship("ClassPost", back_populates="post_files") 