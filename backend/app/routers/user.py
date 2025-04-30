from fastapi import APIRouter, Depends, HTTPException, status, Header
from sqlalchemy.orm import Session
from typing import List, Optional
from ..database import get_db
from ..schemas.user import User, UserCreate, UserUpdate, UserLogin, Token
from ..services import user_service

router = APIRouter(
    prefix="/users",
    tags=["users"]
)

@router.post("/register", response_model=User)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    return user_service.create_user(db, user)

@router.post("/login", response_model=Token)
async def login(user_data: UserLogin, db: Session = Depends(get_db)):
    user = user_service.login_user(db, user_data.email, user_data.password)
    access_token = user_service.create_access_token(data={"sub": user.Email})
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/logout")
async def logout(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid token")
    
    # Trong trường hợp sử dụng JWT đơn giản, chúng ta chỉ cần trả về thông báo thành công
    # Token sẽ được xóa ở phía client
    return {"message": "Successfully logged out"}

@router.get("/me", response_model=User)
async def get_current_user(
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid token")
    
    token = authorization.split(" ")[1]
    user = user_service.get_current_user(token, db)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    return user

@router.get("/", response_model=List[User])
def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return user_service.get_users(db, skip, limit)

@router.get("/{user_id}", response_model=User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = user_service.get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user

@router.put("/{user_id}", response_model=User)
def update_user(user_id: int, user: UserUpdate, db: Session = Depends(get_db)):
    return user_service.update_user(db, user_id, user)

@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    return user_service.delete_user(db, user_id) 