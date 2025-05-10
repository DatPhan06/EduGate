import React, { useState, useEffect } from 'react';
import { 
  Box, Typography, Container, Paper, Grid, Card, CardContent,
  CardHeader, Tabs, Tab, Table, TableBody, TableCell, 
  TableContainer, TableHead, TableRow, Button, IconButton,
  Select, MenuItem, FormControl, InputLabel, CircularProgress,
  TextField, Divider, Chip, useTheme, alpha, Tooltip, Avatar,
  Autocomplete, Alert
} from '@mui/material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import {
  Assessment as AssessmentIcon,
  PieChart as PieChartIcon,
  ShowChart as LineChartIcon,
  Group as GroupIcon,
  School as SchoolIcon,
  Person as PersonIcon,
  BookmarkBorder as GradeIcon,
  EmojiEvents as RewardIcon,
  EventNote as EventIcon,
  Message as MessageIcon,
  FilterList as FilterIcon,
  CloudDownload as DownloadIcon,
  Print as PrintIcon,
  Refresh as RefreshIcon
} from '@mui/icons-material';
import { 
  LineChart, Line, BarChart, Bar, PieChart, Pie, Cell,
  XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, 
  Legend, ResponsiveContainer 
} from 'recharts';
import authService from '../../services/authService';
import vi from 'date-fns/locale/vi';
import { format, subMonths, startOfYear, endOfYear } from 'date-fns';

// TabPanel Component
function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`stats-tabpanel-${index}`}
      aria-labelledby={`stats-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ py: 3 }}>
          {children}
        </Box>
      )}
    </div>
  );
}

// Mock data for demonstration
// In a real application, this would come from API calls
const generateMockData = () => {
  // Mock student statistics by grade
  const studentsByGrade = [
    { name: 'Lớp 1', value: 120 },
    { name: 'Lớp 2', value: 115 },
    { name: 'Lớp 3', value: 125 },
    { name: 'Lớp 4', value: 118 },
    { name: 'Lớp 5', value: 122 },
    { name: 'Lớp 6', value: 130 },
    { name: 'Lớp 7', value: 128 },
    { name: 'Lớp 8', value: 135 },
    { name: 'Lớp 9', value: 132 },
    { name: 'Lớp 10', value: 145 },
    { name: 'Lớp 11', value: 140 },
    { name: 'Lớp 12', value: 138 },
  ];

  // Mock attendance data by month
  const attendanceData = [
    { month: 'Tháng 1', rate: 97.5 },
    { month: 'Tháng 2', rate: 96.8 },
    { month: 'Tháng 3', rate: 98.2 },
    { month: 'Tháng 4', rate: 97.9 },
    { month: 'Tháng 5', rate: 98.5 },
    { month: 'Tháng 6', rate: 99.1 },
    { month: 'Tháng 7', rate: 99.3 },
    { month: 'Tháng 8', rate: 98.7 },
    { month: 'Tháng 9', rate: 97.8 },
    { month: 'Tháng 10', rate: 98.4 },
    { month: 'Tháng 11', rate: 98.9 },
    { month: 'Tháng 12', rate: 98.2 },
  ];

  // Mock academic performance data
  const academicPerformance = [
    { name: 'Xuất sắc', value: 78 },
    { name: 'Giỏi', value: 220 },
    { name: 'Khá', value: 384 },
    { name: 'Trung bình', value: 248 },
    { name: 'Yếu', value: 70 },
  ];

  // Mock rewards and discipline data by month
  const rewardsData = [
    { month: 'Tháng 1', rewards: 24, disciplines: 5 },
    { month: 'Tháng 2', rewards: 18, disciplines: 7 },
    { month: 'Tháng 3', rewards: 32, disciplines: 3 },
    { month: 'Tháng 4', rewards: 22, disciplines: 6 },
    { month: 'Tháng 5', rewards: 28, disciplines: 4 },
    { month: 'Tháng 6', rewards: 35, disciplines: 2 },
    { month: 'Tháng 7', rewards: 15, disciplines: 3 },
    { month: 'Tháng 8', rewards: 10, disciplines: 1 },
    { month: 'Tháng 9', rewards: 27, disciplines: 8 },
    { month: 'Tháng 10', rewards: 31, disciplines: 5 },
    { month: 'Tháng 11', rewards: 29, disciplines: 4 },
    { month: 'Tháng 12', rewards: 36, disciplines: 6 },
  ];

  // Mock recent academic events
  const recentEvents = [
    { id: 1, title: 'Kỳ thi giữa HK1', date: '2023-10-15', type: 'exam' },
    { id: 2, title: 'Hội nghị phụ huynh', date: '2023-10-20', type: 'meeting' },
    { id: 3, title: 'Kỳ thi cuối HK1', date: '2023-12-15', type: 'exam' },
    { id: 4, title: 'Hội khỏe Phù Đổng', date: '2023-11-10', type: 'sport' },
    { id: 5, title: 'Lễ khai giảng', date: '2023-09-05', type: 'ceremony' }
  ];

  // Mock top performing classes
  const topClasses = [
    { id: 1, name: '12A1', averageGrade: 8.9, attendanceRate: 99.2 },
    { id: 2, name: '11A2', averageGrade: 8.7, attendanceRate: 98.5 },
    { id: 3, name: '10A3', averageGrade: 8.6, attendanceRate: 98.9 },
    { id: 4, name: '9A1', averageGrade: 8.8, attendanceRate: 99.0 },
    { id: 5, name: '8A2', averageGrade: 8.5, attendanceRate: 98.1 }
  ];

  return {
    studentsByGrade,
    attendanceData,
    academicPerformance,
    rewardsData,
    recentEvents,
    topClasses,
    totalStats: {
      students: 1600,
      teachers: 85,
      classes: 48,
      events: 32,
      messages: 2150,
    }
  };
};

const ReportsPage = () => {
  const theme = useTheme();
  const [tabValue, setTabValue] = useState(0);
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);
  const [filterYear, setFilterYear] = useState(new Date().getFullYear().toString());
  const [filterSemester, setFilterSemester] = useState('Tất cả');
  const [dateRange, setDateRange] = useState([startOfYear(new Date()), new Date()]);
  
  // Chart colors
  const COLORS = [
    theme.palette.primary.main,
    theme.palette.secondary.main,
    theme.palette.success.main,
    theme.palette.warning.main,
    theme.palette.error.main,
    theme.palette.info.main,
    '#9c27b0',
    '#ff9800',
    '#795548',
    '#607d8b',
    '#e91e63',
    '#4caf50'
  ];

  // Load data on component mount
  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        // In a real application, you would fetch data from your API
        // For now, we'll use mock data with a delay to simulate API call
        setTimeout(() => {
          const mockData = generateMockData();
          setData(mockData);
          setLoading(false);
        }, 1000);

        // Get current user
        const user = authService.getCurrentUser();
        setCurrentUser(user);
      } catch (error) {
        console.error('Error fetching report data:', error);
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Handle tab change
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  // Handle refresh data
  const handleRefreshData = () => {
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      const mockData = generateMockData();
      setData(mockData);
      setLoading(false);
    }, 1000);
  };

  // Handle exporting data
  const handleExportData = (format) => {
    alert(`Xuất dữ liệu dạng ${format} (tính năng đang phát triển)`);
  };

  // Handle printing reports
  const handlePrintReport = () => {
    window.print();
  };

  // Render dashboard overview section
  const renderDashboardOverview = () => {
    if (!data) return null;

    const { totalStats } = data;

    return (
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Paper 
            elevation={3}
            sx={{ 
              p: 3, 
              borderRadius: 2,
              display: 'flex',
              alignItems: 'center',
              background: `linear-gradient(45deg, ${alpha(theme.palette.primary.main, 0.8)}, ${alpha(theme.palette.primary.light, 0.6)})`,
              color: 'white'
            }}
          >
            <Avatar sx={{ bgcolor: 'white', color: theme.palette.primary.main, width: 56, height: 56, mr: 2 }}>
              <GroupIcon fontSize="large" />
            </Avatar>
            <Box>
              <Typography variant="h3" component="div" sx={{ fontWeight: 'bold' }}>
                {totalStats.students}
              </Typography>
              <Typography variant="subtitle1">Học sinh</Typography>
            </Box>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper 
            elevation={3}
            sx={{ 
              p: 3, 
              borderRadius: 2,
              display: 'flex',
              alignItems: 'center',
              background: `linear-gradient(45deg, ${alpha(theme.palette.secondary.main, 0.8)}, ${alpha(theme.palette.secondary.light, 0.6)})`,
              color: 'white'
            }}
          >
            <Avatar sx={{ bgcolor: 'white', color: theme.palette.secondary.main, width: 56, height: 56, mr: 2 }}>
              <PersonIcon fontSize="large" />
            </Avatar>
            <Box>
              <Typography variant="h3" component="div" sx={{ fontWeight: 'bold' }}>
                {totalStats.teachers}
              </Typography>
              <Typography variant="subtitle1">Giáo viên</Typography>
            </Box>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Paper 
            elevation={3}
            sx={{ 
              p: 3, 
              borderRadius: 2,
              display: 'flex',
              alignItems: 'center',
              background: `linear-gradient(45deg, ${alpha(theme.palette.success.main, 0.8)}, ${alpha(theme.palette.success.light, 0.6)})`,
              color: 'white'
            }}
          >
            <Avatar sx={{ bgcolor: 'white', color: theme.palette.success.main, width: 56, height: 56, mr: 2 }}>
              <SchoolIcon fontSize="large" />
            </Avatar>
            <Box>
              <Typography variant="h3" component="div" sx={{ fontWeight: 'bold' }}>
                {totalStats.classes}
              </Typography>
              <Typography variant="subtitle1">Lớp học</Typography>
            </Box>
          </Paper>
        </Grid>
      </Grid>
    );
  };

  // Render student statistics charts and graphs
  const renderStudentStatistics = () => {
    if (!data) return null;

    const { studentsByGrade, academicPerformance } = data;

    return (
      <Grid container spacing={3} sx={{ mt: 2 }}>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <GroupIcon sx={{ mr: 1 }} /> Số học sinh theo khối lớp
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={studentsByGrade}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <RechartsTooltip formatter={(value) => [`${value} học sinh`, 'Số lượng']} />
                <Bar dataKey="value" fill={theme.palette.primary.main} name="Số học sinh" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <GradeIcon sx={{ mr: 1 }} /> Phân bố học lực
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={academicPerformance}
                  cx="50%"
                  cy="50%"
                  labelLine={true}
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                >
                  {academicPerformance.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <RechartsTooltip formatter={(value, name, props) => [`${value} học sinh`, props.payload.name]} />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>
    );
  };

  // Render attendance and performance trends
  const renderAttendanceAndPerformance = () => {
    if (!data) return null;

    const { attendanceData, rewardsData } = data;

    return (
      <Grid container spacing={3} sx={{ mt: 2 }}>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <LineChartIcon sx={{ mr: 1 }} /> Tỷ lệ chuyên cần theo tháng (%)
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={attendanceData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis domain={[90, 100]} />
                <RechartsTooltip formatter={(value) => [`${value}%`, 'Tỷ lệ chuyên cần']} />
                <Line 
                  type="monotone" 
                  dataKey="rate" 
                  stroke={theme.palette.primary.main} 
                  activeDot={{ r: 8 }}
                  name="Tỷ lệ chuyên cần"
                />
              </LineChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2, height: '100%' }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <RewardIcon sx={{ mr: 1 }} /> Khen thưởng & Kỷ luật theo tháng
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={rewardsData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis />
                <RechartsTooltip />
                <Legend />
                <Bar dataKey="rewards" fill={theme.palette.success.main} name="Khen thưởng" />
                <Bar dataKey="disciplines" fill={theme.palette.error.main} name="Kỷ luật" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>
    );
  };

  // Render detail tables
  const renderDetailTables = () => {
    if (!data) return null;

    const { topClasses, recentEvents } = data;

    return (
      <Grid container spacing={3} sx={{ mt: 2 }}>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2 }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <SchoolIcon sx={{ mr: 1 }} /> Top 5 lớp học xuất sắc
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <TableContainer>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>STT</TableCell>
                    <TableCell>Lớp</TableCell>
                    <TableCell align="right">Điểm TB</TableCell>
                    <TableCell align="right">Chuyên cần</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {topClasses.map((row, index) => (
                    <TableRow key={row.id} sx={index < 3 ? { backgroundColor: alpha(theme.palette.success.light, 0.1) } : {}}>
                      <TableCell>
                        {index === 0 ? (
                          <Chip size="small" label="1" color="primary" />
                        ) : index === 1 ? (
                          <Chip size="small" label="2" color="secondary" />
                        ) : index === 2 ? (
                          <Chip size="small" label="3" color="success" />
                        ) : (
                          index + 1
                        )}
                      </TableCell>
                      <TableCell>{row.name}</TableCell>
                      <TableCell align="right">{row.averageGrade}</TableCell>
                      <TableCell align="right">{row.attendanceRate}%</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </Paper>
        </Grid>
        <Grid item xs={12} md={6}>
          <Paper elevation={3} sx={{ p: 2, borderRadius: 2 }}>
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
              <EventIcon sx={{ mr: 1 }} /> Sự kiện học thuật gần đây
            </Typography>
            <Divider sx={{ mb: 2 }} />
            <TableContainer>
              <Table size="small">
                <TableHead>
                  <TableRow>
                    <TableCell>Tiêu đề</TableCell>
                    <TableCell>Loại</TableCell>
                    <TableCell align="right">Ngày</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {recentEvents.map((event) => (
                    <TableRow key={event.id}>
                      <TableCell>{event.title}</TableCell>
                      <TableCell>
                        {event.type === 'exam' && <Chip size="small" label="Thi" color="error" />}
                        {event.type === 'meeting' && <Chip size="small" label="Họp" color="info" />}
                        {event.type === 'sport' && <Chip size="small" label="Thể thao" color="success" />}
                        {event.type === 'ceremony' && <Chip size="small" label="Lễ" color="secondary" />}
                      </TableCell>
                      <TableCell align="right">{format(new Date(event.date), 'dd/MM/yyyy')}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </Paper>
        </Grid>
      </Grid>
    );
  };

  // Render filter section
  const renderFilters = () => {
    return (
      <Paper 
        elevation={3} 
        sx={{ 
          p: 2, 
          mb: 3, 
          borderRadius: 2,
          background: `linear-gradient(to right, ${alpha(theme.palette.primary.light, 0.1)}, ${alpha(theme.palette.background.paper, 0.6)})`
        }}
      >
        <Typography variant="subtitle1" gutterBottom sx={{ display: 'flex', alignItems: 'center', fontWeight: 'bold' }}>
          <FilterIcon sx={{ mr: 1 }} /> Bộ lọc báo cáo
        </Typography>
        <Grid container spacing={2} alignItems="center">
          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth size="small" sx={{ mt: 1 }}>
              <InputLabel>Năm học</InputLabel>
              <Select
                value={filterYear}
                label="Năm học"
                onChange={(e) => setFilterYear(e.target.value)}
              >
                <MenuItem value="2023">2023-2024</MenuItem>
                <MenuItem value="2022">2022-2023</MenuItem>
                <MenuItem value="2021">2021-2022</MenuItem>
              </Select>
            </FormControl>
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <FormControl fullWidth size="small" sx={{ mt: 1 }}>
              <InputLabel>Học kỳ</InputLabel>
              <Select
                value={filterSemester}
                label="Học kỳ"
                onChange={(e) => setFilterSemester(e.target.value)}
              >
                <MenuItem value="Tất cả">Tất cả</MenuItem>
                <MenuItem value="HK1">Học kỳ 1</MenuItem>
                <MenuItem value="HK2">Học kỳ 2</MenuItem>
              </Select>
            </FormControl>
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
              <DatePicker
                label="Từ ngày"
                value={dateRange[0]}
                onChange={(newValue) => {
                  setDateRange([newValue, dateRange[1]]);
                }}
                slotProps={{ textField: { size: 'small', fullWidth: true } }}
              />
            </LocalizationProvider>
          </Grid>
          <Grid item xs={12} sm={6} md={3}>
            <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
              <DatePicker
                label="Đến ngày"
                value={dateRange[1]}
                onChange={(newValue) => {
                  setDateRange([dateRange[0], newValue]);
                }}
                slotProps={{ textField: { size: 'small', fullWidth: true } }}
              />
            </LocalizationProvider>
          </Grid>
        </Grid>
        <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 2 }}>
          <Button 
            variant="outlined" 
            color="primary" 
            startIcon={<RefreshIcon />}
            onClick={handleRefreshData}
            sx={{ mr: 1 }}
          >
            Làm mới
          </Button>
          <Button 
            variant="contained" 
            color="primary"
            onClick={() => alert('Áp dụng bộ lọc (tính năng đang phát triển)')}
          >
            Áp dụng
          </Button>
        </Box>
      </Paper>
    );
  };

  // Check if user has admin access
  const isAdmin = currentUser && ['admin', 'principal'].includes(currentUser.role);

  if (!isAdmin) {
    return (
      <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
        <Alert severity="warning">
          Bạn không có quyền truy cập vào trang thống kê này. Chỉ quản trị viên mới có thể xem trang này.
        </Alert>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ mt: 3, mb: 5 }}>
        {/* Header */}
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Typography variant="h4" component="h1" sx={{ display: 'flex', alignItems: 'center' }}>
            <AssessmentIcon sx={{ mr: 2, fontSize: 35 }} />
            Báo cáo & Thống kê
          </Typography>
          
          <Box>
            <Tooltip title="Xuất PDF">
              <IconButton 
                color="primary" 
                onClick={() => handleExportData('PDF')}
                sx={{ ml: 1 }}
              >
                <DownloadIcon />
              </IconButton>
            </Tooltip>
            <Tooltip title="In báo cáo">
              <IconButton 
                color="primary" 
                onClick={handlePrintReport}
                sx={{ ml: 1 }}
              >
                <PrintIcon />
              </IconButton>
            </Tooltip>
          </Box>
        </Box>

        {/* Filters */}
        {renderFilters()}

        {/* Tabs */}
        <Paper sx={{ borderRadius: 2 }}>
          <Tabs
            value={tabValue}
            onChange={handleTabChange}
            variant="scrollable"
            scrollButtons="auto"
            sx={{ borderBottom: 1, borderColor: 'divider' }}
          >
            <Tab label="Tổng quan" icon={<PieChartIcon />} iconPosition="start" />
            <Tab label="Học sinh" icon={<GroupIcon />} iconPosition="start" />
            <Tab label="Học tập" icon={<GradeIcon />} iconPosition="start" />
            <Tab label="Chuyên cần" icon={<LineChartIcon />} iconPosition="start" />
          </Tabs>
        </Paper>

        {/* Loading indicator */}
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
            <CircularProgress />
          </Box>
        ) : (
          <>
            {/* Tab panels */}
            <TabPanel value={tabValue} index={0}>
              {/* Dashboard overview */}
              {renderDashboardOverview()}
              {renderStudentStatistics()}
              {renderDetailTables()}
            </TabPanel>

            <TabPanel value={tabValue} index={1}>
              {/* Student statistics */}
              {renderStudentStatistics()}
              <Box sx={{ mt: 3 }}>
                <Typography variant="h6" gutterBottom>
                  Báo cáo chi tiết theo lớp
                </Typography>
                <Alert severity="info" sx={{ mt: 2 }}>
                  Báo cáo chi tiết đang được phát triển. Vui lòng quay lại sau.
                </Alert>
              </Box>
            </TabPanel>

            <TabPanel value={tabValue} index={2}>
              {/* Academic performance */}
              <Grid container spacing={3}>
                <Grid item xs={12} md={6}>
                  <Paper elevation={3} sx={{ p: 2, borderRadius: 2 }}>
                    <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                      <GradeIcon sx={{ mr: 1 }} /> Phân bố học lực
                    </Typography>
                    <Divider sx={{ mb: 2 }} />
                    <ResponsiveContainer width="100%" height={300}>
                      <PieChart>
                        <Pie
                          data={data.academicPerformance}
                          cx="50%"
                          cy="50%"
                          labelLine={true}
                          outerRadius={80}
                          fill="#8884d8"
                          dataKey="value"
                          label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                        >
                          {data.academicPerformance.map((entry, index) => (
                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                          ))}
                        </Pie>
                        <RechartsTooltip formatter={(value, name, props) => [`${value} học sinh`, props.payload.name]} />
                        <Legend />
                      </PieChart>
                    </ResponsiveContainer>
                  </Paper>
                </Grid>
                <Grid item xs={12} md={6}>
                  <Paper elevation={3} sx={{ p: 2, borderRadius: 2 }}>
                    <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                      <RewardIcon sx={{ mr: 1 }} /> Khen thưởng & Kỷ luật
                    </Typography>
                    <Divider sx={{ mb: 2 }} />
                    <ResponsiveContainer width="100%" height={300}>
                      <BarChart data={data.rewardsData}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="month" />
                        <YAxis />
                        <RechartsTooltip />
                        <Legend />
                        <Bar dataKey="rewards" fill={theme.palette.success.main} name="Khen thưởng" />
                        <Bar dataKey="disciplines" fill={theme.palette.error.main} name="Kỷ luật" />
                      </BarChart>
                    </ResponsiveContainer>
                  </Paper>
                </Grid>
              </Grid>

              <Box sx={{ mt: 3 }}>
                <Typography variant="h6" gutterBottom>
                  Báo cáo kết quả học tập theo môn học
                </Typography>
                <Alert severity="info" sx={{ mt: 2 }}>
                  Báo cáo chi tiết theo môn học đang được phát triển. Vui lòng quay lại sau.
                </Alert>
              </Box>
            </TabPanel>

            <TabPanel value={tabValue} index={3}>
              {/* Attendance */}
              {renderAttendanceAndPerformance()}
              <Box sx={{ mt: 3 }}>
                <Typography variant="h6" gutterBottom>
                  Báo cáo chuyên cần chi tiết
                </Typography>
                <Alert severity="info" sx={{ mt: 2 }}>
                  Báo cáo chi tiết về chuyên cần đang được phát triển. Vui lòng quay lại sau.
                </Alert>
              </Box>
            </TabPanel>
          </>
        )}
      </Box>
    </Container>
  );
};

export default ReportsPage; 