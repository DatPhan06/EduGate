import React, { useState, useEffect } from 'react';
import { 
    Box, Typography, Paper, Button, TextField, Dialog, DialogActions, 
    DialogContent, DialogContentText, DialogTitle, Table, TableBody, 
    TableCell, TableContainer, TableHead, TableRow, IconButton, Snackbar, 
    Alert, Divider, Chip, InputAdornment, Tab, Tabs, Tooltip, useTheme,
    alpha, CircularProgress, FormControl, InputLabel, Select, MenuItem, 
    ListItemIcon, Grid, Card, CardContent, CardActions
} from '@mui/material';
import { 
    Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon,
    Search as SearchIcon, FilterList as FilterListIcon,
    Schedule as ScheduleIcon, Subject as SubjectIcon,
    School as SchoolIcon, Class as ClassIcon,
    Person as PersonIcon, Today as TodayIcon,
    Timer as TimerIcon
} from '@mui/icons-material';
import timetableService from '../../services/timetableService';
import userService from '../../services/userService';

const TimetableManagementPage = () => {
    const theme = useTheme();
    
    // Constants - moved before states that use them
    const dayOptions = [
        'Monday', 'Tuesday', 'Wednesday', 
        'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    
    const periodOptions = Array.from({ length: 12 }, (_, i) => i + 1); // 1-12
    
    const academicYears = [
        '2022-2023', '2023-2024', '2024-2025', '2025-2026'
    ];
    
    const semesters = ['HK1', 'HK2'];
    
    // Subject states
    const [subjects, setSubjects] = useState([]);
    const [filteredSubjects, setFilteredSubjects] = useState([]);
    
    // Class-Subject states
    const [classSubjects, setClassSubjects] = useState([]);
    const [filteredClassSubjects, setFilteredClassSubjects] = useState([]);
    
    // Schedule states
    const [schedules, setSchedules] = useState([]);
    
    // Reference data
    const [classes, setClasses] = useState([]);
    const [teachers, setTeachers] = useState([]);
    
    // UI states
    const [activeTab, setActiveTab] = useState(0);
    const [searchQuery, setSearchQuery] = useState('');
    const [loading, setLoading] = useState({
        subjects: true,
        classSubjects: true,
        schedules: true,
        classes: true,
        teachers: true
    });
    
    // Add filter states for schedules
    const [dayFilter, setDayFilter] = useState('');
    const [classFilter, setClassFilter] = useState('');
    const [semesterFilter, setSemesterFilter] = useState('');
    const [yearFilter, setYearFilter] = useState('');
    
    // Form states
    const [openSubjectDialog, setOpenSubjectDialog] = useState(false);
    const [openClassSubjectDialog, setOpenClassSubjectDialog] = useState(false);
    const [openScheduleDialog, setOpenScheduleDialog] = useState(false);
    const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
    
    const [currentSubject, setCurrentSubject] = useState(null);
    const [currentClassSubject, setCurrentClassSubject] = useState(null);
    const [currentSchedule, setCurrentSchedule] = useState(null);
    const [deleteType, setDeleteType] = useState('');
    const [deleteId, setDeleteId] = useState(null);
    
    const [subjectFormData, setSubjectFormData] = useState({
        SubjectName: '',
        Description: ''
    });
    
    const [classSubjectFormData, setClassSubjectFormData] = useState({
        TeacherID: '',
        ClassID: '',
        SubjectID: '',
        Semester: '',
        AcademicYear: ''
    });
    
    const [scheduleFormData, setScheduleFormData] = useState({
        ClassSubjectID: '',
        StartPeriod: 1,
        EndPeriod: 1,
        Day: 'Monday',
        ClassID: '',
        SubjectID: '',
        TeacherID: '',
        Semester: 'HK1',
        AcademicYear: academicYears[3]
    });
    
    // Notification state
    const [notification, setNotification] = useState({
        open: false,
        message: '',
        severity: 'success'
    });
    
    // Initial data loading
    useEffect(() => {
        fetchSubjects();
        fetchClassSubjects();
        fetchSchedules();
        fetchClasses();
        fetchTeachers();
    }, []);
    
    // Tab change handler
    const handleTabChange = (event, newValue) => {
        setActiveTab(newValue);
        setSearchQuery('');
    };
    
    // Notification handlers
    const showNotification = (message, severity = 'success') => {
        setNotification({
            open: true,
            message,
            severity
        });
    };
    
    const handleCloseNotification = () => {
        setNotification({
            ...notification,
            open: false
        });
    };

    // Search handler
    const handleSearchChange = (event) => {
        setSearchQuery(event.target.value);
    };
    
    // Fetch data functions
    const fetchSubjects = async () => {
        setLoading(prev => ({ ...prev, subjects: true }));
        try {
            const data = await timetableService.getAllSubjects();
            setSubjects(data);
            setFilteredSubjects(data);
        } catch (error) {
            showNotification('Failed to load subjects', 'error');
            console.error('Error fetching subjects:', error);
        } finally {
            setLoading(prev => ({ ...prev, subjects: false }));
        }
    };
    
    const fetchClassSubjects = async () => {
        setLoading(prev => ({ ...prev, classSubjects: true }));
        try {
            const data = await timetableService.getAllClassSubjects();
            setClassSubjects(data);
            setFilteredClassSubjects(data);
        } catch (error) {
            showNotification('Failed to load class assignments', 'error');
            console.error('Error fetching class subjects:', error);
        } finally {
            setLoading(prev => ({ ...prev, classSubjects: false }));
        }
    };
    
    const fetchSchedules = async () => {
        setLoading(prev => ({ ...prev, schedules: true }));
        try {
            const data = await timetableService.getAllSchedules();
            setSchedules(data);
        } catch (error) {
            showNotification('Failed to load schedules', 'error');
            console.error('Error fetching schedules:', error);
        } finally {
            setLoading(prev => ({ ...prev, schedules: false }));
        }
    };
    
    const fetchClasses = async () => {
        setLoading(prev => ({ ...prev, classes: true }));
        try {
            // Assuming there's a method to get classes in userService or another service
            const data = await userService.getClasses();
            setClasses(data);
        } catch (error) {
            showNotification('Failed to load classes', 'error');
            console.error('Error fetching classes:', error);
        } finally {
            setLoading(prev => ({ ...prev, classes: false }));
        }
    };
    
    const fetchTeachers = async () => {
        setLoading(prev => ({ ...prev, teachers: true }));
        try {
            const users = await userService.getAllUsers();
            // Filter teachers
            const teachersList = users.filter(user => user.role === 'teacher');
            setTeachers(teachersList);
        } catch (error) {
            showNotification('Failed to load teachers', 'error');
            console.error('Error fetching teachers:', error);
        } finally {
            setLoading(prev => ({ ...prev, teachers: false }));
        }
    };

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" gutterBottom>
                Quản Lý Thời Khóa Biểu
            </Typography>
            
            <Tabs
                value={activeTab}
                onChange={handleTabChange}
                indicatorColor="primary"
                textColor="primary"
                variant="scrollable"
                scrollButtons="auto"
                sx={{ mb: 3, borderBottom: 1, borderColor: 'divider' }}
            >
                <Tab label="Môn Học" icon={<SubjectIcon />} iconPosition="start" />
                <Tab label="Môn Học Theo Giáo Viên" icon={<PersonIcon />} iconPosition="start" />
                <Tab label="Phân Công Lớp" icon={<ClassIcon />} iconPosition="start" />
                <Tab label="Lịch Học" icon={<ScheduleIcon />} iconPosition="start" />
            </Tabs>
            
            {/* Subject Management Tab */}
            {activeTab === 0 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3, alignItems: 'center' }}>
                        <TextField
                            placeholder="Tìm kiếm môn học..."
                            variant="outlined"
                            size="small"
                            value={searchQuery}
                            onChange={handleSearchChange}
                            InputProps={{
                                startAdornment: (
                                    <InputAdornment position="start">
                                        <SearchIcon />
                                    </InputAdornment>
                                )
                            }}
                            sx={{ width: '300px' }}
                        />
                        <Button
                            variant="contained"
                            color="primary"
                            startIcon={<AddIcon />}
                            onClick={() => {
                                setCurrentSubject(null);
                                setSubjectFormData({
                                    SubjectName: '',
                                    Description: ''
                                });
                                setOpenSubjectDialog(true);
                            }}
                        >
                            Thêm Môn Học
                        </Button>
                    </Box>
                    
                    {loading.subjects ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
                            <CircularProgress />
                        </Box>
                    ) : filteredSubjects.length === 0 ? (
                        <Paper sx={{ p: 4, textAlign: 'center' }}>
                            <Typography variant="h6" color="textSecondary">
                                Không tìm thấy môn học nào
                            </Typography>
                            <Typography variant="body2" color="textSecondary" sx={{ mt: 1 }}>
                                Hãy thêm môn học mới hoặc điều chỉnh tiêu chí tìm kiếm
                            </Typography>
                        </Paper>
                    ) : (
                        <TableContainer component={Paper}>
                            <Table>
                                <TableHead>
                                    <TableRow>
                                        <TableCell sx={{ fontWeight: 'bold' }}>ID</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Tên Môn Học</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Mô Tả</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Thao Tác</TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {filteredSubjects.map((subject) => (
                                        <TableRow key={subject.SubjectID}>
                                            <TableCell>{subject.SubjectID}</TableCell>
                                            <TableCell>{subject.SubjectName}</TableCell>
                                            <TableCell>{subject.Description || 'Không có mô tả'}</TableCell>
                                            <TableCell>
                                                <IconButton
                                                    color="primary"
                                                    onClick={() => {
                                                        setCurrentSubject(subject);
                                                        setSubjectFormData({
                                                            SubjectName: subject.SubjectName,
                                                            Description: subject.Description || ''
                                                        });
                                                        setOpenSubjectDialog(true);
                                                    }}
                                                >
                                                    <EditIcon />
                                                </IconButton>
                                                <IconButton
                                                    color="error"
                                                    onClick={() => {
                                                        setDeleteType('subject');
                                                        setDeleteId(subject.SubjectID);
                                                        setCurrentSubject(subject);
                                                        setOpenDeleteDialog(true);
                                                    }}
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        </TableContainer>
                    )}
                    
                    {/* Subject Dialog */}
                    <Dialog open={openSubjectDialog} onClose={() => setOpenSubjectDialog(false)} maxWidth="sm" fullWidth>
                        <DialogTitle>
                            {currentSubject ? 'Chỉnh Sửa Môn Học' : 'Thêm Môn Học Mới'}
                        </DialogTitle>
                        <DialogContent>
                            <TextField
                                autoFocus
                                margin="dense"
                                name="SubjectName"
                                label="Tên Môn Học"
                                type="text"
                                fullWidth
                                variant="outlined"
                                value={subjectFormData.SubjectName}
                                onChange={(e) => setSubjectFormData({
                                    ...subjectFormData,
                                    SubjectName: e.target.value
                                })}
                                required
                                sx={{ mb: 2, mt: 1 }}
                            />
                            <TextField
                                margin="dense"
                                name="Description"
                                label="Mô Tả"
                                type="text"
                                fullWidth
                                variant="outlined"
                                value={subjectFormData.Description}
                                onChange={(e) => setSubjectFormData({
                                    ...subjectFormData,
                                    Description: e.target.value
                                })}
                                multiline
                                rows={4}
                            />
                        </DialogContent>
                        <DialogActions>
                            <Button onClick={() => setOpenSubjectDialog(false)}>Hủy</Button>
                            <Button 
                                onClick={async () => {
                                    if (!subjectFormData.SubjectName) {
                                        showNotification('Vui lòng nhập tên môn học', 'error');
                                        return;
                                    }
                                    
                                    try {
                                        if (currentSubject) {
                                            await timetableService.updateSubject(
                                                currentSubject.SubjectID, 
                                                subjectFormData
                                            );
                                            showNotification('Cập nhật môn học thành công');
                                        } else {
                                            await timetableService.createSubject(subjectFormData);
                                            showNotification('Thêm môn học mới thành công');
                                        }
                                        setOpenSubjectDialog(false);
                                        fetchSubjects();
                                    } catch (error) {
                                        showNotification(
                                            `Lỗi ${currentSubject ? 'cập nhật' : 'thêm'} môn học: ${error.message}`,
                                            'error'
                                        );
                                    }
                                }} 
                                color="primary"
                                variant="contained"
                            >
                                {currentSubject ? 'Cập Nhật' : 'Thêm'}
                            </Button>
                        </DialogActions>
                    </Dialog>
                </Box>
            )}
            
            {/* Subject By Teacher Tab */}
            {activeTab === 1 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3, alignItems: 'center' }}>
                        <TextField
                            placeholder="Tìm kiếm giáo viên..."
                            variant="outlined"
                            size="small"
                            value={searchQuery}
                            onChange={handleSearchChange}
                            InputProps={{
                                startAdornment: (
                                    <InputAdornment position="start">
                                        <SearchIcon />
                                    </InputAdornment>
                                )
                            }}
                            sx={{ width: '300px' }}
                        />
                    </Box>
                    
                    {loading.teachers || loading.classSubjects ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
                            <CircularProgress />
                        </Box>
                    ) : teachers.length === 0 ? (
                        <Paper sx={{ p: 4, textAlign: 'center' }}>
                            <Typography variant="h6" color="textSecondary">
                                Không tìm thấy giáo viên nào
                            </Typography>
                        </Paper>
                    ) : (
                        <Box sx={{ mt: 2 }}>
                            {teachers
                                .filter(teacher => {
                                    if (!searchQuery) return true;
                                    const fullName = `${teacher.FirstName} ${teacher.LastName}`.toLowerCase();
                                    return fullName.includes(searchQuery.toLowerCase());
                                })
                                .map(teacher => {
                                    // Get subjects assigned to this teacher
                                    const teacherClassSubjects = classSubjects.filter(cs => cs.TeacherID === teacher.UserID);
                                    
                                    return (
                                        <Paper 
                                            key={teacher.UserID} 
                                            sx={{ 
                                                mb: 3, 
                                                p: 2, 
                                                borderLeft: 4, 
                                                borderColor: theme.palette.primary.main 
                                            }}
                                        >
                                            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                                                <Typography variant="h6" sx={{ display: 'flex', alignItems: 'center' }}>
                                                    <PersonIcon sx={{ mr: 1 }} />
                                                    {teacher.FirstName} {teacher.LastName}
                                                </Typography>
                                                
                                                <Button
                                                    variant="contained"
                                                    color="primary"
                                                    size="small"
                                                    startIcon={<AddIcon />}
                                                    onClick={() => {
                                                        setCurrentClassSubject(null);
                                                        setClassSubjectFormData({
                                                            TeacherID: teacher.UserID,
                                                            ClassID: '',
                                                            SubjectID: '',
                                                            Semester: 'HK1',
                                                            AcademicYear: academicYears[3]
                                                        });
                                                        setOpenClassSubjectDialog(true);
                                                    }}
                                                >
                                                    Thêm Môn Học
                                                </Button>
                                            </Box>
                                            
                                            {teacherClassSubjects.length === 0 ? (
                                                <Typography variant="body2" color="textSecondary" sx={{ textAlign: 'center', py: 2 }}>
                                                    Giáo viên này chưa được phân công môn học nào
                                                </Typography>
                                            ) : (
                                                <TableContainer component={Paper} variant="outlined">
                                                    <Table size="small">
                                                        <TableHead>
                                                            <TableRow>
                                                                <TableCell sx={{ fontWeight: 'bold' }}>Môn Học</TableCell>
                                                                <TableCell sx={{ fontWeight: 'bold' }}>Lớp</TableCell>
                                                                <TableCell sx={{ fontWeight: 'bold' }}>Học Kỳ</TableCell>
                                                                <TableCell sx={{ fontWeight: 'bold' }}>Năm Học</TableCell>
                                                                <TableCell sx={{ fontWeight: 'bold' }}>Thao Tác</TableCell>
                                                            </TableRow>
                                                        </TableHead>
                                                        <TableBody>
                                                            {teacherClassSubjects.map(cs => {
                                                                const subject = subjects.find(s => s.SubjectID === cs.SubjectID);
                                                                const classObj = classes.find(c => c.ClassID === cs.ClassID);
                                                                
                                                                return (
                                                                    <TableRow key={cs.ClassSubjectID}>
                                                                        <TableCell>{subject?.SubjectName || 'Unknown'}</TableCell>
                                                                        <TableCell>
                                                                            {classObj ? (
                                                                                <>Khối {classObj.GradeLevel} - {classObj.ClassName}</>
                                                                            ) : 'Unknown'}
                                                                        </TableCell>
                                                                        <TableCell>{cs.Semester}</TableCell>
                                                                        <TableCell>{cs.AcademicYear}</TableCell>
                                                                        <TableCell>
                                                                            <Box sx={{ display: 'flex' }}>
                                                                                <IconButton
                                                                                    size="small"
                                                                                    color="primary"
                                                                                    onClick={() => {
                                                                                        setCurrentClassSubject(cs);
                                                                                        setClassSubjectFormData({
                                                                                            TeacherID: cs.TeacherID,
                                                                                            ClassID: cs.ClassID,
                                                                                            SubjectID: cs.SubjectID,
                                                                                            Semester: cs.Semester,
                                                                                            AcademicYear: cs.AcademicYear
                                                                                        });
                                                                                        setOpenClassSubjectDialog(true);
                                                                                    }}
                                                                                >
                                                                                    <EditIcon fontSize="small" />
                                                                                </IconButton>
                                                                                <IconButton
                                                                                    size="small"
                                                                                    color="error"
                                                                                    onClick={() => {
                                                                                        setDeleteType('classSubject');
                                                                                        setDeleteId(cs.ClassSubjectID);
                                                                                        setCurrentClassSubject(cs);
                                                                                        setOpenDeleteDialog(true);
                                                                                    }}
                                                                                >
                                                                                    <DeleteIcon fontSize="small" />
                                                                                </IconButton>
                                                                                <IconButton
                                                                                    size="small"
                                                                                    color="info"
                                                                                    onClick={async () => {
                                                                                        try {
                                                                                            // Navigate to schedule tab
                                                                                            setActiveTab(3);
                                                                                        } catch (error) {
                                                                                            showNotification('Không thể tải lịch học', 'error');
                                                                                        }
                                                                                    }}
                                                                                >
                                                                                    <ScheduleIcon fontSize="small" />
                                                                                </IconButton>
                                                                            </Box>
                                                                        </TableCell>
                                                                    </TableRow>
                                                                );
                                                            })}
                                                        </TableBody>
                                                    </Table>
                                                </TableContainer>
                                            )}
                                        </Paper>
                                    );
                                })}
                        </Box>
                    )}
                    
                    {/* Modified Class-Subject Dialog - we'll reuse it but need to modify to handle teacher context */}
                    <Dialog 
                        open={openClassSubjectDialog} 
                        onClose={() => setOpenClassSubjectDialog(false)} 
                        maxWidth="md" 
                        fullWidth
                    >
                        <DialogTitle>
                            {currentClassSubject ? 'Chỉnh Sửa Phân Công Môn Học' : 'Thêm Phân Công Môn Học Mới'}
                        </DialogTitle>
                        <DialogContent>
                            <Grid container spacing={2} sx={{ mt: 1 }}>
                                {/* If opened from teacher tab, pre-select and disable teacher field */}
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Giáo Viên</InputLabel>
                                        <Select
                                            value={classSubjectFormData.TeacherID}
                                            label="Giáo Viên"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                TeacherID: e.target.value
                                            })}
                                            disabled={activeTab === 1 || currentClassSubject !== null}
                                        >
                                            {teachers.map((teacher) => (
                                                <MenuItem key={teacher.UserID} value={teacher.UserID}>
                                                    {`${teacher.FirstName} ${teacher.LastName}`}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Lớp</InputLabel>
                                        <Select
                                            value={classSubjectFormData.ClassID}
                                            label="Lớp"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                ClassID: e.target.value
                                            })}
                                            disabled={currentClassSubject !== null}
                                        >
                                            {classes.map((classObj) => (
                                                <MenuItem key={classObj.ClassID} value={classObj.ClassID}>
                                                    Khối {classObj.GradeLevel} - {classObj.ClassName}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Môn Học</InputLabel>
                                        <Select
                                            value={classSubjectFormData.SubjectID}
                                            label="Môn Học"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                SubjectID: e.target.value
                                            })}
                                            disabled={currentClassSubject !== null}
                                        >
                                            {subjects.map((subject) => (
                                                <MenuItem key={subject.SubjectID} value={subject.SubjectID}>
                                                    {subject.SubjectName}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Học Kỳ</InputLabel>
                                        <Select
                                            value={classSubjectFormData.Semester}
                                            label="Học Kỳ"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                Semester: e.target.value
                                            })}
                                        >
                                            {semesters.map((semester) => (
                                                <MenuItem key={semester} value={semester}>
                                                    {semester}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Năm Học</InputLabel>
                                        <Select
                                            value={classSubjectFormData.AcademicYear}
                                            label="Năm Học"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                AcademicYear: e.target.value
                                            })}
                                        >
                                            {academicYears.map((year) => (
                                                <MenuItem key={year} value={year}>
                                                    {year}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                            </Grid>
                        </DialogContent>
                        <DialogActions>
                            <Button onClick={() => setOpenClassSubjectDialog(false)}>Hủy</Button>
                            <Button 
                                onClick={async () => {
                                    // Validate form
                                    if (!classSubjectFormData.ClassID || 
                                        !classSubjectFormData.SubjectID || 
                                        !classSubjectFormData.TeacherID || 
                                        !classSubjectFormData.Semester || 
                                        !classSubjectFormData.AcademicYear) {
                                        showNotification('Vui lòng điền đầy đủ thông tin', 'error');
                                        return;
                                    }
                                    
                                    try {
                                        if (currentClassSubject) {
                                            await timetableService.updateClassSubject(
                                                currentClassSubject.ClassSubjectID, 
                                                classSubjectFormData
                                            );
                                            showNotification('Cập nhật phân công môn học thành công');
                                        } else {
                                            await timetableService.createClassSubject(classSubjectFormData);
                                            showNotification('Thêm phân công môn học mới thành công');
                                        }
                                        setOpenClassSubjectDialog(false);
                                        fetchClassSubjects();
                                    } catch (error) {
                                        showNotification(
                                            `Lỗi ${currentClassSubject ? 'cập nhật' : 'thêm'} phân công môn học: ${error.message}`,
                                            'error'
                                        );
                                    }
                                }} 
                                color="primary"
                                variant="contained"
                            >
                                {currentClassSubject ? 'Cập Nhật' : 'Thêm'}
                            </Button>
                        </DialogActions>
                    </Dialog>
                </Box>
            )}
            
            {/* Class-Subject Management Tab */}
            {activeTab === 2 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3, alignItems: 'center' }}>
                        <TextField
                            placeholder="Tìm kiếm phân công..."
                            variant="outlined"
                            size="small"
                            value={searchQuery}
                            onChange={handleSearchChange}
                            InputProps={{
                                startAdornment: (
                                    <InputAdornment position="start">
                                        <SearchIcon />
                                    </InputAdornment>
                                )
                            }}
                            sx={{ width: '300px' }}
                        />
                        <Button
                            variant="contained"
                            color="primary"
                            startIcon={<AddIcon />}
                            onClick={() => {
                                setCurrentClassSubject(null);
                                setClassSubjectFormData({
                                    TeacherID: '',
                                    ClassID: '',
                                    SubjectID: '',
                                    Semester: 'HK1',
                                    AcademicYear: academicYears[3]
                                });
                                setOpenClassSubjectDialog(true);
                            }}
                        >
                            Thêm Phân Công Lớp
                        </Button>
                    </Box>
                    
                    {loading.classSubjects ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
                            <CircularProgress />
                        </Box>
                    ) : filteredClassSubjects.length === 0 ? (
                        <Paper sx={{ p: 4, textAlign: 'center' }}>
                            <Typography variant="h6" color="textSecondary">
                                Không tìm thấy phân công lớp nào
                            </Typography>
                            <Typography variant="body2" color="textSecondary" sx={{ mt: 1 }}>
                                Hãy thêm phân công lớp mới hoặc điều chỉnh tiêu chí tìm kiếm
                            </Typography>
                        </Paper>
                    ) : (
                        <TableContainer component={Paper}>
                            <Table>
                                <TableHead>
                                    <TableRow>
                                        <TableCell sx={{ fontWeight: 'bold' }}>ID</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Lớp</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Môn Học</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Giáo Viên</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Học Kỳ</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Năm Học</TableCell>
                                        <TableCell sx={{ fontWeight: 'bold' }}>Thao Tác</TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {filteredClassSubjects.map((classSubject) => {
                                        // Find related data
                                        const subject = subjects.find(s => s.SubjectID === classSubject.SubjectID);
                                        const classObj = classes.find(c => c.ClassID === classSubject.ClassID);
                                        const teacher = teachers.find(t => t.UserID === classSubject.TeacherID);
                                        
                                        return (
                                            <TableRow key={classSubject.ClassSubjectID}>
                                                <TableCell>{classSubject.ClassSubjectID}</TableCell>
                                                <TableCell>
                                                    {classObj ? (
                                                        <>
                                                            Khối {classObj.GradeLevel} - {classObj.ClassName}
                                                        </>
                                                    ) : 'Unknown'}
                                                </TableCell>
                                                <TableCell>{subject?.SubjectName || 'Unknown'}</TableCell>
                                                <TableCell>
                                                    {teacher ? `${teacher.FirstName} ${teacher.LastName}` : 'Unknown'}
                                                </TableCell>
                                                <TableCell>{classSubject.Semester}</TableCell>
                                                <TableCell>{classSubject.AcademicYear}</TableCell>
                                                <TableCell>
                                                    <Tooltip title="Xem lịch học">
                                                        <IconButton
                                                            color="info"
                                                            onClick={async () => {
                                                                try {
                                                                    const schedules = await timetableService.getSchedulesByClassSubject(
                                                                        classSubject.ClassSubjectID
                                                                    );
                                                                    // Set active tab to schedules
                                                                    setActiveTab(3);
                                                                    // TODO: Filter schedules for this class subject
                                                                } catch (error) {
                                                                    showNotification('Không thể tải lịch học', 'error');
                                                                }
                                                            }}
                                                        >
                                                            <ScheduleIcon />
                                                        </IconButton>
                                                    </Tooltip>
                                                    <IconButton
                                                        color="primary"
                                                        onClick={() => {
                                                            setCurrentClassSubject(classSubject);
                                                            setClassSubjectFormData({
                                                                TeacherID: classSubject.TeacherID,
                                                                ClassID: classSubject.ClassID,
                                                                SubjectID: classSubject.SubjectID,
                                                                Semester: classSubject.Semester,
                                                                AcademicYear: classSubject.AcademicYear
                                                            });
                                                            setOpenClassSubjectDialog(true);
                                                        }}
                                                    >
                                                        <EditIcon />
                                                    </IconButton>
                                                    <IconButton
                                                        color="error"
                                                        onClick={() => {
                                                            setDeleteType('classSubject');
                                                            setDeleteId(classSubject.ClassSubjectID);
                                                            setCurrentClassSubject(classSubject);
                                                            setOpenDeleteDialog(true);
                                                        }}
                                                    >
                                                        <DeleteIcon />
                                                    </IconButton>
                                                </TableCell>
                                            </TableRow>
                                        );
                                    })}
                                </TableBody>
                            </Table>
                        </TableContainer>
                    )}
                    
                    {/* Class-Subject Dialog */}
                    <Dialog 
                        open={openClassSubjectDialog} 
                        onClose={() => setOpenClassSubjectDialog(false)} 
                        maxWidth="md" 
                        fullWidth
                    >
                        <DialogTitle>
                            {currentClassSubject ? 'Chỉnh Sửa Phân Công Lớp' : 'Thêm Phân Công Lớp Mới'}
                        </DialogTitle>
                        <DialogContent>
                            <Grid container spacing={2} sx={{ mt: 1 }}>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Lớp</InputLabel>
                                        <Select
                                            value={classSubjectFormData.ClassID}
                                            label="Lớp"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                ClassID: e.target.value
                                            })}
                                            disabled={currentClassSubject !== null}
                                        >
                                            {classes.map((classObj) => (
                                                <MenuItem key={classObj.ClassID} value={classObj.ClassID}>
                                                    Khối {classObj.GradeLevel} - {classObj.ClassName}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Môn Học</InputLabel>
                                        <Select
                                            value={classSubjectFormData.SubjectID}
                                            label="Môn Học"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                SubjectID: e.target.value
                                            })}
                                            disabled={currentClassSubject !== null}
                                        >
                                            {subjects.map((subject) => (
                                                <MenuItem key={subject.SubjectID} value={subject.SubjectID}>
                                                    {subject.SubjectName}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Giáo Viên</InputLabel>
                                        <Select
                                            value={classSubjectFormData.TeacherID}
                                            label="Giáo Viên"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                TeacherID: e.target.value
                                            })}
                                        >
                                            {teachers.map((teacher) => (
                                                <MenuItem key={teacher.UserID} value={teacher.UserID}>
                                                    {`${teacher.FirstName} ${teacher.LastName}`}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Học Kỳ</InputLabel>
                                        <Select
                                            value={classSubjectFormData.Semester}
                                            label="Học Kỳ"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                Semester: e.target.value
                                            })}
                                        >
                                            {semesters.map((semester) => (
                                                <MenuItem key={semester} value={semester}>
                                                    {semester}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Năm Học</InputLabel>
                                        <Select
                                            value={classSubjectFormData.AcademicYear}
                                            label="Năm Học"
                                            onChange={(e) => setClassSubjectFormData({
                                                ...classSubjectFormData,
                                                AcademicYear: e.target.value
                                            })}
                                        >
                                            {academicYears.map((year) => (
                                                <MenuItem key={year} value={year}>
                                                    {year}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                            </Grid>
                        </DialogContent>
                        <DialogActions>
                            <Button onClick={() => setOpenClassSubjectDialog(false)}>Hủy</Button>
                            <Button 
                                onClick={async () => {
                                    // Validate form
                                    if (!classSubjectFormData.ClassID || 
                                        !classSubjectFormData.SubjectID || 
                                        !classSubjectFormData.TeacherID || 
                                        !classSubjectFormData.Semester || 
                                        !classSubjectFormData.AcademicYear) {
                                        showNotification('Vui lòng điền đầy đủ thông tin', 'error');
                                        return;
                                    }
                                    
                                    try {
                                        if (currentClassSubject) {
                                            await timetableService.updateClassSubject(
                                                currentClassSubject.ClassSubjectID, 
                                                classSubjectFormData
                                            );
                                            showNotification('Cập nhật phân công môn học thành công');
                                        } else {
                                            await timetableService.createClassSubject(classSubjectFormData);
                                            showNotification('Thêm phân công môn học mới thành công');
                                        }
                                        setOpenClassSubjectDialog(false);
                                        fetchClassSubjects();
                                    } catch (error) {
                                        showNotification(
                                            `Lỗi ${currentClassSubject ? 'cập nhật' : 'thêm'} phân công môn học: ${error.message}`,
                                            'error'
                                        );
                                    }
                                }} 
                                color="primary"
                                variant="contained"
                            >
                                {currentClassSubject ? 'Cập Nhật' : 'Thêm'}
                            </Button>
                        </DialogActions>
                    </Dialog>
                </Box>
            )}
            
            {/* Schedule Management Tab */}
            {activeTab === 3 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3, alignItems: 'flex-start' }}>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                            <TextField
                                placeholder="Tìm kiếm lịch học..."
                                variant="outlined"
                                size="small"
                                value={searchQuery}
                                onChange={handleSearchChange}
                                InputProps={{
                                    startAdornment: (
                                        <InputAdornment position="start">
                                            <SearchIcon />
                                        </InputAdornment>
                                    )
                                }}
                                sx={{ width: '300px' }}
                            />
                            
                            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, mt: 1 }}>
                                <FormControl size="small" sx={{ minWidth: 150 }}>
                                    <InputLabel>Lọc theo ngày</InputLabel>
                                    <Select
                                        value={dayFilter}
                                        label="Lọc theo ngày"
                                        onChange={(e) => setDayFilter(e.target.value)}
                                    >
                                        <MenuItem value="">Tất cả các ngày</MenuItem>
                                        {dayOptions.map((day) => (
                                            <MenuItem key={day} value={day}>{day}</MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                                
                                <FormControl size="small" sx={{ minWidth: 200 }}>
                                    <InputLabel>Lọc theo lớp</InputLabel>
                                    <Select
                                        value={classFilter}
                                        label="Lọc theo lớp"
                                        onChange={(e) => setClassFilter(e.target.value)}
                                    >
                                        <MenuItem value="">Tất cả các lớp</MenuItem>
                                        {classes.map((classObj) => (
                                            <MenuItem key={classObj.ClassID} value={classObj.ClassID}>
                                                Khối {classObj.GradeLevel} - {classObj.ClassName}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                                
                                <FormControl size="small" sx={{ minWidth: 120 }}>
                                    <InputLabel>Học kỳ</InputLabel>
                                    <Select
                                        value={semesterFilter}
                                        label="Học kỳ"
                                        onChange={(e) => setSemesterFilter(e.target.value)}
                                    >
                                        <MenuItem value="">Tất cả</MenuItem>
                                        {semesters.map((semester) => (
                                            <MenuItem key={semester} value={semester}>{semester}</MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                                
                                <FormControl size="small" sx={{ minWidth: 150 }}>
                                    <InputLabel>Năm học</InputLabel>
                                    <Select
                                        value={yearFilter}
                                        label="Năm học"
                                        onChange={(e) => setYearFilter(e.target.value)}
                                    >
                                        <MenuItem value="">Tất cả</MenuItem>
                                        {academicYears.map((year) => (
                                            <MenuItem key={year} value={year}>{year}</MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                                
                                {(dayFilter || classFilter || semesterFilter || yearFilter) && (
                                    <Button 
                                        variant="outlined" 
                                        size="small" 
                                        onClick={() => {
                                            setDayFilter('');
                                            setClassFilter('');
                                            setSemesterFilter('');
                                            setYearFilter('');
                                        }}
                                        startIcon={<FilterListIcon />}
                                    >
                                        Xóa bộ lọc
                                    </Button>
                                )}
                            </Box>
                        </Box>
                        
                        <Button
                            variant="contained"
                            color="primary"
                            startIcon={<AddIcon />}
                            onClick={() => {
                                setCurrentSchedule(null);
                                setScheduleFormData({
                                    ClassSubjectID: '',
                                    StartPeriod: 1,
                                    EndPeriod: 1,
                                    Day: 'Monday',
                                    ClassID: '',
                                    SubjectID: '',
                                    TeacherID: '',
                                    Semester: 'HK1',
                                    AcademicYear: academicYears[3]
                                });
                                setOpenScheduleDialog(true);
                            }}
                        >
                            Thêm Lịch Học
                        </Button>
                    </Box>
                    
                    {loading.schedules ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
                            <CircularProgress />
                        </Box>
                    ) : schedules.length === 0 ? (
                        <Paper sx={{ p: 4, textAlign: 'center' }}>
                            <Typography variant="h6" color="textSecondary">
                                Không tìm thấy lịch học nào
                            </Typography>
                            <Typography variant="body2" color="textSecondary" sx={{ mt: 1 }}>
                                Hãy thêm lịch học mới hoặc điều chỉnh tiêu chí tìm kiếm
                            </Typography>
                        </Paper>
                    ) : (
                        <Grid container spacing={3}>
                            {/* Filter schedules and group them by day */}
                            {dayOptions
                                .filter(day => dayFilter ? day === dayFilter : true)
                                .map(day => {
                                    // First filter schedules by day
                                    const daySchedules = schedules.filter(s => s.Day === day);
                                    
                                    // Then apply additional filters
                                    const filteredSchedules = daySchedules.filter(schedule => {
                                        // Find the class subject for this schedule
                                        const classSubject = classSubjects.find(cs => cs.ClassSubjectID === schedule.ClassSubjectID);
                                        if (!classSubject) return false;
                                        
                                        // Apply class filter
                                        if (classFilter && classSubject.ClassID !== classFilter) {
                                            return false;
                                        }
                                        
                                        // Apply semester filter
                                        if (semesterFilter && classSubject.Semester !== semesterFilter) {
                                            return false;
                                        }
                                        
                                        // Apply year filter
                                        if (yearFilter && classSubject.AcademicYear !== yearFilter) {
                                            return false;
                                        }
                                        
                                        // Apply search filter if any
                                        if (searchQuery) {
                                            // Get related entities for search
                                            const subject = subjects.find(s => s.SubjectID === classSubject.SubjectID);
                                            const classObj = classes.find(c => c.ClassID === classSubject.ClassID);
                                            const teacher = teachers.find(t => t.UserID === classSubject.TeacherID);
                                            
                                            const subjectName = subject?.SubjectName?.toLowerCase() || '';
                                            const className = classObj?.ClassName?.toLowerCase() || '';
                                            const teacherName = teacher ? 
                                                `${teacher.FirstName} ${teacher.LastName}`.toLowerCase() : '';
                                            
                                            const searchLower = searchQuery.toLowerCase();
                                            
                                            if (!subjectName.includes(searchLower) && 
                                                !className.includes(searchLower) && 
                                                !teacherName.includes(searchLower)) {
                                                return false;
                                            }
                                        }
                                        
                                        return true;
                                    });
                                    
                                    if (filteredSchedules.length === 0) return null;
                                    
                                    return (
                                        <Grid item xs={12} key={day}>
                                            <Typography variant="h6" sx={{ mb: 2, mt: 1, fontWeight: 'bold' }}>
                                                {day}
                                            </Typography>
                                            <TableContainer component={Paper}>
                                                <Table>
                                                    <TableHead>
                                                        <TableRow>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Lớp</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Môn Học</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Giáo Viên</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Tiết Bắt Đầu</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Tiết Kết Thúc</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Học Kỳ/Năm Học</TableCell>
                                                            <TableCell sx={{ fontWeight: 'bold' }}>Thao Tác</TableCell>
                                                        </TableRow>
                                                    </TableHead>
                                                    <TableBody>
                                                        {filteredSchedules.map(schedule => {
                                                            // Find related class subject
                                                            const classSubject = classSubjects.find(
                                                                cs => cs.ClassSubjectID === schedule.ClassSubjectID
                                                            );
                                                            
                                                            // Find related entities
                                                            const subject = classSubject ? subjects.find(
                                                                s => s.SubjectID === classSubject.SubjectID
                                                            ) : null;
                                                            
                                                            const classObj = classSubject ? classes.find(
                                                                c => c.ClassID === classSubject.ClassID
                                                            ) : null;
                                                            
                                                            const teacher = classSubject ? teachers.find(
                                                                t => t.UserID === classSubject.TeacherID
                                                            ) : null;
                                                            
                                                            return (
                                                                <TableRow key={schedule.SubjectScheduleID}>
                                                                    <TableCell>
                                                                        {classObj ? (
                                                                            <>Khối {classObj.GradeLevel} - {classObj.ClassName}</>
                                                                        ) : 'N/A'}
                                                                    </TableCell>
                                                                    <TableCell>{subject?.SubjectName || 'N/A'}</TableCell>
                                                                    <TableCell>
                                                                        {teacher ? `${teacher.FirstName} ${teacher.LastName}` : 'N/A'}
                                                                    </TableCell>
                                                                    <TableCell>{schedule.StartPeriod}</TableCell>
                                                                    <TableCell>{schedule.EndPeriod}</TableCell>
                                                                    <TableCell>
                                                                        {classSubject ? 
                                                                            `${classSubject.Semester}/${classSubject.AcademicYear}` : 
                                                                            'N/A'
                                                                        }
                                                                    </TableCell>
                                                                    <TableCell>
                                                                        <IconButton
                                                                            color="primary"
                                                                            onClick={() => {
                                                                                setCurrentSchedule(schedule);
                                                                                setScheduleFormData({
                                                                                    ClassSubjectID: schedule.ClassSubjectID,
                                                                                    StartPeriod: schedule.StartPeriod,
                                                                                    EndPeriod: schedule.EndPeriod,
                                                                                    Day: schedule.Day,
                                                                                    ClassID: classSubject ? classSubject.ClassID : '',
                                                                                    SubjectID: classSubject ? classSubject.SubjectID : '',
                                                                                    TeacherID: classSubject ? classSubject.TeacherID : '',
                                                                                    Semester: classSubject ? classSubject.Semester : '',
                                                                                    AcademicYear: classSubject ? classSubject.AcademicYear : ''
                                                                                });
                                                                                setOpenScheduleDialog(true);
                                                                            }}
                                                                        >
                                                                            <EditIcon />
                                                                        </IconButton>
                                                                        <IconButton
                                                                            color="error"
                                                                            onClick={() => {
                                                                                setDeleteType('schedule');
                                                                                setDeleteId(schedule.SubjectScheduleID);
                                                                                setCurrentSchedule(schedule);
                                                                                setOpenDeleteDialog(true);
                                                                            }}
                                                                        >
                                                                            <DeleteIcon />
                                                                        </IconButton>
                                                                    </TableCell>
                                                                </TableRow>
                                                            );
                                                        })}
                                                    </TableBody>
                                                </Table>
                                            </TableContainer>
                                        </Grid>
                                    );
                                })}
                        </Grid>
                    )}
                    
                    {/* Schedule Dialog */}
                    <Dialog 
                        open={openScheduleDialog} 
                        onClose={() => setOpenScheduleDialog(false)} 
                        maxWidth="md" 
                        fullWidth
                    >
                        <DialogTitle>
                            {currentSchedule ? 'Chỉnh Sửa Lịch Học' : 'Thêm Lịch Học Mới'}
                        </DialogTitle>
                        <DialogContent>
                            <Grid container spacing={2} sx={{ mt: 1 }}>
                                {currentSchedule ? (
                                    // For editing, show the existing class subject info
                                    <Grid item xs={12}>
                                        <FormControl fullWidth required>
                                            <InputLabel>Phân Công Môn Học</InputLabel>
                                            <Select
                                                value={scheduleFormData.ClassSubjectID}
                                                label="Phân Công Môn Học"
                                                onChange={(e) => setScheduleFormData({
                                                    ...scheduleFormData,
                                                    ClassSubjectID: e.target.value
                                                })}
                                                disabled={currentSchedule !== null}
                                            >
                                                {classSubjects.map((cs) => {
                                                    const subject = subjects.find(s => s.SubjectID === cs.SubjectID);
                                                    const classObj = classes.find(c => c.ClassID === cs.ClassID);
                                                    
                                                    return (
                                                        <MenuItem key={cs.ClassSubjectID} value={cs.ClassSubjectID}>
                                                            {`${classObj ? `Khối ${classObj.GradeLevel} - ${classObj.ClassName}` : 'Unknown'} - ${subject?.SubjectName || 'Unknown'} (${cs.Semester}/${cs.AcademicYear})`}
                                                        </MenuItem>
                                                    );
                                                })}
                                            </Select>
                                        </FormControl>
                                    </Grid>
                                ) : (
                                    // For creating new schedule, show separate fields
                                    <>
                                        <Grid item xs={12} md={6}>
                                            <FormControl fullWidth required>
                                                <InputLabel>Lớp</InputLabel>
                                                <Select
                                                    value={scheduleFormData.ClassID}
                                                    label="Lớp"
                                                    onChange={(e) => {
                                                        const newClassID = e.target.value;
                                                        setScheduleFormData({
                                                            ...scheduleFormData,
                                                            ClassID: newClassID,
                                                            // Reset downstream dependencies
                                                            ClassSubjectID: ''
                                                        });
                                                    }}
                                                >
                                                    <MenuItem value="">Chọn lớp</MenuItem>
                                                    {classes.map((classObj) => (
                                                        <MenuItem key={classObj.ClassID} value={classObj.ClassID}>
                                                            Khối {classObj.GradeLevel} - {classObj.ClassName}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Grid>
                                        
                                        <Grid item xs={12} md={6}>
                                            <FormControl fullWidth required>
                                                <InputLabel>Môn Học</InputLabel>
                                                <Select
                                                    value={scheduleFormData.SubjectID}
                                                    label="Môn Học"
                                                    onChange={(e) => {
                                                        const newSubjectID = e.target.value;
                                                        setScheduleFormData({
                                                            ...scheduleFormData,
                                                            SubjectID: newSubjectID,
                                                            // Reset downstream dependencies
                                                            ClassSubjectID: ''
                                                        });
                                                    }}
                                                >
                                                    <MenuItem value="">Chọn môn học</MenuItem>
                                                    {subjects.map((subject) => (
                                                        <MenuItem key={subject.SubjectID} value={subject.SubjectID}>
                                                            {subject.SubjectName}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Grid>
                                        
                                        <Grid item xs={12} md={6}>
                                            <FormControl fullWidth required>
                                                <InputLabel>Giáo Viên</InputLabel>
                                                <Select
                                                    value={scheduleFormData.TeacherID}
                                                    label="Giáo Viên"
                                                    onChange={(e) => {
                                                        const newTeacherID = e.target.value;
                                                        setScheduleFormData({
                                                            ...scheduleFormData,
                                                            TeacherID: newTeacherID,
                                                            // Reset downstream dependencies
                                                            ClassSubjectID: ''
                                                        });
                                                    }}
                                                >
                                                    <MenuItem value="">Chọn giáo viên</MenuItem>
                                                    {teachers.map((teacher) => (
                                                        <MenuItem key={teacher.UserID} value={teacher.UserID}>
                                                            {`${teacher.FirstName} ${teacher.LastName}`}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Grid>
                                        
                                        <Grid item xs={12} md={6}>
                                            <FormControl fullWidth required>
                                                <InputLabel>Học Kỳ</InputLabel>
                                                <Select
                                                    value={scheduleFormData.Semester}
                                                    label="Học Kỳ"
                                                    onChange={(e) => {
                                                        setScheduleFormData({
                                                            ...scheduleFormData,
                                                            Semester: e.target.value,
                                                            // Reset downstream dependencies
                                                            ClassSubjectID: ''
                                                        });
                                                    }}
                                                >
                                                    {semesters.map((semester) => (
                                                        <MenuItem key={semester} value={semester}>
                                                            {semester}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Grid>
                                        
                                        <Grid item xs={12}>
                                            <FormControl fullWidth required>
                                                <InputLabel>Năm Học</InputLabel>
                                                <Select
                                                    value={scheduleFormData.AcademicYear}
                                                    label="Năm Học"
                                                    onChange={(e) => {
                                                        setScheduleFormData({
                                                            ...scheduleFormData,
                                                            AcademicYear: e.target.value,
                                                            // Reset downstream dependencies
                                                            ClassSubjectID: ''
                                                        });
                                                    }}
                                                >
                                                    {academicYears.map((year) => (
                                                        <MenuItem key={year} value={year}>
                                                            {year}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        </Grid>
                                    </>
                                )}
                                
                                <Grid item xs={12} md={4}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Ngày</InputLabel>
                                        <Select
                                            value={scheduleFormData.Day}
                                            label="Ngày"
                                            onChange={(e) => setScheduleFormData({
                                                ...scheduleFormData,
                                                Day: e.target.value
                                            })}
                                        >
                                            {dayOptions.map((day) => (
                                                <MenuItem key={day} value={day}>
                                                    {day}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={4}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Tiết Bắt Đầu</InputLabel>
                                        <Select
                                            value={scheduleFormData.StartPeriod}
                                            label="Tiết Bắt Đầu"
                                            onChange={(e) => {
                                                const value = Number(e.target.value);
                                                setScheduleFormData({
                                                    ...scheduleFormData,
                                                    StartPeriod: value,
                                                    // Ensure EndPeriod is not less than StartPeriod
                                                    EndPeriod: Math.max(value, scheduleFormData.EndPeriod)
                                                });
                                            }}
                                        >
                                            {periodOptions.map((period) => (
                                                <MenuItem key={period} value={period}>
                                                    {`Tiết ${period}`}
                                                </MenuItem>
                                            ))}
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12} md={4}>
                                    <FormControl fullWidth required>
                                        <InputLabel>Tiết Kết Thúc</InputLabel>
                                        <Select
                                            value={scheduleFormData.EndPeriod}
                                            label="Tiết Kết Thúc"
                                            onChange={(e) => setScheduleFormData({
                                                ...scheduleFormData,
                                                EndPeriod: Number(e.target.value)
                                            })}
                                        >
                                            {periodOptions
                                                .filter(period => period >= scheduleFormData.StartPeriod)
                                                .map((period) => (
                                                    <MenuItem key={period} value={period}>
                                                        {`Tiết ${period}`}
                                                    </MenuItem>
                                                ))
                                            }
                                        </Select>
                                    </FormControl>
                                </Grid>
                            </Grid>
                        </DialogContent>
                        <DialogActions>
                            <Button onClick={() => setOpenScheduleDialog(false)}>Hủy</Button>
                            <Button 
                                onClick={async () => {
                                    // For creating new schedules
                                    if (!currentSchedule) {
                                        // Find or create the class subject assignment if needed
                                        try {
                                            // Validate required fields first
                                            if (!scheduleFormData.ClassID || 
                                                !scheduleFormData.SubjectID || 
                                                !scheduleFormData.TeacherID || 
                                                !scheduleFormData.Semester || 
                                                !scheduleFormData.AcademicYear ||
                                                !scheduleFormData.Day || 
                                                !scheduleFormData.StartPeriod || 
                                                !scheduleFormData.EndPeriod) {
                                                showNotification('Vui lòng điền đầy đủ thông tin', 'error');
                                                return;
                                            }
                                            
                                            if (scheduleFormData.StartPeriod > scheduleFormData.EndPeriod) {
                                                showNotification('Tiết bắt đầu không thể sau tiết kết thúc', 'error');
                                                return;
                                            }
                                            
                                            // Find if a class subject with these properties already exists
                                            let targetClassSubjectID = scheduleFormData.ClassSubjectID;
                                            let wasCreated = false;
                                            
                                            if (!targetClassSubjectID) {
                                                const matchingClassSubject = classSubjects.find(cs => 
                                                    cs.ClassID === scheduleFormData.ClassID &&
                                                    cs.SubjectID === scheduleFormData.SubjectID &&
                                                    cs.TeacherID === scheduleFormData.TeacherID &&
                                                    cs.Semester === scheduleFormData.Semester &&
                                                    cs.AcademicYear === scheduleFormData.AcademicYear
                                                );
                                                
                                                if (matchingClassSubject) {
                                                    // Use existing class subject
                                                    targetClassSubjectID = matchingClassSubject.ClassSubjectID;
                                                    console.log('Found existing class subject:', matchingClassSubject);
                                                } else {
                                                    // Create a new class subject assignment
                                                    console.log('Creating new class subject assignment');
                                                    
                                                    const newClassSubjectData = {
                                                        ClassID: scheduleFormData.ClassID,
                                                        SubjectID: scheduleFormData.SubjectID,
                                                        TeacherID: scheduleFormData.TeacherID,
                                                        Semester: scheduleFormData.Semester,
                                                        AcademicYear: scheduleFormData.AcademicYear
                                                    };
                                                    
                                                    // Look up related entities for notification
                                                    const classObj = classes.find(c => c.ClassID === scheduleFormData.ClassID);
                                                    const subject = subjects.find(s => s.SubjectID === scheduleFormData.SubjectID);
                                                    const teacher = teachers.find(t => t.UserID === scheduleFormData.TeacherID);
                                                    
                                                    const newClassSubject = await timetableService.createClassSubject(newClassSubjectData);
                                                    wasCreated = true;
                                                    targetClassSubjectID = newClassSubject.ClassSubjectID;
                                                    
                                                    // Refresh class subjects list
                                                    fetchClassSubjects();
                                                    
                                                    // Tell the user we created a new assignment
                                                    showNotification(
                                                        `Đã tự động tạo phân công môn ${subject?.SubjectName || 'N/A'} cho lớp ${classObj?.ClassName || 'N/A'} với giáo viên ${teacher ? `${teacher.FirstName} ${teacher.LastName}` : 'N/A'}`,
                                                        'info'
                                                    );
                                                }
                                            }
                                            
                                            // Now create the schedule with the class subject ID
                                            if (!targetClassSubjectID) {
                                                showNotification('Không thể tạo phân công lớp-môn học', 'error');
                                                return;
                                            }
                                            
                                            // Create schedule
                                            const scheduleData = {
                                                ClassSubjectID: targetClassSubjectID,
                                                Day: scheduleFormData.Day,
                                                StartPeriod: scheduleFormData.StartPeriod,
                                                EndPeriod: scheduleFormData.EndPeriod
                                            };
                                            
                                            await timetableService.createSchedule(scheduleData);
                                            
                                            // Show success notification
                                            if (wasCreated) {
                                                showNotification('Đã tạo lịch học và phân công môn học mới thành công');
                                            } else {
                                                showNotification('Thêm lịch học mới thành công');
                                            }
                                            
                                            setOpenScheduleDialog(false);
                                            fetchSchedules();
                                        } catch (error) {
                                            showNotification(`Lỗi thêm lịch học: ${error.message}`, 'error');
                                        }
                                    } else {
                                        // For updating existing schedules
                                        try {
                                            if (!scheduleFormData.ClassSubjectID || 
                                                !scheduleFormData.Day || 
                                                !scheduleFormData.StartPeriod || 
                                                !scheduleFormData.EndPeriod) {
                                                showNotification('Vui lòng điền đầy đủ thông tin', 'error');
                                                return;
                                            }
                                            
                                            if (scheduleFormData.StartPeriod > scheduleFormData.EndPeriod) {
                                                showNotification('Tiết bắt đầu không thể sau tiết kết thúc', 'error');
                                                return;
                                            }
                                            
                                            await timetableService.updateSchedule(
                                                currentSchedule.SubjectScheduleID, 
                                                {
                                                    ClassSubjectID: scheduleFormData.ClassSubjectID,
                                                    Day: scheduleFormData.Day,
                                                    StartPeriod: scheduleFormData.StartPeriod,
                                                    EndPeriod: scheduleFormData.EndPeriod
                                                }
                                            );
                                            
                                            showNotification('Cập nhật lịch học thành công');
                                            setOpenScheduleDialog(false);
                                            fetchSchedules();
                                        } catch (error) {
                                            showNotification(`Lỗi cập nhật lịch học: ${error.message}`, 'error');
                                        }
                                    }
                                }} 
                                color="primary"
                                variant="contained"
                            >
                                {currentSchedule ? 'Cập Nhật' : 'Thêm'}
                            </Button>
                        </DialogActions>
                    </Dialog>
                </Box>
            )}
            
            {/* Delete Confirmation Dialog */}
            <Dialog open={openDeleteDialog} onClose={() => setOpenDeleteDialog(false)}>
                <DialogTitle>Xác Nhận Xóa</DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        {deleteType === 'subject' && `Bạn có chắc chắn muốn xóa môn học "${currentSubject?.SubjectName}" không?`}
                        {deleteType === 'classSubject' && 'Bạn có chắc chắn muốn xóa phân công lớp này không?'}
                        {deleteType === 'schedule' && 'Bạn có chắc chắn muốn xóa lịch học này không?'}
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setOpenDeleteDialog(false)}>Hủy</Button>
                    <Button 
                        onClick={async () => {
                            try {
                                if (deleteType === 'subject') {
                                    await timetableService.deleteSubject(deleteId);
                                    showNotification('Xóa môn học thành công');
                                    fetchSubjects();
                                } else if (deleteType === 'classSubject') {
                                    await timetableService.deleteClassSubject(deleteId);
                                    showNotification('Xóa phân công lớp thành công');
                                    fetchClassSubjects();
                                } else if (deleteType === 'schedule') {
                                    await timetableService.deleteSchedule(deleteId);
                                    showNotification('Xóa lịch học thành công');
                                    fetchSchedules();
                                }
                                setOpenDeleteDialog(false);
                            } catch (error) {
                                showNotification(`Lỗi xóa: ${error.message}`, 'error');
                            }
                        }} 
                        color="error"
                        variant="contained"
                    >
                        Xóa
                    </Button>
                </DialogActions>
            </Dialog>
            
            {/* Notification */}
            <Snackbar 
                open={notification.open} 
                autoHideDuration={6000} 
                onClose={handleCloseNotification}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert 
                    onClose={handleCloseNotification} 
                    severity={notification.severity}
                    sx={{ width: '100%' }}
                >
                    {notification.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default TimetableManagementPage; 