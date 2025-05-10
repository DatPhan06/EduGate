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
  CircularProgress,
  Chip,
  Avatar,
  Badge,
  useTheme,
  useMediaQuery
} from '@mui/material';
import { 
  EmojiEvents as RewardIcon, 
  Gavel as PunishmentIcon, 
  Dashboard as DashboardIcon,
  Add as AddIcon,
  List as ListIcon,
  School as SchoolIcon,
  Info as InfoIcon,
  Error as ErrorIcon,
  Timeline as TimelineIcon,
  Person as PersonIcon
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
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
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
  const [studentStats, setStudentStats] = useState({
    rewards: 0,
    punishments: 0,
    total: 0,
    recentRewards: [],
    recentPunishments: []
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

  // Fetch student stats - specifically for student view
  useEffect(() => {
    const fetchStudentStats = async () => {
      if ((userRole === 'student' || userRole === 'parent') && studentIdForView) {
        setLoading(true);
        try {
          // Get student's rewards/punishments
          const response = await rewardPunishmentService.getStudentRewardPunishments(studentIdForView);
          const studentRecords = response.data || [];
          
          // Process unwrapped data if needed
          let processedRecords = [];
          if (studentRecords.length > 0 && studentRecords[0].reward_punishment) {
            processedRecords = studentRecords.map(item => ({
              ...item,
              ...item.reward_punishment
            }));
          } else {
            processedRecords = studentRecords;
          }
          
          // Calculate stats
          let rewardsCount = 0;
          let punishmentsCount = 0;
          let recentRewards = [];
          let recentPunishments = [];
          
          // Sort by date (newest first)
          processedRecords.sort((a, b) => {
            const dateA = new Date(a.Date || a.date);
            const dateB = new Date(b.Date || b.date);
            return dateB - dateA;
          });
          
          processedRecords.forEach(record => {
            const recordType = (record.Type || record.type || '').toLowerCase();
            if (recordType === 'reward') {
              rewardsCount++;
              if (recentRewards.length < 3) {
                recentRewards.push(record);
              }
            } else if (recordType === 'punishment') {
              punishmentsCount++;
              if (recentPunishments.length < 3) {
                recentPunishments.push(record);
              }
            }
          });
          
          setStudentStats({
            rewards: rewardsCount,
            punishments: punishmentsCount,
            total: processedRecords.length,
            recentRewards,
            recentPunishments
          });
          
        } catch (error) {
          console.error("Error fetching student stats:", error);
          setStudentStats({
            rewards: 0,
            punishments: 0,
            total: 0,
            recentRewards: [],
            recentPunishments: []
          });
        } finally {
          setLoading(false);
        }
      }
    };
    
    fetchStudentStats();
  }, [userRole, studentIdForView, refreshList]);

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

  // Student dashboard stats and timeline
  const renderStudentDashboard = () => (
    <>
      {/* Stats cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={6} sm={4}>
          <Card sx={{
            boxShadow: '0 4px 12px rgba(0,200,83,0.2)',
            height: '100%',
            background: 'linear-gradient(135deg, #f5f7fa 0%, #e8fdf5 100%)',
            border: '1px solid #e0f2dc',
            borderRadius: 2
          }}>
            <CardContent>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Box>
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Khen thưởng
                  </Typography>
                  <Typography variant="h3" component="div" color="success.main" fontWeight="bold">
                    {loading ? (
                      <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                        <CircularProgress size={24} color="success" sx={{ mr: 1 }} />
                      </Box>
                    ) : studentStats.rewards}
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: 'success.light', width: 56, height: 56 }}>
                  <RewardIcon sx={{ color: 'white', fontSize: 32 }} />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={6} sm={4}>
          <Card sx={{
            boxShadow: '0 4px 12px rgba(211,47,47,0.2)',
            height: '100%',
            background: 'linear-gradient(135deg, #f5f7fa 0%, #fdf1f1 100%)',
            border: '1px solid #f2dcdc',
            borderRadius: 2
          }}>
            <CardContent>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Box>
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Kỷ luật
                  </Typography>
                  <Typography variant="h3" component="div" color="error.main" fontWeight="bold">
                    {loading ? (
                      <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                        <CircularProgress size={24} color="error" sx={{ mr: 1 }} />
                      </Box>
                    ) : studentStats.punishments}
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: 'error.light', width: 56, height: 56 }}>
                  <PunishmentIcon sx={{ color: 'white', fontSize: 32 }} />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={4}>
          <Card sx={{
            boxShadow: '0 4px 12px rgba(25,118,210,0.2)',
            height: '100%',
            background: 'linear-gradient(135deg, #f5f7fa 0%, #f0f4fd 100%)',
            border: '1px solid #dde4f2',
            borderRadius: 2
          }}>
            <CardContent>
              <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Box>
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Tổng số
                  </Typography>
                  <Typography variant="h3" component="div" color="primary.main" fontWeight="bold">
                    {loading ? (
                      <Box sx={{ display: 'inline-flex', alignItems: 'center' }}>
                        <CircularProgress size={24} color="primary" sx={{ mr: 1 }} />
                      </Box>
                    ) : studentStats.total}
                  </Typography>
                </Box>
                <Avatar sx={{ bgcolor: 'primary.light', width: 56, height: 56 }}>
                  <TimelineIcon sx={{ color: 'white', fontSize: 32 }} />
                </Avatar>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Học sinh info card */}
      <Card sx={{ 
        mb: 4, 
        background: 'linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%)',
        borderRadius: 2,
        overflow: 'hidden',
        boxShadow: '0 4px 20px rgba(3,169,244,0.15)'
      }}>
        <Box sx={{ 
          display: 'flex', 
          flexDirection: isMobile ? 'column' : 'row',
          alignItems: 'center', 
          p: 3 
        }}>
          <Avatar 
            sx={{ 
              width: 100, 
              height: 100, 
              bgcolor: 'primary.main',
              mb: isMobile ? 2 : 0,
              mr: isMobile ? 0 : 3,
              boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
            }}
          >
            <PersonIcon sx={{ fontSize: 60 }} />
          </Avatar>
          <Box>
            <Typography variant="h5" fontWeight="bold" gutterBottom>
              {currentUser.FirstName} {currentUser.LastName}
            </Typography>
            <Typography variant="subtitle1" color="text.secondary">
              Học sinh ID: {studentIdForView}
            </Typography>
            <Box sx={{ display: 'flex', mt: 1, flexWrap: 'wrap', gap: 1 }}>
              <Chip
                icon={<RewardIcon />}
                label={`${studentStats.rewards} khen thưởng`}
                color="success"
                variant="outlined"
                size="small"
              />
              <Chip
                icon={<PunishmentIcon />}
                label={`${studentStats.punishments} kỷ luật`}
                color="error"
                variant="outlined"
                size="small"
              />
            </Box>
          </Box>
        </Box>
      </Card>
      
      {/* Recent rewards/punishments */}
      <Typography variant="h6" gutterBottom sx={{ mb: 2 }}>
        Gần đây
      </Typography>
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} md={6}>
          <Card sx={{ boxShadow: '0 2px 10px rgba(0,0,0,0.08)', borderRadius: 2 }}>
            <CardContent>
              <Typography variant="subtitle1" sx={{ mb: 2, display: 'flex', alignItems: 'center' }}>
                <RewardIcon sx={{ mr: 1, color: 'success.main' }} />
                Khen thưởng gần đây
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              {studentStats.recentRewards.length > 0 ? (
                studentStats.recentRewards.map((reward, index) => (
                  <Box 
                    key={reward.RecordID || index} 
                    sx={{ 
                      p: 1.5, 
                      mb: 1, 
                      borderLeft: '4px solid',
                      borderColor: 'success.main',
                      bgcolor: 'success.lightest',
                      borderRadius: 1,
                      '&:last-child': { mb: 0 }
                    }}
                  >
                    <Typography variant="subtitle2">
                      {reward.Title || reward.title || 'Khen thưởng'}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                      {reward.Description || reward.description || 'Không có mô tả'}
                    </Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ mt: 1, display: 'block' }}>
                      {new Date(reward.Date || reward.date).toLocaleDateString('vi-VN')}
                    </Typography>
                  </Box>
                ))
              ) : (
                <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                  Không có khen thưởng nào gần đây
                </Typography>
              )}
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={6}>
          <Card sx={{ boxShadow: '0 2px 10px rgba(0,0,0,0.08)', borderRadius: 2 }}>
            <CardContent>
              <Typography variant="subtitle1" sx={{ mb: 2, display: 'flex', alignItems: 'center' }}>
                <PunishmentIcon sx={{ mr: 1, color: 'error.main' }} />
                Kỷ luật gần đây
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              {studentStats.recentPunishments.length > 0 ? (
                studentStats.recentPunishments.map((punishment, index) => (
                  <Box 
                    key={punishment.RecordID || index} 
                    sx={{ 
                      p: 1.5, 
                      mb: 1, 
                      borderLeft: '4px solid',
                      borderColor: 'error.main',
                      bgcolor: 'error.lightest',
                      borderRadius: 1,
                      '&:last-child': { mb: 0 }
                    }}
                  >
                    <Typography variant="subtitle2">
                      {punishment.Title || punishment.title || 'Kỷ luật'}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                      {punishment.Description || punishment.description || 'Không có mô tả'}
                    </Typography>
                    <Typography variant="caption" color="text.secondary" sx={{ mt: 1, display: 'block' }}>
                      {new Date(punishment.Date || punishment.date).toLocaleDateString('vi-VN')}
                    </Typography>
                  </Box>
                ))
              ) : (
                <Typography variant="body2" color="text.secondary" sx={{ py: 2, textAlign: 'center' }}>
                  Không có kỷ luật nào gần đây
                </Typography>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Full list */}
      <Paper 
        elevation={0} 
        sx={{ 
          p: 3, 
          borderRadius: 2,
          border: '1px solid #e0e0e0',
          boxShadow: '0 2px 12px rgba(0,0,0,0.05)'
        }}
      >
        <Typography variant="h6" gutterBottom sx={{ 
          display: 'flex', 
          alignItems: 'center',
          mb: 3
        }}>
          <ListIcon sx={{ mr: 1, color: 'primary.main' }} />
          Danh sách đầy đủ
        </Typography>
        <Divider sx={{ mb: 3 }} />
        <Box sx={{ overflowX: 'auto', width: '100%' }}>
          <RewardPunishmentList 
            targetType="student" 
            studentIdForView={studentIdForView}
            refreshTrigger={refreshList}
          />
        </Box>
      </Paper>
    </>
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
          renderStudentDashboard()
        )}
        
        {(userRole === 'student' || userRole === 'parent') && !studentIdForView && (
          <Paper sx={{ p: 3, borderRadius: 2, bgcolor: '#fafafa', border: '1px solid #e0e0e0', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
            <Typography color="error" sx={{ display: 'flex', alignItems: 'center' }}>
              <ErrorIcon sx={{ mr: 1 }} />
              Không tìm thấy thông tin học sinh liên kết để hiển thị khen thưởng/kỷ luật.
            </Typography>
          </Paper>
        )}
        
        {!canManageRewards && userRole !== 'student' && userRole !== 'parent' && (
          <Paper sx={{ p: 3, borderRadius: 2, bgcolor: '#fafafa', border: '1px solid #e0e0e0', boxShadow: '0 2px 10px rgba(0,0,0,0.05)' }}>
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