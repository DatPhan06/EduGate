import React, { useState } from 'react';
import { Box, Typography, Container, Paper, Tabs, Tab } from '@mui/material';
import RewardPunishmentForm from '../../components/RewardPunishment/RewardPunishmentForm'; // Import component mới
import PersonIcon from '@mui/icons-material/Person';
import GroupIcon from '@mui/icons-material/Group';
// import authService from '../../services/authService'; // Import nếu cần kiểm tra role ở đây

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`rnp-tabpanel-${index}`}
      aria-labelledby={`rnp-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          {children}
        </Box>
      )}
    </div>
  );
}

const Rewards = () => {
    const [tabValue, setTabValue] = useState(0); // 0 for Student, 1 for Class
    // Optional: Get user role to conditionally render or disable
    // const currentUser = authService.getCurrentUser();
    // const canCreate = currentUser?.role === 'admin' || currentUser?.role === 'teacher';

    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    const handleSuccess = (data) => {
        console.log("RNP Created successfully:", data);
        // Có thể thêm thông báo thành công chung ở đây hoặc làm mới danh sách nếu có
    };

    const handleError = (errorMsg) => {
        console.error("RNP Creation failed:", errorMsg);
        // Lỗi đã được hiển thị trong form, có thể thêm thông báo lỗi chung ở đây nếu muốn
    };

    // Optional: Check permissions before rendering the forms
    // if (!canCreate) { ... return permission denied message ... }

    return (
        <Container maxWidth="md" sx={{ py: 4 }}>
             <Typography variant="h4" component="h1" gutterBottom align="center">
                Quản lý Khen thưởng / Kỷ luật
            </Typography>
            <Paper elevation={3} sx={{ overflow: 'hidden' }}>
                 <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                    <Tabs
                        value={tabValue}
                        onChange={handleTabChange}
                        aria-label="Reward punishment type tabs"
                        variant="fullWidth"
                        indicatorColor="primary"
                        textColor="primary"
                    >
                        <Tab icon={<PersonIcon />} iconPosition="start" label="Nhập cho Học sinh" id="rnp-tab-0" aria-controls="rnp-tabpanel-0" />
                        <Tab icon={<GroupIcon />} iconPosition="start" label="Nhập cho Lớp học" id="rnp-tab-1" aria-controls="rnp-tabpanel-1" />
                    </Tabs>
                </Box>
                <TabPanel value={tabValue} index={0}>
                    <RewardPunishmentForm
                        targetType="student"
                        onSuccess={handleSuccess}
                        onError={handleError}
                    />
                </TabPanel>
                <TabPanel value={tabValue} index={1}>
                     <RewardPunishmentForm
                        targetType="class"
                        onSuccess={handleSuccess}
                        onError={handleError}
                    />
                </TabPanel>
            </Paper>
             {/* Có thể thêm phần hiển thị danh sách RNP đã tạo ở đây */}
             {/* <Typography sx={{ mt: 4, textAlign: 'center', color: 'text.secondary' }}>
                Danh sách khen thưởng/kỷ luật sẽ hiển thị ở đây...
            </Typography> */}
        </Container>
    );
};

export default Rewards;