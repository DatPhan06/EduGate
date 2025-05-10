import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Button, Box, CircularProgress, Alert, 
  Breadcrumbs, Link, Card, Tabs, Tab, 
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, 
  Paper, FormControl, InputLabel, MenuItem, Select, TextField,
  Dialog, DialogTitle, DialogContent, DialogActions, IconButton, Tooltip
} from '@mui/material';
import { 
  ArrowBack as ArrowBackIcon, 
  Edit as EditIcon, 
  Save as SaveIcon, 
  Close as CloseOutlinedIcon,
  Add as AddIcon,
  Refresh as RefreshIcon,
  Delete as DeleteIcon,
  MoreVert as MoreVertIcon,
  RemoveCircleOutline as RemoveCircleOutlineIcon
} from '@mui/icons-material';
import { 
  getStudentGrades,
  getGradeComponents,
  updateTeacherGradeComponent,
  createGradeComponent,
  deleteGradeComponent,
  initializeGradeComponents,
  updateGrade,
  deleteGrade,
  updateGradeComponent
} from '../../services/teacherService';
import { useSnackbar } from 'notistack';

const SubjectStudentGradesPage = () => {
  const { classSubjectId, studentId } = useParams();
  const navigate = useNavigate();
  const [studentData, setStudentData] = useState(null);
  const [grades, setGrades] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeSemester, setActiveSemester] = useState('HK1');
  const [editingKey, setEditingKey] = useState('');
  const [editValue, setEditValue] = useState(null);
  const { enqueueSnackbar } = useSnackbar();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [gradeDialogOpen, setGradeDialogOpen] = useState(false);
  const [confirmDeleteOpen, setConfirmDeleteOpen] = useState(false);
  const [editingGrade, setEditingGrade] = useState(null);
  const [newComponent, setNewComponent] = useState({
    ComponentName: '',
    Weight: 1,
    Score: null
  });
  const [currentGradeId, setCurrentGradeId] = useState(null);

  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  
  // Fetch student info and grades
  useEffect(() => {
    const fetchStudentGrades = async () => {
      try {
        setLoading(true);
        const data = await getStudentGrades(
          studentId,
          activeSemester
        );
        
        // Filter grades to only show for the current class subject
        const filteredGrades = data.filter(grade => grade.ClassSubjectID == classSubjectId);
        
        if (filteredGrades && filteredGrades.length > 0) {
          const grade = filteredGrades[0]; // Get the first grade record
          setCurrentGradeId(grade.GradeID);
          setGrades(filteredGrades);
          
          // Fetch grade components separately
          const components = await getGradeComponents(grade.GradeID);
          
          // Sort components: first by weight (descending), then by name
          const sortedComponents = components.sort((a, b) => {
            // First sort by Weight (highest first)
            if (b.Weight !== a.Weight) {
              return b.Weight - a.Weight;
            }
            // Then sort by ComponentName
            return a.ComponentName.localeCompare(b.ComponentName);
          });
          
          // Update the grade with components
          setGrades(prevGrades => 
            prevGrades.map(g => 
              g.GradeID === grade.GradeID 
                ? { ...g, grade_components: sortedComponents } 
                : g
            )
          );
          
          // Extract student info if available
          setStudentData({
            id: grade.StudentID,
            studentId: grade.StudentID,
            name: grade.student ? grade.student.name : 'N/A',
            className: grade.class_subject ? grade.class_subject.class.ClassName : 'N/A',
            classGrade: grade.class_subject ? grade.class_subject.class.GradeLevel : 'N/A'
          });
        } else {
          // No grades yet, will need to create them
          setGrades([]);
        }
        
        setError(null);
      } catch (error) {
        console.error('Error fetching student grades:', error);
        setError('Không thể tải dữ liệu điểm số. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (studentId && classSubjectId) {
      fetchStudentGrades();
    }
  }, [studentId, classSubjectId, activeSemester]);
  
  const handleAddComponent = () => {
    setDialogOpen(true);
  };
  
  const handleCloseDialog = () => {
    setDialogOpen(false);
    setNewComponent({
      ComponentName: '',
      Weight: 1,
      Score: null
    });
  };
  
  // Function to refresh components while maintaining component order
  const refreshGradeComponents = async () => {
    if (currentGradeId) {
      try {
        // First, remember the current components and their order
        let currentComponents = [];
        if (grades.length > 0) {
          const currentGrade = grades.find(g => g.GradeID === currentGradeId);
          if (currentGrade && currentGrade.grade_components) {
            currentComponents = [...currentGrade.grade_components];
          }
        }

        // Get updated components
        const components = await getGradeComponents(currentGradeId);
        
        // If we had existing components, maintain their order
        let orderedComponents = components;
        if (currentComponents.length > 0) {
          // Create an ordered list by matching IDs
          orderedComponents = components.sort((a, b) => {
            // First sort by Weight (highest first)
            if (b.Weight !== a.Weight) {
              return b.Weight - a.Weight;
            }
            // Then sort by ComponentName
            return a.ComponentName.localeCompare(b.ComponentName);
          });
        }
        
        // Also fetch the updated grade to get the latest FinalScore
        const gradesData = await getStudentGrades(studentId, activeSemester);
        const updatedGrade = gradesData.find(g => g.GradeID === currentGradeId);
        
        // Update the grade with components and updated FinalScore
        setGrades(prevGrades => 
          prevGrades.map(g => 
            g.GradeID === currentGradeId 
              ? { 
                  ...g, 
                  grade_components: orderedComponents,
                  FinalScore: updatedGrade ? updatedGrade.FinalScore : g.FinalScore
                } 
              : g
          )
        );
      } catch (error) {
        console.error('Error refreshing grade components:', error);
        enqueueSnackbar('Không thể cập nhật thành phần điểm. Vui lòng thử lại.', { variant: 'error' });
      }
    }
  };
  
  const handleCreateComponent = async () => {
    try {
      if (!newComponent.ComponentName) {
        enqueueSnackbar('Vui lòng nhập tên thành phần điểm', { variant: 'error' });
        return;
      }
      
      if (newComponent.Score !== null && (newComponent.Score < 0 || newComponent.Score > 10)) {
        enqueueSnackbar('Điểm phải từ 0 đến 10', { variant: 'error' });
        return;
      }
      
      // Create the component
      await createGradeComponent(teacherId, currentGradeId, newComponent);
      
      // Refresh the components with consistent ordering
      await refreshGradeComponents();
      
      enqueueSnackbar('Thêm thành phần điểm thành công!', { variant: 'success' });
      handleCloseDialog();
    } catch (error) {
      console.error('Error creating grade component:', error);
      enqueueSnackbar('Không thể thêm thành phần điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };
  
  const handleInitializeComponents = async () => {
    try {
      if (!currentGradeId) {
        enqueueSnackbar('Không tìm thấy bản ghi điểm', { variant: 'error' });
        return;
      }
      
      // Initialize standard components
      await initializeGradeComponents(teacherId, currentGradeId);
      
      // Refresh the components with consistent ordering
      await refreshGradeComponents();
      
      enqueueSnackbar('Khởi tạo cấu trúc điểm thành công!', { variant: 'success' });
    } catch (error) {
      console.error('Error initializing grade components:', error);
      enqueueSnackbar('Không thể khởi tạo cấu trúc điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };
  
  // Keep original handleDeleteComponent for actual deletion when needed
  const handleDeleteComponent = async (componentId) => {
    try {
      // Delete the component
      await deleteGradeComponent(teacherId, componentId);
      
      // Refresh the components with consistent ordering
      await refreshGradeComponents();
      
      enqueueSnackbar('Xóa thành phần điểm thành công!', { variant: 'success' });
    } catch (error) {
      console.error('Error deleting grade component:', error);
      enqueueSnackbar('Không thể xóa thành phần điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };

  // Function to clear a component's score (set to null)
  const handleClearComponentScore = async (componentId) => {
    try {
      // Explicitly set Score to null in the update data
      const updateData = { Score: null };
      console.log("Clearing score for component:", componentId, "with data:", updateData);
      
      // Update the component with null score
      await updateGradeComponent(componentId, updateData);
      
      // Refresh the components with consistent ordering
      await refreshGradeComponents();
      
      enqueueSnackbar('Đã xóa điểm thành công!', { variant: 'success' });
    } catch (error) {
      console.error('Error clearing component score:', error);
      enqueueSnackbar('Không thể xóa điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };
  
  const isEditing = (record) => record.ComponentID === editingKey;
  
  const edit = (record) => {
    setEditingKey(record.ComponentID);
    setEditValue(record.Score);
  };
  
  const cancel = () => {
    setEditingKey('');
    setEditValue(null);
  };
  
  const save = async (componentId) => {
    try {
      if (editValue !== null && (editValue < 0 || editValue > 10)) {
        enqueueSnackbar('Điểm phải từ 0 đến 10', { variant: 'error' });
        return;
      }
      
      // Update the component
      await updateTeacherGradeComponent(teacherId, componentId, { Score: editValue });
      
      // Refresh the components while maintaining order and getting updated average
      await refreshGradeComponents();
      
      setEditingKey('');
      setEditValue(null);
      enqueueSnackbar('Cập nhật điểm thành công!', { variant: 'success' });
    } catch (error) {
      console.error('Error updating grade component:', error);
      enqueueSnackbar('Không thể cập nhật điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };
  
  const handleBackClick = () => {
    navigate(`/teacher/subjects/${classSubjectId}/students`);
  };
  
  const handleSemesterChange = (event) => {
    setActiveSemester(event.target.value);
  };
  
  const handleScoreChange = (e) => {
    setEditValue(parseFloat(e.target.value));
  };
  
  const handleComponentNameChange = (e) => {
    setNewComponent({...newComponent, ComponentName: e.target.value});
  };
  
  const handleComponentWeightChange = (e) => {
    setNewComponent({...newComponent, Weight: parseFloat(e.target.value)});
  };
  
  const handleComponentScoreChange = (e) => {
    setNewComponent({...newComponent, Score: e.target.value ? parseFloat(e.target.value) : null});
  };
  
  // Function to open the edit grade dialog
  const handleEditGrade = (grade) => {
    setEditingGrade({
      GradeID: grade.GradeID,
      FinalScore: grade.FinalScore,
      Semester: grade.Semester
    });
    setGradeDialogOpen(true);
  };

  // Function to close the edit grade dialog
  const handleCloseGradeDialog = () => {
    setGradeDialogOpen(false);
    setEditingGrade(null);
  };

  // Function to update the grade
  const handleUpdateGrade = async () => {
    try {
      if (editingGrade.FinalScore !== null && (editingGrade.FinalScore < 0 || editingGrade.FinalScore > 10)) {
        enqueueSnackbar('Điểm phải từ 0 đến 10', { variant: 'error' });
        return;
      }

      // Update the grade
      await updateGrade(editingGrade.GradeID, {
        FinalScore: editingGrade.FinalScore,
        Semester: editingGrade.Semester
      });

      // Refresh the grades
      const data = await getStudentGrades(studentId, activeSemester);
      const filteredGrades = data.filter(grade => grade.ClassSubjectID == classSubjectId);
      setGrades(filteredGrades);

      enqueueSnackbar('Cập nhật điểm thành công!', { variant: 'success' });
      handleCloseGradeDialog();
    } catch (error) {
      console.error('Error updating grade:', error);
      enqueueSnackbar('Không thể cập nhật điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };

  // Function to open the confirm delete dialog
  const handleConfirmDelete = (grade) => {
    setEditingGrade(grade);
    setConfirmDeleteOpen(true);
  };

  // Function to close the confirm delete dialog
  const handleCloseConfirmDelete = () => {
    setConfirmDeleteOpen(false);
    setEditingGrade(null);
  };

  // Function to delete the grade
  const handleDeleteGrade = async () => {
    try {
      // Delete the grade
      await deleteGrade(editingGrade.GradeID);

      // Refresh the grades
      const data = await getStudentGrades(studentId, activeSemester);
      const filteredGrades = data.filter(grade => grade.ClassSubjectID == classSubjectId);
      setGrades(filteredGrades);

      enqueueSnackbar('Xóa điểm thành công!', { variant: 'success' });
      handleCloseConfirmDelete();
    } catch (error) {
      console.error('Error deleting grade:', error);
      enqueueSnackbar('Không thể xóa điểm. Vui lòng thử lại.', { variant: 'error' });
    }
  };
  
  if (loading) {
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
  
  return (
    <Container style={{ padding: '24px' }}>
      <Breadcrumbs style={{ marginBottom: '16px' }}>
        <Link 
          component="button"
          variant="body1"
          onClick={() => navigate('/teacher/subjects')}
          underline="hover"
        >
          Môn học đang dạy
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
                </Box>
                <Box minWidth={300}>
                  <Typography variant="body1"><strong>Lớp:</strong> {studentData.className}</Typography>
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
      
      {grades.length === 0 ? (
        <Alert severity="info">
          <Typography variant="subtitle1">
            Chưa có dữ liệu điểm số cho {activeSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'}
          </Typography>
        </Alert>
      ) : (
        grades.map(grade => (
          <Box key={grade.GradeID} mt={3}>
            <Box mb={2} display="flex" justifyContent="space-between" alignItems="center">
              <Typography variant="h6">
                {grade.class_subject?.subject?.SubjectName || 'Môn học'}
              </Typography>
              <Box display="flex" alignItems="center">
                <Typography style={{ marginRight: '16px' }}>
                  <strong>Điểm trung bình: </strong>
                  <Typography 
                    component="span" 
                    style={{ fontSize: '16px', color: '#1976d2', fontWeight: 'bold' }}
                  >
                    {grade.FinalScore !== null && grade.FinalScore !== undefined 
                      ? grade.FinalScore.toFixed(1) 
                      : 'Chưa có'}
                  </Typography>
                </Typography>
                <Tooltip title="Chỉnh sửa điểm trung bình">
                  <IconButton
                    color="primary"
                    onClick={() => handleEditGrade(grade)}
                  >
                    <EditIcon />
                  </IconButton>
                </Tooltip>
                <Tooltip title="Xóa bản ghi điểm">
                  <IconButton
                    color="error"
                    onClick={() => handleConfirmDelete(grade)}
                  >
                    <DeleteIcon />
                  </IconButton>
                </Tooltip>
              </Box>
            </Box>
            
            <Box mb={2} display="flex" justifyContent="space-between">
              <Tooltip title="Thêm thành phần điểm mới">
                <Button
                  variant="outlined"
                  color="primary"
                  startIcon={<AddIcon />}
                  onClick={handleAddComponent}
                >
                  Thêm thành phần
                </Button>
              </Tooltip>
              
              <Tooltip title="Khởi tạo cấu trúc điểm tiêu chuẩn">
                <Button
                  variant="outlined"
                  color="secondary"
                  startIcon={<RefreshIcon />}
                  onClick={handleInitializeComponents}
                >
                  Khởi tạo cấu trúc điểm
                </Button>
              </Tooltip>
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
                  {grade.grade_components && grade.grade_components.map(component => (
                    <TableRow key={component.ComponentID}>
                      <TableCell>{component.ComponentName}</TableCell>
                      <TableCell>{component.Weight}</TableCell>
                      <TableCell>
                        {isEditing(component) ? (
                          <TextField
                            type="number"
                            value={editValue !== null ? editValue : ''}
                            onChange={handleScoreChange}
                            inputProps={{ 
                              min: 0, 
                              max: 10, 
                              step: 0.1 
                            }}
                            fullWidth
                          />
                        ) : (
                          component.Score !== null && component.Score !== undefined 
                            ? component.Score.toFixed(1) 
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
                              onClick={() => save(component.ComponentID)}
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
                          <Box>
                            <Button
                              variant="contained"
                              color="primary"
                              startIcon={<EditIcon />}
                              disabled={editingKey !== ''}
                              onClick={() => edit(component)}
                              style={{ marginRight: 8 }}
                            >
                              Sửa
                            </Button>
                            {component.Score !== null && (
                              <Tooltip title="Xóa điểm">
                                <IconButton 
                                  color="error" 
                                  onClick={() => handleClearComponentScore(component.ComponentID)}
                                  disabled={editingKey !== ''}
                                >
                                  <RemoveCircleOutlineIcon />
                                </IconButton>
                              </Tooltip>
                            )}
                          </Box>
                        )}
                      </TableCell>
                    </TableRow>
                  ))}
                  {(!grade.grade_components || grade.grade_components.length === 0) && (
                    <TableRow>
                      <TableCell colSpan={4} align="center">
                        <Typography variant="body1">
                          Chưa có thành phần điểm. Nhấn "Khởi tạo cấu trúc điểm" để tạo cấu trúc điểm tiêu chuẩn.
                        </Typography>
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            </TableContainer>
          </Box>
        ))
      )}
      
      {/* Add Component Dialog */}
      <Dialog open={dialogOpen} onClose={handleCloseDialog}>
        <DialogTitle>Thêm thành phần điểm</DialogTitle>
        <DialogContent>
          <Box pt={1}>
            <TextField
              label="Tên thành phần"
              value={newComponent.ComponentName}
              onChange={handleComponentNameChange}
              fullWidth
              margin="normal"
            />
            <TextField
              label="Hệ số"
              type="number"
              value={newComponent.Weight}
              onChange={handleComponentWeightChange}
              fullWidth
              margin="normal"
              InputProps={{
                inputProps: { min: 1, max: 3, step: 1 }
              }}
              helperText="Hệ số từ 1 đến 3"
            />
            <TextField
              label="Điểm số (có thể để trống)"
              type="number"
              value={newComponent.Score !== null ? newComponent.Score : ''}
              onChange={handleComponentScoreChange}
              fullWidth
              margin="normal"
              InputProps={{
                inputProps: { min: 0, max: 10, step: 0.1 }
              }}
              helperText="Điểm từ 0 đến 10"
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog} color="inherit">
            Hủy
          </Button>
          <Button onClick={handleCreateComponent} color="primary" variant="contained">
            Thêm
          </Button>
        </DialogActions>
      </Dialog>
      
      {/* Edit Grade Dialog */}
      <Dialog open={gradeDialogOpen} onClose={handleCloseGradeDialog}>
        <DialogTitle>Chỉnh sửa điểm trung bình</DialogTitle>
        <DialogContent>
          <Box pt={1}>
            <TextField
              label="Điểm trung bình"
              type="number"
              value={editingGrade?.FinalScore !== null ? editingGrade?.FinalScore : ''}
              onChange={(e) => setEditingGrade({
                ...editingGrade,
                FinalScore: e.target.value ? parseFloat(e.target.value) : null
              })}
              fullWidth
              margin="normal"
              InputProps={{
                inputProps: { min: 0, max: 10, step: 0.1 }
              }}
              helperText="Điểm từ 0 đến 10"
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseGradeDialog} color="inherit">
            Hủy
          </Button>
          <Button onClick={handleUpdateGrade} color="primary" variant="contained">
            Lưu
          </Button>
        </DialogActions>
      </Dialog>

      {/* Confirm Delete Dialog */}
      <Dialog open={confirmDeleteOpen} onClose={handleCloseConfirmDelete}>
        <DialogTitle>Xác nhận xóa</DialogTitle>
        <DialogContent>
          <Typography>
            Bạn có chắc chắn muốn xóa bản ghi điểm này? Hành động này không thể hoàn tác.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseConfirmDelete} color="inherit">
            Hủy
          </Button>
          <Button onClick={handleDeleteGrade} color="error" variant="contained">
            Xóa
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default SubjectStudentGradesPage; 