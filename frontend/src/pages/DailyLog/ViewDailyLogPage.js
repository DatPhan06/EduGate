import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    CircularProgress,
    Alert,
    Button,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    IconButton,
    Tooltip,
    List,
    ListItem,
    ListItemText,
    Divider,
    Chip
} from '@mui/material';
import { format, parseISO } from 'date-fns';
import { getStudentDailyProgress, getTeacherStudents, getParentChildren } from '../../services/dailyProgressService';
import { Visibility as VisibilityIcon } from '@mui/icons-material';
import authService from '../../services/authService';
import AssignmentIcon from '@mui/icons-material/Assignment';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import SchoolIcon from '@mui/icons-material/School';
import CommentIcon from '@mui/icons-material/Comment';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import ManageDailyLogPage from './ManageDailyLogPage';


const ViewDailyLogPage = () => {
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [students, setStudents] = useState([]);
    const [selectedStudent, setSelectedStudent] = useState(null);
    const [dailyProgress, setDailyProgress] = useState([]);
    const [openDialog, setOpenDialog] = useState(false);
    const [currentUser] = useState(() => authService.getCurrentUser());
    const [parentChildren, setParentChildren] = useState([]);
    const [selectedChildId, setSelectedChildId] = useState(null);
    const [detailDialog, setDetailDialog] = useState({ open: false, log: null });

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                if (currentUser.role === 'teacher') {
                    const studentsData = await getTeacherStudents();
                    setStudents(studentsData);
                } else if (currentUser.role === 'student') {
                    const data = await getStudentDailyProgress(currentUser.UserID);
                    setDailyProgress(data);
                } else if (currentUser.role === 'parent') {
                    const children = await getParentChildren();
                    setParentChildren(children);
                    let studentId = selectedChildId || (children[0] && children[0].StudentID);
                    setSelectedChildId(studentId);
                    if (!studentId) throw new Error('Không tìm thấy thông tin học sinh');
                    const data = await getStudentDailyProgress(studentId);
                    setDailyProgress(data);
                }
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (currentUser && currentUser.role) {
            fetchData();
        }
    }, [currentUser, selectedChildId]);

    const handleViewProgress = async (student) => {
        try {
            setLoading(true);
            setSelectedStudent(student);
            const data = await getStudentDailyProgress(student.StudentID);
            setDailyProgress(data);
            setOpenDialog(true);
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleCloseDialog = () => {
        setOpenDialog(false);
        setSelectedStudent(null);
    };

    const handleViewDetail = (log) => {
        setDetailDialog({ open: true, log });
    };

    const handleCloseDetailDialog = () => {
        setDetailDialog({ open: false, log: null });
    };

    const sortDailyProgress = (progress) => {
        return [...progress].sort((a, b) => {
            return parseISO(b.Date) - parseISO(a.Date);
        });
    };

    const truncateText = (text, maxLength) => {
        if (!text) return 'Chưa có thông tin';
        return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
    };

    const getStudentName = (studentId) => {
        if (currentUser.role === 'teacher' && selectedStudent) {
            return `${selectedStudent.LastName} ${selectedStudent.FirstName}`;
        } else if (currentUser.role === 'parent') {
            const child = parentChildren.find(child => child.StudentID === studentId);
            return child ? `${child.LastName} ${child.FirstName}` : 'N/A';
        } else if (currentUser.role === 'student') {
            return `${currentUser.LastName} ${currentUser.FirstName}`;
        }
        return 'N/A';
    };

    const renderDailyProgress = (progress) => {
        const sortedProgress = sortDailyProgress(progress);
        
        return (
            <List sx={{ bgcolor: 'background.paper', borderRadius: 2, border: '1px solid #e0e0e0' }}>
                {sortedProgress.map((item, index) => (
                    <React.Fragment key={item.DailyID}>
                        <ListItem
                            secondaryAction={
                                <Tooltip title="Xem chi tiết">
                                    <IconButton edge="end" onClick={() => handleViewDetail(item)}>
                                        <VisibilityIcon color="primary" />
                                    </IconButton>
                                </Tooltip>
                            }
                        >
                            <ListItemText
                                primary={
                                    <Box display="flex" alignItems="center" mb={1}>
                                        <AssignmentIcon color="primary" sx={{ mr: 1 }} />
                                        <Typography variant="subtitle1" fontWeight={600}>
                                            {getStudentName(item.StudentID)} - Ngày {format(parseISO(item.Date), 'dd/MM/yyyy')}
                                        </Typography>
                                        <Chip
                                            label={item.Reprimand ? "Có nhắc nhở" : "Bình thường"}
                                            color={item.Reprimand ? "warning" : "success"}
                                            size="small"
                                            sx={{ ml: 2 }}
                                        />
                                    </Box>
                                }
                                secondary={
                                    <Box display="flex" justifyContent="space-between" gap={2}>
                                        <Box flex={1}>
                                            <Typography variant="body2" color="text.secondary" fontWeight={500}>
                                                Nhận xét chung
                                            </Typography>
                                            <Typography variant="body2">
                                                {truncateText(item.Overall, 50)}
                                            </Typography>
                                        </Box>
                                        <Box flex={1}>
                                            <Typography variant="body2" color="text.secondary" fontWeight={500}>
                                                Điểm danh
                                            </Typography>
                                            <Typography variant="body2">
                                                {truncateText(item.Attendance, 50)}
                                            </Typography>
                                        </Box>
                                        <Box flex={1}>
                                            <Typography variant="body2" color="text.secondary" fontWeight={500}>
                                                Kết quả học tập
                                            </Typography>
                                            <Typography variant="body2">
                                                {truncateText(item.StudyOutcome, 50)}
                                            </Typography>
                                        </Box>
                                        <Box flex={1}>
                                            <Typography variant="body2" color="text.secondary" fontWeight={500}>
                                                Nhắc nhở
                                            </Typography>
                                            <Typography variant="body2" color={item.Reprimand ? "error" : "text.primary"}>
                                                {truncateText(item.Reprimand, 50)}
                                            </Typography>
                                        </Box>
                                    </Box>
                                }
                            />
                        </ListItem>
                        {index < sortedProgress.length - 1 && <Divider />}
                    </React.Fragment>
                ))}
                {sortedProgress.length === 0 && (
                    <Alert severity="info" sx={{ m: 2 }}>Chưa có dữ liệu sổ liên lạc</Alert>
                )}
            </List>
        );
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="400px">
                <CircularProgress />
            </Box>
        );
    }

    if (error) {
        return (
            <Box p={3}>
                <Alert severity="error">{error}</Alert>
            </Box>
        );
    }

    return (
        <Box p={3}>
            <Typography variant="h4" gutterBottom>
                Sổ Liên Lạc Hằng Ngày
            </Typography>

            {currentUser.role === 'teacher' ? (
                // Giao diện cho giáo viên
                <ManageDailyLogPage />
            ) : currentUser.role === 'parent' && parentChildren.length > 1 ? (
                <Box mb={3}>
                    <Typography variant="h6">Chọn học sinh:</Typography>
                    <select
                        value={selectedChildId || ''}
                        onChange={e => setSelectedChildId(Number(e.target.value))}
                        style={{ fontSize: 16, padding: 8, marginTop: 8 }}
                    >
                        {parentChildren.map(child => (
                            <option key={child.StudentID} value={child.StudentID}>
                                {child.LastName} {child.FirstName} (Lớp: {child.ClassName || 'N/A'})
                            </option>
                        ))}
                    </select>
                    <Box mt={2}>{renderDailyProgress(dailyProgress)}</Box>
                </Box>
            ) : (
                // Giao diện cho học sinh và parent (1 con)
                renderDailyProgress(dailyProgress)
            )}

            {/* Dialog hiển thị danh sách sổ liên lạc */}
            <Dialog 
                open={openDialog} 
                onClose={handleCloseDialog}
                maxWidth="md"
                fullWidth
                PaperProps={{
                    sx: {
                        minHeight: '80vh',
                        maxHeight: '90vh'
                    }
                }}
            >
                <DialogTitle>
                    <Typography variant="h6">
                        Sổ liên lạc - {selectedStudent && `${selectedStudent.LastName} ${selectedStudent.FirstName}`}
                    </Typography>
                </DialogTitle>
                <DialogContent dividers sx={{ maxHeight: '70vh', overflowY: 'auto' }}>
                    {renderDailyProgress(dailyProgress)}
                </DialogContent>
            </Dialog>

            {/* Dialog chi tiết sổ liên lạc */}
            <Dialog
                open={detailDialog.open}
                onClose={handleCloseDetailDialog}
                maxWidth="sm"
                fullWidth
            >
                <DialogTitle>
                    Chi tiết sổ liên lạc - {detailDialog.log && format(parseISO(detailDialog.log.Date), 'dd/MM/yyyy')}
                </DialogTitle>
                <DialogContent dividers sx={{ maxHeight: '60vh', overflowY: 'auto' }}>
                    {detailDialog.log && (
                        <Box>
                            <Box display="flex" alignItems="center" mb={2}>
                                <CheckCircleIcon color="info" sx={{ mr: 1 }} />
                                <Typography variant="subtitle1" fontWeight={600}>
                                    Điểm danh
                                </Typography>
                            </Box>
                            <Typography variant="body1" sx={{ backgroundColor: '#f5f5f5', p: 2, borderRadius: 2, mb: 2 }}>
                                {detailDialog.log.Attendance || "Chưa có thông tin"}
                            </Typography>

                            <Box display="flex" alignItems="center" mb={2}>
                                <SchoolIcon color="success" sx={{ mr: 1 }} />
                                <Typography variant="subtitle1" fontWeight={600}>
                                    Kết quả học tập
                                </Typography>
                            </Box>
                            <Typography variant="body1" sx={{ backgroundColor: '#f5f5f5', p: 2, borderRadius: 2, mb: 2 }}>
                                {detailDialog.log.StudyOutcome || "Chưa có thông tin"}
                            </Typography>

                            <Box display="flex" alignItems="center" mb={2}>
                                <CommentIcon color="primary" sx={{ mr: 1 }} />
                                <Typography variant="subtitle1" fontWeight={600}>
                                    Nhận xét chung
                                </Typography>
                            </Box>
                            <Typography variant="body1" sx={{ backgroundColor: '#f5f5f5', p: 2, borderRadius: 2, mb: 2 }}>
                                {detailDialog.log.Overall || "Chưa có thông tin"}
                            </Typography>

                            <Box display="flex" alignItems="center" mb={2}>
                                <WarningAmberIcon color={detailDialog.log.Reprimand ? "warning" : "disabled"} sx={{ mr: 1 }} />
                                <Typography variant="subtitle1" fontWeight={600} color={detailDialog.log.Reprimand ? "error" : "textSecondary"}>
                                    Nhắc nhở
                                </Typography>
                            </Box>
                            <Typography variant="body1" color={detailDialog.log.Reprimand ? "error" : "textSecondary"} sx={{ backgroundColor: detailDialog.log.Reprimand ? '#fff3e0' : '#f5f5f5', p: 2, borderRadius: 2 }}>
                                {detailDialog.log.Reprimand || "Không có nhắc nhở"}
                            </Typography>
                        </Box>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseDetailDialog}>Đóng</Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};

export default ViewDailyLogPage;