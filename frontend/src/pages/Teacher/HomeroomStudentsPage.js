import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, TextField, 
  CircularProgress, Alert, Breadcrumbs, Link, 
  Paper, Table, TableBody, TableCell, TableContainer, 
  TableHead, TableRow, TablePagination, Box,
  InputAdornment
} from '@mui/material';
import { 
  Search as SearchIcon, 
  ArrowBack as ArrowBackIcon, 
  BarChart as BarChartIcon
} from '@mui/icons-material';
import { getHomeroomClassStudents } from '../../services/teacherService';

const HomeroomStudentsPage = () => {
  const { classId } = useParams();
  const navigate = useNavigate();
  const [students, setStudents] = useState([]);
  const [filteredStudents, setFilteredStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchText, setSearchText] = useState('');
  const [className, setClassName] = useState('');
  
  // Pagination state
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  console.log('User from localStorage:', user);
  
  // Try different possible ID properties
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  console.log('Teacher ID used:', teacherId);
  
  useEffect(() => {
    const fetchStudents = async () => {
      try {
        setLoading(true);
        const data = await getHomeroomClassStudents(teacherId, classId);
        setStudents(data);
        setFilteredStudents(data);
        
        // Set class name from the first student if available
        if (data.length > 0) {
          setClassName(data[0].className || '');
        }
        
        setError(null);
      } catch (error) {
        console.error('Error fetching students:', error);
        setError('Không thể tải danh sách học sinh. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (teacherId && classId) {
      fetchStudents();
    } else {
      setError('Thiếu thông tin giáo viên hoặc lớp học. Vui lòng thử lại.');
      setLoading(false);
    }
  }, [teacherId, classId]);
  
  useEffect(() => {
    if (searchText) {
      const filtered = students.filter(student => 
        student.name.toLowerCase().includes(searchText.toLowerCase()) ||
        (student.studentId && student.studentId.toString().includes(searchText))
      );
      setFilteredStudents(filtered);
    } else {
      setFilteredStudents(students);
    }
  }, [searchText, students]);
  
  const handleSearch = (e) => {
    setSearchText(e.target.value);
  };
  
  const handleBackClick = () => {
    navigate('/teacher/homeroom');
  };
  
  const handleViewGrades = (studentId) => {
    navigate(`/teacher/homeroom/${classId}/student/${studentId}/grades`);
  };
  
  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };
  
  const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('vi-VN');
  };
  
  const renderGender = (gender) => {
    return gender === 'MALE' ? 'Nam' : gender === 'FEMALE' ? 'Nữ' : '-';
  };
  
  if (loading) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải danh sách học sinh...
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
  
  return (
    <Container style={{ padding: '24px' }}>
      <Breadcrumbs style={{ marginBottom: '16px' }}>
        <Link 
          component="button" 
          variant="body1" 
          onClick={handleBackClick}
          underline="hover"
        >
          Lớp chủ nhiệm
        </Link>
        <Typography color="textPrimary">Danh sách học sinh</Typography>
      </Breadcrumbs>
      
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Box>
          <Typography variant="h4" gutterBottom>
            Danh sách học sinh {className && `Lớp ${className}`}
          </Typography>
          <Typography variant="subtitle1" color="textSecondary">
            Tổng số: {students.length} học sinh
          </Typography>
        </Box>
        <Button 
          variant="outlined" 
          startIcon={<ArrowBackIcon />} 
          onClick={handleBackClick}
        >
          Quay lại
        </Button>
      </Box>
      
      <Box mb={3}>
        <TextField
          placeholder="Tìm kiếm theo tên hoặc mã học sinh"
          value={searchText}
          onChange={handleSearch}
          style={{ width: 300 }}
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
        />
      </Box>
      
      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Mã học sinh</TableCell>
              <TableCell>Họ và tên</TableCell>
              <TableCell>Giới tính</TableCell>
              <TableCell>Ngày sinh</TableCell>
              <TableCell>Email</TableCell>
              <TableCell>Số điện thoại</TableCell>
              <TableCell align="center">Thao tác</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredStudents
              .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
              .map((student) => (
                <TableRow key={student.id}>
                  <TableCell>{student.studentId}</TableCell>
                  <TableCell>{student.name}</TableCell>
                  <TableCell>{renderGender(student.gender)}</TableCell>
                  <TableCell>{formatDate(student.dob)}</TableCell>
                  <TableCell>{student.email || '-'}</TableCell>
                  <TableCell>{student.phoneNumber || '-'}</TableCell>
                  <TableCell align="center">
                    <Button
                      variant="contained"
                      color="primary"
                      startIcon={<BarChartIcon />}
                      onClick={() => handleViewGrades(student.id)}
                    >
                      Xem điểm
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
          </TableBody>
        </Table>
        <TablePagination
          rowsPerPageOptions={[10, 20, 50]}
          component="div"
          count={filteredStudents.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
          labelRowsPerPage="Số hàng mỗi trang:"
          labelDisplayedRows={({ from, to, count }) => `${from}-${to} của ${count}`}
        />
      </TableContainer>
    </Container>
  );
};

export default HomeroomStudentsPage; 