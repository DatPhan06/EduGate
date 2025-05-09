import React, { useState } from 'react';
import { 
    Box, Typography, Grid, Paper, Button, useTheme, keyframes,
    Container, Card, CardContent, CardHeader, Divider, Avatar,
    Tab, Tabs, IconButton, Chip, alpha
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import {
    Message as MessageIcon,
    Event as EventIcon,
    Assignment as AssignmentIcon,
    EmojiEvents as EmojiEventsIcon,
    School as SchoolIcon,
    Dashboard as DashboardIcon,
    Notifications as NotificationsIcon,
    CalendarMonth as CalendarMonthIcon,
    ArrowForward as ArrowForwardIcon
} from '@mui/icons-material';
import TimetableViewComponent from '../../components/Timetable/TimetableViewComponent';

// Animation keyframes
const fadeIn = keyframes`
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
`;

const slideIn = keyframes`
    from { opacity: 0; transform: translateX(-20px); }
    to { opacity: 1; transform: translateX(0); }
`;

const pulse = keyframes`
    0% { transform: scale(1); }
    50% { transform: scale(1.03); }
    100% { transform: scale(1); }
`;

const Home = () => {
    const theme = useTheme();
    const navigate = useNavigate();
    const [activeTab, setActiveTab] = useState(0);

    const handleTabChange = (event, newValue) => {
        setActiveTab(newValue);
    };

    const modules = [
        {
            title: 'Quản lý Tin nhắn',
            icon: <MessageIcon />,
            path: '/messaging',
            description: 'Quản lý và theo dõi các tin nhắn trong hệ thống',
            color: theme.palette.primary.main,
            stats: '12 tin nhắn mới'
        },
        {
            title: 'Sự kiện & Lịch',
            icon: <EventIcon />,
            path: '/event-schedule',
            description: 'Quản lý lịch học và các sự kiện trong trường',
            color: theme.palette.success.main,
            stats: '3 sự kiện sắp tới'
        },
        {
            title: 'Đơn kiến nghị',
            icon: <AssignmentIcon />,
            path: '/petitions',
            description: 'Xử lý và theo dõi các đơn kiến nghị từ học sinh',
            color: theme.palette.warning.main,
            stats: '5 đơn chờ xử lý'
        },
        {
            title: 'Khen thưởng & Kỷ luật',
            icon: <EmojiEventsIcon />,
            path: '/rewards-discipline',
            description: 'Quản lý các hình thức khen thưởng và kỷ luật',
            color: theme.palette.error.main,
            stats: '2 mới trong tuần'
        },
        {
            title: 'Kết quả học tập',
            icon: <SchoolIcon />,
            path: '/academic-results',
            description: 'Theo dõi và quản lý kết quả học tập của học sinh',
            color: theme.palette.info.main,
            stats: 'Cập nhật mới nhất'
        },
    ];

    const announcements = [
        { title: "Thông báo nghỉ lễ 30/4 - 1/5", date: "26/04/2023" },
        { title: "Lịch thi học kỳ 2 năm học 2022-2023", date: "15/04/2023" },
        { title: "Thông báo về việc đóng học phí học kỳ 2", date: "03/04/2023" }
    ];

    return (
        <Box
            sx={{
                minHeight: '100vh',
                bgcolor: '#f5f7fa',
                pt: 3,
                pb: 8
            }}
        >
            <Container maxWidth="xl">
                {/* Welcome Banner */}
                <Card
                    elevation={3}
                    sx={{
                        mb: 4,
                        borderRadius: 3,
                        position: 'relative',
                        overflow: 'hidden',
                        background: 'linear-gradient(135deg, #2c3e50 0%, #4CA1AF 100%)',
                        color: 'white',
                        animation: `${fadeIn} 0.8s ease-out`,
                    }}
                >
                    <Box sx={{ p: { xs: 3, md: 5 }, position: 'relative', zIndex: 2 }}>
                        <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 'bold' }}>
                            Chào mừng đến với EduGate
                        </Typography>
                        <Typography variant="h6" sx={{ maxWidth: 800, mb: 3, opacity: 0.9 }}>
                            Hệ thống quản lý giáo dục toàn diện, giúp quản lý và theo dõi các hoạt động học tập một cách hiệu quả
                        </Typography>
                    
                    </Box>
                    <Box 
                        sx={{ 
                            position: 'absolute',
                            top: 0,
                            right: 0,
                            width: { xs: '100%', md: '40%' },
                            height: '100%',
                            background: 'url(/images/school.svg) no-repeat right center',
                            backgroundSize: 'contain',
                            opacity: 0.2,
                            display: { xs: 'none', md: 'block' },
                        }}
                    />
                </Card>

                <Grid container spacing={4}>
                    {/* Left Column */}
                    <Grid item xs={12} md={8}>
                        {/* Timetable Section */}
                        <Card 
                            elevation={2} 
                        sx={{
                            mb: 4,
                                borderRadius: 3, 
                                overflow: 'hidden',
                                animation: `${fadeIn} 0.8s ease-out`,
                            }}
                        >
                            <CardHeader
                                title={
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <CalendarMonthIcon sx={{ mr: 1, color: theme.palette.primary.main }} />
                                        <Typography variant="h6" component="h2">
                                            Thời Khóa Biểu
                    </Typography>
                </Box>
                                }
                                action={
                                    <Button 
                                        size="small" 
                                        endIcon={<ArrowForwardIcon />}
                                        onClick={() => navigate('/timetable-view')}
                                    >
                                        Xem đầy đủ
                                    </Button>
                                }
                                sx={{ 
                                    bgcolor: alpha(theme.palette.primary.light, 0.1),
                                    borderBottom: `1px solid ${alpha(theme.palette.primary.light, 0.2)}`,
                                }}
                            />
                            <CardContent sx={{ p: 0 }}>
                                <TimetableViewComponent />
                            </CardContent>
                        </Card>

                        {/* Quick Access Modules */}
                        <Typography variant="h6" component="h2" gutterBottom sx={{ pl: 1, display: 'flex', alignItems: 'center' }}>
                            <DashboardIcon sx={{ mr: 1, color: theme.palette.primary.main }} />
                            Truy Cập Nhanh
                        </Typography>
                        <Grid container spacing={3}>
                    {modules.map((module, index) => (
                        <Grid item xs={12} sm={6} md={4} key={module.path}>
                                    <Card
                                        elevation={2}
                                sx={{
                                            borderRadius: 3,
                                    transition: 'all 0.3s ease',
                                            height: '100%',
                                    animation: `${fadeIn} 0.8s ease-out ${index * 0.1}s both`,
                                    '&:hover': {
                                        transform: 'translateY(-8px)',
                                                boxShadow: '0 8px 20px rgba(0,0,0,0.1)',
                                    },
                                            display: 'flex',
                                            flexDirection: 'column',
                                }}
                            >
                                <Box
                                    sx={{
                                                p: 2, 
                                                bgcolor: alpha(module.color, 0.1),
                                        display: 'flex',
                                        alignItems: 'center',
                                                borderBottom: `1px solid ${alpha(module.color, 0.2)}`
                                            }}
                                        >
                                            <Avatar 
                                    sx={{
                                                    bgcolor: module.color,
                                                    mr: 1.5,
                                                }}
                                            >
                                                {module.icon}
                                            </Avatar>
                                            <Typography variant="subtitle1" fontWeight="bold">
                                    {module.title}
                                </Typography>
                                        </Box>
                                        <CardContent sx={{ pt: 1.5, pb: 1, flexGrow: 1 }}>
                                            <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                                    {module.description}
                                </Typography>
                                            {module.stats && (
                                                <Chip 
                                                    label={module.stats} 
                                                    size="small" 
                                                    sx={{ 
                                                        bgcolor: alpha(module.color, 0.1),
                                                        color: module.color,
                                                        fontWeight: 'bold'
                                                    }} 
                                                />
                                            )}
                                        </CardContent>
                                        <Box sx={{ p: 2, pt: 0 }}>
                                <Button
                                                fullWidth 
                                                variant="outlined"
                                                size="small"
                                                onClick={() => navigate(module.path)}
                                    sx={{
                                                    color: module.color, 
                                                    borderColor: alpha(module.color, 0.5),
                                        '&:hover': {
                                                        borderColor: module.color,
                                                        bgcolor: alpha(module.color, 0.05)
                                                    }
                                                }}
                                >
                                    Truy cập
                                </Button>
                                        </Box>
                                    </Card>
                                </Grid>
                            ))}
                        </Grid>
                    </Grid>

                    {/* Right Sidebar */}
                    <Grid item xs={12} md={4}>
                        {/* Announcements Panel */}
                        <Card 
                            elevation={2} 
                            sx={{ 
                                mb: 4,
                                borderRadius: 3,
                                animation: `${slideIn} 0.8s ease-out`,
                            }}
                        >
                            <CardHeader
                                title={
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <NotificationsIcon sx={{ mr: 1, color: theme.palette.warning.main }} />
                                        <Typography variant="h6" component="h2">
                                            Thông Báo Mới
                                        </Typography>
                                    </Box>
                                }
                                action={
                                    <IconButton size="small">
                                        <ArrowForwardIcon />
                                    </IconButton>
                                }
                                sx={{ 
                                    bgcolor: alpha(theme.palette.warning.light, 0.1),
                                    borderBottom: `1px solid ${alpha(theme.palette.warning.light, 0.2)}`,
                                }}
                            />
                            <CardContent sx={{ px: 2, py: 0 }}>
                                {announcements.map((item, index) => (
                                    <React.Fragment key={index}>
                                        <Box sx={{ py: 2 }}>
                                            <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
                                                <Typography variant="subtitle2" sx={{ fontWeight: 'bold' }}>
                                                    {item.title}
                                                </Typography>
                                                <Typography variant="caption" color="text.secondary">
                                                    {item.date}
                                                </Typography>
                                            </Box>
                                            <Button 
                                                size="small" 
                                                sx={{ pl: 0, color: theme.palette.primary.main }}
                                            >
                                                Xem chi tiết
                                            </Button>
                                        </Box>
                                        {index < announcements.length - 1 && (
                                            <Divider />
                                        )}
                                    </React.Fragment>
                                ))}
                            </CardContent>
                            <Box sx={{ p: 2, textAlign: 'center' }}>
                                <Button 
                                    variant="text" 
                                    size="small"
                                    endIcon={<ArrowForwardIcon />}
                                    sx={{ color: theme.palette.warning.main }}
                                >
                                    Xem tất cả thông báo
                                </Button>
                            </Box>
                        </Card>

                        {/* System Information Card */}
                        <Card 
                            elevation={2} 
                            sx={{ 
                                borderRadius: 3,
                                animation: `${slideIn} 0.8s ease-out`,
                            }}
                        >
                            <CardHeader
                                title={
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <SchoolIcon sx={{ mr: 1, color: theme.palette.info.main }} />
                                        <Typography variant="h6" component="h2">
                                            Thông Tin Hệ Thống
                                        </Typography>
                                    </Box>
                                }
                                sx={{ 
                                    bgcolor: alpha(theme.palette.info.light, 0.1),
                                    borderBottom: `1px solid ${alpha(theme.palette.info.light, 0.2)}`,
                                }}
                            />
                            <CardContent>
                                <Box sx={{ mb: 2 }}>
                                    <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Năm học hiện tại</Typography>
                                    <Typography variant="body1" sx={{ fontWeight: 'bold' }}>2022-2023</Typography>
                                </Box>
                                <Box sx={{ mb: 2 }}>
                                    <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Học kỳ hiện tại</Typography>
                                    <Typography variant="body1" sx={{ fontWeight: 'bold' }}>Học kỳ 2</Typography>
                                </Box>
                                <Box>
                                    <Typography variant="subtitle2" sx={{ mb: 0.5 }}>Trạng thái hệ thống</Typography>
                                    <Chip 
                                        label="Hoạt động" 
                                        size="small" 
                                        sx={{ 
                                            bgcolor: alpha(theme.palette.success.main, 0.1),
                                            color: theme.palette.success.main,
                                            fontWeight: 'bold'
                                        }} 
                                    />
                                </Box>
                            </CardContent>
                        </Card>
                    </Grid>
                </Grid>
            </Container>
        </Box>
    );
};

export default Home; 