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
import { api } from '../../services/api';

// Utility function to fetch subject info from class_subject_id
const getSubjectFromClassSubject = async (classSubjectId) => {
    try {
        const token = localStorage.getItem('token');
        const response = await api.get(`/class-subjects/${classSubjectId}/subject`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
        return response.data;
    } catch (error) {
        console.error(`Error fetching subject for class subject ${classSubjectId}:`, error);
        return null;
    }
};

// Utility function to fetch grade components by grade id
const getGradeComponentsByGradeId = async (gradeId) => {
    try {
        const token = localStorage.getItem('token');
        const response = await api.get(`/grades/grade/${gradeId}/components`, {
            headers: {
                Authorization: `Bearer ${token}`
            }
        });
        return response.data;
    } catch (error) {
        console.error(`Error fetching components for grade ${gradeId}:`, error);
        return [];
    }
};

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
            // Get the basic grade data
            const data = await gradeService.getStudentGrades(studentId);
            
            // Enhanced data with subject information and components
            const enhancedData = await Promise.all(data.map(async (grade) => {
                // Make a copy of the grade object
                let enhancedGrade = { ...grade };
                
                // Fetch subject information
                if (grade.ClassSubjectID) {
                    try {
                        const subjectInfo = await getSubjectFromClassSubject(grade.ClassSubjectID);
                        if (subjectInfo) {
                            enhancedGrade.subjectName = subjectInfo.subject_name || grade.subjectName;
                            enhancedGrade.className = subjectInfo.class_name || grade.className;
                        }
                    } catch (error) {
                        console.error(`Error fetching subject info for ClassSubjectID ${grade.ClassSubjectID}:`, error);
                    }
                }
                
                // Fetch grade components
                if (grade.GradeID) {
                    try {
                        const components = await getGradeComponentsByGradeId(grade.GradeID);
                        enhancedGrade.grade_components = components;
                    } catch (error) {
                        console.error(`Error fetching components for grade ${grade.GradeID}:`, error);
                    }
                }
                
                return enhancedGrade;
            }));
            
            setStudentGrades(enhancedData || []);
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
    
    // ===== Filtered Students =====
    const filteredStudents = students.filter(student => {
        // Apply search filter
        const matchesSearch = !searchTerm || 
            student.name?.toLowerCase().includes(searchTerm) ||
            student.Email?.toLowerCase().includes(searchTerm) ||
            String(student.studentId).includes(searchTerm);
        
        // Apply class filter
        const matchesClass = !classFilter || student.classId === Number(classFilter);
        
        // Apply grade filter
        const matchesGrade = !gradeFilter || student.classGrade === gradeFilter;
        
        return matchesSearch && matchesClass && matchesGrade;
    });

    // ===== Render Methods =====
    const renderFilters = () => (
        <Paper sx={{ p: 2, mb: 2 }}>
            <Grid container spacing={2} alignItems="center">
                <Grid item xs={12} md={4}>
                    <TextField
                        fullWidth
                        label="Tìm kiếm"
                        placeholder="Tên, Email, Mã học sinh"
                        variant="outlined"
                        value={searchTerm}
                        onChange={handleSearchChange}
                        InputProps={{
                            startAdornment: <SearchIcon color="action" sx={{ mr: 1 }} />,
                        }}
                    />
                </Grid>
                <Grid item xs={12} md={4}>
                    <FormControl fullWidth>
                        <InputLabel id="class-select-label">Lọc theo lớp</InputLabel>
                        <Select
                            labelId="class-select-label"
                            value={classFilter}
                            label="Lọc theo lớp"
                            onChange={handleClassFilterChange}
                        >
                            <MenuItem value="">
                                <em>Tất cả các lớp</em>
                            </MenuItem>
                            {uniqueClasses.map((classItem) => (
                                <MenuItem key={classItem.id} value={classItem.id}>
                                    {classItem.name} (Khối {classItem.grade})
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Grid>
                <Grid item xs={12} md={4}>
                    <FormControl fullWidth>
                        <InputLabel id="grade-select-label">Lọc theo khối</InputLabel>
                        <Select
                            labelId="grade-select-label"
                            value={gradeFilter}
                            label="Lọc theo khối"
                            onChange={handleGradeFilterChange}
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
                </Grid>
            </Grid>
        </Paper>
    );

    const renderStudentTable = () => {
        return (
            <Paper sx={{ width: '100%', overflow: 'hidden' }}>
                <Box p={2} display="flex" justifyContent="space-between" alignItems="center">
                    <Typography variant="h6" component="div">
                        Danh sách học sinh {classFilter ? `- Lớp ${uniqueClasses.find(c => c.id === Number(classFilter))?.name}` : ''}
                    </Typography>
                </Box>
                
                {loadingStudents ? (
                    <Box display="flex" justifyContent="center" p={3}>
                        <CircularProgress />
                    </Box>
                ) : filteredStudents.length === 0 ? (
                    <Box p={3} textAlign="center">
                        <Typography variant="body1" color="textSecondary">
                            Không tìm thấy học sinh nào phù hợp với điều kiện tìm kiếm.
                        </Typography>
                    </Box>
                ) : (
                    <TableContainer sx={{ maxHeight: 'calc(100vh - 250px)' }}>
                        <Table stickyHeader>
                            <TableHead>
                                <TableRow>
                                    <TableCell>Mã học sinh</TableCell>
                                    <TableCell>Tên học sinh</TableCell>
                                    <TableCell>Lớp</TableCell>
                                    <TableCell>Khối</TableCell>
                                    <TableCell>Email</TableCell>
                                    <TableCell align="center">Quản lý điểm</TableCell>
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
            const subjectName = grade.subjectName || 
                             (grade.class_subject?.subject?.SubjectName) || 
                             `Môn học ${grade.ClassSubjectID}`;
            const className = grade.className || grade.class_subject?.class?.ClassName || 'N/A';
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
                                    
                                </Grid>
                            </Box>
                            
                            {/* Grades by subject */}
                            {Object.entries(gradesBySubject).map(([subjectKey, subjectData]) => (
                                <Accordion 
                                    key={subjectKey}
                                    expanded={expandedSubject === subjectKey}
                                    onChange={handleAccordionChange(subjectKey)}
                                    sx={{ mb: 2 }}
                                >
                                    <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                                        <Typography variant="subtitle1">
                                            {subjectData.subjectName}
                                        </Typography>
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
                                                        elevation={1} 
                                                        sx={{ 
                                                            p: 2, 
                                                            mb: 2, 
                                                            border: 1,
                                                            borderColor: 'divider'
                                                        }}
                                                    >
                                                        <Grid container spacing={2}>
                                                            <Grid item xs={12} sm={6}>
                                                                <Typography variant="body1">
                                                                    <strong>Điểm trung bình:</strong> 
                                                                    <Chip
                                                                        label={grade.FinalScore !== null && grade.FinalScore !== undefined ? 
                                                                            Number(grade.FinalScore).toFixed(1) : 'Chưa có điểm'}
                                                                        color={grade.FinalScore >= 8 ? 'success' : 
                                                                            grade.FinalScore >= 6.5 ? 'info' : 
                                                                            grade.FinalScore >= 5 ? 'warning' : 'error'}
                                                                        size="small"
                                                                        sx={{ ml: 1 }}
                                                                    />
                                                                </Typography>
                                                            </Grid>
                                                            <Grid item xs={12} sm={6}>
                                                                <Typography variant="body1">
                                                                    <strong>Học kỳ:</strong> {grade.Semester}
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
                                                                                {grade.grade_components.sort((a, b) => b.Weight - a.Weight).map((component) => (
                                                                                    <TableRow key={component.ComponentID}>
                                                                                        <TableCell>{component.ComponentName}</TableCell>
                                                                                        <TableCell align="center">
                                                                                            {component.Score !== null && component.Score !== undefined ? 
                                                                                                Number(component.Score).toFixed(1) : '-'}
                                                                                        </TableCell>
                                                                                        <TableCell align="center">
                                                                                            {component.Weight}
                                                                                        </TableCell>
                                                                                        <TableCell align="right">
                                                                                            {component.Score !== null && component.Score !== undefined ? 
                                                                                                (component.Score * component.Weight).toFixed(1) : '-'}
                                                                                        </TableCell>
                                                                                    </TableRow>
                                                                                ))}
                                                                            </TableBody>
                                                                        </Table>
                                                                    </TableContainer>
                                                                ) : (
                                                                    <Typography color="text.secondary" variant="body2">
                                                                        Chưa có thành phần điểm nào được ghi nhận.
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
            <Typography variant="h4" component="h1" gutterBottom>
                Quản lý điểm
            </Typography>
            
            {renderFilters()}
            {renderStudentTable()}
            {renderGradeDetailsDialog()}
            
            <Snackbar 
                open={snackbar.open} 
                autoHideDuration={6000} 
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