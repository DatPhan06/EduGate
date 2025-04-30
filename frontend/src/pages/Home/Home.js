import React from 'react';
import { Box, Typography, Grid, Paper, Button } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import {
    Message as MessageIcon,
    Event as EventIcon,
    Assignment as AssignmentIcon,
    EmojiEvents as EmojiEventsIcon,
    School as SchoolIcon,
} from '@mui/icons-material';

const Home = () => {
    const navigate = useNavigate();

    const modules = [
        {
            title: 'Quản lý Tin nhắn',
            icon: <MessageIcon sx={{ fontSize: 40 }} />,
            path: '/messages',
            description: 'Quản lý và theo dõi các tin nhắn trong hệ thống'
        },
        {
            title: 'Quản lý Lịch sự kiện & Thời khóa biểu',
            icon: <EventIcon sx={{ fontSize: 40 }} />,
            path: '/events',
            description: 'Quản lý lịch sự kiện và thời khóa biểu của trường'
        },
        {
            title: 'Quản lý đơn kiến nghị',
            icon: <AssignmentIcon sx={{ fontSize: 40 }} />,
            path: '/petitions',
            description: 'Xử lý và theo dõi các đơn kiến nghị'
        },
        {
            title: 'Quản lý Khen thưởng / Kỷ luật',
            icon: <EmojiEventsIcon sx={{ fontSize: 40 }} />,
            path: '/rewards',
            description: 'Quản lý thông tin khen thưởng và kỷ luật'
        },
        {
            title: 'Quản lý kết quả học tập',
            icon: <SchoolIcon sx={{ fontSize: 40 }} />,
            path: '/academic-results',
            description: 'Theo dõi và quản lý kết quả học tập của học sinh'
        }
    ];

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" gutterBottom>
                Chào mừng đến với EduGate
            </Typography>
            <Typography variant="body1" color="text.secondary" paragraph>
                Hệ thống quản lý giáo dục toàn diện
            </Typography>

            <Grid container spacing={3} sx={{ mt: 2 }}>
                {modules.map((module) => (
                    <Grid item xs={12} sm={6} md={4} key={module.path}>
                        <Paper
                            elevation={3}
                            sx={{
                                p: 3,
                                display: 'flex',
                                flexDirection: 'column',
                                alignItems: 'center',
                                textAlign: 'center',
                                height: '100%',
                                cursor: 'pointer',
                                '&:hover': {
                                    boxShadow: 6,
                                },
                            }}
                            onClick={() => navigate(module.path)}
                        >
                            <Box sx={{ mb: 2, color: 'primary.main' }}>
                                {module.icon}
                            </Box>
                            <Typography variant="h6" gutterBottom>
                                {module.title}
                            </Typography>
                            <Typography variant="body2" color="text.secondary">
                                {module.description}
                            </Typography>
                            <Button
                                variant="contained"
                                sx={{ mt: 2 }}
                                onClick={(e) => {
                                    e.stopPropagation();
                                    navigate(module.path);
                                }}
                            >
                                Truy cập
                            </Button>
                        </Paper>
                    </Grid>
                ))}
            </Grid>
        </Box>
    );
};

export default Home; 