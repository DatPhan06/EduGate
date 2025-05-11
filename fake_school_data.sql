-- Fake data for THPT Chu Văn An (a famous high school in Hanoi)
-- Reset sequences to ensure proper ID generation
ALTER SEQUENCE public."users_UserID_seq" RESTART WITH 100;
ALTER SEQUENCE public."departments_DepartmentID_seq" RESTART WITH 100;
ALTER SEQUENCE public."classes_ClassID_seq" RESTART WITH 100;
ALTER SEQUENCE public."subjects_SubjectID_seq" RESTART WITH 100;

-- 1. Insert Departments
INSERT INTO public.departments ("DepartmentID", "DepartmentName", "Description")
VALUES 
(100, 'Ban Giám Hiệu', 'Ban lãnh đạo nhà trường'),
(101, 'Tổ Toán', 'Giảng dạy Toán học'),
(102, 'Tổ Văn', 'Giảng dạy Ngữ văn'),
(103, 'Tổ Lý - Công Nghệ', 'Giảng dạy Vật lý và Công nghệ'),
(104, 'Tổ Hóa - Sinh', 'Giảng dạy Hóa học và Sinh học'),
(105, 'Tổ Sử - Địa - GDCD', 'Giảng dạy Lịch sử, Địa lý và Giáo dục công dân'),
(106, 'Tổ Ngoại Ngữ', 'Giảng dạy Tiếng Anh và các ngoại ngữ khác'),
(107, 'Tổ Tin Học', 'Giảng dạy Tin học');

-- 2. Insert Users (Administrators)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", "role")
VALUES
(100, 'Minh', 'Nguyễn Văn', 'hieu.truong@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345678', '1965-05-15', 'MALE', 'Số 10 Thụy Khuê, Tây Hồ, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin'),
(101, 'Hương', 'Trần Thị', 'pho.hieu.truong@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345679', '1970-08-20', 'FEMALE', 'Số 25 Nguyễn Biểu, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin'),
(102, 'Tuấn', 'Lê Anh', 'truong.phong.dt@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345680', '1975-03-10', 'MALE', 'Số 45 Liễu Giai, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin');

-- Administrative staff
INSERT INTO public.administrative_staffs ("AdminID", "Note")
VALUES 
(100, 'Hiệu trưởng'),
(101, 'Phó Hiệu trưởng'),
(102, 'Trưởng phòng Đào tạo');

-- 3. Insert Users (Teachers)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", "role")
VALUES
(103, 'Hà', 'Nguyễn Thị', 'nguyen.ha@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345681', '1980-05-10', 'FEMALE', 'Số 78 Đội Cấn, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(104, 'Thành', 'Trần Văn', 'tran.thanh@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345682', '1978-07-15', 'MALE', 'Số 56 Hoàng Hoa Thám, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(105, 'Linh', 'Phạm Thị', 'pham.linh@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345683', '1982-09-20', 'FEMALE', 'Số 123 Hoàng Quốc Việt, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(106, 'Hùng', 'Vũ Mạnh', 'vu.hung@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345684', '1976-11-05', 'MALE', 'Số 45 Phạm Hùng, Nam Từ Liêm, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(107, 'Lan', 'Đỗ Thị', 'do.lan@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345685', '1984-02-18', 'FEMALE', 'Số 67 Trần Duy Hưng, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(108, 'Đức', 'Hoàng Văn', 'hoang.duc@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345686', '1975-04-30', 'MALE', 'Số 89 Nguyễn Chí Thanh, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(109, 'Mai', 'Lê Thị', 'le.mai@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345687', '1985-06-25', 'FEMALE', 'Số 34 Láng Hạ, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(110, 'Tùng', 'Nguyễn Thanh', 'nguyen.tung@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345688', '1979-08-12', 'MALE', 'Số 56 Kim Mã, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher');

-- Teachers
INSERT INTO public.teachers ("TeacherID", "DepartmentID", "Graduate", "Degree", "Position")
VALUES 
(103, 101, 'Đại học Sư phạm Hà Nội', 'ThS', 'Tổ trưởng'),
(104, 102, 'Đại học Sư phạm Hà Nội', 'ThS', 'Tổ trưởng'),
(105, 103, 'Đại học Bách Khoa Hà Nội', 'ThS', 'Tổ trưởng'),
(106, 104, 'Đại học Khoa học Tự nhiên', 'TS', 'Tổ trưởng'),
(107, 105, 'Đại học Sư phạm Hà Nội', 'CN', 'Tổ trưởng'),
(108, 106, 'Đại học Ngoại ngữ', 'ThS', 'Tổ trưởng'),
(109, 101, 'Đại học Sư phạm Hà Nội', 'CN', 'Giáo viên'),
(110, 107, 'Đại học Bách Khoa Hà Nội', 'ThS', 'Tổ trưởng');

-- 4. Insert Subjects
INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
VALUES 
(100, 'Toán học', 'Môn Toán lớp 10-12'),
(101, 'Ngữ văn', 'Môn Văn lớp 10-12'),
(102, 'Vật lý', 'Môn Vật lý lớp 10-12'),
(103, 'Hóa học', 'Môn Hóa học lớp 10-12'),
(104, 'Sinh học', 'Môn Sinh học lớp 10-12'),
(105, 'Lịch sử', 'Môn Lịch sử lớp 10-12'),
(106, 'Địa lý', 'Môn Địa lý lớp 10-12'),
(107, 'Tiếng Anh', 'Môn Tiếng Anh lớp 10-12'),
(108, 'Tin học', 'Môn Tin học lớp 10-12'),
(109, 'Giáo dục công dân', 'Môn GDCD lớp 10-12');

-- 5. Insert Classes
INSERT INTO public.classes ("ClassID", "ClassName", "GradeLevel", "AcademicYear", "HomeroomTeacherID")
VALUES 
(100, '10A1', '10', '2025-2026', 103),
(101, '10A2', '10', '2025-2026', 104),
(102, '11A1', '11', '2025-2026', 105),
(103, '11A2', '11', '2025-2026', 106),
(104, '12A1', '12', '2025-2026', 107),
(105, '12A2', '12', '2025-2026', 108);

-- 6. Insert Users (Students)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", "role")
VALUES
-- 10A1 Students
(111, 'Anh', 'Nguyễn Thị', 'anh.nt@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345689', '2010-01-15', 'FEMALE', 'Số 123 Đội Cấn, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(112, 'Bình', 'Trần Văn', 'binh.tv@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345690', '2010-03-20', 'MALE', 'Số 45 Hoàng Hoa Thám, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(113, 'Cường', 'Lê Mạnh', 'cuong.lm@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345691', '2010-05-10', 'MALE', 'Số 67 Liễu Giai, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),

-- 11A1 Students
(114, 'Dung', 'Phạm Thị', 'dung.pt@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345692', '2009-07-25', 'FEMALE', 'Số 89 Thụy Khuê, Tây Hồ, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(115, 'Hải', 'Vũ Đình', 'hai.vd@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345693', '2009-09-30', 'MALE', 'Số 34 Hoàng Quốc Việt, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(116, 'Hoa', 'Nguyễn Thị', 'hoa.nt@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345694', '2009-11-12', 'FEMALE', 'Số 56 Cầu Giấy, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),

-- 12A1 Students
(117, 'Khánh', 'Trần Minh', 'khanh.tm@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345695', '2008-02-15', 'MALE', 'Số 78 Láng Hạ, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(118, 'Linh', 'Phạm Thùy', 'linh.pt@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345696', '2008-04-20', 'FEMALE', 'Số 90 Kim Mã, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(119, 'Minh', 'Nguyễn Hoàng', 'minh.nh@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345697', '2008-06-05', 'MALE', 'Số 12 Nguyễn Chí Thanh, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student');

-- Students
INSERT INTO public.students ("StudentID", "ClassID", "EnrollmentDate", "YtDate")
VALUES 
(111, 100, '2025-09-01', NULL),
(112, 100, '2025-09-01', NULL),
(113, 100, '2025-09-01', NULL),
(114, 102, '2025-09-01', NULL),
(115, 102, '2025-09-01', NULL),
(116, 102, '2025-09-01', NULL),
(117, 104, '2025-09-01', NULL),
(118, 104, '2025-09-01', NULL),
(119, 104, '2025-09-01', NULL);

-- 7. Insert Users (Parents)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", "role")
VALUES
(120, 'Nhung', 'Trần Thị', 'nhung.tt@parent.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345698', '1980-08-15', 'FEMALE', 'Số 123 Đội Cấn, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'parent'),
(121, 'Phong', 'Nguyễn Văn', 'phong.nv@parent.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345699', '1978-10-20', 'MALE', 'Số 45 Hoàng Hoa Thám, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'parent'),
(122, 'Quỳnh', 'Lê Thị', 'quynh.lt@parent.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345700', '1979-12-10', 'FEMALE', 'Số 67 Liễu Giai, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'parent');

-- Parents
INSERT INTO public.parents ("ParentID", "Occupation")
VALUES 
(120, 'Giáo viên'),
(121, 'Kỹ sư'),
(122, 'Bác sĩ');

-- Parent-Student relationships
INSERT INTO public.parent_students ("RelationshipID", "Relationship", "ParentID", "StudentID")
VALUES 
(100, 'mother', 120, 111),
(101, 'father', 121, 112),
(102, 'mother', 122, 114);

-- 8. Insert Class-Subjects (assign teachers to subjects for classes)
INSERT INTO public.class_subjects ("ClassSubjectID", "TeacherID", "ClassID", "SubjectID", "Semester", "AcademicYear", "UpdatedAt")
VALUES 
-- 10A1 Subjects
(100, 103, 100, 100, 'HK1', '2025-2026', NOW()), -- Toán 10A1
(101, 104, 100, 101, 'HK1', '2025-2026', NOW()), -- Văn 10A1
(102, 105, 100, 102, 'HK1', '2025-2026', NOW()), -- Lý 10A1
(103, 106, 100, 103, 'HK1', '2025-2026', NOW()), -- Hóa 10A1
(104, 108, 100, 107, 'HK1', '2025-2026', NOW()), -- Anh 10A1

-- 11A1 Subjects
(105, 103, 102, 100, 'HK1', '2025-2026', NOW()), -- Toán 11A1
(106, 104, 102, 101, 'HK1', '2025-2026', NOW()), -- Văn 11A1
(107, 105, 102, 102, 'HK1', '2025-2026', NOW()), -- Lý 11A1
(108, 106, 102, 103, 'HK1', '2025-2026', NOW()), -- Hóa 11A1
(109, 108, 102, 107, 'HK1', '2025-2026', NOW()), -- Anh 11A1

-- 12A1 Subjects
(110, 103, 104, 100, 'HK1', '2025-2026', NOW()), -- Toán 12A1
(111, 104, 104, 101, 'HK1', '2025-2026', NOW()), -- Văn 12A1
(112, 105, 104, 102, 'HK1', '2025-2026', NOW()), -- Lý 12A1
(113, 106, 104, 103, 'HK1', '2025-2026', NOW()), -- Hóa 12A1
(114, 108, 104, 107, 'HK1', '2025-2026', NOW()); -- Anh 12A1

-- 9. Insert Timetable (subject schedules)
INSERT INTO public.subject_schedules ("SubjectScheduleID", "ClassSubjectID", "StartPeriod", "EndPeriod", "Day")
VALUES 
-- 10A1 Schedule
(100, 100, 1, 2, 'Monday'), -- Toán 10A1, Thứ 2, Tiết 1-2
(101, 101, 3, 4, 'Monday'), -- Văn 10A1, Thứ 2, Tiết 3-4
(102, 102, 1, 2, 'Tuesday'), -- Lý 10A1, Thứ 3, Tiết 1-2
(103, 103, 3, 4, 'Tuesday'), -- Hóa 10A1, Thứ 3, Tiết 3-4
(104, 104, 1, 2, 'Wednesday'), -- Anh 10A1, Thứ 4, Tiết 1-2

-- 11A1 Schedule
(105, 105, 1, 2, 'Thursday'), -- Toán 11A1, Thứ 5, Tiết 1-2
(106, 106, 3, 4, 'Thursday'), -- Văn 11A1, Thứ 5, Tiết 3-4
(107, 107, 1, 2, 'Friday'), -- Lý 11A1, Thứ 6, Tiết 1-2
(108, 108, 3, 4, 'Friday'), -- Hóa 11A1, Thứ 6, Tiết 3-4
(109, 109, 1, 2, 'Monday'), -- Anh 11A1, Thứ 2, Tiết 1-2

-- 12A1 Schedule
(110, 110, 3, 4, 'Wednesday'), -- Toán 12A1, Thứ 4, Tiết 3-4
(111, 111, 1, 2, 'Thursday'), -- Văn 12A1, Thứ 5, Tiết 1-2
(112, 112, 3, 4, 'Thursday'), -- Lý 12A1, Thứ 5, Tiết 3-4
(113, 113, 1, 2, 'Friday'), -- Hóa 12A1, Thứ 6, Tiết 1-2
(114, 114, 3, 4, 'Friday'); -- Anh 12A1, Thứ 6, Tiết 3-4

-- 10. Insert Grades for students in class 10A1 for Math
INSERT INTO public.grades ("GradeID", "StudentID", "ClassSubjectID", "FinalScore", "Semester", "UpdatedAt")
VALUES 
(100, 111, 100, 8.5, 'HK1', NOW()), -- Anh - Toán
(101, 112, 100, 7.8, 'HK1', NOW()), -- Bình - Toán
(102, 113, 100, 9.0, 'HK1', NOW()); -- Cường - Toán

-- 11. Insert grade components for these students
INSERT INTO public.grade_components ("ComponentID", "ComponentName", "GradeID", "Weight", "Score", "SubmitDate")
VALUES 
-- Anh's math grade components
(100, 'Điểm kiểm tra 15 phút #1', 100, 1, 8.0, NOW()),
(101, 'Điểm kiểm tra 15 phút #2', 100, 1, 9.0, NOW()),
(102, 'Điểm kiểm tra 1 tiết #1', 100, 2, 8.5, NOW()),
(103, 'Điểm kiểm tra 1 tiết #2', 100, 2, 8.0, NOW()),
(104, 'Điểm thi học kỳ', 100, 3, 9.0, NOW()),

-- Bình's math grade components
(105, 'Điểm kiểm tra 15 phút #1', 101, 1, 7.5, NOW()),
(106, 'Điểm kiểm tra 15 phút #2', 101, 1, 8.0, NOW()),
(107, 'Điểm kiểm tra 1 tiết #1', 101, 2, 7.0, NOW()),
(108, 'Điểm kiểm tra 1 tiết #2', 101, 2, 8.0, NOW()),
(109, 'Điểm thi học kỳ', 101, 3, 8.0, NOW()),

-- Cường's math grade components
(110, 'Điểm kiểm tra 15 phút #1', 102, 1, 9.0, NOW()),
(111, 'Điểm kiểm tra 15 phút #2', 102, 1, 9.5, NOW()),
(112, 'Điểm kiểm tra 1 tiết #1', 102, 2, 8.5, NOW()),
(113, 'Điểm kiểm tra 1 tiết #2', 102, 2, 9.0, NOW()),
(114, 'Điểm thi học kỳ', 102, 3, 9.0, NOW());

-- 12. Create some petitions
INSERT INTO public.petitions ("PetitionID", "ParentID", "AdminID", "Title", "Content", "Status", "SubmittedAt", "Response")
VALUES 
(100, 120, 100, 'Xin nghỉ học', 'Con tôi xin phép nghỉ học 3 ngày do bị ốm.', 'APPROVED', NOW() - INTERVAL '10 days', 'Đơn đã được phê duyệt, học sinh được phép nghỉ học.'),
(101, 121, 101, 'Đề nghị xem xét lại điểm thi', 'Kính gửi nhà trường, tôi muốn đề nghị xem xét lại điểm bài thi giữa kỳ môn Toán của con tôi.', 'PENDING', NOW() - INTERVAL '5 days', NULL),
(102, 122, NULL, 'Xin chuyển lớp', 'Tôi muốn xin chuyển con tôi từ lớp 11A1 sang lớp 11A2.', 'NEW', NOW() - INTERVAL '2 days', NULL);

-- 13. Create some events
INSERT INTO public.events ("EventID", "Title", "Type", "Content", "EventDate", "CreatedAt", "AdminID")
VALUES 
(100, 'Lễ khai giảng năm học 2025-2026', 'CEREMONY', 'Trân trọng kính mời quý phụ huynh và học sinh tham dự Lễ khai giảng năm học mới.', '2025-09-05 07:30:00', NOW(), 100),
(101, 'Hội nghị phụ huynh học sinh', 'MEETING', 'Thông báo về việc tổ chức Hội nghị phụ huynh học sinh đầu năm học 2025-2026.', '2025-09-15 14:00:00', NOW(), 101),
(102, 'Cuộc thi Olympic Toán học cấp trường', 'COMPETITION', 'Thông báo về việc tổ chức Cuộc thi Olympic Toán học cấp trường năm học 2025-2026.', '2025-10-20 08:00:00', NOW(), 100);

-- 14. Create some class posts
INSERT INTO public.class_posts ("PostID", "Title", "Type", "Content", "EventDate", "CreatedAt", "TeacherID", "ClassID")
VALUES 
(100, 'Thông báo về bài tập Toán', 'HOMEWORK', 'Yêu cầu học sinh làm bài tập Toán trang 25-26, nộp vào ngày 15/09/2025.', '2025-09-15', NOW(), 103, 100),
(101, 'Lịch kiểm tra giữa kỳ học kỳ 1', 'ANNOUNCEMENT', 'Thông báo lịch kiểm tra giữa kỳ học kỳ 1 các môn học.', '2025-10-25', NOW(), 104, 100),
(102, 'Kế hoạch dã ngoại học tập', 'EVENT', 'Thông báo kế hoạch dã ngoại học tập tại Bảo tàng Lịch sử Việt Nam.', '2025-11-10', NOW(), 107, 104);

-- 15. Create some conversations and messages
INSERT INTO public.conversations ("ConversationID", "CreatedAt", "Name", "NumOfParticipation")
VALUES 
(100, NOW(), 'Giáo viên - Phụ huynh lớp 10A1', 2),
(101, NOW(), 'Giáo viên chủ nhiệm - Học sinh lớp 10A1', 4),
(102, NOW(), 'Ban giám hiệu - Giáo viên', 9);

INSERT INTO public.participations ("ParticipationID", "ConversationID", "UserID", "JoinedAt")
VALUES 
(100, 100, 103, NOW()), -- Cô Hà (GVCN 10A1)
(101, 100, 120, NOW()), -- Mẹ của Anh
(102, 101, 103, NOW()), -- Cô Hà (GVCN 10A1)
(103, 101, 111, NOW()), -- Anh
(104, 101, 112, NOW()), -- Bình
(105, 101, 113, NOW()); -- Cường

INSERT INTO public.messages ("MessageID", "ConversationID", "Content", "SentAt", "UserID")
VALUES 
(100, 100, 'Chào cô, con tôi hôm nay bị ốm và không thể đến trường. Cô có thể cho con tôi biết bài tập về nhà không ạ?', NOW() - INTERVAL '2 hours', 120),
(101, 100, 'Chào chị, hôm nay lớp có bài tập Toán trang 25-26, và bài tập Văn đọc truyện ngắn trang 45. Chúc cháu mau khỏe!', NOW() - INTERVAL '1 hour', 103),
(102, 101, 'Chào các em, cô nhắc các em nộp bài tập Toán vào ngày mai nhé!', NOW() - INTERVAL '3 hours', 103),
(103, 101, 'Vâng thưa cô, em sẽ nộp đúng hạn ạ.', NOW() - INTERVAL '2 hours 30 minutes', 111);

-- 16. Create some reward and punishment records
INSERT INTO public.reward_punishments ("RecordID", "Title", "Type", "Description", "Date", "Semester", "Week", "StudentID", "AdminID")
VALUES 
(100, 'Khen thưởng học sinh giỏi Toán', 'REWARD', 'Đạt giải Nhất Olympic Toán cấp Quận', NOW() - INTERVAL '30 days', 'HK1', 5, 113, 100),
(101, 'Cảnh cáo vắng học không phép', 'PUNISHMENT', 'Vắng học không phép 3 buổi liên tiếp', NOW() - INTERVAL '15 days', 'HK1', 7, 112, 101);

-- 17. Create some daily progress reports
INSERT INTO public.daily_progress ("DailyID", "Overall", "Attendance", "StudyOutcome", "Reprimand", "Date", "TeacherID", "StudentID")
VALUES 
(100, 'Học sinh có tiến bộ trong môn Toán', 'ĐẦY ĐỦ', 'Hoàn thành tốt bài tập về nhà', NULL, NOW() - INTERVAL '10 days', 103, 111),
(101, 'Học sinh cần cố gắng hơn trong môn Văn', 'ĐẦY ĐỦ', 'Chưa hoàn thành bài tập Văn', 'Nhắc nhở về việc làm bài tập', NOW() - INTERVAL '5 days', 104, 112); 