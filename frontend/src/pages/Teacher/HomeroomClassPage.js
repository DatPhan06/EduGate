import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Container, Grid, Card, CardContent, CardActions, 
  Typography, Button, CircularProgress, Alert, Box, CardHeader 
} from '@mui/material';
import { MenuBook, People } from '@mui/icons-material';
import { getTeacherHomeroomClasses } from '../../services/teacherService';

const HomeroomClassPage = () => {
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  
  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  console.log('User from localStorage:', user);
  
  // Try different possible ID properties
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  console.log('Teacher ID used:', teacherId);
  
  useEffect(() => {
    const fetchHomeroomClasses = async () => {
      try {
        setLoading(true);
        const data = await getTeacherHomeroomClasses(teacherId);
        console.log('Homeroom classes data:', data);
        setClasses(data);
        setError(null);
      } catch (error) {
        console.error('Error fetching homeroom classes:', error);
        setError('Không thể tải danh sách lớp chủ nhiệm. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (teacherId) {
      console.log('Teacher ID exists, fetching homeroom classes...');
      fetchHomeroomClasses();
    } else {
      console.log('Teacher ID does not exist, showing error message');
      setError('Không tìm thấy thông tin giáo viên. Vui lòng đăng nhập lại.');
      setLoading(false);
    }
  }, [teacherId]);
  
  const handleViewGradeManagement = (classId) => {
    navigate(`/teacher/homeroom/${classId}/grades`);
  };
  
  const handleViewStudents = (classId) => {
    navigate(`/teacher/homeroom/${classId}/students`);
  };
  
  if (loading) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải danh sách lớp chủ nhiệm...
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
          Bạn chưa được phân công làm giáo viên chủ nhiệm lớp nào.
        </Typography>
      </Alert>
    );
  }
  
  return (
    <Container style={{ padding: '24px' }}>
      <Typography variant="h4" gutterBottom>Lớp Chủ Nhiệm</Typography>
      <Typography variant="subtitle1" color="textSecondary" style={{ marginBottom: '20px' }}>
        Quản lý các lớp bạn được phân công làm giáo viên chủ nhiệm
      </Typography>
      
      <Grid container spacing={3}>
        {classes.map(classItem => (
          <Grid item key={classItem.id} xs={12} sm={6} md={4}>
            <Card variant="outlined" style={{ height: '100%' }}>
              <CardHeader title={`Lớp ${classItem.name}`} />
              <CardContent>
                <Typography variant="body1"><strong>Khối:</strong> {classItem.grade}</Typography>
                <Typography variant="body1"><strong>Năm học:</strong> {classItem.academic_year}</Typography>
              </CardContent>
              <CardActions style={{ flexDirection: 'column', padding: '16px' }}>
                <Button 
                  variant="contained" 
                  color="primary" 
                  startIcon={<MenuBook />}
                  onClick={() => handleViewGradeManagement(classItem.id)}
                  fullWidth
                  style={{ marginBottom: '8px' }}
                >
                  Quản lý điểm số
                </Button>
                <Button 
                  variant="outlined" 
                  startIcon={<People />}
                  onClick={() => handleViewStudents(classItem.id)}
                  fullWidth
                >
                  Xem danh sách học sinh
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Container>
  );
};

export default HomeroomClassPage; 