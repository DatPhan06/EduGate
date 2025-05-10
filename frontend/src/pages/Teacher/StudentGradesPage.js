import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, Box, CircularProgress, Alert, 
  Breadcrumbs, Link, Card, TextField,
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, 
  Paper, FormControl, InputLabel, MenuItem, Select, Divider
} from '@mui/material';
import { 
  ArrowBack as ArrowBackIcon, 
  Edit as EditIcon, 
  Save as SaveIcon, 
  Close as CloseOutlinedIcon 
} from '@mui/icons-material';
import { 
  getStudentGrades, 
  updateGradeComponent,
  updateTeacherGradeComponent,
  getHomeroomClassStudents,
  getSubjectByClassSubjectId,
  getGradeComponentsByGradeId
} from '../../services/teacherService';
import { useSnackbar } from 'notistack';

const StudentGradesPage = () => {
  const { classId, studentId } = useParams();
  const navigate = useNavigate();
  const [studentData, setStudentData] = useState(null);
  const [grades, setGrades] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeSemester, setActiveSemester] = useState('HK1');
  const [activeAcademicYear, setActiveAcademicYear] = useState('2023-2024');
  const [editingKey, setEditingKey] = useState('');
  const [editValue, setEditValue] = useState(null);
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
  
  // Fetch grades by semester and academic year
  useEffect(() => {
    const fetchGrades = async () => {
      try {
        setLoading(true);
        // Use semester and academic year in the API call
        const data = await getStudentGrades(studentId, activeSemester, activeAcademicYear);
        console.log('Student grades data received from API:', data);
        
        // Enhance grade data with detailed subject information and components
        const enhancedData = await Promise.all(data.map(async (grade) => {
          let enhancedGrade = { ...grade };
          
          // Fetch subject information if needed
          if (grade.ClassSubjectID) {
            try {
              // Fetch subject information
              const subjectInfo = await getSubjectByClassSubjectId(grade.ClassSubjectID);
              console.log(`Subject info for class subject ${grade.ClassSubjectID}:`, subjectInfo);
              
              enhancedGrade = {
                ...enhancedGrade,
                subjectName: subjectInfo.subject_name || grade.subjectName,
                subjectId: subjectInfo.subject_id || grade.subjectId,
                className: subjectInfo.class_name || grade.className
              };
            } catch (error) {
              console.error(`Error fetching subject info for ClassSubjectID ${grade.ClassSubjectID}:`, error);
            }
          }
          
          // Always fetch fresh grade components for each grade
          if (grade.GradeID) {
            try {
              console.log(`Fetching components for grade ${grade.GradeID}...`);
              const components = await getGradeComponentsByGradeId(grade.GradeID);
              console.log(`Components received for grade ${grade.GradeID}:`, components);
              
              if (components && components.length > 0) {
                enhancedGrade.grade_components = components;
              } else {
                console.log(`No components found for grade ${grade.GradeID}`);
                enhancedGrade.grade_components = [];
              }
            } catch (error) {
              console.error(`Error fetching components for grade ${grade.GradeID}:`, error);
              enhancedGrade.grade_components = [];
            }
          }
          
          return enhancedGrade;
        }));
        
        console.log('Enhanced data with components:', enhancedData);
        setGrades(enhancedData);
        setError(null);
      } catch (error) {
        console.error('Error fetching grades:', error);
        setError('Không thể tải dữ liệu điểm số. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (studentId && activeSemester && activeAcademicYear) {
      fetchGrades();
    }
  }, [studentId, activeSemester, activeAcademicYear]);
  
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
        console.log(`Attempting to update component ${item.ComponentID} with score ${editValue}`);
        
        // Prepare data for update
        const updateData = { 
          Score: editValue !== '' ? parseFloat(editValue) : null
        };
        
        // First try using teacher-specific update endpoint
        let updateSuccess = false;
        try {
          console.log(`Trying teacher-specific update API with teacherId ${teacherId}`);
          await updateTeacherGradeComponent(teacherId, item.ComponentID, updateData);
          updateSuccess = true;
          console.log('Teacher-specific update successful');
        } catch (teacherUpdateError) {
          console.error('Error using teacher-specific update:', teacherUpdateError);
          // If teacher-specific endpoint fails, try the general endpoint
          console.log('Falling back to general update API');
          await updateGradeComponent(item.ComponentID, updateData);
          updateSuccess = true;
          console.log('General update successful');
        }
        
        if (updateSuccess) {
          // Update local state
          const updatedGrades = [...grades];
          let updated = false;
          
          // Find the specific grade and component to update
          for (let i = 0; i < updatedGrades.length; i++) {
            const grade = updatedGrades[i];
            
            // Check in grade_components
            if (grade.grade_components) {
              for (let j = 0; j < grade.grade_components.length; j++) {
                const comp = grade.grade_components[j];
                if (comp.ComponentID === item.ComponentID) {
                  console.log(`Found component to update in grade_components: ${comp.ComponentName}`);
                  grade.grade_components[j].Score = parseFloat(editValue);
                  updated = true;
                  break;
                }
              }
            }
            
            // Also check in components if exists
            if (!updated && grade.components) {
              for (let j = 0; j < grade.components.length; j++) {
                const comp = grade.components[j];
                if (comp.ComponentID === item.ComponentID) {
                  console.log(`Found component to update in components: ${comp.ComponentName}`);
                  grade.components[j].Score = parseFloat(editValue);
                  updated = true;
                  break;
                }
              }
            }
            
            if (updated) break;
          }
          
          if (!updated) {
            console.log(`Could not find component ${item.ComponentID} in local state, refreshing data...`);
            // If we couldn't find the component to update locally, 
            // fetch fresh data for the subject
            if (item.key) {
              const [gradeId] = item.key.split('_');
              if (gradeId) {
                const freshComponents = await getGradeComponentsByGradeId(gradeId);
                // Update the specific grade with fresh components
                for (let i = 0; i < updatedGrades.length; i++) {
                  if (updatedGrades[i].GradeID.toString() === gradeId.toString()) {
                    updatedGrades[i].grade_components = freshComponents;
                    break;
                  }
                }
              }
            }
          }
          
          setGrades(updatedGrades);
          setEditingKey('');
          setEditValue(null);
          enqueueSnackbar('Cập nhật điểm thành công!', { variant: 'success' });
        } else {
          throw new Error('Không thể cập nhật điểm');
        }
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
  
  const handleAcademicYearChange = (event) => {
    setActiveAcademicYear(event.target.value);
  };
  
  const getGradesBySubject = () => {
    // Group grades by subject
    const subjectMap = {};
    
    console.log("Processing grades in getGradesBySubject:", grades);
    
    grades.forEach(grade => {
      // First try to get the subject name from API response
      // Use ClassSubjectID as fallback if no subject name
      const subjectName = grade.subjectName || 
                        (grade.class_subject && grade.class_subject.subject && 
                         grade.class_subject.subject.SubjectName) || 
                        `Môn học ${grade.ClassSubjectID}`;
      
      if (!subjectMap[subjectName]) {
        subjectMap[subjectName] = {
          subjectName: subjectName,
          classSubjectId: grade.ClassSubjectID,
          gradeId: grade.GradeID || grade.id,
          components: [],
          // Handle both finalGrade and FinalScore formats
          finalGrade: grade.FinalScore !== undefined ? grade.FinalScore : grade.finalGrade
        };
      }
      
      // Add component to the subject
      console.log(`Processing components for subject ${subjectName}, grade ${grade.GradeID || grade.id}:`, 
                 grade.grade_components || grade.components || []);
      
      const components = grade.grade_components || grade.components || [];
      if (components.length > 0) {
        components.forEach(component => {
          // Standardize component property naming to match API
          const componentId = component.ComponentID !== undefined ? component.ComponentID : component.id;
          const componentName = component.ComponentName !== undefined ? component.ComponentName : component.name;
          const weight = component.Weight !== undefined ? component.Weight : component.weight;
          const score = component.Score !== undefined ? component.Score : component.score;
          
          subjectMap[subjectName].components.push({
            key: `${grade.GradeID || grade.id}_${componentId}`,
            componentId: componentId,
            ComponentID: componentId,
            name: componentName,
            ComponentName: componentName,
            score: score,
            Score: score,
            weight: weight,
            Weight: weight
          });
          
          console.log(`Added component to ${subjectName}:`, componentName, weight, score);
        });
        
        // Sort components by weight (descending) and then by name
        subjectMap[subjectName].components.sort((a, b) => {
          if (b.Weight !== a.Weight) {
            return b.Weight - a.Weight;
          }
          return a.ComponentName.localeCompare(b.ComponentName);
        });
      } else {
        console.log(`No components found for subject ${subjectName}, grade ${grade.GradeID || grade.id}`);
      }
    });
    
    console.log("Processed subject map:", subjectMap);
    return Object.values(subjectMap);
  };
  
  const handleScoreChange = (e) => {
    setEditValue(parseFloat(e.target.value));
  };
  
  const formatScore = (score) => {
    if (score === null || score === undefined) return '-';
    return parseFloat(score).toFixed(1);
  };
  
  // Add a new function to fetch grade components
  const fetchGradeComponents = async (gradeId) => {
    try {
      const components = await getGradeComponentsByGradeId(gradeId);
      console.log(`Components fetched for grade ${gradeId}:`, components);
      return components;
    } catch (error) {
      console.error(`Error fetching components for grade ${gradeId}:`, error);
      return [];
    }
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
              <MenuItem value="HK1">HK1</MenuItem>
              <MenuItem value="HK2">HK2</MenuItem>
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
            Chưa có dữ liệu điểm số cho {activeSemester} {activeAcademicYear}
          </Typography>
        </Alert>
      ) : (
        <Box>
          <Typography variant="subtitle1" gutterBottom>
            Học kỳ: {activeSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'}, Năm học: {activeAcademicYear}
          </Typography>
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow style={{ backgroundColor: '#f5f5f5' }}>
                  <TableCell style={{ fontWeight: 'bold', width: '25%' }}>Môn học</TableCell>
                  <TableCell style={{ fontWeight: 'bold', width: '75%' }}>Thành phần điểm và điểm tổng kết</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {subjectGrades.map((subject) => (
                  <TableRow key={subject.subjectName}>
                    <TableCell component="th" scope="row" style={{ verticalAlign: 'top' }}>
                      <Typography variant="subtitle1">{subject.subjectName}</Typography>
                      <Typography variant="caption" color="textSecondary">
                        ID: {subject.classSubjectId}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      {(subject.components.length === 0) ? (
                        <Box>
                          <Alert severity="info" sx={{ mb: 2 }}>
                            <Typography variant="body2">
                              Chưa có thành phần điểm cho môn này
                            </Typography>
                          </Alert>
                          <Button 
                            variant="outlined" 
                            size="small"
                            onClick={async () => {
                              try {
                                console.log(`Manually fetching components for grade ID ${subject.gradeId}...`);
                                const components = await getGradeComponentsByGradeId(subject.gradeId);
                                console.log(`Manually fetched components:`, components);
                                
                                if (components && components.length > 0) {
                                  // Update the local state with these components
                                  const updatedGrades = [...grades];
                                  for (let i = 0; i < updatedGrades.length; i++) {
                                    if (updatedGrades[i].GradeID === subject.gradeId) {
                                      updatedGrades[i].grade_components = components;
                                      break;
                                    }
                                  }
                                  setGrades(updatedGrades);
                                  enqueueSnackbar('Đã tải thành phần điểm', { variant: 'success' });
                                } else {
                                  enqueueSnackbar('Không tìm thấy thành phần điểm', { variant: 'info' });
                                }
                              } catch (error) {
                                console.error('Error manually fetching components:', error);
                                enqueueSnackbar('Lỗi khi tải thành phần điểm', { variant: 'error' });
                              }
                            }}
                          >
                            Tải thành phần điểm
                          </Button>
                        </Box>
                      ) : (
                        <Box>
                          <Table size="small">
                            <TableHead>
                              <TableRow style={{ backgroundColor: '#f8f8f8' }}>
                                <TableCell width="40%" style={{ fontWeight: 'bold' }}>Thành phần</TableCell>
                                <TableCell width="15%" style={{ fontWeight: 'bold' }}>Hệ số</TableCell>
                                <TableCell width="15%" style={{ fontWeight: 'bold' }}>Điểm số</TableCell>
                                <TableCell width="30%" style={{ fontWeight: 'bold' }}>Thao tác</TableCell>
                              </TableRow>
                            </TableHead>
                            <TableBody>
                              {subject.components.map((component) => (
                                <TableRow key={component.key}>
                                  <TableCell>{component.ComponentName}</TableCell>
                                  <TableCell>{component.Weight}</TableCell>
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
                                        size="small"
                                        error={editValue !== null && (editValue < 0 || editValue > 10)}
                                        helperText={editValue !== null && (editValue < 0 || editValue > 10) ? "Điểm từ 0-10" : ""}
                                      />
                                    ) : (
                                      <Typography
                                        style={{
                                          fontWeight: 'bold',
                                          color: component.Score !== null && component.Score !== undefined 
                                            ? (component.Score >= 5 ? '#4caf50' : '#f44336')
                                            : 'inherit'
                                        }}
                                      >
                                        {formatScore(component.Score)}
                                      </Typography>
                                    )}
                                  </TableCell>
                                  <TableCell>
                                    {isEditing(component) ? (
                                      <Box>
                                        <Button
                                          variant="contained"
                                          color="primary"
                                          startIcon={<SaveIcon />}
                                          onClick={() => save(component)}
                                          style={{ marginRight: 8 }}
                                          size="small"
                                        >
                                          Lưu
                                        </Button>
                                        <Button
                                          variant="outlined"
                                          startIcon={<CloseOutlinedIcon />}
                                          onClick={cancel}
                                          size="small"
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
                                        size="small"
                                      >
                                        Sửa
                                      </Button>
                                    )}
                                  </TableCell>
                                </TableRow>
                              ))}
                              {/* Final grade row */}
                              <TableRow style={{ backgroundColor: '#f0f8ff' }}>
                                <TableCell colSpan={2} style={{ fontWeight: 'bold' }}>
                                  Điểm tổng kết
                                </TableCell>
                                <TableCell colSpan={2}>
                                  <Typography 
                                    variant="h6"
                                    style={{ 
                                      fontWeight: 'bold', 
                                      color: (subject.finalGrade !== null && subject.finalGrade !== undefined) 
                                        ? (subject.finalGrade >= 5 ? '#4caf50' : '#f44336') 
                                        : 'inherit'
                                    }}
                                  >
                                    {(subject.finalGrade !== null && subject.finalGrade !== undefined) 
                                      ? formatScore(subject.finalGrade)
                                      : 'Chưa có'}
                                  </Typography>
                                </TableCell>
                              </TableRow>
                            </TableBody>
                          </Table>
                        </Box>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Box>
      )}
    </Container>
  );
};

export default StudentGradesPage; 