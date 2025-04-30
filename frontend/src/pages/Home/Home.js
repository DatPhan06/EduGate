import React from 'react';
import { Box, Typography, Grid, Paper, Button, useTheme, keyframes } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import {
    Message as MessageIcon,
    Event as EventIcon,
    Assignment as AssignmentIcon,
    EmojiEvents as EmojiEventsIcon,
    School as SchoolIcon,
} from '@mui/icons-material';

// Animation keyframes
const fadeIn = keyframes`
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
`;

const pulse = keyframes`
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
`;

const Home = () => {
    const theme = useTheme();
    const navigate = useNavigate();

    const modules = [
        {
            title: 'Quản lý Tin nhắn',
            icon: <MessageIcon sx={{ fontSize: 40 }} />,
            path: '/messages',
            description: 'Quản lý và theo dõi các tin nhắn trong hệ thống',
            color: 'linear-gradient(135deg, #00b4db 0%, #0083b0 100%)',
        },
        {
            title: 'Quản lý Lịch sự kiện & Thời khóa biểu',
            icon: <EventIcon sx={{ fontSize: 40 }} />,
            path: '/events',
            description: 'Quản lý lịch học và các sự kiện trong trường',
            color: 'linear-gradient(135deg, #a8e063 0%, #56ab2f 100%)',
        },
        {
            title: 'Quản lý đơn kiến nghị',
            icon: <AssignmentIcon sx={{ fontSize: 40 }} />,
            path: '/petitions',
            description: 'Xử lý và theo dõi các đơn kiến nghị từ học sinh',
            color: 'linear-gradient(135deg, #ff9a9e 0%, #fad0c4 100%)',
        },
        {
            title: 'Quản lý Khen thưởng / Kỷ luật',
            icon: <EmojiEventsIcon sx={{ fontSize: 40 }} />,
            path: '/rewards',
            description: 'Quản lý các hình thức khen thưởng và kỷ luật',
            color: 'linear-gradient(135deg, #f6d365 0%, #fda085 100%)',
        },
        {
            title: 'Quản lý kết quả học tập',
            icon: <SchoolIcon sx={{ fontSize: 40 }} />,
            path: '/academic-results',
            description: 'Theo dõi và quản lý kết quả học tập của học sinh',
            color: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        },
    ];

    return (
        <Box
            sx={{
                minHeight: '100vh',
                background: 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)',
                py: 8,
                px: { xs: 2, sm: 4, md: 6 },
            }}
        >
            <Box
                sx={{
                    maxWidth: 1200,
                    mx: 'auto',
                    animation: `${fadeIn} 0.8s ease-out`,
                }}
            >
                {/* Header Section */}
                <Box
                    sx={{
                        textAlign: 'center',
                        mb: 6,
                        animation: `${fadeIn} 0.8s ease-out`,
                    }}
                >
                    <Typography
                        variant="h3"
                        component="h1"
                        sx={{
                            fontWeight: 'bold',
                            mb: 2,
                            background: 'linear-gradient(45deg, #2c3e50 30%, #3498db 90%)',
                            WebkitBackgroundClip: 'text',
                            WebkitTextFillColor: 'transparent',
                            animation: `${pulse} 3s infinite`,
                        }}
                    >
                        Chào mừng đến với EduGate
                    </Typography>
                    <Typography
                        variant="h6"
                        sx={{
                            color: 'text.secondary',
                            maxWidth: 800,
                            mx: 'auto',
                            mb: 4,
                        }}
                    >
                        Hệ thống quản lý giáo dục toàn diện, giúp quản lý và theo dõi các hoạt động học tập một cách hiệu quả
                    </Typography>
                </Box>

                {/* Modules Grid */}
                <Grid container spacing={4}>
                    {modules.map((module, index) => (
                        <Grid item xs={12} sm={6} md={4} key={module.path}>
                            <Paper
                                elevation={3}
                                sx={{
                                    p: 3,
                                    minHeight: 320,
                                    display: 'flex',
                                    flexDirection: 'column',
                                    alignItems: 'center',
                                    textAlign: 'center',
                                    background: module.color,
                                    color: 'white',
                                    borderRadius: 4,
                                    transition: 'all 0.3s ease',
                                    animation: `${fadeIn} 0.8s ease-out ${index * 0.1}s both`,
                                    '&:hover': {
                                        transform: 'translateY(-8px)',
                                        boxShadow: '0 12px 20px rgba(0,0,0,0.2)',
                                    },
                                }}
                            >
                                <Box
                                    sx={{
                                        width: 80,
                                        height: 80,
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        mb: 2,
                                        background: 'rgba(255, 255, 255, 0.2)',
                                        borderRadius: '50%',
                                        transition: 'all 0.3s ease',
                                        '&:hover': {
                                            transform: 'scale(1.1) rotate(10deg)',
                                        },
                                    }}
                                >
                                    {module.icon}
                                </Box>
                                <Typography
                                    variant="h5"
                                    component="h2"
                                    sx={{
                                        fontWeight: 'bold',
                                        mb: 1,
                                        textShadow: '0 2px 4px rgba(0,0,0,0.2)',
                                        minHeight: 60,
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                    }}
                                >
                                    {module.title}
                                </Typography>
                                <Typography
                                    variant="body1"
                                    sx={{
                                        mb: 3,
                                        opacity: 0.9,
                                        textShadow: '0 1px 2px rgba(0,0,0,0.2)',
                                        minHeight: 60,
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                    }}
                                >
                                    {module.description}
                                </Typography>
                                <Button
                                    variant="contained"
                                    sx={{
                                        mt: 'auto',
                                        background: 'rgba(255, 255, 255, 0.2)',
                                        color: 'white',
                                        '&:hover': {
                                            background: 'rgba(255, 255, 255, 0.3)',
                                            transform: 'scale(1.05)',
                                        },
                                    }}
                                    onClick={() => navigate(module.path)}
                                >
                                    Truy cập
                                </Button>
                            </Paper>
                        </Grid>
                    ))}
                </Grid>
            </Box>
        </Box>
    );
};

export default Home; 