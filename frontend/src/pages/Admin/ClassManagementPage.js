import React, { useState, useEffect, useCallback } from 'react';
import { 
    Box, 
    Typography, 
    Paper, 
    Tab, 
    Tabs, 
    Button, 
    TextField, 
    Table, 
    TableBody, 
    TableCell, 
    TableContainer, 
    TableHead, 
    TableRow,
    IconButton,
    Dialog,
    DialogActions,
    DialogContent,
    DialogContentText,
    DialogTitle,
    Grid,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Chip,
    Alert,
    Snackbar,
    Checkbox,
    CircularProgress
} from '@mui/material';
import { 
    Add as AddIcon, 
    Edit as EditIcon, 
    Delete as DeleteIcon,
    PersonAdd as PersonAddIcon,
    School as SchoolIcon
} from '@mui/icons-material';
import {
    getClasses, createClass, updateClass, deleteClass,
    getStudents, createStudent, updateStudent, deleteStudent,
    getTeachers,
    assignMultipleStudentsToClass
} from '../../services/classManagementService';

const ClassManagementPage = () => {
    const [tabValue, setTabValue] = useState(0);
    const [classes, setClasses] = useState([]);
    const [students, setStudents] = useState([]);
    const [teachers, setTeachers] = useState([]);

    // Loading states
    const [loadingClasses, setLoadingClasses] = useState(false);
    const [loadingStudents, setLoadingStudents] = useState(false);
    const [loadingTeachers, setLoadingTeachers] = useState(false);

    // Dialog states
    const [openClassDialog, setOpenClassDialog] = useState(false);
    const [openStudentDialog, setOpenStudentDialog] = useState(false);
    const [dialogMode, setDialogMode] = useState('add');
    const [openAddMultipleStudentsDialog, setOpenAddMultipleStudentsDialog] = useState(false);
    const [studentsForBulkAdd, setStudentsForBulkAdd] = useState([]);
    const [selectedStudentsForBulkAdd, setSelectedStudentsForBulkAdd] = useState(new Set());
    
    // Form states
    const [currentClass, setCurrentClass] = useState({ 
        ClassName: '',
        GradeLevel: '',
        AcademicYear: '',
        HomeroomTeacherID: ''
    });
    
    const [currentStudent, setCurrentStudent] = useState({
        FirstName: '',
        LastName: '',
        Email: '',
        Password: '',
        ClassID: '',
        PhoneNumber: '',
        DOB: null,
        Gender: '',
        parentName: ''
    });

    // Snackbar
    const [snackbar, setSnackbar] = useState({
        open: false,
        message: '',
        severity: 'success'
    });
    
    // Filter states
    const [classSearchTerm, setClassSearchTerm] = useState('');
    const [studentSearchTerm, setStudentSearchTerm] = useState('');
    const [classIdFilterForStudents, setClassIdFilterForStudents] = useState('');
    const [gradeLevelFilter, setGradeLevelFilter] = useState('');

    // State for Add Multiple Students Dialog
    const [loadingBulkAddStudents, setLoadingBulkAddStudents] = useState(false);
    const [bulkAddSearchTerm, setBulkAddSearchTerm] = useState('');

    const showErrorSnackbar = (message) => {
        setSnackbar({ open: true, message, severity: 'error' });
    };

    const showSuccessSnackbar = (message) => {
        setSnackbar({ open: true, message, severity: 'success' });
    };

    // Fetch Teachers
    const fetchTeachers = useCallback(async () => {
        setLoadingTeachers(true);
        try {
            const data = await getTeachers();
            // API returns: { id, name, specialization }
            setTeachers(data.map(t => ({ ...t }))); 
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách giáo viên!');
        } finally {
            setLoadingTeachers(false);
        }
    }, []);

    // Fetch Classes
    const fetchClasses = useCallback(async () => {
        setLoadingClasses(true);
        try {
            const params = { search: classSearchTerm, limit: 100, skip: 0 }; 
            const data = await getClasses(params);
            setClasses(data.map(c => ({
                id: c.ClassID,
                name: c.ClassName,
                grade: c.GradeLevel,
                academicYear: c.AcademicYear,
                teacherId: c.HomeroomTeacherID,
                teacherName: c.teacherName,
                totalStudents: c.totalStudents
            })));
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách lớp học!');
            setClasses([]); // Clear classes on error
        } finally {
            setLoadingClasses(false);
        }
    }, [classSearchTerm]);

    // Fetch Students
    const fetchStudents = useCallback(async () => {
        setLoadingStudents(true);
        try {
            const params = { 
                search: studentSearchTerm, 
                class_id_filter: classIdFilterForStudents ? Number(classIdFilterForStudents) : null,
                classGrade: gradeLevelFilter || null,
                limit: 100, 
                skip: 0 
            };
            const data = await getStudents(params);
            
            // Apply additional client-side filtering if server doesn't filter correctly
            let filteredData = data;
            if (gradeLevelFilter) {
                filteredData = data.filter(student => student.classGrade === gradeLevelFilter);
            }
            
            setStudents(filteredData.map(s => ({...s}))); 
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách học sinh!');
            setStudents([]); // Clear students on error
        } finally {
            setLoadingStudents(false);
        }
    }, [studentSearchTerm, classIdFilterForStudents, gradeLevelFilter]);

    const fetchStudentsForBulkAdd = useCallback(async () => {
        if (!classIdFilterForStudents) return; // Should not happen if button is correctly disabled
        setLoadingBulkAddStudents(true);
        try {
            // Fetch all students, then filter client-side
            const allStudentsData = await getStudents({ limit: 1000 }); // Adjust limit as needed

            const studentsInCurrentClassSet = new Set(students.filter(s => s.classId === Number(classIdFilterForStudents)).map(s => s.id));
            
            const availableStudents = allStudentsData
                .filter(s => s.id && !studentsInCurrentClassSet.has(s.id)) // Ensure they have an id and are not in current class
                .map(s => ({ // Map to a consistent structure if needed, or use as is
                    id: s.id, 
                    name: s.name || `${s.FirstName || ''} ${s.LastName || ''}`.trim(),
                    email: s.Email
                }));

            setStudentsForBulkAdd(availableStudents);
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách học sinh để thêm vào lớp!');
            setStudentsForBulkAdd([]);
        } finally {
            setLoadingBulkAddStudents(false);
        }
    }, [classIdFilterForStudents, students]);

    useEffect(() => {
        fetchTeachers();
    }, [fetchTeachers]);

    useEffect(() => {
        fetchClasses();
    }, [fetchClasses]);

    useEffect(() => {
        fetchStudents();
    }, [fetchStudents]);

    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    // Class handlers
    const handleOpenClassDialog = (mode, classData = null) => {
        setDialogMode(mode);
        if (mode === 'edit' && classData) {
            // classData from table is like: { id, name, grade, academicYear, teacherId, ... }
            // setCurrentClass expects: { ClassName, GradeLevel, AcademicYear, HomeroomTeacherID }
            setCurrentClass({
                id: classData.id, // Keep id for update operations
                ClassName: classData.name,
                GradeLevel: classData.grade,
                AcademicYear: classData.academicYear,
                HomeroomTeacherID: classData.teacherId ? String(classData.teacherId) : ''
            });
        } else {
            setCurrentClass({ ClassName: '', GradeLevel: '', AcademicYear: '', HomeroomTeacherID: '' });
        }
        setOpenClassDialog(true);
    };

    const handleCloseClassDialog = () => {
        setOpenClassDialog(false);
    };

    const handleClassChange = (e) => {
        const { name, value } = e.target;
        setCurrentClass(prev => ({ ...prev, [name]: value }));
    };

    const handleSaveClass = async () => {
        // Basic validation (can be enhanced with a library like Yup)
        if (!currentClass.ClassName || !currentClass.GradeLevel || !currentClass.AcademicYear) {
            showErrorSnackbar('Vui lòng điền đầy đủ thông tin bắt buộc cho lớp học.');
            return;
        }

        const payload = {
            ClassName: currentClass.ClassName,
            GradeLevel: currentClass.GradeLevel,
            AcademicYear: currentClass.AcademicYear,
            HomeroomTeacherID: currentClass.HomeroomTeacherID ? Number(currentClass.HomeroomTeacherID) : null
        };

        try {
        if (dialogMode === 'add') {
                await createClass(payload);
                showSuccessSnackbar('Thêm lớp học thành công!');
        } else {
                await updateClass(currentClass.id, payload);
                showSuccessSnackbar('Cập nhật lớp học thành công!');
            }
            fetchClasses(); // Refresh class list
            handleCloseClassDialog();
        } catch (error) {
            const errorMsg = error.response?.data?.detail || (dialogMode === 'add' ? 'Lỗi thêm lớp học!' : 'Lỗi cập nhật lớp học!');
            showErrorSnackbar(errorMsg);
        }
    };

    const handleDeleteClass = async (classId) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa lớp học này? Việc này cũng sẽ xóa học sinh liên quan (hoặc bỏ liên kết).')) {
            try {
                await deleteClass(classId);
                showSuccessSnackbar('Đã xóa lớp học!');
                fetchClasses(); // Refresh class list
                fetchStudents(); // Refresh student list as students might be affected
            } catch (error) {
                const errorMsg = error.response?.data?.detail || 'Lỗi xóa lớp học!';
                showErrorSnackbar(errorMsg);
            }
        }
    };

    // Student handlers
    const handleOpenStudentDialog = (mode, studentData = null) => {
        setDialogMode(mode);
        if (mode === 'edit' && studentData) {
            setCurrentStudent({
                id: studentData.id, 
                FirstName: studentData.name ? studentData.name.split(' ')[0] : '',
                LastName: studentData.name ? studentData.name.split(' ').slice(1).join(' ') : '',
                Email: studentData.Email || '',
                Password: '', 
                ClassID: studentData.classId ? String(studentData.classId) : (classIdFilterForStudents || ''),
                PhoneNumber: studentData.PhoneNumber || '',
                DOB: studentData.DOB ? new Date(studentData.DOB).toISOString().split('T')[0] : null, 
                Gender: studentData.Gender || '',
            });
        } else {
            setCurrentStudent({
                FirstName: '', LastName: '', Email: '', Password: '',
                ClassID: classIdFilterForStudents || '',
                PhoneNumber: '', DOB: null, Gender: '',
            });
        }
        setOpenStudentDialog(true);
    };

    const handleCloseStudentDialog = () => {
        setOpenStudentDialog(false);
    };

    const handleStudentChange = (e) => {
        const { name, value, type } = e.target;
        setCurrentStudent(prev => ({
            ...prev,
            [name]: type === 'date' && value === '' ? null : value
        }));
    };

    const handleSaveStudent = async () => {
        const { FirstName, LastName, Email, Password, ClassID, DOB, PhoneNumber, Gender } = currentStudent;

        if (!FirstName || !LastName || !Email) {
            showErrorSnackbar('Vui lòng điền Họ, Tên và Email.');
            return;
        }
        if (dialogMode === 'add' && !Password) {
            showErrorSnackbar('Vui lòng nhập Mật khẩu cho học sinh mới.');
            return;
        }

        const payload = {
            FirstName,
            LastName,
            Email,
            ClassID: ClassID ? Number(ClassID) : null,
            DOB: DOB ? new Date(DOB).toISOString() : null,
            PhoneNumber: PhoneNumber || null,
            Gender: Gender || null,
            role: 'student'
        };
        if (dialogMode === 'add') {
            payload.Password = Password;
        }

        try {
            if (dialogMode === 'add') {
                await createStudent(payload);
                showSuccessSnackbar('Thêm học sinh thành công!');
            } else {
                const updatePayload = { ...payload };
                delete updatePayload.Password;
                delete updatePayload.role;
                await updateStudent(currentStudent.id, updatePayload);
                showSuccessSnackbar('Cập nhật học sinh thành công!');
            }
            fetchStudents();
            fetchClasses();
            handleCloseStudentDialog();
        } catch (error) {
            const errorMsg = error.response?.data?.detail || (dialogMode === 'add' ? 'Lỗi thêm học sinh!' : 'Lỗi cập nhật học sinh!');
            showErrorSnackbar(errorMsg);
        }
    };

    const handleDeleteStudent = async (studentUserId) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa học sinh này?')) {
            try {
                await deleteStudent(studentUserId);
                showSuccessSnackbar('Đã xóa học sinh!');
                fetchStudents();
                fetchClasses();
            } catch (error) {
                const errorMsg = error.response?.data?.detail || 'Lỗi xóa học sinh!';
                showErrorSnackbar(errorMsg);
            }
        }
    };

    const handleCloseSnackbar = () => {
        setSnackbar({ ...snackbar, open: false });
    };

    const handleOpenAddMultipleStudentsDialog = () => {
        if (!classIdFilterForStudents) {
            showErrorSnackbar("Vui lòng chọn một lớp để thêm học sinh.");
            return;
        }
        fetchStudentsForBulkAdd();
        setSelectedStudentsForBulkAdd(new Set()); // Reset selection
        setBulkAddSearchTerm(''); // Reset search
        setOpenAddMultipleStudentsDialog(true);
    };

    const handleCloseAddMultipleStudentsDialog = () => {
        setOpenAddMultipleStudentsDialog(false);
        setStudentsForBulkAdd([]); // Clear the list
    };

    const handleToggleStudentForBulkAdd = (studentId) => {
        setSelectedStudentsForBulkAdd(prevSelected => {
            const newSelected = new Set(prevSelected);
            if (newSelected.has(studentId)) {
                newSelected.delete(studentId);
            } else {
                newSelected.add(studentId);
            }
            return newSelected;
        });
    };
    
    const handleBulkAddStudentsToClass = async () => {
        if (selectedStudentsForBulkAdd.size === 0) {
            showErrorSnackbar("Vui lòng chọn ít nhất một học sinh để thêm.");
            return;
        }
        if (!classIdFilterForStudents) {
            showErrorSnackbar("Lỗi: Không có lớp nào được chọn.");
            return;
        }

        try {
            const studentIdsArray = Array.from(selectedStudentsForBulkAdd);
            const result = await assignMultipleStudentsToClass(Number(classIdFilterForStudents), studentIdsArray);
            
            if (result.errors && result.errors.length > 0) {
                showErrorSnackbar(`Thêm nhiều học sinh thất bại hoặc thành công một phần. Lỗi: ${result.errors.map(e => e.error).join(', ')}`);
            } else {
                showSuccessSnackbar(result.message || 'Thêm học sinh vào lớp thành công!');
            }
            
            fetchStudents(); // Refresh student list for the current class view
            fetchClasses(); // Refresh class list (for sĩ số)
            handleCloseAddMultipleStudentsDialog();
        } catch (error) {
            const errorMsg = error.response?.data?.detail || 'Lỗi khi thêm nhiều học sinh vào lớp!';
            showErrorSnackbar(errorMsg);
        }
    };

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" component="h1" gutterBottom sx={{ mb: 3 }}>
                <SchoolIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                Quản lý Lớp học và Thành viên
            </Typography>

            <Box sx={{ borderBottom: 1, borderColor: 'divider', mb: 3 }}>
                <Tabs value={tabValue} onChange={handleTabChange}>
                    <Tab label="Danh sách Lớp" />
                    <Tab label="Danh sách Học sinh" />
                </Tabs>
            </Box>

            {/* Class List Tab */}
            {tabValue === 0 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
                        <TextField 
                            label="Tìm kiếm lớp (Tên, Khối, Năm học, GVCN)" 
                            variant="outlined" 
                            size="small" 
                            value={classSearchTerm}
                            onChange={(e) => setClassSearchTerm(e.target.value)}
                            sx={{ width: '400px' }}
                        />
                        <Button 
                            variant="contained" 
                            startIcon={<AddIcon />}
                            onClick={() => handleOpenClassDialog('add')}
                        >
                            Thêm Lớp học
                        </Button>
                    </Box>

                    <TableContainer component={Paper}>
                        <Table>
                            <TableHead>
                                <TableRow>
                                    <TableCell>ID</TableCell>
                                    <TableCell>Tên lớp</TableCell>
                                    <TableCell>Khối</TableCell>
                                    <TableCell>Năm học</TableCell>
                                    <TableCell>Giáo viên chủ nhiệm</TableCell>
                                    <TableCell>Sĩ số</TableCell>
                                    <TableCell>Thao tác</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {loadingClasses ? (
                                    <TableRow><TableCell colSpan={7} align="center">Đang tải...</TableCell></TableRow>
                                ) : classes.length > 0 ? (
                                    classes.map((classItem) => (
                                        <TableRow key={classItem.id}>
                                            <TableCell>{classItem.id}</TableCell>
                                            <TableCell>{classItem.name}</TableCell>
                                            <TableCell>{classItem.grade}</TableCell>
                                            <TableCell>{classItem.academicYear}</TableCell>
                                            <TableCell>{classItem.teacherName}</TableCell>
                                            <TableCell>{classItem.totalStudents}</TableCell>
                                            <TableCell>
                                                <IconButton 
                                                    color="primary"
                                                    onClick={() => {
                                                        setClassIdFilterForStudents(String(classItem.id));
                                                        setTabValue(1);
                                                    }}
                                                    title="Xem học sinh trong lớp"
                                                >
                                                    <PersonAddIcon />
                                                </IconButton>
                                                <IconButton 
                                                    color="secondary"
                                                    onClick={() => handleOpenClassDialog('edit', classItem)}
                                                >
                                                    <EditIcon />
                                                </IconButton>
                                                <IconButton 
                                                    color="error"
                                                    onClick={() => handleDeleteClass(classItem.id)}
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            </TableCell>
                                        </TableRow>
                                    ))
                                ) : (
                                    <TableRow>
                                        <TableCell colSpan={7} align="center">
                                            Không tìm thấy dữ liệu lớp học
                                        </TableCell>
                                    </TableRow>
                                )}
                            </TableBody>
                        </Table>
                    </TableContainer>
                </Box>
            )}

            {/* Student List Tab */}
            {tabValue === 1 && (
                <Box>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
                        <Box sx={{ display: 'flex', gap: 2 }}>
                            <TextField 
                                label="Tìm kiếm học sinh (Tên, Lớp)" 
                                variant="outlined" 
                                size="small" 
                                value={studentSearchTerm}
                                onChange={(e) => setStudentSearchTerm(e.target.value)}
                                sx={{ width: '300px' }}
                            />
                            <FormControl sx={{ width: '200px' }} size="small">
                                <InputLabel>Lọc theo lớp</InputLabel>
                                <Select
                                    value={classIdFilterForStudents}
                                    label="Lọc theo lớp"
                                    onChange={(e) => setClassIdFilterForStudents(e.target.value)}
                                >
                                    <MenuItem value="">Tất cả lớp</MenuItem>
                                    {classes.map((c) => (
                                        <MenuItem key={c.id} value={String(c.id)}>
                                            {c.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                            <FormControl sx={{ width: '150px' }} size="small">
                                <InputLabel>Lọc theo khối</InputLabel>
                                <Select
                                    value={gradeLevelFilter}
                                    label="Lọc theo khối"
                                    onChange={(e) => setGradeLevelFilter(e.target.value)}
                                >
                                    <MenuItem value="">Tất cả khối</MenuItem>
                                    {Array.from(new Set(classes.map(c => c.grade))).sort().map((grade) => (
                                        <MenuItem key={grade} value={grade}>
                                            Khối {grade}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Box>
                        <Box sx={{ display: 'flex', gap: 1}}>
                            <Button 
                                variant="contained" 
                                startIcon={<AddIcon />}
                                onClick={() => handleOpenStudentDialog('add')}
                            >
                                Thêm Học sinh
                            </Button>
                            <Button
                                variant="outlined"
                                startIcon={<PersonAddIcon />}
                                onClick={handleOpenAddMultipleStudentsDialog}
                                disabled={!classIdFilterForStudents}
                            >
                                Thêm nhiều Học sinh vào lớp
                            </Button>
                        </Box>
                    </Box>

                    {classIdFilterForStudents && classes.find(c => c.id === Number(classIdFilterForStudents)) && (
                        <Box sx={{ mb: 2, display: 'flex', gap: 1 }}>
                            <Chip 
                                label={`Đang lọc học sinh theo lớp: ${classes.find(c => c.id === Number(classIdFilterForStudents))?.name || ''}`} 
                                onDelete={() => setClassIdFilterForStudents('')}
                                color="primary"
                            />
                            {gradeLevelFilter && (
                                <Chip 
                                    label={`Đang lọc theo khối: ${gradeLevelFilter}`} 
                                    onDelete={() => setGradeLevelFilter('')}
                                    color="secondary"
                                />
                            )}
                        </Box>
                    )}
                    
                    {!classIdFilterForStudents && gradeLevelFilter && (
                        <Box sx={{ mb: 2 }}>
                            <Chip 
                                label={`Đang lọc học sinh theo khối: ${gradeLevelFilter}`} 
                                onDelete={() => setGradeLevelFilter('')}
                                color="secondary"
                            />
                        </Box>
                    )}

                    <TableContainer component={Paper}>
                        <Table>
                            <TableHead>
                                <TableRow>
                                    <TableCell>ID (UserID)</TableCell>
                                    <TableCell>Họ và tên</TableCell>
                                    <TableCell>Lớp</TableCell>
                                    <TableCell>Khối</TableCell>
                                    <TableCell>Email</TableCell>
                                    <TableCell>SĐT</TableCell>
                                    <TableCell>Thao tác</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {loadingStudents ? (
                                    <TableRow><TableCell colSpan={7} align="center">Đang tải...</TableCell></TableRow>
                                ) : students.length > 0 ? (
                                    students.map((student) => (
                                        <TableRow key={student.id}>
                                            <TableCell>{student.id}</TableCell>
                                            <TableCell>{student.name}</TableCell>
                                            <TableCell>{student.className}</TableCell>
                                            <TableCell>{student.classGrade}</TableCell>
                                            <TableCell>{student.Email}</TableCell>
                                            <TableCell>{student.PhoneNumber}</TableCell>
                                            <TableCell>
                                                <IconButton 
                                                    color="secondary"
                                                    onClick={() => handleOpenStudentDialog('edit', student)}
                                                >
                                                    <EditIcon />
                                                </IconButton>
                                                <IconButton 
                                                    color="error"
                                                    onClick={() => handleDeleteStudent(student.id)}
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            </TableCell>
                                        </TableRow>
                                    ))
                                ) : (
                                    <TableRow>
                                        <TableCell colSpan={6} align="center">
                                            Không tìm thấy dữ liệu học sinh
                                        </TableCell>
                                    </TableRow>
                                )}
                            </TableBody>
                        </Table>
                    </TableContainer>
                </Box>
            )}

            {/* Class Dialog */}
            <Dialog open={openClassDialog} onClose={handleCloseClassDialog} maxWidth="sm" fullWidth>
                <DialogTitle>
                    {dialogMode === 'add' ? 'Thêm lớp học mới' : 'Chỉnh sửa lớp học'}
                </DialogTitle>
                <DialogContent>
                    <Grid container spacing={2} sx={{ mt: 1 }}>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Tên lớp"
                                name="ClassName"
                                value={currentClass.ClassName}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Khối"
                                name="GradeLevel"
                                value={currentClass.GradeLevel}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Năm học"
                                name="AcademicYear"
                                value={currentClass.AcademicYear}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <FormControl fullWidth required>
                                <InputLabel>Giáo viên chủ nhiệm</InputLabel>
                                <Select
                                    name="HomeroomTeacherID"
                                    value={currentClass.HomeroomTeacherID}
                                    label="Giáo viên chủ nhiệm"
                                    onChange={handleClassChange}
                                >
                                    <MenuItem value=""><em>Không chọn</em></MenuItem>
                                    {teachers.map((teacher) => (
                                        <MenuItem key={teacher.id} value={teacher.id}>
                                            {teacher.name} {teacher.specialization ? `(${teacher.specialization})` : ''}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Grid>
                    </Grid>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseClassDialog}>Hủy</Button>
                    <Button onClick={handleSaveClass} variant="contained" color="primary">
                        {dialogMode === 'add' ? 'Thêm' : 'Lưu'}
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Student Dialog */}
            <Dialog open={openStudentDialog} onClose={handleCloseStudentDialog} maxWidth="sm" fullWidth>
                <DialogTitle>
                    {dialogMode === 'add' ? 'Thêm học sinh mới' : 'Chỉnh sửa thông tin học sinh'}
                </DialogTitle>
                <DialogContent>
                    <Grid container spacing={2} sx={{ mt: 1 }}>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Họ" name="FirstName" value={currentStudent.FirstName} onChange={handleStudentChange} required />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Tên" name="LastName" value={currentStudent.LastName} onChange={handleStudentChange} required />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField fullWidth label="Email" name="Email" value={currentStudent.Email} onChange={handleStudentChange} required type="email"/>
                        </Grid>
                        {dialogMode === 'add' && (
                            <Grid item xs={12}>
                                <TextField fullWidth label="Mật khẩu" name="Password" value={currentStudent.Password} onChange={handleStudentChange} required type="password"/>
                            </Grid>
                        )}
                        <Grid item xs={6}>
                            <FormControl fullWidth>
                                <InputLabel>Lớp</InputLabel>
                                <Select name="ClassID" value={currentStudent.ClassID} label="Lớp" onChange={handleStudentChange}>
                                    <MenuItem value=""><em>Không chọn / Thôi học</em></MenuItem>
                                    {classes.map((classItem) => (
                                        <MenuItem key={classItem.id} value={classItem.id}>
                                            {classItem.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs={6}>
                            <TextField fullWidth label="Số điện thoại" name="PhoneNumber" value={currentStudent.PhoneNumber || ''} onChange={handleStudentChange} />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Ngày sinh"
                                name="DOB" 
                                type="date"
                                value={currentStudent.DOB || ''}
                                onChange={handleStudentChange}
                                InputLabelProps={{ shrink: true }}
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <FormControl fullWidth>
                                <InputLabel>Giới tính</InputLabel>
                                <Select name="Gender" value={currentStudent.Gender} label="Giới tính" onChange={handleStudentChange}>
                                    <MenuItem value=""><em>Không chọn</em></MenuItem>
                                    <MenuItem value="MALE">Nam</MenuItem>
                                    <MenuItem value="FEMALE">Nữ</MenuItem>
                                    <MenuItem value="OTHER">Khác</MenuItem>
                                </Select>
                            </FormControl>
                        </Grid>
                    </Grid>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseStudentDialog}>Hủy</Button>
                    <Button onClick={handleSaveStudent} variant="contained" color="primary">
                        {dialogMode === 'add' ? 'Thêm' : 'Lưu'}
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Snackbar */}
            <Snackbar
                open={snackbar.open}
                autoHideDuration={6000}
                onClose={handleCloseSnackbar}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert onClose={handleCloseSnackbar} severity={snackbar.severity} variant="filled">
                    {snackbar.message}
                </Alert>
            </Snackbar>

            {/* Add Multiple Students Dialog */}
            <Dialog open={openAddMultipleStudentsDialog} onClose={handleCloseAddMultipleStudentsDialog} maxWidth="md" fullWidth>
                <DialogTitle>Thêm nhiều Học sinh vào lớp: {classes.find(c => c.id === Number(classIdFilterForStudents))?.name || ''}</DialogTitle>
                <DialogContent>
                    <TextField
                        fullWidth
                        label="Tìm kiếm học sinh (Tên, Email)"
                        variant="outlined"
                        size="small"
                        value={bulkAddSearchTerm}
                        onChange={(e) => setBulkAddSearchTerm(e.target.value)}
                        sx={{ mb: 2, mt: 1 }}
                    />
                    {loadingBulkAddStudents ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', my: 3 }}><CircularProgress /></Box>
                    ) : studentsForBulkAdd.length === 0 ? (
                        <Typography sx={{ textAlign: 'center', my: 3 }}>Không có học sinh nào phù hợp hoặc tất cả đã ở trong lớp này.</Typography>
                    ) : (
                        <TableContainer component={Paper} sx={{ maxHeight: 400 }}>
                            <Table stickyHeader>
                                <TableHead>
                                    <TableRow>
                                        <TableCell padding="checkbox">
                                            {/* Optional: Select/Deselect All Checkbox */}
                                        </TableCell>
                                        <TableCell>ID</TableCell>
                                        <TableCell>Họ và Tên</TableCell>
                                        <TableCell>Email</TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {studentsForBulkAdd
                                        .filter(student => 
                                            student.name.toLowerCase().includes(bulkAddSearchTerm.toLowerCase()) ||
                                            (student.email && student.email.toLowerCase().includes(bulkAddSearchTerm.toLowerCase()))
                                        )
                                        .map((student) => (
                                        <TableRow 
                                            key={student.id} 
                                            hover 
                                            onClick={() => handleToggleStudentForBulkAdd(student.id)}
                                            role="checkbox"
                                            aria-checked={selectedStudentsForBulkAdd.has(student.id)}
                                            selected={selectedStudentsForBulkAdd.has(student.id)}
                                        >
                                            <TableCell padding="checkbox">
                                                <Checkbox
                                                    color="primary"
                                                    checked={selectedStudentsForBulkAdd.has(student.id)}
                                                />
                                            </TableCell>
                                            <TableCell>{student.id}</TableCell>
                                            <TableCell>{student.name}</TableCell>
                                            <TableCell>{student.email || 'N/A'}</TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        </TableContainer>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseAddMultipleStudentsDialog}>Hủy</Button>
                    <Button 
                        onClick={handleBulkAddStudentsToClass} 
                        variant="contained" 
                        color="primary"
                        disabled={selectedStudentsForBulkAdd.size === 0 || loadingBulkAddStudents}
                    >
                        Thêm {selectedStudentsForBulkAdd.size > 0 ? `(${selectedStudentsForBulkAdd.size})` : ''} Học sinh vào lớp
                    </Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};

export default ClassManagementPage; 