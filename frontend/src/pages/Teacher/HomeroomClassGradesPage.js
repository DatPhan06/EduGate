import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, Box, CircularProgress, Alert, 
  Breadcrumbs, Link, Card, Tabs, Tab, 
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, 
  Paper, FormControl, InputLabel, MenuItem, Select, TextField,
  IconButton, Tooltip, Dialog, DialogTitle, DialogContent, DialogActions
} from '@mui/material';
import { 
  ArrowBack as ArrowBackIcon, 
  Edit as EditIcon, 
  Search as SearchIcon,
  Refresh as RefreshIcon,
  Person as PersonIcon
} from '@mui/icons-material';
import { 
  getHomeroomClassStudents, 
  getClassGrades, 
  getClassSubjects,
  getStudentGrades 
} from '../../services/teacherService';
import { useSnackbar } from 'notistack';

const HomeroomClassGradesPage = () => {
  const { classId } = useParams();
  const navigate = useNavigate();
  const [students, setStudents] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [grades, setGrades] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [className, setClassName] = useState('');
  const [activeSemester, setActiveSemester] = useState('HK1');
  const [activeAcademicYear, setActiveAcademicYear] = useState('2023-2024');
  const [activeSubject, setActiveSubject] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');
  const { enqueueSnackbar } = useSnackbar();
  const [studentDialogOpen, setStudentDialogOpen] = useState(false);
  const [selectedStudent, setSelectedStudent] = useState(null);

  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  
  // Fetch students for the class
  useEffect(() => {
    const fetchStudents = async () => {
      try {
        setLoading(true);
        const data = await getHomeroomClassStudents(teacherId, classId);
        setStudents(data);
        
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

  // Fetch subjects for the class
  useEffect(() => {
    const fetchSubjects = async () => {
      try {
        const data = await getClassSubjects(classId);
        console.log('Original subjects from API:', data);
        
        // Remove duplicate subjects based on subject ID
        const uniqueSubjects = [];
        const subjectIds = new Set();
        
        data.forEach(subject => {
          if (!subjectIds.has(subject.id)) {
            subjectIds.add(subject.id);
            uniqueSubjects.push(subject);
          }
        });
        
        console.log('Unique subjects after filtering:', uniqueSubjects);
        setSubjects(uniqueSubjects);
      } catch (error) {
        console.error('Error fetching subjects:', error);
        enqueueSnackbar('Không thể tải danh sách môn học', { variant: 'error' });
      }
    };
    
    if (classId) {
      fetchSubjects();
    }
  }, [classId, enqueueSnackbar]);

  // Fetch grades when semester, academic year, or students change
  useEffect(() => {
    const fetchAllStudentsGrades = async () => {
      if (!classId) return;
      
      try {
        setLoading(true);
        
        // Get all grades for the class in one API call
        const classGradesData = await getClassGrades(teacherId, classId, activeSemester, activeAcademicYear);
        console.log('Class grades data:', classGradesData);
        
        // Transform the data into the format expected by the component
        const gradesData = {};
        
        classGradesData.forEach(studentGradeData => {
          const studentId = studentGradeData.student_id;
          gradesData[studentId] = studentGradeData.grades.map(grade => ({
            id: grade.GradeID,
            studentId: grade.StudentID,
            subjectId: grade.subjectId,
            subjectName: grade.subjectName,
            finalGrade: grade.FinalScore,
            semester: grade.Semester,
            components: grade.grade_components?.map(component => ({
              id: component.ComponentID,
              name: component.ComponentName,
              weight: component.Weight,
              score: component.Score
            })) || []
          }));
        });
        
        setGrades(gradesData);
        setError(null);
      } catch (error) {
        console.error('Error fetching class grades:', error);
        setError('Không thể tải dữ liệu điểm số. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (classId && activeSemester && activeAcademicYear) {
      fetchAllStudentsGrades();
    }
  }, [classId, teacherId, activeSemester, activeAcademicYear]);

  const handleSemesterChange = (event) => {
    setActiveSemester(event.target.value);
  };
  
  const handleAcademicYearChange = (event) => {
    setActiveAcademicYear(event.target.value);
  };
  
  const handleSubjectChange = (event, newValue) => {
    setActiveSubject(newValue);
  };
  
  const handleBackClick = () => {
    navigate('/teacher/homeroom');
  };
  
  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };
  
  const filteredStudents = students.filter(student => 
    student.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    (student.studentId && student.studentId.toString().includes(searchTerm))
  );
  
  const handleViewStudentGrades = (student) => {
    setSelectedStudent(student);
    setStudentDialogOpen(true);
  };
  
  const handleCloseStudentDialog = () => {
    setStudentDialogOpen(false);
    setSelectedStudent(null);
  };
  
  const handleViewDetailedGrades = (studentId) => {
    navigate(`/teacher/homeroom/${classId}/student/${studentId}/grades`);
  };
  
  // Get the current subject
  const getCurrentSubject = () => {
    return subjects[activeSubject] || {};
  };
  
  // Get average grade for a student in a specific subject
  const getStudentSubjectAverage = (studentId, subjectId) => {
    if (!grades[studentId]) return '-';
    
    const studentGrades = grades[studentId];
    const subjectGrade = studentGrades.find(grade => grade.subjectId === subjectId);
    
    return subjectGrade && subjectGrade.finalGrade !== undefined && subjectGrade.finalGrade !== null ? 
      subjectGrade.finalGrade.toFixed(1) : '-';
  };
  
  // Calculate average of all subjects for a student
  const getStudentOverallAverage = (studentId) => {
    if (!grades[studentId]) return '-';
    
    const studentGrades = grades[studentId];
    if (studentGrades.length === 0) return '-';
    
    const gradesWithFinals = studentGrades.filter(grade => 
      grade.finalGrade !== undefined && grade.finalGrade !== null
    );
    
    if (gradesWithFinals.length === 0) return '-';
    
    const sum = gradesWithFinals.reduce((total, grade) => total + grade.finalGrade, 0);
    return (sum / gradesWithFinals.length).toFixed(1);
  };
  
  if (loading && students.length === 0) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải dữ liệu...
        </Typography>
      </Box>
    );
  }
  
  if (error && students.length === 0) {
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
          onClick={() => navigate('/teacher/homeroom')}
          underline="hover"
        >
          Lớp chủ nhiệm
        </Link>
        <Typography color="textPrimary">Bảng điểm lớp {className}</Typography>
      </Breadcrumbs>
      
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Bảng Điểm Lớp {className}</Typography>
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
          <FormControl variant="outlined" size="small" style={{ width: 150, marginRight: 16 }}>
            <InputLabel id="academic-year-select-label">Năm học</InputLabel>
            <Select
              labelId="academic-year-select-label"
              value={activeAcademicYear}
              onChange={handleAcademicYearChange}
              label="Năm học"
            >
              <MenuItem value="2022-2023">2022-2023</MenuItem>
              <MenuItem value="2023-2024">2023-2024</MenuItem>
              <MenuItem value="2024-2025">2024-2025</MenuItem>
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
      
      <Box mb={3}>
        <TextField
          placeholder="Tìm kiếm học sinh..."
          value={searchTerm}
          onChange={handleSearchChange}
          variant="outlined"
          size="small"
          style={{ width: 300 }}
          InputProps={{
            startAdornment: <SearchIcon color="action" style={{ marginRight: 8 }} />,
          }}
        />
      </Box>
      
      {subjects.length > 0 ? (
        <Paper variant="outlined">
          <Box borderBottom={1} borderColor="divider">
            <Tabs 
              value={activeSubject} 
              onChange={handleSubjectChange}
              indicatorColor="primary"
              textColor="primary"
              variant="scrollable"
              scrollButtons="auto"
            >
              {subjects.map((subject, index) => (
                <Tab key={subject.id} label={subject.name} />
              ))}
              <Tab label="Tổng hợp" />
            </Tabs>
          </Box>
          
          {loading ? (
            <Box display="flex" justifyContent="center" p={3}>
              <CircularProgress size={40} />
            </Box>
          ) : (
            <TableContainer>
              <Table>
                <TableHead>
                  <TableRow>
                    <TableCell style={{ fontWeight: 'bold' }}>Mã HS</TableCell>
                    <TableCell style={{ fontWeight: 'bold' }}>Họ và tên</TableCell>
                    <TableCell style={{ fontWeight: 'bold' }}>Điểm trung bình</TableCell>
                    <TableCell align="center" style={{ fontWeight: 'bold' }}>Thao tác</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredStudents.map((student) => (
                    <TableRow key={student.id}>
                      <TableCell>{student.studentId}</TableCell>
                      <TableCell>{student.name}</TableCell>
                      <TableCell>
                        {activeSubject < subjects.length ? (
                          getStudentSubjectAverage(student.id, subjects[activeSubject].id)
                        ) : (
                          getStudentOverallAverage(student.id)
                        )}
                      </TableCell>
                      <TableCell align="center">
                        <Tooltip title="Xem chi tiết điểm">
                          <IconButton 
                            color="primary"
                            onClick={() => handleViewStudentGrades(student)}
                          >
                            <PersonIcon />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
                  {filteredStudents.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={4} align="center">
                        <Typography variant="body1">
                          Không tìm thấy học sinh nào
                        </Typography>
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          )}
        </Paper>
      ) : (
        <Alert severity="info">
          <Typography variant="subtitle1">
            Chưa có dữ liệu môn học cho lớp này
          </Typography>
        </Alert>
      )}

      {/* Student Grades Dialog */}
      <Dialog 
        open={studentDialogOpen} 
        onClose={handleCloseStudentDialog}
        maxWidth="md"
        fullWidth
      >
        {selectedStudent && (
          <>
            <DialogTitle>
              Bảng điểm chi tiết - {selectedStudent.name}
            </DialogTitle>
            <DialogContent>
              <Box mb={2}>
                <Typography variant="subtitle1">
                  <strong>Mã học sinh:</strong> {selectedStudent.studentId}
                </Typography>
                <Typography variant="subtitle1">
                  <strong>Lớp:</strong> {className}
                </Typography>
                <Typography variant="subtitle1">
                  <strong>Học kỳ:</strong> {activeSemester}
                </Typography>
                <Typography variant="subtitle1">
                  <strong>Năm học:</strong> {activeAcademicYear}
                </Typography>
              </Box>
              
              <TableContainer component={Paper} variant="outlined">
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell style={{ fontWeight: 'bold' }}>Môn học</TableCell>
                      <TableCell style={{ fontWeight: 'bold' }}>Điểm trung bình</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {subjects.map(subject => (
                      <TableRow key={subject.id}>
                        <TableCell>{subject.name}</TableCell>
                        <TableCell>{getStudentSubjectAverage(selectedStudent.id, subject.id)}</TableCell>
                      </TableRow>
                    ))}
                    <TableRow>
                      <TableCell style={{ fontWeight: 'bold' }}>Điểm trung bình chung</TableCell>
                      <TableCell style={{ fontWeight: 'bold' }}>
                        {getStudentOverallAverage(selectedStudent.id)}
                      </TableCell>
                    </TableRow>
                  </TableBody>
                </Table>
              </TableContainer>
            </DialogContent>
            <DialogActions>
              <Button 
                onClick={handleCloseStudentDialog} 
                color="primary"
              >
                Đóng
              </Button>
              <Button 
                variant="contained" 
                color="primary"
                onClick={() => handleViewDetailedGrades(selectedStudent.id)}
              >
                Xem chi tiết và quản lý điểm
              </Button>
            </DialogActions>
          </>
        )}
      </Dialog>
    </Container>
  );
};

export default HomeroomClassGradesPage; 