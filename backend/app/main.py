from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from .database import get_db
from .models import *
from .config import settings
from .routers import auth, user, reward_punishment, petition, message
from .routers import classes_router, students_router, teachers_router, admin_conversation_router
from .routers import departments_router, subjects_router, timetable_router
from .routers import parent_student_router, class_post_router
from .routers import grade_router, class_subjects_router, event_router
from .database import engine, Base
from fastapi.staticfiles import StaticFiles
import os

# Tạo bảng trong database
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.PROJECT_VERSION
)

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=["*"],
)

# Mount static files for /public
app.mount(
    "/public",
    StaticFiles(directory=os.path.join(os.path.dirname(__file__), "../public")),
    name="public"
)

# Create upload directory if it doesn't exist
os.makedirs(os.path.join(os.path.dirname(__file__), "../uploads/events"), exist_ok=True)

@app.get("/")
async def root():
    return {"message": "Welcome to EduGate API"}

# Include routers
app.include_router(auth.router)
app.include_router(user.router)
app.include_router(reward_punishment.router) 
app.include_router(petition.router)
app.include_router(message.router)
# app.include_router(class_management.router) # Comment out or remove if not used/replaced

# Add new routers
app.include_router(classes_router.router)
app.include_router(students_router.router)
app.include_router(teachers_router.router)
app.include_router(departments_router.router)
app.include_router(parent_student_router.router)
app.include_router(admin_conversation_router.router)
app.include_router(class_post_router.router)

# Add timetable management routers
app.include_router(subjects_router.router)
app.include_router(timetable_router.router)
app.include_router(class_subjects_router.router)

# Add grade management router
app.include_router(grade_router.router)

# Add event management router
app.include_router(event_router.router)
