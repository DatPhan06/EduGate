import React, { useState, useEffect } from 'react';
import {
    Container,
    Typography,
    Box,
    CircularProgress,
    Alert,
    Paper,
    Breadcrumbs,
    Link as MuiLink
} from '@mui/material';
import { Link } from 'react-router-dom';
import { ClassOutlined, NavigateNext } from '@mui/icons-material';
import authService from '../../services/authService';
import studentService from '../../services/studentService';
import { getClassById } from '../../services/classManagementService';
import ClassEventsList from '../../components/ClassEvents/ClassEventsList';

const StudentClassEventsPage = () => {
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [studentClassId, setStudentClassId] = useState(null);
    const [className, setClassName] = useState('');

    useEffect(() => {
        const fetchStudentClassInfo = async () => {
            setLoading(true);
            try {
                // Get current user data to verify it's a student
                const currentUser = authService.getCurrentUser();
                
                if (currentUser && currentUser.role === 'student') {
                    try {
                        // Fetch student details using the student service
                        const studentDetails = await studentService.getStudentById(currentUser.UserID);
                        
                        if (studentDetails && studentDetails.classId) {
                            setStudentClassId(studentDetails.classId);
                            
                            // If we have className directly from the student API, use it
                            if (studentDetails.className) {
                                setClassName(studentDetails.className);
                            } else {
                                // Otherwise fetch class details to get the name
                                try {
                                    const classDetails = await getClassById(studentDetails.classId);
                                    if (classDetails && classDetails.ClassName) {
                                        setClassName(classDetails.ClassName);
                                    } else {
                                        setClassName(`Lớp ID: ${studentDetails.classId}`);
                                    }
                                } catch (classError) {
                                    console.error('Error fetching class details:', classError);
                                    setClassName(`Lớp ID: ${studentDetails.classId}`);
                                }
                            }
                            
                            setError('');
                        } else {
                            setError('Không tìm thấy thông tin lớp học của bạn. Vui lòng liên hệ quản trị viên.');
                        }
                    } catch (studentError) {
                        console.error('Error fetching student details:', studentError);
                        setError('Đã xảy ra lỗi khi tải thông tin học sinh.');
                    }
                } else {
                    if (!currentUser) {
                        setError('Không thể xác thực người dùng. Vui lòng đăng nhập lại.');
                    } else if (currentUser.role !== 'student') {
                        setError('Trang này chỉ dành cho học sinh.');
                    }
                }
            } catch (err) {
                console.error('Error in fetching student data:', err);
                setError('Đã xảy ra lỗi khi tải thông tin học sinh.');
            } finally {
                setLoading(false);
            }
        };
        
        fetchStudentClassInfo();
    }, []);

    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                {/* Breadcrumbs navigation */}
                <Breadcrumbs
                    separator={<NavigateNext fontSize="small" />}
                    aria-label="breadcrumb"
                >
                    <MuiLink component={Link} to="/home" underline="hover" color="text.primary">
                        Trang chủ
                    </MuiLink>
                    <Typography color="text.primary" sx={{ display: 'flex', alignItems: 'center' }}>
                        <ClassOutlined sx={{ mr: 0.5 }} fontSize="small" />
                        Thông báo lớp học
                    </Typography>
                </Breadcrumbs>

                {/* Page title */}
                <Typography variant="h4" component="h1" fontWeight="500">
                    Thông báo {className ? `lớp ${className}` : 'lớp học'}
                </Typography>

                {/* Loading state */}
                {loading && (
                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
                        <CircularProgress />
                    </Box>
                )}

                {/* Error message */}
                {error && !loading && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                )}

                {/* Class events list - shown only when a class is selected */}
                {!loading && !error && studentClassId && (
                    <ClassEventsList
                        classId={studentClassId}
                        isHomeRoomTeacher={false} // Students are never homeroom teachers
                    />
                )}

                {/* No class message */}
                {!loading && !error && !studentClassId && (
                     <Paper elevation={0} sx={{ p: 3, textAlign: 'center' }}>
                        <Typography variant="h6" color="text.secondary">
                            Bạn hiện không thuộc lớp nào hoặc không thể tải thông tin lớp.
                        </Typography>
                    </Paper>
                )}
            </Box>
        </Container>
    );
};

export default StudentClassEventsPage;