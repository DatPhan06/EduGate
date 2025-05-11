# EduGate

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![React](https://img.shields.io/badge/React-18.x-61DAFB)
![FastAPI](https://img.shields.io/badge/FastAPI-0.95.x-009688)
![License](https://img.shields.io/badge/license-MIT-green)

**Hệ thống Thông tin Liên lạc Giáo dục Toàn diện**  
*Comprehensive Educational Communication System*

</div>

## 📋 Tổng quan | Overview

EduGate là hệ thống quản lý thông tin giáo dục hiện đại, kết nối liền mạch giữa nhà trường, giáo viên, phụ huynh và học sinh. Nền tảng này tích hợp đầy đủ các chức năng thiết yếu để nâng cao hiệu quả quản lý, minh bạch hóa thông tin và tăng cường tương tác trong môi trường giáo dục.

*EduGate is a modern educational information management system that seamlessly connects schools, teachers, parents, and students. This platform integrates all essential functions to enhance management efficiency, information transparency, and interaction in the educational environment.*

## ✨ Tính năng chính | Key Features

### 🔐 Quản lý người dùng & Phân quyền | User Management & Access Control
- Hệ thống xác thực bảo mật với JWT
- Phân quyền chi tiết cho ban giám hiệu, giáo viên, nhân viên, phụ huynh và học sinh
- Quản lý thông tin cá nhân và đổi mật khẩu an toàn

### 📚 Quản lý học tập | Academic Management
- **Quản lý điểm số:** Nhập điểm, tính toán trung bình, xếp loại tự động
- **Báo cáo học tập:** Thống kê theo môn, học kỳ, năm học với biểu đồ trực quan
- **Theo dõi tiến độ:** Đánh giá phát triển năng lực học sinh qua thời gian

### 📝 Quản lý lớp học & Môn học | Class & Subject Management
- Phân công giáo viên chủ nhiệm và giáo viên bộ môn
- Quản lý thời khóa biểu, lịch thi và các hoạt động giáo dục
- Thống kê sĩ số, thành tích lớp học

### 💬 Hệ thống liên lạc | Communication System
- **Tin nhắn trực tiếp:** Giao tiếp giữa giáo viên, phụ huynh và học sinh
- **Thông báo nhà trường:** Chia sẻ thông tin sự kiện, lịch học, thi cử
- **Quản lý đơn từ:** Xin nghỉ phép, chuyển lớp, phản hồi ý kiến

### 📊 Thống kê & Báo cáo | Statistics & Reports
- Tổng hợp kết quả học tập theo lớp, khối, toàn trường
- Đánh giá rèn luyện, khen thưởng, kỷ luật
- Xuất báo cáo PDF, Excel cho phụ huynh và nhà quản lý

## 👥 Tính năng theo vai trò | Role-based Features

### 🏫 Ban giám hiệu | School Administrators
- Quản lý toàn diện hệ thống, phân quyền người dùng
- Phê duyệt và quản lý tài khoản giáo viên, nhân viên
- Xem thống kê, báo cáo tổng hợp toàn trường
- Quản lý thời khóa biểu, phân công giảng dạy
- Duyệt đơn từ, kiến nghị từ phụ huynh, học sinh
- Đăng thông báo quan trọng cho toàn trường
- Quản lý học tập: theo dõi kết quả, phân lớp, điều chỉnh môn học

### 👨‍🏫 Giáo viên | Teachers
- **Giáo viên chủ nhiệm:**
  - Quản lý thông tin học sinh trong lớp
  - Cập nhật điểm danh, hạnh kiểm
  - Gửi thông báo tới phụ huynh và học sinh
  - Tổng hợp kết quả học tập của lớp
  - Duyệt đơn xin phép nghỉ học
- **Giáo viên bộ môn:**
  - Nhập điểm thành phần, điểm kiểm tra
  - Quản lý bài tập, bài kiểm tra
  - Tạo báo cáo kết quả học tập theo môn
  - Ghi nhận thành tích, tiến bộ của học sinh

### 👨‍💼 Nhân viên văn phòng | Administrative Staff
- Quản lý hồ sơ học sinh, giáo viên
- Tiếp nhận và xử lý đơn từ
- Quản lý cơ sở vật chất, thiết bị dạy học
- Hỗ trợ quản lý thông báo, sự kiện trường
- Xuất báo cáo và thống kê theo yêu cầu
- Quản lý nội trú, bán trú (nếu có)

### 👨‍👩‍👧‍👦 Phụ huynh | Parents
- Theo dõi kết quả học tập của con em
- Nhận thông báo từ nhà trường, giáo viên
- Gửi tin nhắn trao đổi với giáo viên
- Nộp đơn xin phép, kiến nghị trực tuyến
- Đăng ký tham gia hoạt động trường
- Cập nhật thông tin liên lạc cá nhân
- Xem lịch học, thời khóa biểu của con

### 👨‍🎓 Học sinh | Students
- Xem điểm số, kết quả học tập cá nhân
- Xem thời khóa biểu, lịch thi
- Nhận thông báo từ trường, giáo viên
- Gửi tin nhắn cho giáo viên
- Xem bài tập, nộp bài tập trực tuyến
- Tham gia hoạt động trường qua đăng ký
- Gửi đơn từ, kiến nghị đến nhà trường

## 🛠️ Công nghệ sử dụng | Technology Stack

### Frontend
- **React.js:** Thư viện JavaScript xây dựng giao diện người dùng
- **Material-UI:** Framework UI cho thiết kế responsive, modern
- **Redux Toolkit:** Quản lý state ứng dụng
- **Axios:** Thực hiện HTTP requests
- **React Router:** Điều hướng ứng dụng
- **JWT Authentication:** Xác thực người dùng an toàn

### Backend
- **FastAPI:** Framework Python hiệu năng cao, dễ phát triển API
- **SQLAlchemy:** ORM cho tương tác cơ sở dữ liệu
- **PostgreSQL:** Hệ quản trị cơ sở dữ liệu quan hệ
- **Pydantic:** Validation dữ liệu
- **JWT Authentication:** Xác thực và phân quyền

## 🏗️ Kiến trúc dự án | Project Architecture

### Frontend Structure
```
frontend/
├── public/                 # Tài nguyên tĩnh
├── src/
│   ├── components/         # Components tái sử dụng
│   │   ├── common/         # Các components phổ biến
│   │   ├── layout/         # Components bố cục
│   │   └── forms/          # Components biểu mẫu
│   ├── pages/              # Các trang chức năng
│   ├── services/           # Dịch vụ API
│   ├── store/              # Redux store
│   ├── routes/             # Cấu hình định tuyến
│   ├── utils/              # Tiện ích
│   ├── App.js              # Component chính
│   └── index.js            # Điểm khởi đầu
└── package.json            # Cấu hình dependencies
```

### Backend Structure
```
backend/
├── app/
│   ├── routers/            # API endpoints
│   ├── models/             # Models cơ sở dữ liệu
│   ├── schemas/            # Pydantic schemas
│   ├── services/           # Logic nghiệp vụ
│   ├── database.py         # Kết nối cơ sở dữ liệu
│   └── main.py             # Điểm khởi đầu ứng dụng
├── tests/                  # Unit tests
└── requirements.txt        # Dependencies Python
```

## 🚀 Cài đặt và khởi chạy | Installation and Setup

### Yêu cầu hệ thống | Requirements
- Node.js >= 14.x
- Python >= 3.8
- PostgreSQL >= 12.x

### Frontend Setup
```bash
# Clone repository
git clone https://github.com/your-username/edugate.git
cd edugate/frontend

# Cài đặt dependencies
npm install

# Khởi chạy development server
npm start
```

### Backend Setup
```bash
# Di chuyển đến thư mục backend
cd ../backend

# Tạo môi trường ảo
python -m venv venv

# Kích hoạt môi trường ảo
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt

# Khởi chạy server
uvicorn app.main:app --reload
```

### Cấu hình cơ sở dữ liệu | Database Setup
```bash
# Đăng nhập vào PostgreSQL
psql -U postgres

# Tạo database
CREATE DATABASE edugate;

# Tạo người dùng (tùy chọn)
CREATE USER edugate_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE edugate TO edugate_user;
```

## 📝 Hướng dẫn đóng góp | Contribution Guidelines

1. Fork dự án
2. Tạo branch tính năng (`git checkout -b feature/amazing-feature`)
3. Commit thay đổi (`git commit -m 'Add amazing feature'`)
4. Push đến branch (`git push origin feature/amazing-feature`)
5. Mở Pull Request

## 📄 Giấy phép | License

Dự án được phân phối dưới giấy phép MIT. Xem tệp `LICENSE` để biết thêm thông tin.

## 📞 Liên hệ | Contact

Email: your-email@example.com

---

<div align="center">
  <strong>EduGate - Kết nối, Minh bạch, Hiệu quả</strong><br>
  <em>Connect, Transparent, Efficient</em>
</div>

## 📋 Yêu cầu chức năng | Functional Requirements

### 1️⃣ Quản lý người dùng và phân quyền
- **Quản lý tài khoản người dùng:**
  - Admin đẩy tài khoản (cấp tài khoản), tạo các class (GVCN, phụ huynh, học sinh).
  - Các user không có quyền tự tạo tài khoản.
  - Admin quản lý tài khoản đó, tuỳ ý chỉnh sửa thông tin tài khoản người dùng.
- **Quản lý phân quyền người dùng:**
  - Hệ thống có 4 người dùng cơ bản với các quyền hạn mặc định khác nhau:
    - Admin
    - Teacher
    - Parent
    - Student
  - Các teacher sẽ thuộc các phòng ban (Department). Quản lý department sẽ do Admin quản lý. Ứng với phòng ban mà tài khoản Teacher sẽ có các access permission bổ sung thêm:
    - **Ban Giám Hiệu:** Thêm quyền view Điểm của các học sinh trong trường + view danh sách các đơn kiến nghị của phụ huynh.
    - **Các bộ môn:** Vẫn là quyền hạn teacher mặc định.
    - **Các phòng ban khác:** Vẫn là quyền hạn teacher mặc định.
- **Xác thực người dùng:** Qua việc kiểm tra tên đăng nhập và mật khẩu.
- **Uỷ quyền người dùng:** Xác định quyền truy cập của người dùng sau khi đã được xác thực.

### 2️⃣ Gửi - nhận tin nhắn
- **Role Có quyền gửi/nhận tin nhắn:** Teacher, Parent, Student. Admin chỉ có quyền hạn quản lý các nhóm chat.
- **Tạo nhóm chat:** Mọi tài khoản đều có thể tạo nhóm chat.
- **Auto add nhóm chat theo lớp:** Khi một class đã được Admin tạo, hệ thống tự động tạo 2 group chat. Khi admin add một user vào class, hệ thống check role và tự động add vào các nhóm chat tương ứng:
  1. Nhóm chat GVCN + Phụ huynh
  2. Nhóm chat GVCN + Học sinh
- **Gửi tin nhắn:** Các đối tượng tham gia tự do nhắn tin trực tiếp đến bất kỳ đối tượng nào cũng được (trừ Admin).
- **Lưu trữ:** Hệ thống lưu trữ lịch sử tin nhắn và cho phép người dùng xem tin nhắn hiện tại, tin nhắn cũ.

### 3️⃣ Quản lý lịch sự kiện, lịch học
- **Mô tả:** Admin sẽ quản lý tạo và cập nhật:
  - **Lịch sự kiện:** Lịch hoạt động ngoại khóa, Lịch quan trọng (lịch nghỉ học), các thông báo từ nhà trường, lịch thi.
  - **Lịch học:** Thời khóa biểu của các lớp.
  - **Target:** Global (Toàn trường): Do Admin đẩy lên và quản lý.
- **Xem thông báo/lịch:**
  - Toàn bộ các tài khoản được xem thông tin các event + TKB toàn trường.

### 4️⃣ Quản lý thông tin các bài đăng trong lớp
- Khi Admin tạo một class mới:
  - Trong class đó sẽ có trang hiển thị các bài đăng trong lớp đó.
- **Tạo post class:**
  - **Target:** Các thành viên trong class đó thôi (GVCN, học sinh, phụ huynh).
  - **GVCN:** Tạo và quản lý các post class này.
- **Xem các bài đăng trong class:**
  - Toàn bộ các tài khoản là thành viên class được xem.

### 5️⃣ Tiếp nhận & Xử lý đơn kiến nghị từ phụ huynh
- **Loại đơn:** Đơn xin đổi GVCN, GVBM, Đơn xin học thêm,...
- **Quy trình xử lý:**
  - **Phụ huynh:** Gửi đơn kiến nghị, nhận phản hồi trạng thái đơn.
  - **Admin:** Nhận đơn kiến nghị (Thông báo có đơn kiến nghị đến).
  - **Admin:** Cập nhật trạng thái đơn (Đã xử lý/Đang xử lý/Đã Phê Duyệt/Từ chối) + Response.
- **Lưu trữ - Xem đơn kiến nghị:**
  - Admin xem được tất cả.
  - Phụ huynh xem được đơn của mình.
  - Ban giám hiệu được xem tất cả.

### 6️⃣ Theo dõi khen thưởng/kỷ luật
- **Nhập khen thưởng/Kỷ luật:** Chỉ Admin nhập.
  - Các khen thưởng/kỷ luật mà được admin nhập và lưu trữ vào hệ thống, hồ sơ học sinh là các khen thưởng/kỷ luật mang tính cá nhân.
  - Các khen thưởng/Kỷ luật của tập thể, sẽ được admin đăng bài Event để thông báo chung vui (không có ý nghĩa gì khác khi lưu trữ nó).
- **Xem khen thưởng/kỷ luật:**
  - **Học sinh:** Xem của lớp mình học.
  - **Phụ huynh:** Xem của lớp con mình học.
  - **Admin, Giáo viên:** Xem toàn bộ.

### 7️⃣ Sổ liên lạc hằng ngày
- **Nội dung:**
  - **Attendance:** Chuyên cần (Đi học/Vắng có phép/Vắng không phép).
  - **Overall:** Nhận xét tổng quan.
  - **StudeyOutcome:** Nhận xét học tập hằng ngày.
  - **Reprimand:** Khiển trách vi phạm (Nếu có).
- **Tạo và quản lý:** GVCN của lớp đó.
- **Xem sổ liên lạc:**
  - **Phụ huynh, học sinh:** Xem được của mình/con mình.
  - **GVCN:** Xem được của lớp mình.
  - **Admin, BGH:** Không có quyền xem.

### 8️⃣ Theo dõi điểm
- **Nhập điểm:**
  - GV Dạy môn học đó nhập điểm cho môn đó cho từng học sinh đó.
- **Xem điểm:**
  - **Học sinh:** Xem của mình.
  - **Phụ huynh:** Xem của con mình.
  - **GVCN:** Xem của lớp mình.
  - **Giáo viên Bộ môn:** Xem môn mình phụ trách.
  - **Admin, BGH:** Xem full + thống kê.
- **Lưu trữ:** Cho phép tra cứu, thống kê theo lớp, học kỳ, năm học.
- **Báo cáo kết quả học tập:**
  - Dành cho Học sinh và phụ huynh xem điểm của con mình.
  - Tạo báo cáo thống kê kết quả học tập theo kỳ, năm học. Bao gồm tổng hợp:
    - Điểm.
    - Khen thưởng.
    - Kỷ luật.