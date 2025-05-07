from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..base import Base
import datetime

class PetitionFile(Base):
    __tablename__ = "petition_files"

    FileID = Column(Integer, primary_key=True, index=True)
    FileName = Column(String)
    FilePath = Column(String)
    FileSize = Column(Integer)
    ContentType = Column(String)
    SubmittedAt = Column(DateTime, default=datetime.datetime.utcnow)
    PetitionID = Column(Integer, ForeignKey("petitions.PetitionID"))

    # Relationship
    petition = relationship("Petition", back_populates="petition_files") 