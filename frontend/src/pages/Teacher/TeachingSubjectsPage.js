import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Container, Typography, Box, Grid, Card, CardContent, 
  CardActions, Button, CircularProgress, Alert,
  List, ListItem, ListItemText, Accordion, AccordionSummary,
  AccordionDetails, Divider
} from '@mui/material';
import { 
  ExpandMore as ExpandMoreIcon,
  School as SchoolIcon, 
  People as PeopleIcon,
  Assessment as AssessmentIcon
} from '@mui/icons-material';
import { getTeacherSubjects } from '../../services/teacherService';

const TeachingSubjectsPage = () => {
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  
  // Get teacher ID from the user object in localStorage
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const teacherId = user.id || user.UserID || user.userId || user.teacher_id || user.teacherId;
  
  useEffect(() => {
    const fetchTeacherSubjects = async () => {
      try {
        setLoading(true);
        const data = await getTeacherSubjects(teacherId);
        console.log('Teacher subjects data:', data);
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
  
  const handleViewStudents = (classSubjectId) => {
    navigate(`/teacher/subjects/${classSubjectId}/students`);
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
      <Typography variant="h4" gutterBottom>Môn Học Đang Dạy</Typography>
      <Typography variant="subtitle1" color="textSecondary" style={{ marginBottom: '20px' }}>
        Quản lý điểm số cho các lớp và môn học bạn được phân công giảng dạy
      </Typography>
      
      <Grid container spacing={3}>
        {classes.map(classItem => (
          <Grid item key={classItem.class_id} xs={12} sm={6} md={4}>
            <Card variant="outlined" style={{ height: '100%' }}>
              <CardContent>
                <Box display="flex" alignItems="center" mb={2}>
                  <SchoolIcon color="primary" style={{ marginRight: '12px' }} />
                  <Typography variant="h6">Lớp {classItem.class_name}</Typography>
                </Box>
                <Typography variant="body1" gutterBottom>
                  <strong>Khối:</strong> {classItem.grade_level}
                </Typography>
                
                <Box mt={2}>
                  <Typography variant="subtitle2" gutterBottom>Môn học:</Typography>
                  <List dense>
                    {classItem.subjects.map(subject => (
                      <ListItem key={subject.class_subject_id} disableGutters>
                        <ListItemText 
                          primary={subject.subject_name}
                        />
                        <Button
                          size="small"
                          variant="outlined"
                          color="primary"
                          onClick={() => handleViewStudents(subject.class_subject_id)}
                        >
                          Xem học sinh
                        </Button>
                      </ListItem>
                    ))}
                  </List>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Container>
  );
};

export default TeachingSubjectsPage; 