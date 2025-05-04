# EduGate - Hệ thống Thông tin Liên lạc Giáo dục

EduGate là một hệ thống thông tin liên lạc toàn diện giữa Nhà trường, Phụ huynh và Học sinh, giúp tăng cường kết nối và quản lý thông tin trong môi trường giáo dục phổ thông.

## 🚀 Tính năng chính

### Quản lý người dùng và phân quyền
- Đăng ký và đăng nhập với xác thực JWT
- Phân quyền chi tiết cho từng đối tượng:
  - Ban giám hiệu
  - Giáo viên
  - Nhân viên văn phòng
  - Phụ huynh
  - Học sinh
- Quản lý thông tin cá nhân
- Đổi mật khẩu an toàn

### Hệ thống tin nhắn
- Gửi/nhận tin nhắn giữa các đối tượng:
  - Nhà trường → Phụ huynh/Học sinh
  - Giáo viên → Phụ huynh/Học sinh
  - Phụ huynh → Giáo viên/Nhà trường
  - Học sinh → Giáo viên
- Phân loại tin nhắn theo mức độ ưu tiên
- Đính kèm file trong tin nhắn
- Thông báo đã đọc/chưa đọc
- Lưu trữ lịch sử tin nhắn

### Quản lý thông báo
- Đăng thông báo đa dạng:
  - Lịch học, thi cử
  - Thời khóa biểu
  - Hoạt động ngoại khóa
  - Khen thưởng/Kỷ luật
  - Sự kiện trường
- Phân loại thông báo theo mức độ quan trọng
- Gửi thông báo đến nhóm đối tượng cụ thể
- Xác nhận đã đọc thông báo
- Lịch sử thông báo

### Quản lý đơn từ và kiến nghị
- Phụ huynh gửi đơn từ:
  - Xin nghỉ học
  - Xin chuyển lớp
  - Đề xuất ý kiến
  - Khiếu nại
- Theo dõi trạng thái đơn:
  - Đã gửi
  - Đang xử lý
  - Đã phê duyệt
  - Từ chối
- Phản hồi từ nhà trường
- Lưu trữ lịch sử đơn từ

### Quản lý thành tích và kỷ luật
- Ghi nhận thành tích:
  - Học tập
  - Thể thao
  - Văn nghệ
  - Hoạt động xã hội
- Quản lý kỷ luật:
  - Cảnh cáo
  - Khiển trách
  - Hạ hạnh kiểm
- Thống kê và báo cáo:
  - Bảng điểm
  - Xếp loại học lực
  - Xếp loại hạnh kiểm
  - Tổng kết năm học

### Quản lý điểm và kết quả học tập
- Giáo viên nhập điểm:
  - Điểm miệng
  - Điểm 15 phút
  - Điểm 1 tiết
  - Điểm học kỳ
- Tính điểm trung bình tự động
- Xếp loại học lực
- Báo cáo kết quả học tập:
  - Theo môn
  - Theo học kỳ
  - Theo năm học
- Thống kê và biểu đồ tiến độ học tập

## 🛠 Công nghệ sử dụng

### Frontend
- React.js
- Material-UI
- Redux Toolkit
- Axios
- React Router
- JWT Authentication

### Backend
- Python
- FastAPI
- SQLAlchemy
- PostgreSQL
- JWT Authentication
- Pydantic

## 📁 Cấu trúc dự án

### Frontend (`/frontend`)
```
frontend/
├── public/                 # Static files
│   ├── index.html
│   └── assets/            # Images, fonts, etc.
├── src/
│   ├── components/        # Reusable components
│   │   ├── common/       # Common components (Button, Input, etc.)
│   │   ├── layout/       # Layout components (Header, Sidebar, etc.)
│   │   └── forms/        # Form components
│   ├── pages/            # Page components
│   │   ├── Auth/         # Authentication pages
│   │   │   ├── Login.js
│   │   │   └── Register.js
│   │   ├── Students/     # Student management pages
│   │   ├── Teachers/     # Teacher management pages
│   │   ├── Classes/      # Class management pages
│   │   ├── Subjects/     # Subject management pages
│   │   └── Users/        # User management pages
│   │       └── UserProfile.js
│   ├── services/         # API services
│   │   ├── authService.js
│   │   ├── userService.js
│   │   ├── studentService.js
│   │   ├── teacherService.js
│   │   ├── classService.js
│   │   └── subjectService.js
│   ├── store/            # Redux store
│   │   ├── slices/       # Redux slices
│   │   └── store.js
│   ├── routes/           # Route configurations
│   ├── App.js            # Main App component
│   └── index.js          # Entry point
├── package.json
└── .env                  # Environment variables
```

### Backend (`/backend`)
```
backend/
├── app/
│   ├── api/              # API endpoints
│   │   ├── v1/          # API version 1
│   │   │   ├── auth.py
│   │   │   ├── users.py
│   │   │   ├── students.py
│   │   │   ├── teachers.py
│   │   │   ├── classes.py
│   │   │   └── subjects.py
│   ├── core/            # Core functionality
│   │   ├── config.py    # Configuration
│   │   ├── security.py  # Security utilities
│   │   └── database.py  # Database connection
│   ├── models/          # Database models
│   │   ├── user.py
│   │   ├── student.py
│   │   ├── teacher.py
│   │   ├── class.py
│   │   └── subject.py
│   ├── schemas/         # Pydantic schemas
│   │   ├── user.py
│   │   ├── student.py
│   │   ├── teacher.py
│   │   ├── class.py
│   │   └── subject.py
│   └── services/        # Business logic
│       ├── auth.py
│       ├── user.py
│       ├── student.py
│       ├── teacher.py
│       ├── class.py
│       └── subject.py
├── tests/               # Test files
├── main.py             # Application entry point
├── requirements.txt    # Python dependencies
└── .env               # Environment variables
```


## 📦 Cài đặt và chạy

### Yêu cầu hệ thống
- Node.js >= 14.x
- Python >= 3.8
- PostgreSQL >= 12.x

### Cài đặt Frontend
```bash
cd frontend
npm install
npm start
```

### Cài đặt Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Trên Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```