from pydantic import BaseModel

class ParentStudentLink(BaseModel):
    parent_user_id: int

class ParentBasicInfo(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: str

    model_config = {"from_attributes": True}

class StudentBasicInfo(BaseModel):
    UserID: int
    FirstName: str
    LastName: str
    Email: str
    # Optionally add class name/ID
    ClassName: str | None = None

    model_config = {"from_attributes": True} 