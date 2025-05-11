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

// Helper function to generate random numbers
const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const getRandomFloat = (min, max, decimals) => parseFloat((Math.random() * (max - min) + min).toFixed(decimals));

const generateRealisticMockData = (currentYear) => {
  const academicYear = `${currentYear}-${currentYear + 1}`;
  const prevAcademicYear = `${currentYear - 1}-${currentYear}`;

  // --- Total Stats ---
  // Based on SQL, smaller numbers seem more appropriate than the original 1600 students.
  // Let's assume a small to medium-sized high school.
  const totalStudents = getRandomInt(300, 600); // e.g., ~100-200 per grade for 3 grades
  const totalTeachers = getRandomInt(25, 50);
  const totalClasses = getRandomInt(12, 20); // e.g., 4-6 classes per grade level

  // --- Students By Grade ---
  // Assuming a typical 3-grade high school (10, 11, 12)
  const gradeLevels = ['Khối 10', 'Khối 11', 'Khối 12'];
  const studentsByGrade = gradeLevels.map(grade => ({
    name: grade,
    value: Math.floor(totalStudents / gradeLevels.length) + getRandomInt(-20, 20), // distribute students, with some variance
  }));
  // Adjust total students to match sum from byGrade for consistency
  const actualTotalStudents = studentsByGrade.reduce((sum, g) => sum + g.value, 0);


  // --- Attendance Data (for current academic year, monthly) ---
  const months = ['Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5'];
  const attendanceData = months.map(month => ({
    month: month,
    rate: getRandomFloat(92.0, 99.5, 1), // Attendance rate %
  }));

  // --- Academic Performance (distribution for the whole school) ---
  const performanceCategories = ['Xuất sắc', 'Giỏi', 'Khá', 'Trung bình', 'Yếu'];
  let remainingStudentsForPerformance = actualTotalStudents;
  const academicPerformance = performanceCategories.map((category, index) => {
    let count;
    if (index === performanceCategories.length - 1) {
      count = remainingStudentsForPerformance;
    } else {
      let maxForCategory;
      switch(category) {
        case 'Xuất sắc': maxForCategory = Math.floor(actualTotalStudents * 0.15); break; // Max 15%
        case 'Giỏi': maxForCategory = Math.floor(actualTotalStudents * 0.35); break;     // Max 35%
        case 'Khá': maxForCategory = Math.floor(actualTotalStudents * 0.40); break;      // Max 40%
        case 'Trung bình': maxForCategory = Math.floor(actualTotalStudents * 0.20); break; // Max 20%
        default: maxForCategory = Math.floor(actualTotalStudents * 0.10);
      }
      count = getRandomInt(Math.floor(actualTotalStudents * 0.05), maxForCategory);
      if (count > remainingStudentsForPerformance) count = remainingStudentsForPerformance;
    }
    remainingStudentsForPerformance -= count;
    if (remainingStudentsForPerformance < 0) remainingStudentsForPerformance = 0;
    return { name: category, value: count < 0 ? 0 : count };
  });
   // Ensure sum matches totalStudents
  const performanceSum = academicPerformance.reduce((sum, p) => sum + p.value, 0);
  if (performanceSum !== actualTotalStudents && academicPerformance.length > 0) {
    const diff = actualTotalStudents - performanceSum;
    academicPerformance[academicPerformance.length -1].value += diff; // Add/remove diff from last category
     if(academicPerformance[academicPerformance.length -1].value < 0) academicPerformance[academicPerformance.length -1].value = 0;
  }


  // --- Rewards and Discipline Data (monthly for current academic year) ---
  const rewardsData = months.map(month => ({
    month: month,
    rewards: getRandomInt(5, 30),
    disciplines: getRandomInt(0, 10),
  }));

  // --- Recent Academic Events ---
  // Based on 'events' table: Title, Type, EventDate
  const eventTypes = ['exam', 'meeting', 'sport', 'ceremony', 'activity', 'school_holiday', 'teacher_training'];
  const eventTitles = {
    exam: ['Kiểm tra giữa kỳ', 'Thi học kỳ I', 'Thi học kỳ II', 'Thi thử THPT Quốc Gia'],
    meeting: ['Họp phụ huynh đầu năm', 'Họp phụ huynh cuối kỳ', 'Họp chuyên môn tổ', 'Họp hội đồng sư phạm'],
    sport: ['Hội khỏe Phù Đổng cấp trường', 'Giải bóng đá học sinh', 'Giải cờ vua'],
    ceremony: ['Lễ khai giảng', 'Lễ tổng kết năm học', 'Lễ kỷ niệm ngày nhà giáo'],
    activity: ['Hoạt động ngoại khóa STEM', 'Tham quan dã ngoại', 'Chương trình văn nghệ'],
    school_holiday: ['Nghỉ Lễ Quốc Khánh', 'Nghỉ Tết Âm Lịch', 'Nghỉ Giỗ Tổ Hùng Vương'],
    teacher_training: ['Tập huấn chuyên môn hè', 'Workshop ứng dụng CNTT', 'Bồi dưỡng nghiệp vụ'],
  };
  const recentEvents = Array.from({ length: getRandomInt(5, 10) }).map((_, i) => {
    const type = eventTypes[getRandomInt(0, eventTypes.length - 1)];
    const titleArray = eventTitles[type] || ['Sự kiện chung'];
    const title = titleArray[getRandomInt(0, titleArray.length - 1)];
    const eventMonth = getRandomInt(1, 12);
    const eventDay = getRandomInt(1, 28);
    // Generate dates within the current academic year, or slightly before/after
    const yearForEvent = (eventMonth >=8 && eventMonth <=12) ? currentYear : currentYear + 1;
    return {
      id: i + 1,
      title: `${title} - ${academicYear}`,
      date: new Date(yearForEvent, eventMonth - 1, eventDay).toISOString().split('T')[0],
      type: type,
    };
  }).sort((a, b) => new Date(b.date) - new Date(a.date)); // Sort by date descending

  // --- Top Performing Classes ---
  // Based on 'classes' table: ClassName, GradeLevel
  // We'll make up some class names
  const classNamesExamples = ['A1', 'A2', 'A3', 'B1', 'B2', 'C1'];
  const topClasses = Array.from({ length: 5 }).map((_, i) => {
    const gradeLevel = gradeLevels[getRandomInt(0, gradeLevels.length -1)].replace('Khối ', ''); // "10", "11", "12"
    const classSuffix = classNamesExamples[getRandomInt(0, classNamesExamples.length - 1)];
    return {
      id: i + 1,
      name: `${gradeLevel}${classSuffix}`, // e.g., 10A1, 11B2
      averageGrade: getRandomFloat(7.5, 9.5, 1),
      attendanceRate: getRandomFloat(95.0, 99.8, 1),
    };
  }).sort((a,b) => b.averageGrade - a.averageGrade);


  return {
    studentsByGrade,
    attendanceData,
    academicPerformance,
    rewardsData,
    recentEvents,
    topClasses,
    totalStats: {
      students: actualTotalStudents,
      teachers: totalTeachers,
      classes: totalClasses,
      events: recentEvents.length, // Count generated events
      messages: getRandomInt(500, 3000), // Still a placeholder
    },
    currentAcademicYear: academicYear,
    previousAcademicYear: prevAcademicYear
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
          const currentYearForData = parseInt(filterYear); // Use the selected filter year
          const realisticMockData = generateRealisticMockData(currentYearForData);
          setData(realisticMockData);
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
      const currentYearForData = parseInt(filterYear); // Use the selected filter year
      const realisticMockData = generateRealisticMockData(currentYearForData);
      setData(realisticMockData);
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
    const currentYr = new Date().getFullYear();
    const academicYears = Array.from({length: 5}, (_, i) => {
      const year = currentYr - i;
      return { value: year.toString(), label: `${year}-${year+1}` };
    });
    // Add future years if needed, e.g., for planning
    // To make it align with current selection options, ensure the current year is in the middle of a few past/future if possible
    const yearsForFilter = [];
    for (let i = 2; i > 0; i--) { // 2 past years
        const year = currentYr - i;
        yearsForFilter.push({ value: year.toString(), label: `${year}-${year+1}` });
    }
    yearsForFilter.push({ value: currentYr.toString(), label: `${currentYr}-${currentYr+1}` }); // current year
    for (let i = 1; i <= 2; i++) { // 2 future years
        const year = currentYr + i;
        yearsForFilter.push({ value: year.toString(), label: `${year}-${year+1}` });
    }

    // Ensure the initially selected filterYear is present, or add it.
    // The current `filterYear` is a string like "2023", the value in `yearsForFilter` is also a string.
    if (!yearsForFilter.find(y => y.value === filterYear)) {
        const selectedYearInt = parseInt(filterYear);
        yearsForFilter.push({ value: filterYear, label: `${selectedYearInt}-${selectedYearInt+1}`});
        // Sort again if a new year was pushed
        yearsForFilter.sort((a,b) => parseInt(a.value) - parseInt(b.value));
    }


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
                onChange={(e) => {
                  setFilterYear(e.target.value);
                  // Data will be refreshed by Apply or Refresh button
                }}
              >
                {yearsForFilter.map(ay => (
                  <MenuItem key={ay.value} value={ay.value}>{ay.label}</MenuItem>
                ))}
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
            onClick={handleRefreshData}
          >
            Áp dụng
          </Button>
        </Box>
      </Paper>
    );
  };

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
                  <Paper elevation={3} sx={{ p: 2, borderRadius: 2, height: '100%' }}>
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