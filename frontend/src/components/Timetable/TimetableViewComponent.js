import React, { useState, useEffect } from 'react';
import {
    Box, Typography, Paper, Table, TableBody, TableCell, TableContainer, 
    TableHead, TableRow, FormControl, InputLabel, Select, MenuItem, 
    CircularProgress, Grid, Chip, useTheme, alpha, Divider, IconButton,
    Tooltip
} from '@mui/material';
import {
    FilterList as FilterListIcon,
    Info as InfoIcon,
    Person as PersonIcon,
    Event as EventIcon,
    Room as RoomIcon,
    Schedule as ScheduleIcon
} from '@mui/icons-material';
import timetableService from '../../services/timetableService';
import userService from '../../services/userService';

const TimetableViewComponent = () => {
    const theme = useTheme();
    
    // Constants
    const dayOptions = [
        'Monday', 'Tuesday', 'Wednesday', 
        'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    
    const periodLabels = {
        morning: Array.from({ length: 5 }, (_, i) => `Tiết ${i + 1}`),
        afternoon: Array.from({ length: 5 }, (_, i) => `Tiết ${i + 1}`)
    };
    
    const academicYears = [
        '2022-2023', '2023-2024', '2024-2025', '2025-2026'
    ];
    
    const semesters = ['HK1', 'HK2'];
    
    // States
    const [loading, setLoading] = useState(true);
    const [schedules, setSchedules] = useState([]);
    const [classes, setClasses] = useState([]);
    const [classSubjects, setClassSubjects] = useState([]);
    const [subjects, setSubjects] = useState([]);
    const [teachers, setTeachers] = useState([]);
    
    // Filter states
    const [classFilter, setClassFilter] = useState('');
    const [semesterFilter, setSemesterFilter] = useState('HK1');
    const [yearFilter, setYearFilter] = useState(academicYears[0]);
    
    // Organized timetable data
    const [timetableData, setTimetableData] = useState({});
    
    // Initial data loading
    useEffect(() => {
        fetchAllData();
    }, []);
    
    // Update timetable when filters change
    useEffect(() => {
        if (schedules.length > 0 && classSubjects.length > 0) {
            organizeTimetableData();
        }
    }, [schedules, classSubjects, classFilter, semesterFilter, yearFilter]);
    
    const fetchAllData = async () => {
        setLoading(true);
        try {
            const [
                schedulesData,
                classesData,
                classSubjectsData,
                subjectsData,
                teachersData
            ] = await Promise.all([
                timetableService.getAllSchedules(),
                userService.getClasses(),
                timetableService.getAllClassSubjects(),
                timetableService.getAllSubjects(),
                userService.getAllUsers().then(users => users.filter(user => user.role === 'teacher'))
            ]);
            
            setSchedules(schedulesData);
            setClasses(classesData);
            setClassSubjects(classSubjectsData);
            setSubjects(subjectsData);
            setTeachers(teachersData);
            
            // Set default class filter if none is selected
            if (!classFilter && classesData.length > 0) {
                setClassFilter(classesData[0].ClassID);
            }
        } catch (error) {
            console.error('Error fetching timetable data:', error);
        } finally {
            setLoading(false);
        }
    };
    
    const organizeTimetableData = () => {
        // Create empty timetable structure with morning and afternoon sections
        const timetable = {
            morning: {},
            afternoon: {}
        };
        
        // Initialize the structure
        dayOptions.forEach(day => {
            timetable.morning[day] = {};
            timetable.afternoon[day] = {};
            
            // Morning periods (1-5)
            for (let period = 1; period <= 5; period++) {
                timetable.morning[day][period] = null;
            }
            
            // Afternoon periods (1-5)
            for (let period = 1; period <= 5; period++) {
                timetable.afternoon[day][period] = null;
            }
        });
        
        // Filter schedules based on selected filters
        const filteredSchedules = schedules.filter(schedule => {
            // Get the class subject for this schedule
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
            
            return true;
        });
        
        // Populate timetable with filtered schedules
        filteredSchedules.forEach(schedule => {
            const classSubject = classSubjects.find(cs => cs.ClassSubjectID === schedule.ClassSubjectID);
            if (!classSubject) return;
            
            const subject = subjects.find(s => s.SubjectID === classSubject.SubjectID);
            const teacher = teachers.find(t => t.UserID === classSubject.TeacherID);
            
            // Determine if this is a morning or afternoon schedule
            // Morning: periods 1-5, Afternoon: periods 6-10 (mapped to 1-5 in the afternoon section)
            const isMorning = schedule.StartPeriod <= 5;
            const section = isMorning ? 'morning' : 'afternoon';
            
            // Adjust period numbers for afternoon (convert 6-10 to 1-5)
            const startPeriod = isMorning ? schedule.StartPeriod : schedule.StartPeriod - 5;
            const endPeriod = isMorning ? Math.min(schedule.EndPeriod, 5) : Math.min(schedule.EndPeriod - 5, 5);
            
            // Skip if the adjusted period is out of bounds
            if (startPeriod > 5 || endPeriod < 1) return;
            
            // For each period in the schedule's range, add this class
            for (let period = startPeriod; period <= endPeriod; period++) {
                timetable[section][schedule.Day][period] = {
                    schedule,
                    classSubject,
                    subject,
                    teacher,
                    isStart: period === startPeriod,
                    isEnd: period === endPeriod,
                    spanLength: endPeriod - startPeriod + 1,
                    originalStartPeriod: schedule.StartPeriod,
                    originalEndPeriod: schedule.EndPeriod
                };
            }
        });
        
        setTimetableData(timetable);
    };
    
    // Generate a consistent color for a subject
    const getSubjectColor = (subjectID) => {
        const colors = [
            theme.palette.primary.light,
            theme.palette.secondary.light,
            theme.palette.error.light,
            theme.palette.warning.light,
            theme.palette.info.light,
            theme.palette.success.light,
            '#e57373', // red lighten-2
            '#81c784', // green lighten-2
            '#64b5f6', // blue lighten-2
            '#ffb74d', // orange lighten-2
            '#ba68c8', // purple lighten-2
            '#4db6ac', // teal lighten-2
            '#fff176', // yellow lighten-2
        ];
        
        // Simple hash function to get a consistent color
        const index = subjectID % colors.length;
        return colors[index];
    };
    
    // Get the current class name
    const getCurrentClassName = () => {
        if (!classFilter) return 'Tất cả các lớp';
        const currentClass = classes.find(c => c.ClassID === classFilter);
        return currentClass ? `Khối ${currentClass.GradeLevel} - ${currentClass.ClassName}` : '';
    };
    
    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" gutterBottom>
                Thời Khóa Biểu
            </Typography>
            
            {/* Filters */}
            <Grid container spacing={2} sx={{ mb: 4, mt: 1 }}>
                <Grid item xs={12} md={4}>
                    <FormControl fullWidth size="small">
                        <InputLabel>Lớp</InputLabel>
                        <Select
                            value={classFilter}
                            label="Lớp"
                            onChange={(e) => setClassFilter(e.target.value)}
                        >
                            {classes.map((classObj) => (
                                <MenuItem key={classObj.ClassID} value={classObj.ClassID}>
                                    Khối {classObj.GradeLevel} - {classObj.ClassName}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Grid>
                <Grid item xs={12} md={4}>
                    <FormControl fullWidth size="small">
                        <InputLabel>Học Kỳ</InputLabel>
                        <Select
                            value={semesterFilter}
                            label="Học Kỳ"
                            onChange={(e) => setSemesterFilter(e.target.value)}
                        >
                            {semesters.map((semester) => (
                                <MenuItem key={semester} value={semester}>{semester}</MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Grid>
                <Grid item xs={12} md={4}>
                    <FormControl fullWidth size="small">
                        <InputLabel>Năm Học</InputLabel>
                        <Select
                            value={yearFilter}
                            label="Năm Học"
                            onChange={(e) => setYearFilter(e.target.value)}
                        >
                            {academicYears.map((year) => (
                                <MenuItem key={year} value={year}>{year}</MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Grid>
            </Grid>
            
            {/* Timetable Header */}
            <Box sx={{ mb: 2, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <Typography variant="h5">
                    {getCurrentClassName()} - {semesterFilter} - {yearFilter}
                </Typography>
                <Tooltip title="Thời khóa biểu được cập nhật thường xuyên">
                    <IconButton>
                        <InfoIcon />
                    </IconButton>
                </Tooltip>
            </Box>
            
            {/* Timetable Grid - Morning */}
            {loading ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
                    <CircularProgress />
                </Box>
            ) : (
                <>
                    <Typography variant="h6" sx={{ mt: 4, mb: 2, display: 'flex', alignItems: 'center' }}>
                        <EventIcon sx={{ mr: 1 }} /> Buổi Sáng (Tiết 1-5)
                    </Typography>
                    <TableContainer component={Paper} elevation={2}>
                        <Table sx={{ minWidth: 650 }}>
                            <TableHead>
                                <TableRow>
                                    <TableCell sx={{ fontWeight: 'bold', width: '10%' }}>Tiết/Ngày</TableCell>
                                    {dayOptions.map((day, index) => (
                                        <TableCell 
                                            key={index} 
                                            align="center" 
                                            sx={{ 
                                                fontWeight: 'bold',
                                                backgroundColor: alpha(theme.palette.primary.main, 0.05)
                                            }}
                                        >
                                            {day}
                                        </TableCell>
                                    ))}
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {/* Render morning periods 1 through 5 as rows */}
                                {Array.from({ length: 5 }, (_, periodIndex) => {
                                    const period = periodIndex + 1;
                                    
                                    return (
                                        <TableRow key={`morning-${period}`} sx={{ '&:nth-of-type(odd)': { 
                                            backgroundColor: alpha(theme.palette.primary.main, 0.02) 
                                        }}}>
                                            <TableCell 
                                                component="th" 
                                                scope="row" 
                                                sx={{ 
                                                    fontWeight: 'bold',
                                                    backgroundColor: alpha(theme.palette.primary.main, 0.05)
                                                }}
                                            >
                                                Tiết {period}
                                            </TableCell>
                                            
                                            {/* Render each day as a column */}
                                            {dayOptions.map((day) => {
                                                const cellData = timetableData.morning && 
                                                                timetableData.morning[day] && 
                                                                timetableData.morning[day][period];
                                                
                                                return (
                                                    <TableCell 
                                                        key={`${day}-${period}`} 
                                                        align="center"
                                                        sx={{
                                                            position: 'relative',
                                                            height: '80px',
                                                            p: 1,
                                                            ...(cellData && {
                                                                backgroundColor: alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.2),
                                                                border: `1px solid ${alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.3)}`,
                                                            })
                                                        }}
                                                    >
                                                        {cellData ? (
                                                            <Box sx={{ 
                                                                display: 'flex', 
                                                                flexDirection: 'column',
                                                                height: '100%',
                                                                justifyContent: 'space-between'
                                                            }}>
                                                                <Typography variant="subtitle2" sx={{ fontWeight: 'bold' }}>
                                                                    {cellData.subject?.SubjectName || 'N/A'}
                                                                </Typography>
                                                                
                                                                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mt: 1 }}>
                                                                    <Typography variant="body2" sx={{ display: 'flex', alignItems: 'center' }}>
                                                                        <PersonIcon fontSize="small" sx={{ mr: 0.5 }} />
                                                                        {cellData.teacher ? 
                                                                            `${cellData.teacher.FirstName} ${cellData.teacher.LastName}` : 
                                                                            'N/A'
                                                                        }
                                                                    </Typography>
                                                                </Box>
                                                                
                                                                <Box sx={{ mt: 1 }}>
                                                                    <Chip 
                                                                        size="small" 
                                                                        label={`Tiết ${cellData.originalStartPeriod}-${cellData.originalEndPeriod}`}
                                                                        sx={{ 
                                                                            backgroundColor: alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.3),
                                                                            fontSize: '0.7rem' 
                                                                        }}
                                                                    />
                                                                </Box>
                                                            </Box>
                                                        ) : (
                                                            <Box sx={{ 
                                                                fontSize: '0.75rem', 
                                                                color: theme.palette.text.secondary,
                                                                height: '100%',
                                                                display: 'flex',
                                                                alignItems: 'center',
                                                                justifyContent: 'center',
                                                                opacity: 0.5
                                                            }}>
                                                                <ScheduleIcon fontSize="small" sx={{ mr: 0.5 }} />
                                                                Trống
                                                            </Box>
                                                        )}
                                                    </TableCell>
                                                );
                                            })}
                                        </TableRow>
                                    );
                                })}
                            </TableBody>
                        </Table>
                    </TableContainer>

                    {/* Afternoon Timetable */}
                    <Typography variant="h6" sx={{ mt: 4, mb: 2, display: 'flex', alignItems: 'center' }}>
                        <EventIcon sx={{ mr: 1 }} /> Buổi Chiều (Tiết 6-10)
                    </Typography>
                    <TableContainer component={Paper} elevation={2}>
                        <Table sx={{ minWidth: 650 }}>
                            <TableHead>
                                <TableRow>
                                    <TableCell sx={{ fontWeight: 'bold', width: '10%' }}>Tiết/Ngày</TableCell>
                                    {dayOptions.map((day, index) => (
                                        <TableCell 
                                            key={index} 
                                            align="center" 
                                            sx={{ 
                                                fontWeight: 'bold',
                                                backgroundColor: alpha(theme.palette.primary.light, 0.05)
                                            }}
                                        >
                                            {day}
                                        </TableCell>
                                    ))}
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {/* Render afternoon periods 1 through 5 (actually 6-10) as rows */}
                                {Array.from({ length: 5 }, (_, periodIndex) => {
                                    const period = periodIndex + 1;
                                    const displayPeriod = period + 5; // For display, show as period 6-10
                                    
                                    return (
                                        <TableRow key={`afternoon-${period}`} sx={{ '&:nth-of-type(odd)': { 
                                            backgroundColor: alpha(theme.palette.primary.light, 0.02) 
                                        }}}>
                                            <TableCell 
                                                component="th" 
                                                scope="row" 
                                                sx={{ 
                                                    fontWeight: 'bold',
                                                    backgroundColor: alpha(theme.palette.primary.light, 0.05)
                                                }}
                                            >
                                                Tiết {displayPeriod}
                                            </TableCell>
                                            
                                            {/* Render each day as a column */}
                                            {dayOptions.map((day) => {
                                                const cellData = timetableData.afternoon && 
                                                                timetableData.afternoon[day] && 
                                                                timetableData.afternoon[day][period];
                                                
                                                return (
                                                    <TableCell 
                                                        key={`${day}-${period}`} 
                                                        align="center"
                                                        sx={{
                                                            position: 'relative',
                                                            height: '80px',
                                                            p: 1,
                                                            ...(cellData && {
                                                                backgroundColor: alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.2),
                                                                border: `1px solid ${alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.3)}`,
                                                            })
                                                        }}
                                                    >
                                                        {cellData ? (
                                                            <Box sx={{ 
                                                                display: 'flex', 
                                                                flexDirection: 'column',
                                                                height: '100%',
                                                                justifyContent: 'space-between'
                                                            }}>
                                                                <Typography variant="subtitle2" sx={{ fontWeight: 'bold' }}>
                                                                    {cellData.subject?.SubjectName || 'N/A'}
                                                                </Typography>
                                                                
                                                                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mt: 1 }}>
                                                                    <Typography variant="body2" sx={{ display: 'flex', alignItems: 'center' }}>
                                                                        <PersonIcon fontSize="small" sx={{ mr: 0.5 }} />
                                                                        {cellData.teacher ? 
                                                                            `${cellData.teacher.FirstName} ${cellData.teacher.LastName}` : 
                                                                            'N/A'
                                                                        }
                                                                    </Typography>
                                                                </Box>
                                                                
                                                                <Box sx={{ mt: 1 }}>
                                                                    <Chip 
                                                                        size="small" 
                                                                        label={`Tiết ${cellData.originalStartPeriod}-${cellData.originalEndPeriod}`}
                                                                        sx={{ 
                                                                            backgroundColor: alpha(getSubjectColor(cellData.subject?.SubjectID || 0), 0.3),
                                                                            fontSize: '0.7rem' 
                                                                        }}
                                                                    />
                                                                </Box>
                                                            </Box>
                                                        ) : (
                                                            <Box sx={{ 
                                                                fontSize: '0.75rem', 
                                                                color: theme.palette.text.secondary,
                                                                height: '100%',
                                                                display: 'flex',
                                                                alignItems: 'center',
                                                                justifyContent: 'center',
                                                                opacity: 0.5
                                                            }}>
                                                                <ScheduleIcon fontSize="small" sx={{ mr: 0.5 }} />
                                                                Trống
                                                            </Box>
                                                        )}
                                                    </TableCell>
                                                );
                                            })}
                                        </TableRow>
                                    );
                                })}
                            </TableBody>
                        </Table>
                    </TableContainer>
                </>
            )}
            
            {/* Legend */}
            <Paper sx={{ p: 2, mt: 3 }}>
                <Typography variant="subtitle1" sx={{ mb: 1 }}>Chú thích:</Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2 }}>
                    {subjects
                        .filter(subject => {
                            // Only show subjects used in the current filtered view
                            return classSubjects.some(cs => 
                                cs.SubjectID === subject.SubjectID && 
                                (!classFilter || cs.ClassID === classFilter) &&
                                (!semesterFilter || cs.Semester === semesterFilter) &&
                                (!yearFilter || cs.AcademicYear === yearFilter)
                            );
                        })
                        .map(subject => (
                            <Chip 
                                key={subject.SubjectID}
                                label={subject.SubjectName}
                                sx={{ 
                                    backgroundColor: alpha(getSubjectColor(subject.SubjectID), 0.2),
                                    border: `1px solid ${alpha(getSubjectColor(subject.SubjectID), 0.3)}`,
                                }}
                            />
                        ))
                    }
                </Box>
            </Paper>
        </Box>
    );
};

export default TimetableViewComponent; 