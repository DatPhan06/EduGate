from pydantic import BaseModel
from typing import Optional

# Schema for reading/returning teacher information
class TeacherRead(BaseModel):
    id: int # Maps to User.UserID / Teacher.TeacherID
    name: str # Concatenation of User.FirstName and User.LastName
    specialization: Optional[str] = None # Derived from Teacher.Degree or other relevant field

    model_config = {
        "from_attributes": True # Allow ORM mode
    } 