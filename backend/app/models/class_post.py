from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime

class ClassPost(Base):
    __tablename__ = "class_posts"

    PostID = Column(Integer, primary_key=True, index=True)
    Title = Column(String)
    Type = Column(String)  # Consider Enum if type has fixed values
    Content = Column(Text) # Using Text for potentially long content
    EventDate = Column(DateTime, nullable=True)
    CreatedAt = Column(DateTime, default=datetime.datetime.utcnow)
    
    TeacherID = Column(Integer, ForeignKey("teachers.TeacherID")) # Assuming teachers table and TeacherID PK
    ClassID = Column(Integer, ForeignKey("classes.ClassID"))     # Assuming classes table and ClassID PK

    # Relationships
    teacher = relationship("Teacher", back_populates="class_posts")
    class_ = relationship("Class", back_populates="class_posts") # Assuming Class model name is 'Class'
    post_files = relationship("PostFile", back_populates="class_post", cascade="all, delete-orphan")

# Add back_populates to Teacher and Class models later
# Teacher model: class_posts = relationship("ClassPost", back_populates="teacher")
# Class model: class_posts = relationship("ClassPost", back_populates="class_") 