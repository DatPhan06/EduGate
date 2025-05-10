import React, { useState, useEffect } from 'react';
import {
    Container,
    Typography,
    Box,
    Paper,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    CircularProgress,
    Alert,
    Breadcrumbs,
    Link as MuiLink,
    useTheme
} from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { ClassOutlined, NavigateNext } from '@mui/icons-material';
import ClassEventsList from '../components/ClassEvents/ClassEventsList';
import authService from '../services/authService';

const ClassEventsPage = () => {
    const theme = useTheme();
    const navigate = useNavigate();
    
    // State for loading and user info
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [userClasses, setUserClasses] = useState([]);
    const [selectedClass, setSelectedClass] = useState('');
    const [userRole, setUserRole] = useState('');
    const [isHomeRoomTeacher, setIsHomeRoomTeacher] = useState(false);
    
    // Get user classes and role on component mount
    useEffect(() => {
        const fetchUserData = async () => {
            setLoading(true);
            try {
                const userData = await authService.getCurrentUser();
                setUserRole(userData.role);
                
                // Fetch classes based on user role
                let classesData = [];
                
                if (userData.role === 'teacher') {
                    // For teachers - fetch their classes
                    classesData = await fetchTeacherClasses(userData.id);
                    
                    // Check if this teacher is a homeroom teacher for any class
                    const isHomeRoom = classesData.some(cls => cls.homeroom_teacher_id === userData.id);
                    setIsHomeRoomTeacher(isHomeRoom);
                    
                } else if (userData.role === 'student') {
                    // For students - fetch their class
                    classesData = await fetchStudentClass(userData.id);
                } else if (userData.role === 'parent') {
                    // For parents - fetch their children's classes
                    classesData = await fetchParentChildrenClasses(userData.id);
                }
                
                // Set classes and automatically select one if there's only one
                setUserClasses(classesData);
                if (classesData.length === 1) {
                    setSelectedClass(classesData[0].class_id);
                }
                
                setError('');
            } catch (err) {
                console.error('Error fetching user data:', err);
                setError('Không thể tải thông tin lớp học. Vui lòng thử lại sau.');
            } finally {
                setLoading(false);
            }
        };
        
        fetchUserData();
    }, []);
    
    // Mock function to fetch teacher's classes - replace with real API call
    const fetchTeacherClasses = async (teacherId) => {
        // This is a placeholder for the actual API call
        // In a real implementation, you would call your API service
        // Example: return await classService.getTeacherClasses(teacherId);
        
        // Return mock data for now
        return [
            { class_id: '1', class_name: '10A1', homeroom_teacher_id: teacherId },
            { class_id: '2', class_name: '11A2', homeroom_teacher_id: 'other-teacher' },
        ];
    };
    
    // Mock function to fetch student's class - replace with real API call
    const fetchStudentClass = async (studentId) => {
        // This is a placeholder for the actual API call
        // In a real implementation, you would call your API service
        
        // Return mock data for now
        return [
            { class_id: '1', class_name: '10A1' }
        ];
    };
    
    // Mock function to fetch parent's children classes - replace with real API call
    const fetchParentChildrenClasses = async (parentId) => {
        // This is a placeholder for the actual API call
        // In a real implementation, you would call your API service
        
        // Return mock data for now
        return [
            { class_id: '1', class_name: '10A1', student_name: 'Nguyễn Văn A' },
            { class_id: '3', class_name: '7B2', student_name: 'Nguyễn Văn B' }
        ];
    };
    
    // Handle class selection change
    const handleClassChange = (event) => {
        setSelectedClass(event.target.value);
    };
    
    // Check if user is a homeroom teacher for the selected class
    const isHomeRoomTeacherForSelectedClass = () => {
        if (userRole !== 'teacher' || !selectedClass) return false;
        
        const selectedClassData = userClasses.find(cls => cls.class_id === selectedClass);
        return selectedClassData && selectedClassData.homeroom_teacher_id === authService.getCurrentUserId();
    };
    
    // Navigate to teacher management page
    const handleGoToTeacherPage = () => {
        navigate('/teacher/class-events');
    };
    
    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                {/* Breadcrumbs navigation */}
                <Breadcrumbs 
                    separator={<NavigateNext fontSize="small" />}
                    aria-label="breadcrumb"
                    sx={{ mb: 1 }}
                >
                    <MuiLink 
                        component={Link} 
                        to="/home" 
                        underline="hover" 
                        color="text.primary"
                        sx={{ display: 'flex', alignItems: 'center' }}
                    >
                        Trang chủ
                    </MuiLink>
                    <Typography color="text.primary" sx={{ display: 'flex', alignItems: 'center' }}>
                        <ClassOutlined sx={{ mr: 0.5 }} fontSize="small" />
                        Thông báo lớp
                    </Typography>
                </Breadcrumbs>
                
                {/* Page header */}
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <Typography variant="h4" component="h1" gutterBottom>
                        Thông báo lớp học
                    </Typography>
                </Box>

                {/* Error message */}
                {error && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                        {error}
                    </Alert>
                )}
                
                {/* Loading state */}
                {loading ? (
                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
                        <CircularProgress />
                    </Box>
                ) : (
                    <>
                        {/* Class selection */}
                        <Paper elevation={0} sx={{ p: 3, mb: 3, borderRadius: 2 }}>
                            <FormControl fullWidth>
                                <InputLabel>Chọn lớp học</InputLabel>
                                <Select
                                    value={selectedClass}
                                    onChange={handleClassChange}
                                    label="Chọn lớp học"
                                >
                                    {userClasses.map((cls) => (
                                        <MenuItem key={cls.class_id} value={cls.class_id}>
                                            {cls.class_name}
                                            {cls.student_name && ` - ${cls.student_name}`}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Paper>
                        
                        {/* Class events list - shown only when a class is selected */}
                        {selectedClass ? (
                            <ClassEventsList 
                                classId={selectedClass} 
                                isHomeRoomTeacher={isHomeRoomTeacherForSelectedClass()}
                            />
                        ) : (
                            <Paper
                                elevation={0}
                                sx={{
                                    p: 5,
                                    textAlign: 'center',
                                    borderRadius: 2,
                                    bgcolor: theme.palette.background.paper,
                                }}
                            >
                                <Typography variant="h6" color="text.secondary" gutterBottom>
                                    Vui lòng chọn một lớp học để xem thông báo
                                </Typography>
                            </Paper>
                        )}
                    </>
                )}
            </Box>
        </Container>
    );
};

export default ClassEventsPage;