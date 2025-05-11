-- Fake data for THPT Chu Văn An (a famous high school in Hanoi)
-- Instead of resetting sequences, we'll use explicit IDs and handle duplicates

-- 1. First clean up any possible test data (OPTIONAL - comment out if you don't want to delete existing data)
-- DELETE FROM public.daily_progress;
-- DELETE FROM public.reward_punishments;
-- DELETE FROM public.messages;
-- DELETE FROM public.participations;
-- DELETE FROM public.conversations;
-- DELETE FROM public.class_posts;
-- DELETE FROM public.grade_components;
-- DELETE FROM public.grades;
-- DELETE FROM public.subject_schedules;
-- DELETE FROM public.class_subjects;
-- DELETE FROM public.parent_students;
-- DELETE FROM public.petitions;
-- DELETE FROM public.events;
-- DELETE FROM public.students;
-- DELETE FROM public.parents;
-- DELETE FROM public.teachers;
-- DELETE FROM public.classes;
-- DELETE FROM public.subjects;
-- DELETE FROM public.administrative_staffs;
-- DELETE FROM public.departments;
-- DELETE FROM public.users WHERE "UserID" >= 100;

-- 1. Insert Departments - with conflict handling
INSERT INTO public.departments ("DepartmentID", "DepartmentName", "Description")
VALUES 
(100, 'Ban Giám Hiệu', 'Ban lãnh đạo nhà trường'),
(101, 'Tổ Toán', 'Giảng dạy Toán học'),
(102, 'Tổ Văn', 'Giảng dạy Ngữ văn'),
(103, 'Tổ Lý - Công Nghệ', 'Giảng dạy Vật lý và Công nghệ'),
(104, 'Tổ Hóa - Sinh', 'Giảng dạy Hóa học và Sinh học'),
(105, 'Tổ Sử - Địa - GDCD', 'Giảng dạy Lịch sử, Địa lý và Giáo dục công dân'),
(106, 'Tổ Ngoại Ngữ', 'Giảng dạy Tiếng Anh và các ngoại ngữ khác'),
(107, 'Tổ Tin Học', 'Giảng dạy Tin học')
ON CONFLICT ("DepartmentID") DO UPDATE 
SET "DepartmentName" = EXCLUDED."DepartmentName",
    "Description" = EXCLUDED."Description";

-- 2. Insert Users (Administrators)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", role)
VALUES
(100, 'Minh', 'Nguyễn Văn', 'hieu.truong@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345678', '1965-05-15', 'MALE', 'Số 10 Thụy Khuê, Tây Hồ, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin'),
(101, 'Hương', 'Trần Thị', 'pho.hieu.truong@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345679', '1970-08-20', 'FEMALE', 'Số 25 Nguyễn Biểu, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin'),
(102, 'Tuấn', 'Lê Anh', 'truong.phong.dt@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345680', '1975-03-10', 'MALE', 'Số 45 Liễu Giai, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'admin')
ON CONFLICT ("UserID") DO UPDATE 
SET "Email" = EXCLUDED."Email",
    "FirstName" = EXCLUDED."FirstName",
    "LastName" = EXCLUDED."LastName",
    "UpdatedAt" = NOW();

-- Administrative staff
INSERT INTO public.administrative_staffs ("AdminID", "Note")
VALUES 
(100, 'Hiệu trưởng'),
(101, 'Phó Hiệu trưởng'),
(102, 'Trưởng phòng Đào tạo')
ON CONFLICT ("AdminID") DO UPDATE 
SET "Note" = EXCLUDED."Note";

-- 3. Insert Users (Teachers)
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", role)
VALUES
(103, 'Hà', 'Nguyễn Thị', 'nguyen.ha@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345681', '1980-05-10', 'FEMALE', 'Số 78 Đội Cấn, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(104, 'Thành', 'Trần Văn', 'tran.thanh@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345682', '1978-07-15', 'MALE', 'Số 56 Hoàng Hoa Thám, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(105, 'Linh', 'Phạm Thị', 'pham.linh@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345683', '1982-09-20', 'FEMALE', 'Số 123 Hoàng Quốc Việt, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(106, 'Hùng', 'Vũ Mạnh', 'vu.hung@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345684', '1976-11-05', 'MALE', 'Số 45 Phạm Hùng, Nam Từ Liêm, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(107, 'Lan', 'Đỗ Thị', 'do.lan@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345685', '1984-02-18', 'FEMALE', 'Số 67 Trần Duy Hưng, Cầu Giấy, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(108, 'Đức', 'Hoàng Văn', 'hoang.duc@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345686', '1975-04-30', 'MALE', 'Số 89 Nguyễn Chí Thanh, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(109, 'Mai', 'Lê Thị', 'le.mai@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345687', '1985-06-25', 'FEMALE', 'Số 34 Láng Hạ, Đống Đa, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher'),
(110, 'Tùng', 'Nguyễn Thanh', 'nguyen.tung@cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345688', '1979-08-12', 'MALE', 'Số 56 Kim Mã, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'teacher')
ON CONFLICT ("UserID") DO UPDATE 
SET "Email" = EXCLUDED."Email",
    "FirstName" = EXCLUDED."FirstName",
    "LastName" = EXCLUDED."LastName",
    "UpdatedAt" = NOW();

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
(110, 107, 'Đại học Bách Khoa Hà Nội', 'ThS', 'Tổ trưởng')
ON CONFLICT ("TeacherID") DO UPDATE 
SET "Graduate" = EXCLUDED."Graduate",
    "Degree" = EXCLUDED."Degree",
    "Position" = EXCLUDED."Position";

-- 4. Insert Subjects (with conflict handling for unique subject names)
DO $$
BEGIN
    -- Try to insert Toán học (100)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (100, 'Toán học', 'Môn Toán lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        -- If Toán học already exists, get its ID and update our reference
        UPDATE public.subjects SET "Description" = 'Môn Toán lớp 10-12'
        WHERE "SubjectName" = 'Toán học';
    END;
    
    -- Try to insert Ngữ văn (101)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (101, 'Ngữ văn', 'Môn Văn lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Văn lớp 10-12'
        WHERE "SubjectName" = 'Ngữ văn';
    END;
    
    -- Try to insert Vật lý (102)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (102, 'Vật lý', 'Môn Vật lý lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Vật lý lớp 10-12'
        WHERE "SubjectName" = 'Vật lý';
    END;
    
    -- Try to insert Hóa học (103)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (103, 'Hóa học', 'Môn Hóa học lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Hóa học lớp 10-12'
        WHERE "SubjectName" = 'Hóa học';
    END;
    
    -- Try to insert Sinh học (104)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (104, 'Sinh học', 'Môn Sinh học lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Sinh học lớp 10-12'
        WHERE "SubjectName" = 'Sinh học';
    END;
    
    -- Try to insert Lịch sử (105)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (105, 'Lịch sử', 'Môn Lịch sử lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Lịch sử lớp 10-12'
        WHERE "SubjectName" = 'Lịch sử';
    END;
    
    -- Try to insert Địa lý (106)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (106, 'Địa lý', 'Môn Địa lý lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Địa lý lớp 10-12'
        WHERE "SubjectName" = 'Địa lý';
    END;
    
    -- Try to insert Tiếng Anh (107)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (107, 'Tiếng Anh', 'Môn Tiếng Anh lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Tiếng Anh lớp 10-12'
        WHERE "SubjectName" = 'Tiếng Anh';
    END;
    
    -- Try to insert Tin học (108)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (108, 'Tin học', 'Môn Tin học lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn Tin học lớp 10-12'
        WHERE "SubjectName" = 'Tin học';
    END;
    
    -- Try to insert Giáo dục công dân (109)
    BEGIN
        INSERT INTO public.subjects ("SubjectID", "SubjectName", "Description")
        VALUES (109, 'Giáo dục công dân', 'Môn GDCD lớp 10-12');
    EXCEPTION WHEN unique_violation THEN
        UPDATE public.subjects SET "Description" = 'Môn GDCD lớp 10-12'
        WHERE "SubjectName" = 'Giáo dục công dân';
    END;
END $$;

-- 5. Insert Classes
INSERT INTO public.classes ("ClassID", "ClassName", "GradeLevel", "AcademicYear", "HomeroomTeacherID")
VALUES 
(100, '10A1', '10', '2025-2026', 103),
(101, '10A2', '10', '2025-2026', 104),
(102, '11A1', '11', '2025-2026', 105),
(103, '11A2', '11', '2025-2026', 106),
(104, '12A1', '12', '2025-2026', 107),
(105, '12A2', '12', '2025-2026', 108)
ON CONFLICT ("ClassID") DO UPDATE 
SET "ClassName" = EXCLUDED."ClassName",
    "GradeLevel" = EXCLUDED."GradeLevel",
    "AcademicYear" = EXCLUDED."AcademicYear",
    "HomeroomTeacherID" = EXCLUDED."HomeroomTeacherID";

-- The remaining INSERT statements would follow the same pattern - adding ON CONFLICT clauses
-- to update rather than fail when duplicates exist. I'm showing only part of the script since
-- it would be too large to include everything.

-- Example continuing with students:
INSERT INTO public.users ("UserID", "FirstName", "LastName", "Email", "Password", "PhoneNumber", "DOB", "Gender", "Address", "CreatedAt", "UpdatedAt", "Status", "role")
VALUES
-- 10A1 Students
(111, 'Anh', 'Nguyễn Thị', 'anh.nt@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345689', '2010-01-15', 'FEMALE', 'Số 123 Đội Cấn, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(112, 'Bình', 'Trần Văn', 'binh.tv@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345690', '2010-03-20', 'MALE', 'Số 45 Hoàng Hoa Thám, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student'),
(113, 'Cường', 'Lê Mạnh', 'cuong.lm@student.cva.edu.vn', '$2b$12$tOf7fKwwglW5ZCusHs3brenezRAJO6Vcau3xEVGb/fgVZZSDopAvy', '0912345691', '2010-05-10', 'MALE', 'Số 67 Liễu Giai, Ba Đình, Hà Nội', NOW(), NOW(), 'ACTIVE', 'student')
ON CONFLICT ("UserID") DO UPDATE 
SET "Email" = EXCLUDED."Email",
    "FirstName" = EXCLUDED."FirstName",
    "LastName" = EXCLUDED."LastName",
    "UpdatedAt" = NOW();

-- Insert Students with conflict handling
INSERT INTO public.students ("StudentID", "ClassID", "EnrollmentDate", "YtDate")
VALUES 
(111, 100, '2025-09-01', NULL),
(112, 100, '2025-09-01', NULL),
(113, 100, '2025-09-01', NULL)
ON CONFLICT ("StudentID") DO UPDATE 
SET "ClassID" = EXCLUDED."ClassID",
    "EnrollmentDate" = EXCLUDED."EnrollmentDate";

-- For brevity, I've shown only part of the script. The full script would similarly add
-- ON CONFLICT clauses to all INSERT statements. 