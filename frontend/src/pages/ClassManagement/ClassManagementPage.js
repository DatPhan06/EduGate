import React, { useState, useEffect } from 'react';
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
    Snackbar
} from '@mui/material';
import { 
    Add as AddIcon, 
    Edit as EditIcon, 
    Delete as DeleteIcon,
    PersonAdd as PersonAddIcon,
    School as SchoolIcon
} from '@mui/icons-material';

const ClassManagementPage = () => {
    const [tabValue, setTabValue] = useState(0);
    const [classes, setClasses] = useState([
        { id: 1, name: 'Lớp 10A1', grade: '10', academicYear: '2023-2024', teacherId: 1, teacherName: 'Nguyễn Văn A', totalStudents: 30 },
        { id: 2, name: 'Lớp 10A2', grade: '10', academicYear: '2023-2024', teacherId: 2, teacherName: 'Trần Thị B', totalStudents: 32 },
        { id: 3, name: 'Lớp 11A1', grade: '11', academicYear: '2023-2024', teacherId: 3, teacherName: 'Lê Văn C', totalStudents: 28 },
    ]);
    
    const [students, setStudents] = useState([
        { id: 1, name: 'Học sinh 1', classId: 1, className: 'Lớp 10A1', studentId: 'HS001', parentName: 'Phụ huynh 1' },
        { id: 2, name: 'Học sinh 2', classId: 1, className: 'Lớp 10A1', studentId: 'HS002', parentName: 'Phụ huynh 2' },
        { id: 3, name: 'Học sinh 3', classId: 2, className: 'Lớp 10A2', studentId: 'HS003', parentName: 'Phụ huynh 3' },
    ]);

    const [teachers, setTeachers] = useState([
        { id: 1, name: 'Nguyễn Văn A', specialization: 'Toán học' },
        { id: 2, name: 'Trần Thị B', specialization: 'Vật lý' },
        { id: 3, name: 'Lê Văn C', specialization: 'Hóa học' },
    ]);

    // Dialog states
    const [openClassDialog, setOpenClassDialog] = useState(false);
    const [openStudentDialog, setOpenStudentDialog] = useState(false);
    const [dialogMode, setDialogMode] = useState('add'); // 'add' or 'edit'
    
    // Form states
    const [currentClass, setCurrentClass] = useState({ 
        name: '', 
        grade: '', 
        academicYear: '', 
        teacherId: '' 
    });
    
    const [currentStudent, setCurrentStudent] = useState({
        name: '',
        classId: '',
        studentId: '',
        parentName: ''
    });

    // Snackbar
    const [snackbar, setSnackbar] = useState({
        open: false,
        message: '',
        severity: 'success'
    });
    
    // Filter states
    const [classFilter, setClassFilter] = useState('');
    const [studentFilter, setStudentFilter] = useState('');
    const [classIdFilter, setClassIdFilter] = useState('');

    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    // Class handlers
    const handleOpenClassDialog = (mode, classData = null) => {
        setDialogMode(mode);
        if (mode === 'edit' && classData) {
            setCurrentClass(classData);
        } else {
            setCurrentClass({ name: '', grade: '', academicYear: '', teacherId: '' });
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

    const handleSaveClass = () => {
        if (dialogMode === 'add') {
            const newClass = {
                id: classes.length + 1,
                ...currentClass,
                teacherName: teachers.find(t => t.id === Number(currentClass.teacherId))?.name || '',
                totalStudents: 0
            };
            setClasses([...classes, newClass]);
            setSnackbar({
                open: true,
                message: 'Thêm lớp học thành công!',
                severity: 'success'
            });
        } else {
            const updatedClasses = classes.map(c => 
                c.id === currentClass.id 
                    ? {
                        ...currentClass,
                        teacherName: teachers.find(t => t.id === Number(currentClass.teacherId))?.name || ''
                      } 
                    : c
            );
            setClasses(updatedClasses);
            setSnackbar({
                open: true,
                message: 'Cập nhật lớp học thành công!',
                severity: 'success'
            });
        }
        setOpenClassDialog(false);
    };

    const handleDeleteClass = (id) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa lớp học này?')) {
            setClasses(classes.filter(c => c.id !== id));
            // Also remove students from this class
            setStudents(students.filter(s => s.classId !== id));
            setSnackbar({
                open: true,
                message: 'Đã xóa lớp học!',
                severity: 'success'
            });
        }
    };

    // Student handlers
    const handleOpenStudentDialog = (mode, studentData = null) => {
        setDialogMode(mode);
        if (mode === 'edit' && studentData) {
            setCurrentStudent(studentData);
        } else {
            setCurrentStudent({ name: '', classId: classIdFilter || '', studentId: '', parentName: '' });
        }
        setOpenStudentDialog(true);
    };

    const handleCloseStudentDialog = () => {
        setOpenStudentDialog(false);
    };

    const handleStudentChange = (e) => {
        const { name, value } = e.target;
        setCurrentStudent(prev => ({ ...prev, [name]: value }));
    };

    const handleSaveStudent = () => {
        const selectedClass = classes.find(c => c.id === Number(currentStudent.classId));
        
        if (dialogMode === 'add') {
            const newStudent = {
                id: students.length + 1,
                ...currentStudent,
                classId: Number(currentStudent.classId),
                className: selectedClass?.name || ''
            };
            setStudents([...students, newStudent]);
            
            // Update class total students
            const updatedClasses = classes.map(c => 
                c.id === Number(currentStudent.classId) 
                    ? { ...c, totalStudents: c.totalStudents + 1 } 
                    : c
            );
            setClasses(updatedClasses);
            
            setSnackbar({
                open: true,
                message: 'Thêm học sinh thành công!',
                severity: 'success'
            });
        } else {
            // Check if class has changed
            const oldStudent = students.find(s => s.id === currentStudent.id);
            const classChanged = oldStudent.classId !== Number(currentStudent.classId);
            
            const updatedStudents = students.map(s => 
                s.id === currentStudent.id 
                    ? {
                        ...currentStudent,
                        classId: Number(currentStudent.classId),
                        className: selectedClass?.name || ''
                      } 
                    : s
            );
            setStudents(updatedStudents);
            
            // Update classes if student moved between classes
            if (classChanged) {
                const updatedClasses = classes.map(c => {
                    if (c.id === oldStudent.classId) {
                        return { ...c, totalStudents: c.totalStudents - 1 };
                    } else if (c.id === Number(currentStudent.classId)) {
                        return { ...c, totalStudents: c.totalStudents + 1 };
                    }
                    return c;
                });
                setClasses(updatedClasses);
            }
            
            setSnackbar({
                open: true,
                message: 'Cập nhật học sinh thành công!',
                severity: 'success'
            });
        }
        setOpenStudentDialog(false);
    };

    const handleDeleteStudent = (id) => {
        if (window.confirm('Bạn có chắc chắn muốn xóa học sinh này?')) {
            const studentToDelete = students.find(s => s.id === id);
            setStudents(students.filter(s => s.id !== id));
            
            // Update class total students
            const updatedClasses = classes.map(c => 
                c.id === studentToDelete.classId 
                    ? { ...c, totalStudents: c.totalStudents - 1 } 
                    : c
            );
            setClasses(updatedClasses);
            
            setSnackbar({
                open: true,
                message: 'Đã xóa học sinh!',
                severity: 'success'
            });
        }
    };

    const handleCloseSnackbar = () => {
        setSnackbar({ ...snackbar, open: false });
    };

    // Filter handlers
    const filteredClasses = classes.filter(c => 
        c.name.toLowerCase().includes(classFilter.toLowerCase()) ||
        c.grade.includes(classFilter) ||
        c.academicYear.includes(classFilter) ||
        c.teacherName.toLowerCase().includes(classFilter.toLowerCase())
    );

    const filteredStudents = students.filter(s => {
        const matchesFilter = 
            s.name.toLowerCase().includes(studentFilter.toLowerCase()) ||
            s.studentId.toLowerCase().includes(studentFilter.toLowerCase()) ||
            s.className.toLowerCase().includes(studentFilter.toLowerCase()) ||
            s.parentName.toLowerCase().includes(studentFilter.toLowerCase());
            
        const matchesClass = classIdFilter ? s.classId === Number(classIdFilter) : true;
        
        return matchesFilter && matchesClass;
    });

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
                            label="Tìm kiếm lớp" 
                            variant="outlined" 
                            size="small" 
                            value={classFilter}
                            onChange={(e) => setClassFilter(e.target.value)}
                            sx={{ width: '300px' }}
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
                                {filteredClasses.length > 0 ? (
                                    filteredClasses.map((classItem) => (
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
                                                        setClassIdFilter(classItem.id.toString());
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
                                label="Tìm kiếm học sinh" 
                                variant="outlined" 
                                size="small" 
                                value={studentFilter}
                                onChange={(e) => setStudentFilter(e.target.value)}
                                sx={{ width: '300px' }}
                            />
                            <FormControl sx={{ width: '200px' }} size="small">
                                <InputLabel>Lọc theo lớp</InputLabel>
                                <Select
                                    value={classIdFilter}
                                    label="Lọc theo lớp"
                                    onChange={(e) => setClassIdFilter(e.target.value)}
                                >
                                    <MenuItem value="">Tất cả lớp</MenuItem>
                                    {classes.map((c) => (
                                        <MenuItem key={c.id} value={c.id.toString()}>
                                            {c.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Box>
                        <Button 
                            variant="contained" 
                            startIcon={<AddIcon />}
                            onClick={() => handleOpenStudentDialog('add')}
                        >
                            Thêm Học sinh
                        </Button>
                    </Box>

                    {classIdFilter && (
                        <Box sx={{ mb: 2 }}>
                            <Chip 
                                label={`Lớp: ${classes.find(c => c.id === Number(classIdFilter))?.name || ''}`} 
                                onDelete={() => setClassIdFilter('')}
                                color="primary"
                            />
                        </Box>
                    )}

                    <TableContainer component={Paper}>
                        <Table>
                            <TableHead>
                                <TableRow>
                                    <TableCell>ID</TableCell>
                                    <TableCell>Mã học sinh</TableCell>
                                    <TableCell>Họ và tên</TableCell>
                                    <TableCell>Lớp</TableCell>
                                    <TableCell>Phụ huynh</TableCell>
                                    <TableCell>Thao tác</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {filteredStudents.length > 0 ? (
                                    filteredStudents.map((student) => (
                                        <TableRow key={student.id}>
                                            <TableCell>{student.id}</TableCell>
                                            <TableCell>{student.studentId}</TableCell>
                                            <TableCell>{student.name}</TableCell>
                                            <TableCell>{student.className}</TableCell>
                                            <TableCell>{student.parentName}</TableCell>
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
                                name="name"
                                value={currentClass.name}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Khối"
                                name="grade"
                                value={currentClass.grade}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Năm học"
                                name="academicYear"
                                value={currentClass.academicYear}
                                onChange={handleClassChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <FormControl fullWidth>
                                <InputLabel>Giáo viên chủ nhiệm</InputLabel>
                                <Select
                                    name="teacherId"
                                    value={currentClass.teacherId}
                                    label="Giáo viên chủ nhiệm"
                                    onChange={handleClassChange}
                                >
                                    {teachers.map((teacher) => (
                                        <MenuItem key={teacher.id} value={teacher.id.toString()}>
                                            {teacher.name} - {teacher.specialization}
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
                    {dialogMode === 'add' ? 'Thêm học sinh mới' : 'Chỉnh sửa học sinh'}
                </DialogTitle>
                <DialogContent>
                    <Grid container spacing={2} sx={{ mt: 1 }}>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Họ và tên"
                                name="name"
                                value={currentStudent.name}
                                onChange={handleStudentChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Mã học sinh"
                                name="studentId"
                                value={currentStudent.studentId}
                                onChange={handleStudentChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <FormControl fullWidth>
                                <InputLabel>Lớp</InputLabel>
                                <Select
                                    name="classId"
                                    value={currentStudent.classId}
                                    label="Lớp"
                                    onChange={handleStudentChange}
                                >
                                    {classes.map((classItem) => (
                                        <MenuItem key={classItem.id} value={classItem.id.toString()}>
                                            {classItem.name}
                                        </MenuItem>
                                    ))}
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Phụ huynh"
                                name="parentName"
                                value={currentStudent.parentName}
                                onChange={handleStudentChange}
                            />
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
        </Box>
    );
};

export default ClassManagementPage; 