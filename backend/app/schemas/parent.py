from pydantic import BaseModel
from typing import Optional

class ParentBase(BaseModel):
    Occupation: str

class ParentCreate(ParentBase):
    pass

class ParentUpdate(ParentBase):
    Occupation: Optional[str] = None

class ParentInDB(ParentBase):
    ParentID: int

    model_config = {
        "from_attributes": True
    }