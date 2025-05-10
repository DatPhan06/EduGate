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
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Button
} from '@mui/material';
import { 
  EmojiEvents as RewardIcon, 
  Gavel as PunishmentIcon, 
  Dashboard as DashboardIcon,
  FilterList as FilterIcon,
  School as SchoolIcon,
  ViewList as ViewListIcon,
  Class as ClassIcon,
} from '@mui/icons-material';
import RewardPunishmentList from '../../components/RewardPunishment/RewardPunishmentList';
import authService from '../../services/authService';
import rewardPunishmentService from '../../services/rewardPunishmentService';
import { getTeacherHomeroomClasses, getHomeroomClassStudents } from '../../services/teacherService';

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

const TeacherRewardsDisciplinePage = () => {
  const [currentUser, setCurrentUser] = useState(null);
  const [teacherId, setTeacherId] = useState(null);
  const [tabValue, setTabValue] = useState(0);
  const [refreshList, setRefreshList] = useState(false);
  const [loading, setLoading] = useState(false);
  const [classes, setClasses] = useState([]);
  const [selectedClass, setSelectedClass] = useState('');
  const [students, setStudents] = useState([]);
  const [selectedStudent, setSelectedStudent] = useState('');
  const [stats, setStats] = useState({
    rewards: 0,
    punishments: 0,
    total: 0
  });
  const [schoolStats, setSchoolStats] = useState({
    rewards: 0,
    punishments: 0,
    total: 0
  });

  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const user = authService.getCurrentUser();
        if (user && user.role === 'teacher') {
          setCurrentUser(user);
          setTeacherId(user.UserID || user.id);
        } else {
          console.error("Unauthorized access: User is not a teacher");
        }
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    };
  
    fetchUserData();
  }, []);

  // Fetch classes taught by the teacher
  useEffect(() => {
    const fetchTeacherClasses = async () => {
      if (!teacherId) return;
      
      setLoading(true);
      try {
        const teacherClasses = await getTeacherHomeroomClasses(teacherId);
        setClasses(teacherClasses);
        setLoading(false);
      } catch (error) {
        console.error("Error fetching teacher classes:", error);
        setLoading(false);
      }
    };

    fetchTeacherClasses();
  }, [teacherId]);

  // Fetch students when a class is selected
  useEffect(() => {
    const fetchClassStudents = async () => {
      if (!teacherId || !selectedClass) {
        setStudents([]);
        return;
      }
      
      setLoading(true);
      try {
        const classStudents = await getHomeroomClassStudents(teacherId, selectedClass);
        setStudents(classStudents);
        setSelectedStudent('');
        setLoading(false);
      } catch (error) {
        console.error("Error fetching class students:", error);
        setLoading(false);
      }
    };

    fetchClassStudents();
  }, [teacherId, selectedClass]);

  // Fetch class-filtered stats data
  useEffect(() => {
    const fetchFilteredStats = async () => {
      if (!teacherId) return;
      
      setLoading(true);
      try {
        // Always fetch all rewards/punishments first
        const response = await rewardPunishmentService.getAllRewardPunishments();
        let allRecords = response.data || [];
        
        // Apply filtering if needed
        if (selectedStudent) {
          allRecords = allRecords.filter(record => 
            String(record.StudentID || record.student_id) === String(selectedStudent)
          );
        } else if (selectedClass && students.length > 0) {
          const studentIds = students.map(student => String(student.id || student.StudentID));
          allRecords = allRecords.filter(record => 
            studentIds.includes(String(record.StudentID || record.student_id))
          );
        }
        
        // Calculate filtered stats
        let rewardsCount = 0;
        let punishmentsCount = 0;
        
        allRecords.forEach(record => {
          const recordType = (record.Type || record.type || '').toLowerCase();
          if (recordType === 'reward') {
            rewardsCount++;
          } else if (recordType === 'punishment') {
            punishmentsCount++;
          }
        });
        
        setStats({
          rewards: rewardsCount,
          punishments: punishmentsCount,
          total: allRecords.length
        });
      } catch (error) {
        console.error("Error fetching rewards/punishments stats:", error);
        setStats({
          rewards: 0,
          punishments: 0,
          total: 0
        });
      } finally {
        setLoading(false);
      }
    };
    
    fetchFilteredStats();
  }, [teacherId, selectedClass, selectedStudent, refreshList]);

  // Fetch school-wide stats
  useEffect(() => {
    const fetchSchoolStats = async () => {
      if (!teacherId) return;
      
      setLoading(true);
      try {
        const response = await rewardPunishmentService.getAllRewardPunishments();
        const allRecords = response.data || [];
        
        // Calculate stats for whole school
        let rewardsCount = 0;
        let punishmentsCount = 0;
        
        allRecords.forEach(record => {
          const recordType = (record.Type || record.type || '').toLowerCase();
          if (recordType === 'reward') {
            rewardsCount++;
          } else if (recordType === 'punishment') {
            punishmentsCount++;
          }
        });
        
        setSchoolStats({
          rewards: rewardsCount,
          punishments: punishmentsCount,
          total: allRecords.length
        });
      } catch (error) {
        console.error("Error fetching school stats:", error);
        setSchoolStats({
          rewards: 0,
          punishments: 0,
          total: 0
        });
      } finally {
        setLoading(false);
      }
    };
    
    fetchSchoolStats();
  }, [teacherId, refreshList]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleClassChange = (event) => {
    setSelectedClass(event.target.value);
  };

  const handleStudentChange = (event) => {
    setSelectedStudent(event.target.value);
  };

  const handleResetFilters = () => {
    setSelectedClass('');
    setSelectedStudent('');
  };

  // Show stats cards for school-wide view
  const renderSchoolStatsCards = () => (
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
                  ) : schoolStats.rewards}
                </Typography>
              </Box>
              <RewardIcon sx={{ color: 'success.main', fontSize: 40 }} />
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
                  ) : schoolStats.punishments}
                </Typography>
              </Box>
              <PunishmentIcon sx={{ color: 'error.main', fontSize: 40 }} />
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
                  ) : schoolStats.total}
                </Typography>
              </Box>
              <SchoolIcon sx={{ color: 'text.secondary', fontSize: 40 }} />
            </Box>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );

  // Show stats cards for class view
  const renderClassStatsCards = () => (
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
              <RewardIcon sx={{ color: 'success.main', fontSize: 40 }} />
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
              <PunishmentIcon sx={{ color: 'error.main', fontSize: 40 }} />
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

  if (!currentUser || !teacherId) {
    return (
      <Container maxWidth="xl" sx={{ width: '100%', px: { xs: 2, sm: 4 } }}>
        <Box sx={{ my: 4 }}>
          <Typography>Vui lòng đăng nhập với tài khoản giáo viên để xem thông tin.</Typography>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="xl" sx={{ width: '100%', px: { xs: 2, sm: 4 } }}>
      <Box sx={{ mb: 4 }}>
        <Paper 
          elevation={0} 
          sx={{ 
            p: 3, 
            mb: 4, 
            bgcolor: 'background.paper',
            borderRadius: 1,
            border: '1px solid #e0e0e0'
          }}
        >
          <Typography variant="h5" component="h1" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
            <DashboardIcon sx={{ mr: 1, color: 'primary.main' }} />
            Quản lý Khen thưởng & Kỷ luật
          </Typography>
          <Typography variant="subtitle1" color="text.secondary">
            Trang quản lý khen thưởng và kỷ luật dành cho giáo viên
          </Typography>
        </Paper>

        <AppBar 
          position="static" 
          color="default" 
          elevation={0}
          sx={{ 
            borderRadius: 1,
            bgcolor: 'background.paper',
            mb: 3,
            border: '1px solid #e0e0e0'
          }}
        >
          <Tabs
            value={tabValue}
            onChange={handleTabChange}
            indicatorColor="primary"
            textColor="primary"
            variant="fullWidth"
          >
            <Tab 
              label="Tổng quan" 
              icon={<SchoolIcon />} 
              iconPosition="start"
            />
            <Tab 
              label="Theo lớp" 
              icon={<ClassIcon />} 
              iconPosition="start"
            />
          </Tabs>
        </AppBar>

        {/* Tab 1: Toàn trường */}
        <TabPanel value={tabValue} index={0}>
          {renderSchoolStatsCards()}

          <Paper sx={{ 
            p: 3, 
            borderRadius: 1,
            border: '1px solid #e0e0e0',
            mb: 3
          }}>
            <Box sx={{ mb: 3, display: 'flex', alignItems: 'center' }}>
              <ViewListIcon sx={{ mr: 1, color: 'primary.main' }} />
              <Typography variant="h6">
                Danh sách khen thưởng/kỷ luật toàn trường
              </Typography>
            </Box>
            <Divider sx={{ mb: 3 }} />
            
            <Box sx={{ overflowX: 'auto', width: '100%' }}>
              <RewardPunishmentList 
                targetType="all" 
                refreshTrigger={refreshList}
              />
            </Box>
          </Paper>
        </TabPanel>

        {/* Tab 2: Theo lớp */}
        <TabPanel value={tabValue} index={1}>
          <Paper
            elevation={0}
            sx={{
              p: 3,
              mb: 4,
              bgcolor: 'background.paper',
              borderRadius: 1,
              border: '1px solid #e0e0e0'
            }}
          >
            <Typography variant="h6" sx={{ mb: 2, display: 'flex', alignItems: 'center' }}>
              <FilterIcon sx={{ mr: 1, color: 'primary.main' }} />
              Bộ lọc
            </Typography>
            
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} md={4}>
                <FormControl fullWidth size="small">
                  <InputLabel id="class-select-label">Lớp</InputLabel>
                  <Select
                    labelId="class-select-label"
                    id="class-select"
                    value={selectedClass}
                    label="Lớp"
                    onChange={handleClassChange}
                  >
                    <MenuItem value="">Tất cả lớp</MenuItem>
                    {classes.map((cls) => (
                      <MenuItem key={cls.id} value={cls.id}>
                        {cls.name}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              
              <Grid item xs={12} md={4}>
                <FormControl fullWidth size="small" disabled={!selectedClass || students.length === 0}>
                  <InputLabel id="student-select-label">Học sinh</InputLabel>
                  <Select
                    labelId="student-select-label"
                    id="student-select"
                    value={selectedStudent}
                    label="Học sinh"
                    onChange={handleStudentChange}
                  >
                    <MenuItem value="">Tất cả học sinh</MenuItem>
                    {students.map((student) => (
                      <MenuItem key={student.id || student.StudentID} value={student.id || student.StudentID}>
                        {student.name || `${student.FirstName} ${student.LastName}`}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              
              <Grid item xs={12} md={4}>
                <Button 
                  variant="outlined" 
                  onClick={handleResetFilters}
                  disabled={!selectedClass && !selectedStudent}
                  fullWidth
                >
                  Đặt lại bộ lọc
                </Button>
              </Grid>
            </Grid>
          </Paper>

          {/* Thống kê theo lớp/học sinh */}
          {(selectedClass || selectedStudent) && renderClassStatsCards()}

          <Paper sx={{ 
            p: 3, 
            borderRadius: 1,
            border: '1px solid #e0e0e0',
            mb: 3
          }}>
            <Box sx={{ mb: 3, display: 'flex', alignItems: 'center' }}>
              <ViewListIcon sx={{ mr: 1, color: 'primary.main' }} />
              <Typography variant="h6">
                Danh sách khen thưởng/kỷ luật theo lớp
              </Typography>
            </Box>
            <Divider sx={{ mb: 3 }} />
            
            <Box sx={{ overflowX: 'auto', width: '100%' }}>
              <RewardPunishmentList 
                targetType={selectedStudent ? 'student' : 'all'} 
                studentIdForView={selectedStudent}
                refreshTrigger={refreshList}
              />
            </Box>
          </Paper>
        </TabPanel>
      </Box>
    </Container>
  );
};

export default TeacherRewardsDisciplinePage; 