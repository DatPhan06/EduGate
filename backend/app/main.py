from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import *
import os
from dotenv import load_dotenv

# Load biến môi trường từ file .env
load_dotenv()

app = FastAPI(title="Flight Booking System")

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép tất cả các origin trong môi trường development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Bao gồm các router
# app.include_router(flights_router)
# app.include_router(bookings_router)
# app.include_router(users_router)
# app.include_router(login_auth_router)
# app.include_router(general_info_router)
# app.include_router(airports_router)
# app.include_router(seats_router)
# app.include_router(news_router)
# app.include_router(notification_router)
# app.include_router(promotion_router)
# app.include_router(tickets_router)
# app.include_router(flight_log_router)
# app.include_router(admin_router)
# app.include_router(airplane_router)
# app.include_router(location_router) 
# app.include_router(chat_router)


@app.get("/")
async def root():
    return {"message": "Hello World"}