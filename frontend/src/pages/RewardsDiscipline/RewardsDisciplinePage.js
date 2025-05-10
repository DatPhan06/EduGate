import React, { useState, useEffect } from 'react';
import { 
  Box, 
  Typography, 
  Container, 
  Paper, 
  Tabs, 
  Tab, 
  Grid, 
  Card, 
  CardContent, 
  Divider,
  AppBar,
  CircularProgress
} from '@mui/material';
import { 
  EmojiEvents as RewardIcon, 
  Gavel as PunishmentIcon, 
  Dashboard as DashboardIcon,
  Add as AddIcon,
  List as ListIcon,
  School as SchoolIcon,
  Info as InfoIcon,
  Error as ErrorIcon
} from '@mui/icons-material';
import RewardPunishmentForm from '../../components/RewardPunishment/RewardPunishmentForm';
import RewardPunishmentList from '../../components/RewardPunishment/RewardPunishmentList';
import authService from '../../services/authService';
import rewardPunishmentService from '../../services/rewardPunishmentService';
import { Link } from 'react-router-dom';

// Styled TabPanel component
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
      {value === index && (
        <Box sx={{ p: { xs: 2, sm: 3 } }}>
          {children}
        </Box>
      )}
    </div>
  );
}

const RewardsDisciplinePage = () => {
  const [currentUser, setCurrentUser] = useState(null);
  const [userRole, setUserRole] = useState(null);
  const [studentIdForView, setStudentIdForView] = useState(null);
  const [tabValue, setTabValue] = useState(0);
  const [refreshList, setRefreshList] = useState(false);
  const [stats, setStats] = useState({
    rewards: 0,
    punishments: 0,
    total: 0
  });
  const [loading, setLoading] = useState(false);

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
            // Uncomment when parentService is available
            // const response = await parentService.getChildren();
            // if (response.data && response.data.length > 0) {
            //   setStudentIdForView(response.data[0].StudentID);
            // }
          }
        }
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    };
  
    fetchUserData();
  }, []);

  // Fetch real dashboard stats data from API
  useEffect(() => {
    const fetchDashboardStats = async () => {
      if (userRole === 'admin') {
        setLoading(true);
        try {
          const response = await rewardPunishmentService.getAllRewardPunishments();
          const allRecords = response.data || [];
          
          // Process data to get counts
          let rewardsCount = 0;
          let punishmentsCount = 0;
          
          allRecords.forEach(record => {
            // Check all possible variations of the type field (uppercase, lowercase)
            const recordType = (record.Type || record.type || '').toLowerCase();
            if (recordType === 'reward') {
              rewardsCount++;
            } else if (recordType === 'punishment') {
              punishmentsCount++;
            }
          });
          
          // Update stats with real data
          setStats({
            rewards: rewardsCount,
            punishments: punishmentsCount,
            total: allRecords.length
          });
        } catch (error) {
          console.error("Error fetching dashboard stats:", error);
          // Fallback to zeros if fetch fails
          setStats({
            rewards: 0,
            punishments: 0,
            total: 0
          });
        } finally {
          setLoading(false);
        }
      }
    };
    
    fetchDashboardStats();
  }, [userRole, refreshList]); // Also refresh when new rewards are created

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

  const canManageRewards = userRole === 'admin'; // Chỉ admin có thể quản lý trực tiếp

  if (!currentUser) {
    return (
      <Container maxWidth="xl" sx={{ width: '100%', px: { xs: 2, sm: 4 } }}>
        <Box sx={{ my: 4 }}>
          <Typography>Vui lòng đăng nhập để xem thông tin.</Typography>
        </Box>
      </Container>
    );
  }

  // Admin Dashboard stats cards
  const renderDashboardCards = () => (
    <Grid container spacing={3} sx={{ mb: 4 }}>
      <Grid item xs={12} sm={4}>
        <Card sx={{
          boxShadow: '0 2px 8px 0 rgba(0,0,0,0.1)',
          height: '100%'
        }}>
          <CardContent>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Box>
                <Typography variant="subtitle2" color="textSecondary" gutterBottom>
                  Khen thưởng
                </Typography>
                <Typography variant="h4" component="div">
                  {loading ? (
                    <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                      <CircularProgress size={24} sx={{ mr: 1 }} />
                    </Box>
                  ) : stats.rewards}
                </Typography>
              </Box>
              <RewardIcon sx={{ color: 'primary.light', fontSize: 40 }} />
            </Box>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} sm={4}>
        <Card sx={{
          boxShadow: '0 2px 8px 0 rgba(0,0,0,0.1)',
          height: '100%'
        }}>
          <CardContent>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Box>
                <Typography variant="subtitle2" color="textSecondary" gutterBottom>
                  Kỷ luật
                </Typography>
                <Typography variant="h4" component="div">
                  {loading ? (
                    <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                      <CircularProgress size={24} sx={{ mr: 1 }} />
                    </Box>
                  ) : stats.punishments}
                </Typography>
              </Box>
              <PunishmentIcon sx={{ color: 'error.light', fontSize: 40 }} />
            </Box>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} sm={4}>
        <Card sx={{
          boxShadow: '0 2px 8px 0 rgba(0,0,0,0.1)',
          height: '100%'
        }}>
          <CardContent>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <Box>
                <Typography variant="subtitle2" color="textSecondary" gutterBottom>
                  Tổng số
                </Typography>
                <Typography variant="h4" component="div">
                  {loading ? (
                    <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                      <CircularProgress size={24} sx={{ mr: 1 }} />
                    </Box>
                  ) : stats.total}
                </Typography>
              </Box>
              <SchoolIcon sx={{ color: 'text.secondary', fontSize: 40 }} />
            </Box>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  return (
    <Container maxWidth="xl" sx={{ width: '100%', px: { xs: 2, sm: 4 } }}>
      <Box sx={{ mb: 4 }}>
        {/* Header with more subtle styling */}
        <Paper 
          elevation={0} 
          sx={{ 
            p: 3, 
            mb: 4, 
            bgcolor: 'background.paper',
            borderBottom: '1px solid #e0e0e0',
            borderRadius: 0,
            width: '100%'
          }}
        >
          <Typography variant="h4" component="div" sx={{ fontWeight: 'medium' }}>
            Khen thưởng & Kỷ luật
          </Typography>
          <Typography variant="subtitle1" color="text.secondary">
            Quản lý thông tin khen thưởng và kỷ luật học sinh
          </Typography>
        </Paper>
        
        {canManageRewards && (
          <>
            {/* Dashboard stats for admin */}
            {renderDashboardCards()}
            
            {/* Main content with tabs */}
            <Paper sx={{ 
              width: '100%', 
              mb: 2, 
              borderRadius: 0,
              boxShadow: '0 1px 3px 0 rgba(0,0,0,0.1)'
            }}>
              <AppBar position="static" color="default" elevation={0} sx={{ borderBottom: '1px solid #e0e0e0' }}>
                <Tabs 
                  value={tabValue} 
                  onChange={handleTabChange}
                  indicatorColor="primary"
                  textColor="primary"
                  sx={{
                    '& .MuiTab-root': {
                      fontWeight: 'normal',
                      minHeight: 48
                    }
                  }}
                >
                  <Tab 
                    label="Tạo mới" 
                    icon={<AddIcon />} 
                    iconPosition="start"
                  />
                  <Tab 
                    label="Danh sách" 
                    icon={<ListIcon />} 
                    iconPosition="start"
                  />
                </Tabs>
              </AppBar>
              
              <TabPanel value={tabValue} index={0}>
                <Box sx={{ maxWidth: '100%', mx: 'auto' }}>
                  <Card elevation={0} sx={{ bgcolor: '#f9f9f9', mb: 3, p: 1, borderRadius: 0, border: '1px solid #e0e0e0' }}>
                    <CardContent>
                      <Typography variant="subtitle1" sx={{ mb: 1, display: 'flex', alignItems: 'center', fontWeight: 'medium' }}>
                        <InfoIcon sx={{ mr: 1, color: 'text.secondary' }} fontSize="small" />
                        Hướng dẫn
                      </Typography>
                      <Typography variant="body2" color="text.secondary">
                        Nhập thông tin khen thưởng hoặc kỷ luật cho học sinh vào biểu mẫu bên dưới. 
                        Các trường có dấu (*) là bắt buộc phải nhập.
                      </Typography>
                    </CardContent>
                  </Card>
                  <RewardPunishmentForm 
                    targetType="student"
                    onSuccess={handleRewardCreated}
                  />
                </Box>
              </TabPanel>
              
              <TabPanel value={tabValue} index={1}>
                <Box sx={{ overflowX: 'auto', width: '100%' }}>
                  <RewardPunishmentList 
                    targetType="student"
                    refreshTrigger={refreshList}
                  />
                </Box>
              </TabPanel>
            </Paper>
          </>
        )}
        
        {(userRole === 'student' || userRole === 'parent') && studentIdForView && (
          <Paper sx={{ 
            width: '100%', 
            p: 3, 
            borderRadius: 0,
            boxShadow: '0 1px 3px 0 rgba(0,0,0,0.1)'
          }}>
            <Box sx={{ mb: 3, display: 'flex', alignItems: 'center' }}>
              <ListIcon sx={{ mr: 1, color: 'text.secondary' }} />
              <Typography variant="h5">
                Danh sách khen thưởng/kỷ luật
              </Typography>
            </Box>
            <Divider sx={{ mb: 3 }} />
            <Box sx={{ overflowX: 'auto', width: '100%' }}>
              <RewardPunishmentList 
                targetType="student" 
                studentIdForView={studentIdForView}
                refreshTrigger={refreshList}
              />
            </Box>
          </Paper>
        )}
        
        {(userRole === 'student' || userRole === 'parent') && !studentIdForView && (
          <Paper sx={{ p: 3, borderRadius: 0, bgcolor: '#fafafa', border: '1px solid #e0e0e0' }}>
            <Typography color="error" sx={{ display: 'flex', alignItems: 'center' }}>
              <ErrorIcon sx={{ mr: 1 }} />
              Không tìm thấy thông tin học sinh liên kết để hiển thị khen thưởng/kỷ luật.
            </Typography>
          </Paper>
        )}
        
        {!canManageRewards && userRole !== 'student' && userRole !== 'parent' && (
          <Paper sx={{ p: 3, borderRadius: 0, bgcolor: '#fafafa', border: '1px solid #e0e0e0' }}>
            <Typography sx={{ display: 'flex', alignItems: 'center' }}>
              <ErrorIcon sx={{ mr: 1, color: 'text.secondary' }} />
              {userRole === 'teacher' ? (
                <>
                  Giáo viên vui lòng sử dụng trang <Link to="/teacher/rewards-discipline" style={{ color: 'blue', textDecoration: 'underline', marginLeft: '4px', marginRight: '4px' }}>Quản lý khen thưởng/kỷ luật</Link> dành riêng cho giáo viên.
                </>
              ) : (
                'Bạn không có quyền truy cập mục này.'
              )}
            </Typography>
          </Paper>
        )}
      </Box>
    </Container>
  );
};

export default RewardsDisciplinePage;