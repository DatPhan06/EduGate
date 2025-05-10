import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, Box, CircularProgress, Alert, 
  Breadcrumbs, Link, Card, Tabs, Tab, InputAdornment, TextField,
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, 
  Paper, FormControl, InputLabel, MenuItem, Select
} from '@mui/material';
import { 
  ArrowBack as ArrowBackIcon, 
  Edit as EditIcon, 
  Save as SaveIcon, 
  Close as CloseOutlinedIcon 
} from '@mui/icons-material';
import { getStudentGrades, updateGradeComponent } from '../../services/teacherService';
import { getHomeroomClassStudents } from '../../services/teacherService';
import { useSnackbar } from 'notistack';

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`subject-tabpanel-${index}`}
      aria-labelledby={`subject-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box p={3}>
          {children}
        </Box>
      )}
    </div>
  );
}

const StudentGradesPage = () => {
  const { classId, studentId } = useParams();
  const navigate = useNavigate();
  const [studentData, setStudentData] = useState(null);
  const [grades, setGrades] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeSemester, setActiveSemester] = useState('Học kỳ 1');
  const [editingKey, setEditingKey] = useState('');
  const [editValue, setEditValue] = useState(null);
  const [tabValue, setTabValue] = useState(0);
  const { enqueueSnackbar } = useSnackbar();

  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  console.log('User from localStorage:', user);
  
  // Try different possible ID properties
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  console.log('Teacher ID used:', teacherId);
  
  // Fetch student info
  useEffect(() => {
    const fetchStudentInfo = async () => {
      try {
        const students = await getHomeroomClassStudents(teacherId, classId);
        const student = students.find(s => s.id.toString() === studentId.toString());
        if (student) {
          setStudentData(student);
        } else {
          setError('Không tìm thấy thông tin học sinh.');
        }
      } catch (error) {
        console.error('Error fetching student info:', error);
        setError('Không thể tải thông tin học sinh. Vui lòng thử lại sau.');
      }
    };
    
    if (teacherId && classId && studentId) {
      fetchStudentInfo();
    }
  }, [teacherId, classId, studentId]);
  
  // Fetch grades by semester
  useEffect(() => {
    const fetchGrades = async () => {
      try {
        setLoading(true);
        const data = await getStudentGrades(studentId, activeSemester);
        setGrades(data);
        setError(null);
      } catch (error) {
        console.error('Error fetching grades:', error);
        setError('Không thể tải dữ liệu điểm số. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (studentId && activeSemester) {
      fetchGrades();
    }
  }, [studentId, activeSemester]);
  
  const isEditing = (record) => record.key === editingKey;
  
  const edit = (record) => {
    setEditingKey(record.key);
    setEditValue(record.score);
  };
  
  const cancel = () => {
    setEditingKey('');
    setEditValue(null);
  };
  
  const save = async (item) => {
    try {
      if (editValue === null || editValue === undefined) {
        enqueueSnackbar('Vui lòng nhập điểm', { variant: 'error' });
        return;
      }
      
      if (editValue < 0 || editValue > 10) {
        enqueueSnackbar('Điểm phải từ 0 đến 10', { variant: 'error' });
        return;
      }
      
      try {
        // Call API to update grade
        await updateGradeComponent(item.componentId, { 
          score: editValue 
        });
        
        // Update local state
        const updatedGrades = [...grades];
        const subjectGrades = getGradesBySubject();
        
        // Find and update the grade in our local state
        for (let subject of subjectGrades) {
          const componentIndex = subject.components.findIndex(comp => comp.key === editingKey);
          if (componentIndex > -1) {
            subject.components[componentIndex].score = editValue;
            break;
          }
        }
        
        setGrades(updatedGrades);
        setEditingKey('');
        setEditValue(null);
        enqueueSnackbar('Cập nhật điểm thành công!', { variant: 'success' });
      } catch (error) {
        console.error('Error updating grade:', error);
        enqueueSnackbar('Không thể cập nhật điểm. Vui lòng thử lại sau.', { variant: 'error' });
      }
    } catch (errInfo) {
      console.log('Validate Failed:', errInfo);
    }
  };
  
  const handleBackClick = () => {
    navigate(`/teacher/homeroom/${classId}/students`);
  };
  
  const handleSemesterChange = (event) => {
    setActiveSemester(event.target.value);
  };
  
  const handleChangeTab = (event, newValue) => {
    setTabValue(newValue);
  };
  
  const getGradesBySubject = () => {
    // Group grades by subject
    const subjectMap = {};
    
    grades.forEach(grade => {
      if (!subjectMap[grade.subjectName]) {
        subjectMap[grade.subjectName] = {
          subjectName: grade.subjectName,
          components: [],
          finalGrade: grade.finalGrade
        };
      }
      
      // Add component to the subject
      if (grade.components) {
        grade.components.forEach(component => {
          subjectMap[grade.subjectName].components.push({
            key: `${grade.id}_${component.id}`,
            componentId: component.id,
            name: component.name,
            score: component.score,
            weight: component.weight
          });
        });
      }
    });
    
    return Object.values(subjectMap);
  };
  
  const handleScoreChange = (e) => {
    setEditValue(parseFloat(e.target.value));
  };
  
  if (loading && !studentData) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải dữ liệu...
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
  
  const subjectGrades = getGradesBySubject();

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
        <Link
          component="button"
          variant="body1"
          onClick={handleBackClick}
          underline="hover"
        >
          Danh sách học sinh
        </Link>
        <Typography color="textPrimary">Bảng điểm học sinh</Typography>
      </Breadcrumbs>
      
      {studentData && (
        <Box mb={3}>
          <Card variant="outlined">
            <Box p={2}>
              <Typography variant="h5" gutterBottom>Thông tin học sinh</Typography>
              <Box display="flex" flexWrap="wrap">
                <Box minWidth={300} mr={3}>
                  <Typography variant="body1"><strong>Họ và tên:</strong> {studentData.name}</Typography>
                  <Typography variant="body1"><strong>Mã học sinh:</strong> {studentData.studentId}</Typography>
                  <Typography variant="body1"><strong>Lớp:</strong> {studentData.className}</Typography>
                </Box>
                <Box minWidth={300}>
                  <Typography variant="body1">
                    <strong>Giới tính:</strong> {studentData.gender === 'MALE' ? 'Nam' : studentData.gender === 'FEMALE' ? 'Nữ' : '-'}
                  </Typography>
                  <Typography variant="body1">
                    <strong>Ngày sinh:</strong> {studentData.dob ? new Date(studentData.dob).toLocaleDateString('vi-VN') : '-'}
                  </Typography>
                  <Typography variant="body1"><strong>Khối:</strong> {studentData.classGrade}</Typography>
                </Box>
              </Box>
            </Box>
          </Card>
        </Box>
      )}
      
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
        <Typography variant="h4">Bảng điểm</Typography>
        <Box display="flex" alignItems="center">
          <FormControl variant="outlined" size="small" style={{ width: 120, marginRight: 16 }}>
            <InputLabel id="semester-select-label">Học kỳ</InputLabel>
            <Select
              labelId="semester-select-label"
              value={activeSemester}
              onChange={handleSemesterChange}
              label="Học kỳ"
            >
              <MenuItem value="Học kỳ 1">Học kỳ 1</MenuItem>
              <MenuItem value="Học kỳ 2">Học kỳ 2</MenuItem>
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
      
      {loading ? (
        <Box display="flex" justifyContent="center" padding="50px">
          <CircularProgress size={60} />
          <Typography variant="h6" style={{ marginLeft: '16px' }}>
            Đang tải dữ liệu điểm số...
          </Typography>
        </Box>
      ) : subjectGrades.length === 0 ? (
        <Alert severity="info">
          <Typography variant="subtitle1">
            Chưa có dữ liệu điểm số cho {activeSemester}
          </Typography>
        </Alert>
      ) : (
        <Box>
          <Tabs
            value={tabValue}
            onChange={handleChangeTab}
            variant="scrollable"
            scrollButtons="auto"
            indicatorColor="primary"
            textColor="primary"
          >
            {subjectGrades.map((subject, index) => (
              <Tab label={subject.subjectName} id={`subject-tab-${index}`} key={subject.subjectName} />
            ))}
          </Tabs>
          
          {subjectGrades.map((subject, index) => (
            <TabPanel value={tabValue} index={index} key={subject.subjectName}>
              <Box mb={2}>
                <Typography variant="subtitle1">
                  <strong>Điểm trung bình môn: </strong>
                  <Typography 
                    component="span" 
                    style={{ fontSize: '16px', color: '#1976d2', fontWeight: 'bold' }}
                  >
                    {subject.finalGrade !== null && subject.finalGrade !== undefined 
                      ? subject.finalGrade.toFixed(1) 
                      : 'Chưa có'}
                  </Typography>
                </Typography>
              </Box>
              
              <TableContainer component={Paper}>
                <Table>
                  <TableHead>
                    <TableRow>
                      <TableCell>Thành phần</TableCell>
                      <TableCell>Hệ số</TableCell>
                      <TableCell>Điểm số</TableCell>
                      <TableCell align="center">Thao tác</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {subject.components.map(component => (
                      <TableRow key={component.key}>
                        <TableCell>{component.name}</TableCell>
                        <TableCell>{component.weight}</TableCell>
                        <TableCell>
                          {isEditing(component) ? (
                            <TextField
                              type="number"
                              value={editValue}
                              onChange={handleScoreChange}
                              inputProps={{ 
                                min: 0, 
                                max: 10, 
                                step: 0.1 
                              }}
                              fullWidth
                            />
                          ) : (
                            component.score !== null && component.score !== undefined 
                              ? component.score.toFixed(1) 
                              : '-'
                          )}
                        </TableCell>
                        <TableCell align="center">
                          {isEditing(component) ? (
                            <Box>
                              <Button
                                variant="contained"
                                color="primary"
                                startIcon={<SaveIcon />}
                                onClick={() => save(component)}
                                style={{ marginRight: 8 }}
                              >
                                Lưu
                              </Button>
                              <Button
                                variant="outlined"
                                startIcon={<CloseOutlinedIcon />}
                                onClick={cancel}
                              >
                                Hủy
                              </Button>
                            </Box>
                          ) : (
                            <Button
                              variant="contained"
                              color="primary"
                              startIcon={<EditIcon />}
                              disabled={editingKey !== ''}
                              onClick={() => edit(component)}
                            >
                              Sửa
                            </Button>
                          )}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </TabPanel>
          ))}
        </Box>
      )}
    </Container>
  );
};

export default StudentGradesPage; 