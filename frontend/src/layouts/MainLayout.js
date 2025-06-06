import React, { useState, useEffect, useCallback } from 'react';
import { Outlet } from 'react-router-dom';
import Navbar from '../components/Navbar';
import { Box, useMediaQuery, useTheme, Toolbar } from '@mui/material';

const MainLayout = () => {
    const theme = useTheme();
    // Sử dụng isMobileQuery để theo dõi thay đổi của breakpoint
    const isMobileQuery = useMediaQuery(theme.breakpoints.down('md'));

    // State cho chiều rộng hiện tại của Navbar và trạng thái mobile trong MainLayout
    const [currentLayoutDrawerWidth, setCurrentLayoutDrawerWidth] = useState(0);
    const [isLayoutMobile, setIsLayoutMobile] = useState(isMobileQuery);

    // Callback để Navbar cập nhật MainLayout
    const handleLayoutChange = useCallback((drawerWidthForLayout, mobileStatus) => {
        setCurrentLayoutDrawerWidth(drawerWidthForLayout);
        setIsLayoutMobile(mobileStatus);
    }, []);
    
    // Cập nhật isLayoutMobile khi isMobileQuery thay đổi
     useEffect(() => {
        setIsLayoutMobile(isMobileQuery);
    }, [isMobileQuery]);


    const mobileAppBarHeight = '56px'; // Điều chỉnh nếu chiều cao AppBar mobile của bạn khác

    return (
        // Box ngoài cùng bây giờ sẽ là flex row để Navbar và content nằm cạnh nhau
        <Box sx={{ display: 'flex' }}> 
            <Navbar onLayoutChange={handleLayoutChange} /> {/* Truyền callback */}
            
            <Box
                component="main"
                sx={{
                    flexGrow: 1,
                    p: 3,
                    transition: theme.transitions.create(['margin', 'width'], {
                        easing: theme.transitions.easing.sharp,
                        duration: theme.transitions.duration.enteringScreen,
                    }),
                    marginLeft: {
                        xs: 0,
                        sm: `8px`, // Adjusted margin to give a little space between navbar and content
                    },
                    width: {
                        xs: '100%',
                        sm: `4 px`, // Adjusted width calculation
                    },
                }}
            >
                {/* Toolbar này giúp đẩy nội dung xuống dưới AppBar cố định trên mobile của Navbar */}
                {/* Chỉ render nếu isLayoutMobile là true VÀ Navbar có AppBar cố định trên mobile */}
                {isLayoutMobile && <Toolbar />} 
                <Outlet />
            </Box>
        </Box>
    );
};

export default MainLayout; 