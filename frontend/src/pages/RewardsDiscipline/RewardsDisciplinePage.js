import React, { useState, useEffect } from 'react';
import { Box, Typography, Container, Paper, Tabs, Tab } from '@mui/material';
import RewardPunishmentForm from '../../components/RewardPunishment/RewardPunishmentForm';
import RewardPunishmentList from '../../components/RewardPunishment/RewardPunishmentList';
import authService from '../../services/authService'; // Import authService

function TabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`rewards-tabpanel-${index}`}
      aria-labelledby={`rewards-tab-${index}`}
      {...other}
    >
      {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
    </div>
  );
}

const RewardsDisciplinePage = () => {
  const [currentUser, setCurrentUser] = useState(null);
  const [userRole, setUserRole] = useState(null);
  const [studentIdForView, setStudentIdForView] = useState(null);
  
  const [tabValue, setTabValue] = useState(0);
  const [refreshList, setRefreshList] = useState(false);


useEffect(() => {
  const fetchUserData = async () => {
    try {
      const user = authService.getCurrentUser();
      if (user) {
        setCurrentUser(user);
        setUserRole(user.role);
        
        // Student sẽ xem dữ liệu của bản thân
        if (user.role === 'student') {
          setStudentIdForView(user.UserID || user.id);
        }
        // Parent sẽ cần chọn con (hoặc mặc định là con đầu tiên)
        else if (user.role === 'parent') {
          // Đây là một ví dụ đơn giản, bạn có thể cần tải danh sách con
          // và cho phép parent chọn con cụ thể
          const response = await parentService.getChildren();
          if (response.data && response.data.length > 0) {
            setStudentIdForView(response.data[0].StudentID);
          }
        }
      }
    } catch (error) {
      console.error("Error fetching user data:", error);
    }
  };

  fetchUserData();
}, []);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleRewardCreated = () => {
    // Only admins/teachers (those who can see the form) would trigger this
    if (userRole === 'admin' || userRole === 'teacher') {
        setTabValue(1); // Switch to list tab
    }
    setRefreshList(prev => !prev);
  };

  const canManageRewards = userRole === 'admin'; // Or include 'teacher' if they can create

  if (!currentUser) {
    return (
      <Container maxWidth="lg">
        <Box sx={{ my: 4 }}>
          <Typography>Vui lòng đăng nhập để xem thông tin.</Typography>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ my: 4 }}>
        <Typography variant="h4" gutterBottom>
          Khen thưởng & Kỷ luật
        </Typography>
        
        {canManageRewards ? (
          <Paper sx={{ width: '100%', mb: 2 }}>
            <Tabs 
              value={tabValue} 
              onChange={handleTabChange}
              indicatorColor="primary"
              textColor="primary"
              centered
            >
              <Tab label="Nhập thông tin mới" />
              <Tab label="Danh sách khen thưởng/kỷ luật" />
            </Tabs>
            
            <TabPanel value={tabValue} index={0}>
              <RewardPunishmentForm 
                targetType="student" // Or allow admin to choose targetType
                onSuccess={handleRewardCreated}
              />
            </TabPanel>
            
            <TabPanel value={tabValue} index={1}>
              <RewardPunishmentList 
                targetType="student" // Or allow admin to choose targetType
                refreshTrigger={refreshList}
                // Admin will use search, no studentIdForView passed
              />
            </TabPanel>
          </Paper>
        ) : (userRole === 'student' || userRole === 'parent') && studentIdForView ? (
          <Paper sx={{ width: '100%', p: 3 }}>
            <Typography variant="h5" gutterBottom>
              Danh sách khen thưởng/kỷ luật
            </Typography>
            <RewardPunishmentList 
              targetType="student" 
              studentIdForView={studentIdForView}
              refreshTrigger={refreshList}
            />
          </Paper>
        ) : (userRole === 'student' || userRole === 'parent') && !studentIdForView ? (
            <Typography color="error">Không tìm thấy thông tin học sinh liên kết để hiển thị khen thưởng/kỷ luật.</Typography>
        ) : (
            <Typography>Bạn không có quyền truy cập mục này.</Typography>
        )}
      </Box>
    </Container>
  );
};

export default RewardsDisciplinePage;