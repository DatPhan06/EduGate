import React, { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Box, Grid, 
  CircularProgress, Alert, FormControl, InputLabel,
  Select, MenuItem, TextField, IconButton, Chip,
  Table, TableBody, TableCell, TableContainer, TableHead, 
  TableRow, Paper, Button, TablePagination
} from '@mui/material';
import { 
  School as SchoolIcon, 
  FilterList as FilterListIcon,
  Search as SearchIcon,
  Clear as ClearIcon,
  People as PeopleIcon
} from '@mui/icons-material';
import { getTeacherSubjects } from '../../services/teacherService';

const TeachingSubjectsPage = () => {
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  
  // Filtering state
  const [selectedSemester, setSelectedSemester] = useState('all');
  const [selectedYear, setSelectedYear] = useState('all');
  const [searchText, setSearchText] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  
  // Pagination state
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  
  useEffect(() => {
    const fetchTeacherSubjects = async () => {
      try {
        setLoading(true);
        const data = await getTeacherSubjects(teacherId);
        console.log('Teacher subjects data:', data);
        
        // The API now provides semester and academic year info, no need to add dummy data
        setClasses(data);
        setError(null);
      } catch (error) {
        console.error('Error fetching teacher subjects:', error);
        setError('Không thể tải danh sách lớp học và môn học. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (teacherId) {
      fetchTeacherSubjects();
    } else {
      setError('Không tìm thấy thông tin giáo viên. Vui lòng đăng nhập lại.');
      setLoading(false);
    }
  }, [teacherId]);
  
  // Extract all subjects from classes into a flat list
  const allSubjects = useMemo(() => {
    let subjects = [];
    classes.forEach(classItem => {
      classItem.subjects.forEach(subject => {
        subjects.push({
          ...subject,
          class_name: classItem.class_name,
          grade_level: classItem.grade_level,
          class_id: classItem.class_id
        });
      });
    });
    return subjects;
  }, [classes]);
  
  // Extract available academic years and semesters for filter options
  const { availableYears, availableSemesters } = useMemo(() => {
    const years = new Set();
    const semesters = new Set();
    
    allSubjects.forEach(subject => {
      if (subject.academic_year) years.add(subject.academic_year);
      if (subject.semester) semesters.add(subject.semester);
    });
    
    return {
      availableYears: Array.from(years).sort().reverse(),
      availableSemesters: Array.from(semesters).sort()
    };
  }, [allSubjects]);
  
  // Filter subjects based on selected filters
  const filteredSubjects = useMemo(() => {
    return allSubjects.filter(subject => {
      const matchesSemester = selectedSemester === 'all' || subject.semester === selectedSemester;
      const matchesYear = selectedYear === 'all' || subject.academic_year === selectedYear;
      const matchesSearch = !searchText || 
        subject.subject_name.toLowerCase().includes(searchText.toLowerCase()) ||
        subject.class_name.toLowerCase().includes(searchText.toLowerCase());
      
      return matchesSemester && matchesYear && matchesSearch;
    });
  }, [allSubjects, selectedSemester, selectedYear, searchText]);
  
  const handleViewStudents = (classSubjectId) => {
    navigate(`/teacher/subjects/${classSubjectId}/students`);
  };
  
  const handleSemesterChange = (event) => {
    setSelectedSemester(event.target.value);
  };
  
  const handleYearChange = (event) => {
    setSelectedYear(event.target.value);
  };
  
  const handleSearchChange = (event) => {
    setSearchText(event.target.value);
  };
  
  const handleClearFilters = () => {
    setSelectedSemester('all');
    setSelectedYear('all');
    setSearchText('');
  };
  
  const toggleFilters = () => {
    setShowFilters(!showFilters);
  };
  
  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };
  
  const getFullClassName = (className, gradeLevel) => {
    return `Khối ${gradeLevel} - ${className}`;
  };
  
  if (loading) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải danh sách lớp học và môn học...
        </Typography>
      </Box>
    );
  }
  
  if (error) {
    return (
      <Alert severity="error">
        <Typography variant="subtitle1">{error}</Typography>
      </Alert>
    );
  }
  
  if (classes.length === 0) {
    return (
      <Alert severity="info">
        <Typography variant="subtitle1">
          Bạn chưa được phân công dạy lớp nào.
        </Typography>
      </Alert>
    );
  }
  
  return (
    <Container style={{ padding: '24px' }}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Box>
          <Typography variant="h4" gutterBottom>Môn Học Đang Dạy</Typography>
          <Typography variant="subtitle1" color="textSecondary">
            Quản lý điểm số cho các lớp và môn học bạn được phân công giảng dạy
          </Typography>
        </Box>
        <Button
          variant="outlined"
          startIcon={<FilterListIcon />}
          onClick={toggleFilters}
        >
          Bộ lọc
        </Button>
      </Box>
      
      {showFilters && (
        <Box 
          mb={3} 
          p={2} 
          border={1} 
          borderColor="divider" 
          borderRadius={1} 
          bgcolor="background.paper"
        >
          <Typography variant="subtitle1" gutterBottom fontWeight="bold">
            Lọc kết quả
          </Typography>
          
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth size="small">
                <InputLabel>Học kỳ</InputLabel>
                <Select
                  value={selectedSemester}
                  onChange={handleSemesterChange}
                  label="Học kỳ"
                >
                  <MenuItem value="all">Tất cả học kỳ</MenuItem>
                  {availableSemesters.map(semester => (
                    <MenuItem key={semester} value={semester}>
                      {semester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} sm={3}>
              <FormControl fullWidth size="small">
                <InputLabel>Năm học</InputLabel>
                <Select
                  value={selectedYear}
                  onChange={handleYearChange}
                  label="Năm học"
                >
                  <MenuItem value="all">Tất cả năm học</MenuItem>
                  {availableYears.map(year => (
                    <MenuItem key={year} value={year}>
                      {year}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            
            <Grid item xs={12} sm={4}>
              <TextField
                fullWidth
                size="small"
                label="Tìm kiếm"
                value={searchText}
                onChange={handleSearchChange}
                InputProps={{
                  endAdornment: searchText ? (
                    <IconButton 
                      size="small" 
                      onClick={() => setSearchText('')}
                      edge="end"
                    >
                      <ClearIcon fontSize="small" />
                    </IconButton>
                  ) : (
                    <SearchIcon color="action" />
                  )
                }}
              />
            </Grid>
            
            <Grid item xs={12} sm={2}>
              <Button 
                fullWidth 
                variant="outlined" 
                onClick={handleClearFilters}
              >
                Xóa bộ lọc
              </Button>
            </Grid>
          </Grid>
          
          {/* Display active filters */}
          {(selectedSemester !== 'all' || selectedYear !== 'all' || searchText) && (
            <Box mt={2} display="flex" flexWrap="wrap" gap={1}>
              {selectedSemester !== 'all' && (
                <Chip 
                  label={`Học kỳ: ${selectedSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'}`} 
                  onDelete={() => setSelectedSemester('all')} 
                  size="small"
                  color="primary"
                  variant="outlined"
                />
              )}
              {selectedYear !== 'all' && (
                <Chip 
                  label={`Năm học: ${selectedYear}`} 
                  onDelete={() => setSelectedYear('all')} 
                  size="small"
                  color="primary"
                  variant="outlined"
                />
              )}
              {searchText && (
                <Chip 
                  label={`Tìm kiếm: ${searchText}`} 
                  onDelete={() => setSearchText('')} 
                  size="small"
                  color="primary"
                  variant="outlined"
                />
              )}
            </Box>
          )}
        </Box>
      )}
      
      {filteredSubjects.length === 0 ? (
        <Alert severity="info">
          <Typography variant="subtitle1">
            Không tìm thấy môn học nào phù hợp với bộ lọc đã chọn.
          </Typography>
        </Alert>
      ) : (
        <Paper elevation={0} variant="outlined">
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell><strong>Môn Học</strong></TableCell>
                  <TableCell><strong>Lớp</strong></TableCell>
                  <TableCell><strong>Học Kỳ</strong></TableCell>
                  <TableCell><strong>Năm Học</strong></TableCell>
                  <TableCell align="center"><strong>Thao Tác</strong></TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredSubjects
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((subject) => (
                    <TableRow key={subject.class_subject_id}>
                      <TableCell>{subject.subject_name}</TableCell>
                      <TableCell>{getFullClassName(subject.class_name, subject.grade_level)}</TableCell>
                      <TableCell>
                        <Chip 
                          label={subject.semester} 
                          size="small" 
                          color={subject.semester === 'HK1' ? 'primary' : 'secondary'} 
                        />
                      </TableCell>
                      <TableCell>{subject.academic_year}</TableCell>
                      <TableCell align="center">
                        <Button
                          variant="contained"
                          color="primary"
                          startIcon={<PeopleIcon />}
                          onClick={() => handleViewStudents(subject.class_subject_id)}
                        >
                          Xem học sinh
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
              </TableBody>
            </Table>
            <TablePagination
              rowsPerPageOptions={[5, 10, 25]}
              component="div"
              count={filteredSubjects.length}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={handleChangePage}
              onRowsPerPageChange={handleChangeRowsPerPage}
              labelRowsPerPage="Số hàng mỗi trang:"
              labelDisplayedRows={({ from, to, count }) => `${from}-${to} của ${count}`}
            />
          </TableContainer>
        </Paper>
      )}
    </Container>
  );
};

export default TeachingSubjectsPage; 