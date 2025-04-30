import React, { useState, useEffect } from 'react';
import { Container, Typography, Box, CircularProgress, Alert } from '@mui/material';
import authService from '../../services/authService';

const Petitions = () => {
    const [userRole, setUserRole] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchUserRole = async () => {
            try {
                const user = await authService.getCurrentUser();
                setUserRole(user.role);
            } catch (error) {
                console.error('Error fetching user role:', error);
                setError('Không thể tải thông tin người dùng');
            } finally {
                setLoading(false);
            }
        };

        fetchUserRole();
    }, []);

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="80vh">
                <CircularProgress />
            </Box>
        );
    }

    if (error) {
        return (
            <Box p={3}>
                <Alert severity="error">{error}</Alert>
            </Box>
        );
    }

    // Trang dành cho phụ huynh
    if (userRole === 'parent') {
        return (
            <Container maxWidth="lg" sx={{ py: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Trang quản lý đơn kiến nghị - Phụ huynh
                </Typography>
                <Typography variant="body1">
                    Đây là trang quản lý đơn kiến nghị dành cho phụ huynh.
                </Typography>
            </Container>
        );
    }

    // Trang dành cho giáo viên
    if (userRole === 'teacher') {
        return (
            <Container maxWidth="lg" sx={{ py: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Trang quản lý đơn kiến nghị - Giáo viên
                </Typography>
                <Typography variant="body1">
                    Đây là trang quản lý đơn kiến nghị dành cho giáo viên.
                </Typography>
            </Container>
        );
    }

    // Trang dành cho admin
    if (userRole === 'admin') {
        return (
            <Container maxWidth="lg" sx={{ py: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Trang quản lý đơn kiến nghị - Quản trị viên
                </Typography>
                <Typography variant="body1">
                    Đây là trang quản lý đơn kiến nghị dành cho quản trị viên.
                </Typography>
            </Container>
        );
    }

    // Trang dành cho học sinh
    if (userRole === 'student') {
        return (
            <Container maxWidth="lg" sx={{ py: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Trang quản lý đơn kiến nghị - Học sinh
                </Typography>
                <Typography variant="body1">
                    Đây là trang quản lý đơn kiến nghị dành cho học sinh.
                </Typography>
            </Container>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Typography variant="h4" component="h1" gutterBottom>
                Trang quản lý đơn kiến nghị
            </Typography>
            <Typography variant="body1">
                Vui lòng đăng nhập để sử dụng chức năng này.
            </Typography>
        </Container>
    );
};

export default Petitions; 