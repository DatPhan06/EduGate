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
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    Fab,
    useTheme
} from '@mui/material';
import { Link } from 'react-router-dom';
import {
    ClassOutlined,
    NavigateNext,
    Add as AddIcon,
    PostAdd as PostAddIcon
} from '@mui/icons-material';
import ClassEventsList from '../../components/ClassEvents/ClassEventsList';
import ClassEventEditor from '../../components/ClassEvents/ClassEventEditor';
import classPostService from '../../services/classPostService';
import authService from '../../services/authService';
import timetableService from '../../services/timetableService';
import { getClasses } from '../../services/classManagementService';

const TeacherClassEventsPage = () => {
    const theme = useTheme();
    
    // State
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [teacherClasses, setTeacherClasses] = useState([]);
    const [homeRoomClasses, setHomeRoomClasses] = useState([]);
    const [selectedClass, setSelectedClass] = useState('');
    const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
    const [createPostLoading, setCreatePostLoading] = useState(false);
    const [createPostError, setCreatePostError] = useState('');
    
    useEffect(() => {
        const loadInitialData = async () => {
            setLoading(true);
            try {
                const userData = await authService.getCurrentUser();
                
                // Correctly check for UserID
                if (!userData || typeof userData.UserID === 'undefined') { 
                    console.error('TeacherClassEventsPage: User data or UserID is undefined.');
                    setError('Không thể tải thông tin giáo viên. Vui lòng đăng nhập lại.');
                    setTeacherClasses([]);
                    setHomeRoomClasses([]);
                    setLoading(false);
                    return;
                }
                const teacherId = userData.UserID; // Use UserID here
                
                const { allClassesForTeacher, homeroomClassesForTeacher } = await fetchTeacherClassInfo(teacherId);
                
                setTeacherClasses(allClassesForTeacher);
                setHomeRoomClasses(homeroomClassesForTeacher);
                
                // Automatically select a class if there's only one homeroom class
                if (homeroomClassesForTeacher.length === 1) {
                    setSelectedClass(homeroomClassesForTeacher[0].class_id);
                } else if (homeroomClassesForTeacher.length === 0 && allClassesForTeacher.length === 1) {
                    // If no homeroom classes but teaches only one class, select that one.
                    setSelectedClass(allClassesForTeacher[0].class_id);
                }
                
                setError('');
            } catch (err) {
                console.error('Error fetching teacher class info:', err);
                setError('Không thể tải thông tin lớp học. Vui lòng thử lại sau.');
            } finally {
                setLoading(false);
            }
        };
        
        loadInitialData();
    }, []);
    
    // Fetches all classes a teacher is involved with AND specifically their homeroom classes
    const fetchTeacherClassInfo = async (teacherId) => { // teacherId parameter is the UserID
        const teacherUserIdStr = String(teacherId);

        // 1. Get all classes in the system
        const allSystemClasses = await getClasses(); // Fetches { ClassID, ClassName, HomeroomTeacherID, ... }

        // 2. Identify homeroom classes directly
        const homeroomClasses = allSystemClasses
            .filter(cls => String(cls.HomeroomTeacherID) === teacherUserIdStr)
            .map(cls => ({
                class_id: String(cls.ClassID),
                class_name: cls.ClassName,
                homeroom_teacher_id: String(cls.HomeroomTeacherID) 
            }));

        // 3. Identify all classes the teacher teaches subjects in (via timetable)
        const teacherClassAssignments = await timetableService.getClassSubjectsByTeacher(teacherId);
        // teacherClassAssignments is like: [{ ClassID, SubjectID, TeacherID, ... }]
        
        const taughtClassIDs = new Set(teacherClassAssignments.map(cs => cs.ClassID));

        // 4. Combine homeroom classes and taught classes for the general dropdown
        const allInvolvedClassIDs = new Set([...homeroomClasses.map(hc => parseInt(hc.class_id)), ...taughtClassIDs]);

        const allClassesForTeacherDropdown = Array.from(allInvolvedClassIDs).map(classId => {
            const classDetail = allSystemClasses.find(c => c.ClassID === classId);
            if (classDetail) {
                return {
                    class_id: String(classDetail.ClassID),
                    class_name: classDetail.ClassName,
                    // We need homeroom_teacher_id here to correctly populate the dropdown sections later
                    homeroom_teacher_id: classDetail.HomeroomTeacherID ? String(classDetail.HomeroomTeacherID) : null
                };
            }
            return null;
        }).filter(Boolean);

        return { 
            allClassesForTeacher: allClassesForTeacherDropdown, 
            homeroomClassesForTeacher: homeroomClasses 
        };
    };
    
    // Handle class selection change
    const handleClassChange = (event) => {
        setSelectedClass(event.target.value);
    };
    
    // Open create dialog
    const handleOpenCreateDialog = () => {
        setIsCreateDialogOpen(true);
        setCreatePostError('');
    };
    
    // Close create dialog
    const handleCloseCreateDialog = () => {
        setIsCreateDialogOpen(false);
    };
    
    // Create new class post
    const handleCreatePost = async (postData) => {
        setCreatePostLoading(true);
        try {
            await classPostService.createClassPost(postData);
            setIsCreateDialogOpen(false);
            
            // Force reload class events list
            // You might want to use a more elegant way to refresh the list
            // like passing a refresh trigger down to the ClassEventsList component
            window.location.reload();
            
            setCreatePostError('');
        } catch (err) {
            console.error('Error creating class post:', err);
            setCreatePostError('Đã xảy ra lỗi khi tạo thông báo. Vui lòng thử lại.');
        } finally {
            setCreatePostLoading(false);
        }
    };
    
    // Check if the current class is one where the teacher is the homeroom teacher
    const isHomeRoomForSelectedClass = () => {
        if (!selectedClass) return false;
        return homeRoomClasses.some(cls => cls.class_id === selectedClass);
    };
    
    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                {/* Breadcrumbs navigation */}
                <Breadcrumbs 
                    separator={<NavigateNext fontSize="small" />}
                    aria-label="breadcrumb"
                >
                    <MuiLink 
                        component={Link} 
                        to="/home" 
                        underline="hover" 
                        color="text.primary"
                    >
                        Trang chủ
                    </MuiLink>
                    <MuiLink 
                        component={Link}
                        to="/teacher/dashboard"
                        underline="hover"
                        color="text.primary"
                    >
                        Giáo viên
                    </MuiLink>
                    <Typography color="text.primary" sx={{ display: 'flex', alignItems: 'center' }}>
                        <ClassOutlined sx={{ mr: 0.5 }} fontSize="small" />
                        Quản lý thông báo lớp
                    </Typography>
                </Breadcrumbs>
                
                {/* Page header */}
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <Typography variant="h4" component="h1" fontWeight="500">
                        Quản lý thông báo lớp học
                    </Typography>
                    
                    {/* Create button - shown only when a homeroom class is selected */}
                    {isHomeRoomForSelectedClass() && (
                        <Button
                            variant="contained"
                            color="primary"
                            startIcon={<PostAddIcon />}
                            onClick={handleOpenCreateDialog}
                        >
                            Tạo thông báo mới
                        </Button>
                    )}
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
                        {/* Teacher info and guidance */}
                        <Paper elevation={0} sx={{ p: 3, mb: 3, borderRadius: 2 }}>
                            <Typography variant="subtitle1" gutterBottom fontWeight={500}>
                                Giáo viên chủ nhiệm
                            </Typography>
                            
                            {homeRoomClasses.length === 0 ? (
                                <Alert severity="info">
                                    Bạn không phải là giáo viên chủ nhiệm của lớp nào. 
                                    Vui lòng liên hệ quản trị viên để được phân công.
                                </Alert>
                            ) : (
                                <Typography variant="body2" paragraph>
                                    Bạn là giáo viên chủ nhiệm của {homeRoomClasses.length} lớp: {' '}
                                    {homeRoomClasses.map((cls) => cls.class_name).join(', ')}.
                                    Chọn một lớp trong danh sách bên dưới để quản lý thông báo.
                                </Typography>
                            )}
                            
                            <FormControl fullWidth sx={{ mt: 2 }}>
                                <InputLabel>Chọn lớp học</InputLabel>
                                <Select
                                    value={selectedClass}
                                    onChange={handleClassChange}
                                    label="Chọn lớp học"
                                >
                                    <MenuItem disabled value="">
                                        <em>Chọn lớp học</em>
                                    </MenuItem>
                                    
                                    {/* Homeroom classes section */}
                                    {homeRoomClasses.length > 0 && (
                                        <MenuItem disabled sx={{ opacity: 1, fontWeight: 'bold', bgcolor: 'background.default' }}>
                                            Lớp chủ nhiệm
                                        </MenuItem>
                                    )}
                                    
                                    {homeRoomClasses.map((cls) => (
                                        <MenuItem key={`homeroom-${cls.class_id}`} value={cls.class_id}>
                                            {cls.class_name} (Chủ nhiệm)
                                        </MenuItem>
                                    ))}
                                    
                                    {/* Regular teaching classes section */}
                                    {teacherClasses.filter(cls => !homeRoomClasses.some(hrc => hrc.class_id === cls.class_id)).length > 0 && (
                                        <MenuItem disabled sx={{ opacity: 1, fontWeight: 'bold', bgcolor: 'background.default' }}>
                                            Lớp giảng dạy
                                        </MenuItem>
                                    )}
                                    
                                    {teacherClasses
                                        .filter(cls => !homeRoomClasses.some(hrc => hrc.class_id === cls.class_id))
                                        .map((cls) => (
                                            <MenuItem key={`teaching-${cls.class_id}`} value={cls.class_id}>
                                                {cls.class_name}
                                            </MenuItem>
                                        ))
                                    }
                                </Select>
                            </FormControl>
                        </Paper>
                        
                        {/* Class events list - shown only when a class is selected */}
                        {selectedClass ? (
                            <ClassEventsList 
                                classId={selectedClass} 
                                isHomeRoomTeacher={isHomeRoomForSelectedClass()}
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
                                    Vui lòng chọn một lớp học để xem và quản lý thông báo
                                </Typography>
                            </Paper>
                        )}
                    </>
                )}
                
                {/* Create dialog */}
                <Dialog
                    open={isCreateDialogOpen}
                    onClose={() => !createPostLoading && handleCloseCreateDialog()}
                    fullWidth
                    maxWidth="md"
                >
                    <DialogTitle>
                        Tạo thông báo lớp học mới
                    </DialogTitle>
                    <DialogContent>
                        {createPostError && (
                            <Alert severity="error" sx={{ mt: 2, mb: 2 }}>
                                {createPostError}
                            </Alert>
                        )}
                        
                        <ClassEventEditor
                            classId={selectedClass}
                            onSubmit={handleCreatePost}
                            isLoading={createPostLoading}
                        />
                    </DialogContent>
                </Dialog>
                
                {/* Floating action button - for mobile view */}
                {isHomeRoomForSelectedClass() && (
                    <Fab
                        color="primary"
                        aria-label="add"
                        onClick={handleOpenCreateDialog}
                        sx={{
                            position: 'fixed',
                            bottom: 16,
                            right: 16,
                            display: { sm: 'none' }
                        }}
                    >
                        <AddIcon />
                    </Fab>
                )}
            </Box>
        </Container>
    );
};

export default TeacherClassEventsPage;