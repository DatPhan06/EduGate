import React, { useState, useEffect, useCallback } from 'react';
import {
    Box,
    Typography,
    Paper,
    List,
    ListItem,
    ListItemButton,
    ListItemText,
    CircularProgress,
    Snackbar,
    Alert,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    TextField,
    IconButton,
    Button,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    Accordion,
    AccordionSummary, 
    AccordionDetails,
    Divider,
    Chip,
    Grid
} from '@mui/material';
import {
    Grading as GradingIcon,
    Search as SearchIcon,
    ReadMore as ReadMoreIcon,
    ExpandMore as ExpandMoreIcon,
    Grade as GradeIcon
} from '@mui/icons-material';
import gradeService from '../../services/gradeService';

const GradeManagementPage = () => {
    // Main data states
    const [students, setStudents] = useState([]);
    const [uniqueClasses, setUniqueClasses] = useState([]); // For class filter dropdown
    const [uniqueGrades, setUniqueGrades] = useState([]); // For grade filter dropdown
    
    // Loading states
    const [loadingStudents, setLoadingStudents] = useState(false);
    const [loadingStudentGrades, setLoadingStudentGrades] = useState(false);

    // Search and Filter state
    const [searchTerm, setSearchTerm] = useState('');
    const [classFilter, setClassFilter] = useState('');
    const [gradeFilter, setGradeFilter] = useState(''); // Filter by class grade (e.g., "12", "11", etc.)
    
    // Grade details dialog state
    const [gradeDetailsOpen, setGradeDetailsOpen] = useState(false);
    const [selectedStudent, setSelectedStudent] = useState(null);
    const [studentGrades, setStudentGrades] = useState([]);
    const [expandedSubject, setExpandedSubject] = useState(false);
    
    // Snackbar state
    const [snackbar, setSnackbar] = useState({
        open: false,
        message: '',
        severity: 'success'
    });

    const showSnackbar = (message, severity = 'success') => {
        setSnackbar({
            open: true,
            message,
            severity
        });
    };

    const handleCloseSnackbar = () => {
        setSnackbar(prev => ({
            ...prev,
            open: false
        }));
    };
    
    // ===== Fetch Data Functions =====
    
    const fetchStudents = useCallback(async () => {
        setLoadingStudents(true);
        try {
            const data = await gradeService.getStudentsForGrading();
            setStudents(data || []);
            
            // Extract unique classes and grades from student data
            if (data && data.length > 0) {
                // Extract unique classes
                const classMap = new Map();
                data.forEach(student => {
                    if (student.classId && student.className) {
                        classMap.set(student.classId, {
                            id: student.classId,
                            name: student.className,
                            grade: student.classGrade
                        });
                    }
                });
                setUniqueClasses(Array.from(classMap.values()));
                
                // Extract unique grades
                const gradeSet = new Set();
                data.forEach(student => {
                    if (student.classGrade) {
                        gradeSet.add(student.classGrade);
                    }
                });
                setUniqueGrades(Array.from(gradeSet).sort());
                
                // Debug first student
                if (data.length > 0) {
                    console.log("First student data:", data[0]);
                }
            }
        } catch (error) {
            showSnackbar('Không thể tải danh sách học sinh', 'error');
            setStudents([]);
            setUniqueClasses([]);
            setUniqueGrades([]);
        } finally {
            setLoadingStudents(false);
        }
    }, []);

    const fetchStudentGrades = async (studentId) => {
        if (!studentId) return;
        
        setLoadingStudentGrades(true);
        try {
            const data = await gradeService.getStudentGrades(studentId);
            setStudentGrades(data || []);
        } catch (error) {
            showSnackbar(`Không thể tải điểm cho học sinh (ID: ${studentId})`, 'error');
            setStudentGrades([]);
        } finally {
            setLoadingStudentGrades(false);
        }
    };
    
    // ===== Effect Hooks =====
    
    useEffect(() => {
        fetchStudents();
    }, [fetchStudents]);
    
    // ===== Event Handlers =====
    const handleSearchChange = (event) => {
        setSearchTerm(event.target.value.toLowerCase());
    };

    const handleClassFilterChange = (event) => {
        const value = event.target.value;
        console.log("Setting class filter to:", value);
        setClassFilter(value);
    };

    const handleGradeFilterChange = (event) => {
        const value = event.target.value;
        console.log("Setting grade filter to:", value);
        setGradeFilter(value);
    };

    const handleOpenGradeDetails = async (student) => {
        setSelectedStudent(student);
        setGradeDetailsOpen(true);
        await fetchStudentGrades(student.studentId);
    };

    const handleCloseGradeDetails = () => {
        setGradeDetailsOpen(false);
        setSelectedStudent(null);
        setStudentGrades([]);
        setExpandedSubject(false);
    };
    
    const handleAccordionChange = (subjectId) => (event, isExpanded) => {
        setExpandedSubject(isExpanded ? subjectId : false);
    };

    // Client-side filtering
    const filteredStudents = students.filter(student => {
        // Debug values for first student
        if (student.studentId === 1) {
            console.log("Filter values:", {
                classFilter, 
                gradeFilter, 
                studentClassId: student.classId,
                studentClassGrade: student.classGrade
            });
        }
        
        const studentId = student.studentId ? String(student.studentId) : '';
        const name = student.name ? student.name.toLowerCase() : '';
        const className = student.className ? student.className.toLowerCase() : '';
        const classGrade = student.classGrade ? student.classGrade.toLowerCase() : '';
        const email = student.Email ? student.Email.toLowerCase() : '';
        
        // Class filter logic - using toString() to compare numbers and strings
        const classMatch = !classFilter || 
                           (student.classId && student.classId.toString() === classFilter);
        
        // Grade filter logic - direct string comparison
        const gradeMatch = !gradeFilter || student.classGrade === gradeFilter;

        // Search term logic
        const searchMatch = !searchTerm || 
                            name.includes(searchTerm) ||
                            studentId.includes(searchTerm) ||
                            className.includes(searchTerm) ||
                            classGrade.includes(searchTerm) ||
                            email.includes(searchTerm);
        
        return classMatch && gradeMatch && searchMatch;
    });

    // ===== Render Methods =====
    
    const renderStudentTable = () => {
        if (loadingStudents) {
            return (
                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '200px', mt: 2 }}>
                    <CircularProgress />
                </Box>
            );
        }
        
        return (
            <Paper sx={{ mt: 2, p: 2 }}>
                <Box sx={{ mb: 2, display: 'flex', alignItems: 'center', gap: 2 }}>
                    <TextField
                        sx={{ flexGrow: 1 }}
                        variant="outlined"
                        label="Tìm kiếm học sinh (Tên, ID, Lớp, Khối, Email)"
                        onChange={handleSearchChange}
                        InputProps={{
                            startAdornment: (
                                <SearchIcon sx={{ mr: 1, color: 'action.active' }} />
                            ),
                        }}
                    />
                    <FormControl sx={{ minWidth: 150 }} size="small">
                        <InputLabel>Lọc theo lớp</InputLabel>
                        <Select
                            value={classFilter}
                            label="Lọc theo lớp"
                            onChange={handleClassFilterChange}
                            disabled={loadingStudents}
                        >
                            <MenuItem value="">
                                <em>Tất cả các lớp</em>
                            </MenuItem>
                            {uniqueClasses.map((cls) => (
                                <MenuItem key={cls.id} value={cls.id.toString()}>
                                    {cls.name} {cls.grade ? `(Khối ${cls.grade})` : ''}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                    <FormControl sx={{ minWidth: 150 }} size="small">
                        <InputLabel>Lọc theo khối</InputLabel>
                        <Select
                            value={gradeFilter}
                            label="Lọc theo khối"
                            onChange={handleGradeFilterChange}
                            disabled={loadingStudents}
                        >
                            <MenuItem value="">
                                <em>Tất cả các khối</em>
                            </MenuItem>
                            {uniqueGrades.map((grade) => (
                                <MenuItem key={grade} value={grade}>
                                    Khối {grade}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Box>

                {filteredStudents.length === 0 && !loadingStudents && (
                     <Typography sx={{ textAlign: 'center', p: 2 }}>Không tìm thấy học sinh nào.</Typography>
                )}

                {filteredStudents.length > 0 && (
                    <TableContainer>
                        <Table stickyHeader>
                            <TableHead>
                                <TableRow>
                                    <TableCell>ID</TableCell>
                                    <TableCell>Họ và Tên</TableCell>
                                    <TableCell>Lớp</TableCell>
                                    <TableCell>Khối</TableCell>
                                    <TableCell>Email</TableCell>
                                    <TableCell align="center">Hành động</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {filteredStudents.map((student) => (
                                    <TableRow hover key={student.studentId}>
                                        <TableCell>{student.studentId}</TableCell>
                                        <TableCell>{student.name}</TableCell>
                                        <TableCell>{student.className || 'N/A'}</TableCell>
                                        <TableCell>{student.classGrade || 'N/A'}</TableCell>
                                        <TableCell>{student.Email || 'N/A'}</TableCell>
                                        <TableCell align="center">
                                        
                                            <Button 
                                                variant="outlined"
                                                size="small"
                                                startIcon={<GradeIcon />}
                                                onClick={() => handleOpenGradeDetails(student)}
                                            >
                                                Xem Điểm
                                            </Button>
                                        </TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </TableContainer>
                )}
            </Paper>
        );
    };
    
    const renderGradeDetailsDialog = () => {
        // Group grades by subject and semester
        const gradesBySubject = {};
        studentGrades.forEach(grade => {
            const subjectKey = grade.ClassSubjectID;
            const subjectName = grade.class_subject?.subject?.SubjectName || 'Chưa có tên môn học';
            const className = grade.class_subject?.class?.ClassName || 'N/A';
            const semester = grade.Semester || 'Không xác định';
            
            if (!gradesBySubject[subjectKey]) {
                gradesBySubject[subjectKey] = {
                    subjectName: `${subjectName} - ${className}`,
                    semesters: {}
                };
            }
            
            if (!gradesBySubject[subjectKey].semesters[semester]) {
                gradesBySubject[subjectKey].semesters[semester] = [];
            }
            
            gradesBySubject[subjectKey].semesters[semester].push(grade);
        });
        
        return (
            <Dialog 
                open={gradeDetailsOpen} 
                onClose={handleCloseGradeDetails}
                maxWidth="md"
                fullWidth
            >
                <DialogTitle>
                    {selectedStudent ? (
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                            <GradeIcon sx={{ mr: 1, color: 'primary.main' }} />
                            <Typography variant="h6">
                                Bảng điểm của học sinh: {selectedStudent.name}
                            </Typography>
                        </Box>
                    ) : 'Bảng điểm'}
                </DialogTitle>
                
                <DialogContent dividers>
                    {loadingStudentGrades ? (
                        <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}>
                            <CircularProgress />
                        </Box>
                    ) : studentGrades.length === 0 ? (
                        <Typography align="center" sx={{ p: 2 }}>
                            Học sinh này chưa có điểm nào được ghi nhận.
                        </Typography>
                    ) : (
                        <Box>
                            {/* Basic student info */}
                            <Box sx={{ mb: 3, p: 2, bgcolor: 'background.paper', borderRadius: 1 }}>
                                <Grid container spacing={2}>
                                    <Grid item xs={12} sm={6}>
                                        <Typography variant="body1">
                                            <strong>Họ và tên:</strong> {selectedStudent?.name || 'N/A'}
                                        </Typography>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Typography variant="body1">
                                            <strong>Lớp:</strong> {selectedStudent?.className || 'Chưa có lớp'}
                                        </Typography>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Typography variant="body1">
                                            <strong>Khối:</strong> {selectedStudent?.classGrade || 'N/A'}
                                        </Typography>
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <Typography variant="body1">
                                            <strong>Mã học sinh:</strong> {selectedStudent?.studentId || 'N/A'}
                                        </Typography>
                                    </Grid>
                                </Grid>
                            </Box>
                            
                            {/* Grades by subject */}
                            <Typography variant="h6" sx={{ mb: 2 }}>Điểm theo môn học:</Typography>
                            
                            {Object.entries(gradesBySubject).map(([subjectKey, subjectData]) => (
                                <Accordion 
                                    key={subjectKey} 
                                    expanded={expandedSubject === subjectKey} 
                                    onChange={handleAccordionChange(subjectKey)}
                                    sx={{ mb: 1 }}
                                >
                                    <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                                        <Typography variant="subtitle1">{subjectData.subjectName}</Typography>
                                    </AccordionSummary>
                                    <AccordionDetails>
                                        {/* Organize by semester */}
                                        {Object.entries(subjectData.semesters).map(([semester, semesterGrades]) => (
                                            <Box key={semester} sx={{ mb: 3 }}>
                                                <Typography 
                                                    variant="subtitle2" 
                                                    sx={{ 
                                                        mb: 1, 
                                                        fontWeight: 'bold',
                                                        backgroundColor: 'primary.light',
                                                        color: 'primary.contrastText',
                                                        py: 0.5,
                                                        px: 1,
                                                        borderRadius: 1
                                                    }}
                                                >
                                                    {semester}
                                                </Typography>
                                                
                                                {semesterGrades.map((grade) => (
                                                    <Paper 
                                                        key={grade.GradeID} 
                                                        variant="outlined" 
                                                        sx={{ p: 2, mb: 2 }}
                                                    >
                                                        <Grid container spacing={2}>
                                                            <Grid item xs={12} sm={6}>
                                                                <Typography variant="body2" color="text.secondary">
                                                                    Điểm tổng kết:
                                                                </Typography>
                                                                <Box sx={{ mt: 0.5 }}>
                                                                    <Chip 
                                                                        label={grade.FinalScore?.toFixed(2) || 'N/A'} 
                                                                        color={
                                                                            grade.FinalScore >= 8 ? 'success' : 
                                                                            grade.FinalScore >= 6.5 ? 'primary' :
                                                                            grade.FinalScore >= 5 ? 'warning' : 'error'
                                                                        }
                                                                        size="medium"
                                                                        sx={{ fontWeight: 'bold' }}
                                                                    />
                                                                </Box>
                                                            </Grid>
                                                            <Grid item xs={12} sm={6}>
                                                                <Typography variant="body2" color="text.secondary">
                                                                    Cập nhật:
                                                                </Typography>
                                                                <Typography variant="body1">
                                                                    {new Date(grade.UpdatedAt).toLocaleDateString()}
                                                                </Typography>
                                                            </Grid>
                                                            <Grid item xs={12}>
                                                                <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                                                                    Thành phần điểm:
                                                                </Typography>
                                                                {grade.grade_components && grade.grade_components.length > 0 ? (
                                                                    <TableContainer component={Paper} variant="outlined">
                                                                        <Table size="small">
                                                                            <TableHead>
                                                                                <TableRow>
                                                                                    <TableCell>Thành phần</TableCell>
                                                                                    <TableCell align="center">Điểm</TableCell>
                                                                                    <TableCell align="center">Trọng số</TableCell>
                                                                                    <TableCell align="right">Điểm quy đổi</TableCell>
                                                                                </TableRow>
                                                                            </TableHead>
                                                                            <TableBody>
                                                                                {grade.grade_components.map(comp => (
                                                                                    <TableRow key={comp.ComponentID}>
                                                                                        <TableCell>{comp.ComponentName}</TableCell>
                                                                                        <TableCell align="center">{comp.Score.toFixed(2)}</TableCell>
                                                                                        <TableCell align="center">{(comp.Weight*100).toFixed(0)}%</TableCell>
                                                                                        <TableCell align="right">
                                                                                            {(comp.Score * comp.Weight).toFixed(2)}
                                                                                        </TableCell>
                                                                                    </TableRow>
                                                                                ))}
                                                                            </TableBody>
                                                                        </Table>
                                                                    </TableContainer>
                                                                ) : (
                                                                    <Typography variant="body2" color="text.secondary" sx={{ fontStyle: 'italic' }}>
                                                                        Không có thông tin về thành phần điểm
                                                                    </Typography>
                                                                )}
                                                            </Grid>
                                                        </Grid>
                                                    </Paper>
                                                ))}
                                            </Box>
                                        ))}
                                    </AccordionDetails>
                                </Accordion>
                            ))}
                        </Box>
                    )}
                </DialogContent>
                
                <DialogActions>
                    <Button onClick={handleCloseGradeDetails} color="primary">
                        Đóng
                    </Button>
                </DialogActions>
            </Dialog>
        );
    };
    
    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                <GradingIcon sx={{ mr: 1 }} /> Quản lý điểm - Danh sách học sinh
            </Typography>
            
            {renderStudentTable()}
            {renderGradeDetailsDialog()}
            
            {/* Snackbar for notifications */}
            <Snackbar 
                open={snackbar.open} 
                autoHideDuration={3000} 
                onClose={handleCloseSnackbar}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert onClose={handleCloseSnackbar} severity={snackbar.severity} sx={{ width: '100%' }}>
                    {snackbar.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default GradeManagementPage; 