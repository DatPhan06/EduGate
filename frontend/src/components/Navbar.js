import React, { useState, useCallback, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBell, faUser } from "@fortawesome/free-solid-svg-icons";
import styles from "./Navbar.module.css";
import authService from "../services/authService";
import axios from 'axios';
import {
    AppBar,
    Toolbar,
    Typography,
    Button,
    Box,
    IconButton,
    MenuItem,
    ListItemIcon,
    ListItemText,
    Avatar,
    Tooltip,
    Divider,
    useMediaQuery,
    useTheme,
    keyframes,
    Drawer,
    List,
    ListItem,
    ListItemButton,
} from '@mui/material';
import {
    Message as MessageIcon,
    Event as EventIcon,
    Assignment as AssignmentIcon,
    EmojiEvents as EmojiEventsIcon,
    School as SchoolIcon,
    Menu as MenuIcon,
    AccountCircle,
    Logout,
    Lock as LockIcon,
    Home as HomeIcon,
    People as PeopleIcon,
    Book as DailyLogIcon,
    Assessment as ReportsIcon,
    SupervisorAccount as PrincipalIcon,
    ClassOutlined as ClassIcon,
    Announcement as AnnouncementIcon,
    Grading as GradingIcon,
    MenuBook as MenuBookIcon,

} from '@mui/icons-material';
import { useBGHTeacher } from '../contexts/BGHTeacherContext';

/**
 * Thành phần Navbar hiển thị thanh điều hướng của trang web.
 * Bao gồm các mục chính như Đặt Vé, Thông Tin Hành Trình, Khám Phá, QAirline và Tài Khoản.
 *
 * @component
 * @returns {JSX.Element} Thành phần Navbar.
 */
/**
 * Navbar component that renders the navigation bar with various menu items and user account options.
 * It also handles fetching notifications and user data, and displays notifications in a modal.
 *
 * @component
 * @returns {JSX.Element} The rendered Navbar component.
 *
 * @example
 * return (
 *   <Navbar />
 * )
 *
 * @function
 * @name Navbar
 *
 * @description
 * The Navbar component manages the state for menu and notification toggles, fetches user data and notifications,
 * and displays them in a dropdown and modal. It also provides navigation links for different sections of the application.
 *
 * @property {boolean} isMenuOpen - State to track if the menu is open.
 * @property {function} setIsMenuOpen - Function to set the state of isMenuOpen.
 * @property {boolean} isNotificationOpen - State to track if the notification dropdown is open.
 * @property {function} setIsNotificationOpen - Function to set the state of isNotificationOpen.
 * @property {Array} notifications - State to store the list of notifications.
 * @property {function} setNotifications - Function to set the state of notifications.
 * @property {Object|null} currentUser - State to store the current user data.
 * @property {function} setCurrentUser - Function to set the state of currentUser.
 * @property {Object|null} selectedNotification - State to store the selected notification for the modal.
 * @property {function} setSelectedNotification - Function to set the state of selectedNotification.
 * @property {boolean} isModalOpen - State to track if the notification modal is open.
 * @property {function} setIsModalOpen - Function to set the state of isModalOpen.
 * @property {string|null} token - The authentication token retrieved from localStorage.
 * @property {boolean} isLoggedIn - Boolean indicating if the user is logged in.
 *
 * @method fetchNotifications
 * @description Fetches notifications from the server and updates the notifications state.
 *
 * @method fetchUserAndNotifications
 * @description Fetches the current user data and their notifications if the user is logged in.
 *
 * @method toggleNotification
 * @description Toggles the state of the notification dropdown.
 *
 * @method toggleMenu
 * @description Toggles the state of the menu.
 *
 * @method handleNotificationClick
 * @description Handles the click event on a notification item, sets the selected notification, and opens the modal.
 *
 * @method handleCloseModal
 * @description Handles the event to close the notification modal.
 */

// Animation keyframes
const pulse = keyframes`
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
`;

const slideIn = keyframes`
    from { transform: translateY(-10px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
`;

const Navbar = ({ onLayoutChange }) => {
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('md'));
    const navigate = useNavigate();
    const [mobileOpen, setMobileOpen] = useState(false);
    const currentUser = authService.getCurrentUser();
    // Check if the current user is a BGH teacher
    const { isBGHTeacher } = useBGHTeacher();

    const expandedDrawerWidth = 260;
    const collapsedDrawerWidth = isMobile ? 0 : 60;
    const [isDrawerHovered, setIsDrawerHovered] = useState(false);

    // Use a fixed layout width for the main content area
    const fixedLayoutWidth = collapsedDrawerWidth;
    
    // Visual width for the drawer that changes on hover
    const visualDrawerWidth = isMobile ? expandedDrawerWidth : (isDrawerHovered ? expandedDrawerWidth : collapsedDrawerWidth);

    useEffect(() => {
        if (onLayoutChange) {
            // Always use the fixed width for layout calculations
            const widthForMainLayout = isMobile ? 0 : fixedLayoutWidth;
            onLayoutChange(widthForMainLayout, isMobile);
        }
    }, [fixedLayoutWidth, isMobile, onLayoutChange]);

    const handleDrawerToggle = () => {
        setMobileOpen(!mobileOpen);
    };

    const handleNavigation = useCallback((path) => {
        navigate(path);
        if (isMobile) {
            setMobileOpen(false);
        }
    }, [navigate, isMobile]);

    const handleLogout = useCallback(() => {
        authService.logout();
        navigate('/login');
        if (isMobile) {
            setMobileOpen(false);
        }
    }, [navigate, isMobile]);

    const handleDrawerMouseEnter = () => {
        if (!isMobile) {
            setIsDrawerHovered(true);
        }
    };

    const handleDrawerMouseLeave = () => {
        if (!isMobile) {
            setIsDrawerHovered(false);
        }
    };

    const menuItems = [
        {
            text: 'Trang chủ',
            icon: <HomeIcon />,
            path: '/home',
            roles: [],
        },
        {
            text: 'Quản lý Người dùng',
            icon: <PeopleIcon />,
            path: '/user-management',
            roles: ['admin'],
        },
        {
            text: 'Quản lý Lớp học',
            icon: <ClassIcon />,
            path: '/class-management',
            roles: ['admin'],
        },
        {
            text: 'Quản lý Phòng ban',
            icon: <PeopleIcon />,
            path: '/department-management',
            roles: ['admin'],
        },
        {
            text: 'Tin nhắn',
            icon: <MessageIcon />,
            path: '/messaging',
            roles: ['teacher', 'parent', 'student'],
        },
        {
            text: 'Quản lý cuộc trò chuyện',
            icon: <MessageIcon />,
            path: '/conversation-monitor',
            roles: ['admin'],
        },
        {
            text: 'Quản lý lịch học',
            icon: <EventIcon />,
            path: '/timetable-management',
            roles: ['admin'],
        },
        {
            text: 'Quản lý điểm',
            icon: <GradingIcon />,
            path: '/grade-management',
            roles: ['admin'],
        },
        {
            text: 'Lớp chủ nhiệm',
            icon: <MenuBookIcon />,
            path: '/teacher/homeroom',
            roles: ['teacher'],
        },
        {
            text: 'Quản lý điểm môn học',
            icon: <GradingIcon />,
            path: '/teacher/subjects',
            roles: ['teacher'],
        },
        {
            text: 'Lịch & Sự kiện',
            icon: <EventIcon />,
            path: '/event-schedule',
            roles: ['teacher', 'parent', 'student'],
        },
        {
            text: 'Thông báo lớp',
            icon: <AnnouncementIcon />,
            path: '/teacher/class-events',
            roles: ['teacher'],
        },
        {
            text: 'Thông báo lớp',
            icon: <AnnouncementIcon />,
            path: '/student/class-events',
            roles: ['student'],
        },
        {
            text: 'Khen thưởng/Kỷ luật',
            icon: <EmojiEventsIcon />,
            path: '/rewards-discipline',
            roles: ['admin', 'teacher', 'parent', 'student'],
        },
        {
            text: 'Sổ liên lạc',
            icon: <DailyLogIcon />,
            path: '/daily-log',
            roles: ['teacher', 'parent', 'student'],
        },
        {
            text: 'Kết quả học tập',
            icon: <SchoolIcon />,
            path: '/academic-results',
            roles: ['teacher', 'parent', 'student'],
        },
        {
            text: 'Xem điểm số',
            icon: <GradingIcon />,
            path: '/student/grades',
            roles: ['student'],
        },
        {
            text: 'Báo cáo & Thống kê',
            icon: <ReportsIcon />,
            path: '/reports-statistics',
            roles: ['admin', 'principal', 'bgh', 'teacher'],
        },
        {
            text: 'Đơn thỉnh cầu',
            icon: <AssignmentIcon />,
            path: '/petitions',
            roles: ['parent'],
        },
        {
            text: 'Quản lý đơn thỉnh cầu',
            icon: <AssignmentIcon />,
            path: '/petitions-management',
            roles: ['admin'],
        },
        {
            text: 'Đơn thỉnh cầu BGH',
            icon: <AssignmentIcon />,
            path: '/bgh-petitions',
            roles: ['teacher'],
            bghOnly: true,
        },
        {
            text: 'Giám sát (BGH)',
            icon: <PrincipalIcon />,
            path: '/principal-dashboard',
            roles: ['principal', 'bgh'],
        },
    ];

    const userRole = currentUser?.role;
    const accessibleMenuItems = menuItems.filter(item => {
        // Nếu menu item có flag bghOnly = true
        if (item.bghOnly) {
            // Chỉ hiển thị khi:
            // 1. user là giáo viên (userRole === 'teacher')
            // 2. VÀ user là giáo viên BGH (isBGHTeacher === true)
            return userRole === 'teacher' && isBGHTeacher;
        }
        
        // Với các menu item thông thường:
        // 1. Hoặc là menu public (roles.length === 0)
        // 2. Hoặc user có role nằm trong danh sách roles của menu item
        return item.roles.length === 0 || (userRole && item.roles.includes(userRole));
    });

    const userActionItems = [
        {
            text: 'Thông tin cá nhân',
            icon: <AccountCircle fontSize="small" />,
            action: () => handleNavigation('/profile'),
        },

        {
            text: 'Đăng xuất',
            icon: <Logout fontSize="small" />,
            action: handleLogout,
        },
    ];

    const drawerContent = (
        <Box
            onMouseEnter={handleDrawerMouseEnter}
            onMouseLeave={handleDrawerMouseLeave}
            sx={{
                display: 'flex',
                flexDirection: 'column',
                height: '100%',
                background: 'linear-gradient(180deg, #2c3e50 0%, #3498db 100%)',
                color: 'white',
                paddingTop: '20px',
                overflowX: 'hidden',
                transition: theme.transitions.create('width', {
                    easing: theme.transitions.easing.sharp,
                    duration: theme.transitions.duration.enteringScreen,
                }),
                width: visualDrawerWidth,
                position: 'absolute',
                zIndex: 10,
            }}
        >
            <Box sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: isDrawerHovered || isMobile ? 'flex-start' : 'center',
                mb: 3,
                p: 2,
                pl: isDrawerHovered || isMobile ? 2 : 0,
                minHeight: '64px',
            }}>
                <IconButton 
                    onClick={() => navigate('/')} 
                    sx={{ 
                        color: 'white', 
                        display: isDrawerHovered || isMobile ? 'none' : 'inline-flex',
                        p:1.5
                    }}
                >
                    <SchoolIcon sx={{ fontSize: 32 }}/>
                </IconButton>
                <Typography
                    variant="h5"
                    component="div"
                    sx={{
                        fontWeight: 'bold',
                        cursor: 'pointer',
                        textShadow: '0 2px 4px rgba(0,0,0,0.2)',
                        background: 'linear-gradient(45deg, #fff 30%, #e0e0e0 90%)',
                        WebkitBackgroundClip: 'text',
                        WebkitTextFillColor: 'transparent',
                        animation: `${pulse} 2s infinite`,
                        display: isDrawerHovered || isMobile ? 'block' : 'none',
                        ml: isDrawerHovered || isMobile ? 1 : 0,
                        fontSize: '1.5rem',
                        '&:hover': {
                            animation: 'none',
                            transform: 'scale(1.05)',
                        },
                    }}
                    onClick={() => navigate('/')}
                    noWrap
                >
                    EduGate
                </Typography>
            </Box>

            <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.2)', mb: 2 }} />

            <List sx={{ flexGrow: 1 }}>
                {accessibleMenuItems.map((item, index) => (
                    <ListItem key={item.path} disablePadding sx={{ display: 'block' }}>
                        <ListItemButton
                            onClick={() => handleNavigation(item.path)}
                            title={item.text}
                            sx={{
                                minHeight: 48,
                                justifyContent: isDrawerHovered || isMobile ? 'initial' : 'center',
                                px: isDrawerHovered || isMobile ? 2.5 : 1.5,
                                py: 1.5,
                                transition: 'all 0.2s ease-in-out',
                                animation: `${slideIn} 0.5s ease-out ${index * 0.1}s both`,
                                '&:hover': {
                                    backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                    transform: isDrawerHovered || isMobile ? 'translateX(5px)' : 'scale(1.1)',
                                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.1)',
                                },
                            }}
                        >
                            <ListItemIcon sx={{
                                minWidth: 0,
                                mr: isDrawerHovered || isMobile ? 3 : 'auto',
                                justifyContent: 'center',
                                color: 'white',
                                fontSize: '1.2rem',
                                transition: theme.transitions.create('margin', {
                                    easing: theme.transitions.easing.sharp,
                                    duration: theme.transitions.duration.enteringScreen,
                                }),
                                '&:hover': {
                                    transform: 'scale(1.2)',
                                },
                                '& .MuiSvgIcon-root': {
                                    fontSize: '1.4rem',
                                }
                            }}>
                                {item.icon}
                            </ListItemIcon>
                            <ListItemText 
                                primary={item.text} 
                                primaryTypographyProps={{ 
                                    variant: 'body1',
                                    noWrap: true,
                                    sx: { fontWeight: 'medium' }
                                }}
                                sx={{ 
                                    opacity: isDrawerHovered || isMobile ? 1 : 0,
                                    transition: theme.transitions.create('opacity', {
                                        easing: theme.transitions.easing.sharp,
                                        duration: theme.transitions.duration.enteringScreen,
                                    }),
                                    color: 'white',
                                }}
                            />
                        </ListItemButton>
                    </ListItem>
                ))}
            </List>

            <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.2)', mt: 'auto' }} />

            <Box sx={{
                mt: 'auto',
                transition: theme.transitions.create('padding', {
                    easing: theme.transitions.easing.sharp,
                    duration: theme.transitions.duration.enteringScreen,
                }),
            }}>
                <Tooltip title={isDrawerHovered || isMobile ? "Tài khoản" : `${currentUser?.FirstName} ${currentUser?.LastName}`}>
                    <Box
                        sx={{
                            display: 'flex',
                            alignItems: 'center',
                            cursor: 'default',
                            p: 1.5,
                            px: isDrawerHovered || isMobile ? 1.5 : (collapsedDrawerWidth - 40)/2,
                            borderRadius: 1,
                            backgroundColor: 'rgba(255, 255, 255, 0.1)', 
                            transition: 'all 0.3s ease',
                            overflow: 'hidden',
                            justifyContent: isDrawerHovered || isMobile ? 'flex-start' : 'center',
                            '&:hover': {
                                backgroundColor: 'rgba(255, 255, 255, 0.2)',
                            },
                        }}
                    >
                        <Avatar sx={{
                            width: 40,
                            height: 40,
                            bgcolor: 'rgba(255, 255, 255, 0.2)',
                            mr: isDrawerHovered || isMobile ? 1.5 : 0,
                            transition: theme.transitions.create(['margin', 'transform'], {
                                easing: theme.transitions.easing.sharp,
                                duration: theme.transitions.duration.enteringScreen,
                            }),
                        }}>
                            <AccountCircle />
                        </Avatar>
                        <Box sx={{
                            overflow: 'hidden',
                            opacity: isDrawerHovered || isMobile ? 1 : 0,
                            width: isDrawerHovered || isMobile ? 'auto' : 0,
                            transition: theme.transitions.create(['opacity', 'width'], {
                                easing: theme.transitions.easing.sharp,
                                duration: theme.transitions.duration.enteringScreen,
                            }),
                            ml: isDrawerHovered || isMobile ? 1 : 0,
                        }}>
                            <Typography variant="subtitle2" noWrap sx={{ color: 'white', fontWeight: 'medium' }}>
                                {currentUser?.FirstName} {currentUser?.LastName}
                            </Typography>
                            <Typography variant="caption" noWrap sx={{ color: 'rgba(255, 255, 255, 0.7)' }}>
                                {currentUser?.Email}
                            </Typography>
                        </Box>
                    </Box>
                </Tooltip>

                <Box sx={{
                    overflow: 'hidden',
                    height: isDrawerHovered || isMobile ? 'auto' : 0,
                    opacity: isDrawerHovered || isMobile ? 1 : 0,
                    transition: theme.transitions.create(['height', 'opacity'], {
                        easing: theme.transitions.easing.sharp,
                        duration: theme.transitions.duration.enteringScreen,
                    }),
                    mt:1,
                }}>
                    {userActionItems.map((item, index) => (
                        <ListItemButton
                            key={item.text}
                            onClick={item.action}
                            sx={{
                                py: 1,
                                px: 2.5, 
                                justifyContent: 'flex-start',
                                transition: 'all 0.3s ease',
                                '&:hover': {
                                    backgroundColor: 'rgba(255, 255, 255, 0.25)',
                                    transform: 'translateX(3px)',
                                },
                            }}
                        >
                            <ListItemIcon sx={{
                                minWidth: 36,
                                color: 'white',
                                mr:1
                            }}>
                                {item.icon}
                            </ListItemIcon>
                            <ListItemText 
                                primary={item.text} 
                                primaryTypographyProps={{ variant: 'body2', noWrap: true, sx: {color: 'white'} }}
                            />
                        </ListItemButton>
                    ))}
                </Box>
            </Box>
        </Box>
    );

    return (
        <Box sx={{ display: 'flex' }}>
            {/* Dark overlay when drawer is hovered */}
            {!isMobile && isDrawerHovered && (
                <Box 
                    sx={{
                        position: 'fixed',
                        top: 0,
                        left: 0,
                        width: '100%',
                        height: '100%',
                        backgroundColor: 'rgba(0, 0, 0, 0.4)',
                        zIndex: 1050,
                        transition: 'all 0.3s ease',
                        opacity: isDrawerHovered ? 1 : 0,
                        pointerEvents: 'none',
                        marginLeft: `${collapsedDrawerWidth}px`,
                    }}
                />
            )}
            
            {isMobile && (
                <AppBar 
                    position="fixed"
                    elevation={0}
                    sx={{ 
                        background: 'linear-gradient(135deg, #2c3e50 0%, #3498db 100%)',
                        color: 'white',
                        borderBottom: 'none',
                        boxShadow: '0 4px 20px rgba(0, 0, 0, 0.1)',
                        width: { sm: `calc(100% - ${fixedLayoutWidth}px)` },
                        ml: { sm: `${fixedLayoutWidth}px` },
                    }}
                >
                    <Toolbar>
                        <IconButton
                            color="inherit"
                            aria-label="open drawer"
                            edge="start"
                            onClick={handleDrawerToggle}
                            sx={{ 
                                mr: 2, 
                                display: { sm: 'none' },
                                transition: 'all 0.3s ease',
                                '&:hover': {
                                    transform: 'rotate(90deg)',
                                    backgroundColor: 'rgba(255, 255, 255, 0.2)',
                                },
                            }}
                        >
                            <MenuIcon />
                        </IconButton>
                         <Typography
                            variant="h6"
                            component="div"
                            onClick={() => navigate('/')}
                             sx={{
                                fontWeight: 'bold',
                                cursor: 'pointer',
                                textShadow: '0 2px 4px rgba(0,0,0,0.2)',
                                background: 'linear-gradient(45deg, #fff 30%, #e0e0e0 90%)',
                                WebkitBackgroundClip: 'text',
                                WebkitTextFillColor: 'transparent',
                                animation: `${pulse} 2s infinite`,
                                '&:hover': {
                                    animation: 'none',
                                    transform: 'scale(1.05)',
                                },
                            }}
                        >
                            EduGate
                        </Typography>
                    </Toolbar>
                </AppBar>
            )}

            <Box
                component="nav"
                sx={{ 
                    width: { sm: fixedLayoutWidth },
                    flexShrink: { sm: 0 },
                    position: 'relative',
                }}
                aria-label="mailbox folders"
            >
                <Drawer
                    variant="temporary"
                    open={isMobile && mobileOpen}
                    onClose={handleDrawerToggle}
                    ModalProps={{
                        keepMounted: true,
                    }}
                    sx={{
                        display: { xs: 'block', sm: 'none' },
                        '& .MuiDrawer-paper': { 
                            boxSizing: 'border-box', 
                            width: expandedDrawerWidth,
                            borderRight: 'none',
                            animation: `${slideIn} 0.3s ease-out`,
                        },
                    }}
                >
                    {drawerContent}
                </Drawer>
                <Box
                    sx={{
                        display: { xs: 'none', sm: 'block' },
                        position: 'fixed',
                        top: 0,
                        left: 0,
                        height: '100%',
                        zIndex: 1100,
                    }}
                >
                    {drawerContent}
                </Box>
            </Box>
        </Box>
  );
};

export default Navbar;
