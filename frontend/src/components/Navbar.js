import React, { useState, useCallback } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBell, faUser } from "@fortawesome/free-solid-svg-icons";
import styles from "./Navbar.module.css";
import authService from "../services/authService";
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
} from '@mui/icons-material';

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

const Navbar = () => {
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('md'));
    const navigate = useNavigate();
    const [mobileOpen, setMobileOpen] = useState(false);
    const currentUser = authService.getCurrentUser();

    const expandedDrawerWidth = 240;
    const collapsedDrawerWidth = isMobile ? 0 : 80; // Mobile drawer is full width when open or 0 when closed
    const [isDrawerHovered, setIsDrawerHovered] = useState(false);

    const currentDrawerWidth = isMobile ? expandedDrawerWidth : (isDrawerHovered ? expandedDrawerWidth : collapsedDrawerWidth);

    const handleDrawerToggle = () => {
        setMobileOpen(!mobileOpen);
    };

    const handleNavigation = useCallback((path) => { // useCallback to keep function identity stable
        navigate(path);
        if (isMobile) {
            setMobileOpen(false);
        }
    }, [navigate, isMobile]);

    const handleLogout = useCallback(() => { // useCallback
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
            text: 'Quản lý Tin nhắn',
            icon: <MessageIcon />,
            path: '/messages',
        },
        {
            text: 'Quản lý Lịch sự kiện & Thời khóa biểu',
            icon: <EventIcon />,
            path: '/events',
        },
        {
            text: 'Quản lý đơn kiến nghị',
            icon: <AssignmentIcon />,
            path: '/petitions',
        },
        {
            text: 'Quản lý Khen thưởng / Kỷ luật',
            icon: <EmojiEventsIcon />,
            path: '/rewards',
        },
        {
            text: 'Quản lý kết quả học tập',
            icon: <SchoolIcon />,
            path: '/academic-results',
        },
    ];

    const userActionItems = [
        {
            text: 'Thông tin cá nhân',
            icon: <AccountCircle fontSize="small" />,
            action: () => handleNavigation('/users/me'),
        },
        {
            text: 'Đổi mật khẩu',
            icon: <LockIcon fontSize="small" />,
            action: () => handleNavigation('/users/me#change-password'),
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
                overflowX: 'hidden', // Hide content when collapsing
                transition: theme.transitions.create('width', {
                    easing: theme.transitions.easing.sharp,
                    duration: theme.transitions.duration.enteringScreen,
                }),
                width: currentDrawerWidth, // Dynamic width
            }}
        >
            {/* Logo */}
            <Box sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: isDrawerHovered || isMobile ? 'flex-start' : 'center', // Center logo when collapsed
                mb: 3,
                p: 2,
                pl: isDrawerHovered || isMobile ? 2 : 0, // Adjust padding left for centered icon
                minHeight: '64px', // Ensure consistent height with AppBar
            }}>
                <IconButton 
                    onClick={() => navigate('/')} 
                    sx={{ 
                        color: 'white', 
                        display: isDrawerHovered || isMobile ? 'none' : 'inline-flex', // Show icon instead of text when collapsed
                        p:1.5
                    }}
                >
                    {/* Placeholder for a smaller logo icon if you have one, e.g., an <img /> or another <Icon /> */}
                     <SchoolIcon sx={{ fontSize: 30 }}/> 
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
                        display: isDrawerHovered || isMobile ? 'block' : 'none', // Hide text when collapsed
                        ml: isDrawerHovered || isMobile ? 1 : 0,
                        '&:hover': {
                            animation: 'none',
                            transform: 'scale(1.05)',
                        },
                    }}
                    onClick={() => navigate('/')}
                    noWrap // Prevent text from wrapping
                >
                    EduGate
                </Typography>
            </Box>

            <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.2)', mb: 2 }} />

            {/* Navigation Items */}
            <List sx={{ flexGrow: 1 }}>
                {menuItems.map((item, index) => (
                    <ListItem key={item.path} disablePadding sx={{ display: 'block' }}>
                        <ListItemButton
                            onClick={() => handleNavigation(item.path)}
                            title={item.text} // Show full text on native tooltip when collapsed
                            sx={{
                                minHeight: 48,
                                justifyContent: isDrawerHovered || isMobile ? 'initial' : 'center',
                                px: 2.5,
                                py: 1.5,
                                transition: 'all 0.2s ease-in-out',
                                animation: `${slideIn} 0.5s ease-out ${index * 0.1}s both`,
                                '&:hover': {
                                    backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                    transform: isDrawerHovered || isMobile ? 'translateX(5px)' : 'scale(1.1)', // Different hover for collapsed
                                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.1)',
                                },
                            }}
                        >
                            <ListItemIcon sx={{
                                minWidth: 0, // Allow icon to be centered when text is hidden
                                mr: isDrawerHovered || isMobile ? 3 : 'auto',
                                justifyContent: 'center',
                                color: 'white',
                                transition: theme.transitions.create('margin', {
                                    easing: theme.transitions.easing.sharp,
                                    duration: theme.transitions.duration.enteringScreen,
                                }),
                                '&:hover': {
                                    transform: 'scale(1.2)',
                                },
                            }}>
                                {item.icon}
                            </ListItemIcon>
                            <ListItemText 
                                primary={item.text} 
                                primaryTypographyProps={{ variant: 'body2', noWrap: true }}
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

            {/* User Menu Trigger and Actions at the bottom */}
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
                            px: isDrawerHovered || isMobile ? 1.5 : (collapsedDrawerWidth - 36)/2,
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
                            width: 36,
                            height: 36,
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
                            <Typography variant="subtitle2" noWrap sx={{ color: 'white' }}>
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
            {isMobile && (
                 <AppBar 
                    position="fixed"
                    elevation={0}
                    sx={{ 
                        background: 'linear-gradient(135deg, #2c3e50 0%, #3498db 100%)',
                        color: 'white',
                        borderBottom: 'none',
                        boxShadow: '0 4px 20px rgba(0, 0, 0, 0.1)',
                        width: { sm: `calc(100% - ${currentDrawerWidth}px)` },
                        ml: { sm: `${currentDrawerWidth}px` },
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
                    width: { sm: currentDrawerWidth }, // Adjusted for dynamic width
                    flexShrink: { sm: 0 },
                    transition: theme.transitions.create('width', { // Transition for the nav container itself
                        easing: theme.transitions.easing.sharp,
                        duration: theme.transitions.duration.enteringScreen,
                    }),
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
                            width: expandedDrawerWidth, // Mobile drawer always expanded width when open
                            borderRight: 'none',
                            animation: `${slideIn} 0.3s ease-out`,
                        },
                    }}
                >
                    {drawerContent}
                </Drawer>
                <Drawer
                    variant="permanent"
                    sx={{
                        display: { xs: 'none', sm: 'block' },
                        '& .MuiDrawer-paper': { 
                            boxSizing: 'border-box', 
                            width: currentDrawerWidth, // Adjusted for dynamic width
                            borderRight: 'none',
                            boxShadow: '2px 0 10px rgba(0,0,0,0.1)',
                            overflowX: 'hidden', // Important to prevent scrollbars during transition
                            transition: theme.transitions.create('width', {
                                easing: theme.transitions.easing.sharp,
                                duration: theme.transitions.duration.enteringScreen,
                            }),
                        },
                    }}
                    open
                >
                    {drawerContent}
                </Drawer>
            </Box>
        </Box>
  );
};

export default Navbar;
