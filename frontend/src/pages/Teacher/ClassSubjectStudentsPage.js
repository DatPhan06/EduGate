import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, TextField, 
  CircularProgress, Alert, Breadcrumbs, Link, 
  Paper, Table, TableBody, TableCell, TableContainer, 
  TableHead, TableRow, TablePagination, Box,
  InputAdornment, FormControl, InputLabel, MenuItem, Select
} from '@mui/material';
import { 
  Search as SearchIcon, 
  ArrowBack as ArrowBackIcon, 
  Assessment as AssessmentIcon
} from '@mui/icons-material';
import { getStudentsInClassSubject, getStudentGradesForTeacher } from '../../services/teacherService';

const ClassSubjectStudentsPage = () => {
  const { classSubjectId } = useParams();
  const navigate = useNavigate();
  const [students, setStudents] = useState([]);
  const [filteredStudents, setFilteredStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchText, setSearchText] = useState('');
  const [className, setClassName] = useState('');
  const [subjectName, setSubjectName] = useState('');
  const [activeSemester, setActiveSemester] = useState('HK1');
  const [studentGrades, setStudentGrades] = useState({});
  const [loadingGrades, setLoadingGrades] = useState(false);
  
  // Pagination state
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  
  useEffect(() => {
    const fetchStudents = async () => {
      try {
        setLoading(true);
        console.log(`Fetching students for teacher ${teacherId} and class subject ${classSubjectId}`);
        const data = await getStudentsInClassSubject(teacherId, classSubjectId);
        console.log('Student data:', data);
        setStudents(data);
        setFilteredStudents(data);
        
        // Set class and subject names if available in the first student
        if (data.length > 0) {
          setClassName(data[0].className || '');
          setSubjectName(data[0].subjectName || '');
        }
        
        setError(null);
      } catch (error) {
        console.error('Error fetching students:', error);
        setError('Không thể tải danh sách học sinh. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (teacherId && classSubjectId) {
      fetchStudents();
    } else {
      setError('Thiếu thông tin giáo viên hoặc lớp học. Vui lòng thử lại.');
      setLoading(false);
    }
  }, [teacherId, classSubjectId]);
  
  // Fetch grades for all students in the class
  useEffect(() => {
    const fetchStudentGrades = async () => {
      if (!students.length) return;
      
      try {
        setLoadingGrades(true);
        const gradesMap = {};
        
        // Fetch grades for each student
        for (const student of students) {
          try {
            const grades = await getStudentGradesForTeacher(
              teacherId,
              student.id,
              classSubjectId,
              activeSemester
            );
            
            // If there are grades for this student and this subject, store the final score
            if (grades && grades.length > 0) {
              const gradeForThisSubject = grades.find(g => g.ClassSubjectID == classSubjectId);
              if (gradeForThisSubject) {
                gradesMap[student.id] = gradeForThisSubject.FinalScore;
              }
            }
          } catch (e) {
            console.error(`Error fetching grades for student ${student.id}:`, e);
          }
        }
        
        setStudentGrades(gradesMap);
      } catch (error) {
        console.error('Error fetching student grades:', error);
      } finally {
        setLoadingGrades(false);
      }
    };
    
    fetchStudentGrades();
  }, [students, teacherId, classSubjectId, activeSemester]);
  
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
    navigate('/teacher/subjects');
  };
  
  const handleViewGrades = (studentId) => {
    navigate(`/teacher/subjects/${classSubjectId}/student/${studentId}/grades`);
  };
  
  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };
  
  const handleSemesterChange = (event) => {
    setActiveSemester(event.target.value);
  };
  
  const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('vi-VN');
  };
  
  const renderGender = (gender) => {
    return gender === 'MALE' ? 'Nam' : gender === 'FEMALE' ? 'Nữ' : '-';
  };
  
  const renderFinalGrade = (studentId) => {
    if (loadingGrades) return <CircularProgress size={16} />;
    
    const grade = studentGrades[studentId];
    if (grade !== undefined && grade !== null) {
      return (
        <Typography 
          variant="body1" 
          style={{ 
            fontWeight: 'bold', 
            color: grade >= 5 ? '#2e7d32' : '#d32f2f' 
          }}
        >
          {grade.toFixed(1)}
        </Typography>
      );
    }
    return <Typography variant="body2" color="textSecondary">Chưa có</Typography>;
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
          Môn học đang dạy
        </Link>
        <Typography color="textPrimary">Danh sách học sinh</Typography>
      </Breadcrumbs>
      
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Box>
          <Typography variant="h4" gutterBottom>
            Danh sách học sinh {className && `Lớp ${className}`}
            {subjectName && ` - ${subjectName}`}
          </Typography>
          <Typography variant="subtitle1" color="textSecondary">
            Tổng số: {students.length} học sinh
          </Typography>
        </Box>
        <Box display="flex" alignItems="center">
          <FormControl variant="outlined" size="small" style={{ width: 120, marginRight: 16 }}>
            <InputLabel id="semester-select-label">Học kỳ</InputLabel>
            <Select
              labelId="semester-select-label"
              value={activeSemester}
              onChange={handleSemesterChange}
              label="Học kỳ"
            >
              <MenuItem value="HK1">Học kỳ 1</MenuItem>
              <MenuItem value="HK2">Học kỳ 2</MenuItem>
            </Select>
          </FormControl>
          <Button 
            variant="outlined" 
            startIcon={<ArrowBackIcon />} 
            onClick={handleBackClick}
          >
            Quay lại
          </Button>
        </Box>
      </Box>
      
      <Box mb={3} display="flex" justifyContent="space-between" alignItems="center">
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
        <Typography variant="subtitle1">
          {loadingGrades && <CircularProgress size={20} style={{ marginRight: 8 }} />}
          Đang hiển thị điểm {activeSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'}
        </Typography>
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
              <TableCell align="center">Điểm tổng kết</TableCell>
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
                  <TableCell align="center">{renderFinalGrade(student.id)}</TableCell>
                  <TableCell align="center">
                    <Button
                      variant="contained"
                      color="primary"
                      startIcon={<AssessmentIcon />}
                      onClick={() => handleViewGrades(student.id)}
                    >
                      Điểm số
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

export default ClassSubjectStudentsPage; 