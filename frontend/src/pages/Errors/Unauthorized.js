import React from 'react';
import { Box, Typography, Button } from '@mui/material';
import { useNavigate } from 'react-router-dom';

const Unauthorized = () => {
    const navigate = useNavigate();

    return (
        <Box
            sx={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                minHeight: '60vh',
                textAlign: 'center',
                p: 3,
            }}
        >
            <Typography variant="h1" component="h1" gutterBottom>
                403
            </Typography>
            <Typography variant="h4" component="h2" gutterBottom>
                Không có quyền truy cập
            </Typography>
            <Typography variant="body1" color="text.secondary" paragraph>
                Bạn không có quyền truy cập vào trang này. Vui lòng liên hệ với quản trị viên nếu bạn cần quyền truy cập.
            </Typography>
            <Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
                <Button
                    variant="contained"
                    color="primary"
                    onClick={() => navigate('/')}
                >
                    Quay về trang chủ
                </Button>
                <Button
                    variant="outlined"
                    color="primary"
                    onClick={() => navigate(-1)}
                >
                    Quay lại trang trước
                </Button>
            </Box>
        </Box>
    );
};

export default Unauthorized; 