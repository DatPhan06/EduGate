import React, { useState } from "react";
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
    Menu,
    MenuItem,
    ListItemIcon,
    ListItemText,
    Avatar,
    Tooltip,
    Divider,
    useMediaQuery,
    useTheme,
    keyframes,
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
    const [anchorEl, setAnchorEl] = useState(null);
    const [userMenuAnchor, setUserMenuAnchor] = useState(null);
    const currentUser = authService.getCurrentUser();

    const handleMenuClick = (event) => {
        setAnchorEl(event.currentTarget);
    };

    const handleUserMenuClick = (event) => {
        setUserMenuAnchor(event.currentTarget);
    };

    const handleMenuClose = () => {
        setAnchorEl(null);
    };

    const handleUserMenuClose = () => {
        setUserMenuAnchor(null);
    };

    const handleNavigation = (path) => {
        navigate(path);
        handleMenuClose();
    };

    const handleLogout = () => {
        authService.logout();
        navigate('/login');
        handleUserMenuClose();
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

  return (
        <AppBar 
            position="static" 
            elevation={0}
            sx={{ 
                background: 'linear-gradient(135deg, #2c3e50 0%, #3498db 100%)',
                color: 'white',
                borderBottom: 'none',
                boxShadow: '0 4px 20px rgba(0, 0, 0, 0.1)',
                animation: `${slideIn} 0.5s ease-out`,
            }}
        >
            <Toolbar sx={{ justifyContent: 'space-between' }}>
                {/* Left side - Logo and Menu */}
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                    <IconButton
                        edge="start"
                        color="inherit"
                        aria-label="menu"
                        onClick={handleMenuClick}
                        sx={{ 
                            mr: 2,
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
                        onClick={() => navigate('/')}
                    >
                        EduGate
                    </Typography>
                </Box>

                {/* Center - Navigation Items (Desktop) */}
                {!isMobile && (
                    <Box sx={{ display: 'flex', gap: 2 }}>
                        {menuItems.map((item, index) => (
                            <Box
                                key={item.path}
                                sx={{
                                    display: 'flex',
                                    alignItems: 'center',
                                    cursor: 'pointer',
                                    p: 1,
                                    borderRadius: 1,
                                    transition: 'all 0.3s ease',
                                    animation: `${slideIn} 0.5s ease-out ${index * 0.1}s both`,
                                    '&:hover': {
                                        backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                        transform: 'translateY(-2px) scale(1.05)',
                                        boxShadow: '0 4px 8px rgba(0, 0, 0, 0.2)',
                                    },
                                }}
                                onClick={() => handleNavigation(item.path)}
                            >
                                <ListItemIcon sx={{ 
                                    minWidth: 40, 
                                    color: 'white',
                                    transition: 'transform 0.3s ease',
                                    '&:hover': {
                                        transform: 'scale(1.2) rotate(5deg)',
                                    },
                                }}>
                                    {item.icon}
                                </ListItemIcon>
                                <Typography variant="body2" sx={{ 
                                    color: 'white',
                                    transition: 'all 0.3s ease',
                                    '&:hover': {
                                        letterSpacing: '0.5px',
                                    },
                                }}>
                                    {item.text}
                                </Typography>
                            </Box>
                        ))}
                    </Box>
                )}

                {/* Right side - User Menu */}
                <Box>
                    <Tooltip title="Tài khoản">
                        <IconButton
                            onClick={handleUserMenuClick}
                            size="small"
                            sx={{ 
                                ml: 2,
                                backgroundColor: 'rgba(255, 255, 255, 0.1)',
                                transition: 'all 0.3s ease',
                                '&:hover': {
                                    backgroundColor: 'rgba(255, 255, 255, 0.2)',
                                    transform: 'scale(1.1)',
                                    boxShadow: '0 0 15px rgba(255, 255, 255, 0.3)',
                                },
                            }}
                        >
                            <Avatar sx={{ 
                                width: 32, 
                                height: 32, 
                                bgcolor: 'rgba(255, 255, 255, 0.2)',
                                transition: 'all 0.3s ease',
                                '&:hover': {
                                    transform: 'rotate(360deg)',
                                },
                            }}>
                                <AccountCircle />
                            </Avatar>
                        </IconButton>
                    </Tooltip>
                </Box>

                {/* Mobile Menu */}
                <Menu
                    anchorEl={anchorEl}
                    open={Boolean(anchorEl)}
                    onClose={handleMenuClose}
                    PaperProps={{
                        sx: {
                            mt: 1.5,
                            minWidth: 200,
                            background: 'linear-gradient(135deg, #2c3e50 0%, #3498db 100%)',
                            color: 'white',
                            animation: `${slideIn} 0.3s ease-out`,
                        },
                    }}
                >
                    {menuItems.map((item, index) => (
                        <MenuItem
                            key={item.path}
                            onClick={() => handleNavigation(item.path)}
                            sx={{
                                transition: 'all 0.3s ease',
                                animation: `${slideIn} 0.3s ease-out ${index * 0.1}s both`,
                                '&:hover': {
                                    backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                    transform: 'translateX(5px)',
                                },
                            }}
                        >
                            <ListItemIcon sx={{ 
                                color: 'white',
                                transition: 'transform 0.3s ease',
                                '&:hover': {
                                    transform: 'scale(1.2)',
                                },
                            }}>
                                {item.icon}
                            </ListItemIcon>
                            <ListItemText primary={item.text} />
                        </MenuItem>
                    ))}
                </Menu>

                {/* User Menu */}
                <Menu
                    anchorEl={userMenuAnchor}
                    open={Boolean(userMenuAnchor)}
                    onClose={handleUserMenuClose}
                    PaperProps={{
                        sx: {
                            mt: 1.5,
                            minWidth: 200,
                            background: 'linear-gradient(135deg, #2c3e50 0%, #3498db 100%)',
                            color: 'white',
                            animation: `${slideIn} 0.3s ease-out`,
                        },
                    }}
                >
                    <Box sx={{ 
                        p: 2,
                        background: 'rgba(255, 255, 255, 0.05)',
                        borderRadius: '4px 4px 0 0',
                    }}>
                        <Typography variant="subtitle1" noWrap sx={{ 
                            color: 'white',
                            textShadow: '0 2px 4px rgba(0,0,0,0.2)',
                        }}>
                            {currentUser?.FirstName} {currentUser?.LastName}
                        </Typography>
                        <Typography variant="body2" sx={{ 
                            color: 'rgba(255, 255, 255, 0.7)',
                            textShadow: '0 1px 2px rgba(0,0,0,0.2)',
                        }} noWrap>
                            {currentUser?.Email}
                        </Typography>
                    </Box>
                    <MenuItem 
                        onClick={() => {
                            handleUserMenuClose();
                            navigate('/users/me');
                        }}
                        sx={{
                            transition: 'all 0.3s ease',
                            '&:hover': {
                                backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                transform: 'translateX(5px)',
                            },
                        }}
                    >
                        <ListItemIcon sx={{ 
                            color: 'white',
                            transition: 'transform 0.3s ease',
                            '&:hover': {
                                transform: 'scale(1.2)',
                            },
                        }}>
                            <AccountCircle fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary="Thông tin cá nhân" />
                    </MenuItem>
                    <MenuItem 
                        onClick={() => {
                            handleUserMenuClose();
                            navigate('/users/me#change-password');
                        }}
                        sx={{
                            transition: 'all 0.3s ease',
                            '&:hover': {
                                backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                transform: 'translateX(5px)',
                            },
                        }}
                    >
                        <ListItemIcon sx={{ 
                            color: 'white',
                            transition: 'transform 0.3s ease',
                            '&:hover': {
                                transform: 'scale(1.2)',
                            },
                        }}>
                            <LockIcon fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary="Đổi mật khẩu" />
                    </MenuItem>
                    <Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.1)' }} />
                    
                    <MenuItem 
                        onClick={handleLogout}
                        sx={{
                            transition: 'all 0.3s ease',
                            '&:hover': {
                                backgroundColor: 'rgba(255, 255, 255, 0.15)',
                                transform: 'translateX(5px)',
                              },
                            }}
                          >
                        <ListItemIcon sx={{ 
                            color: 'white',
                            transition: 'transform 0.3s ease',
                            '&:hover': {
                                transform: 'scale(1.2)',
                            },
                        }}>
                            <Logout fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary="Đăng xuất" />
                    </MenuItem>
                </Menu>
            </Toolbar>
        </AppBar>
  );
};

export default Navbar;
