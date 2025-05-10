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
    TextField,
    Grid,
    IconButton,
    Tooltip,
    Card,
    CardContent,
    Chip,
    Divider
} from '@mui/material';
import { format, parseISO } from 'date-fns';
import { Edit as EditIcon, Save as SaveIcon, Visibility as VisibilityIcon } from '@mui/icons-material';
import { getTeacherStudents, getClassDailyProgress, createOrUpdateDailyProgress } from '../../services/dailyProgressService';
import authService from '../../services/authService';

const ManageDailyLogPage = () => {
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [students, setStudents] = useState([]);
    const [dailyProgress, setDailyProgress] = useState({});
    const [selectedStudent, setSelectedStudent] = useState(null);
    const [openDialog, setOpenDialog] = useState(false);
    const [editLog, setEditLog] = useState(null);
    const [editForm, setEditForm] = useState({
        Date: '',
        Overall: '',
        Attendance: '',
        StudyOutcome: '',
        Reprimand: ''
    });
    const [creatingNew, setCreatingNew] = useState(false);
    const [newForm, setNewForm] = useState({
        Date: format(new Date(), 'yyyy-MM-dd'),
        Overall: '',
        Attendance: '',
        StudyOutcome: '',
        Reprimand: ''
    });
    // State mới cho dialog chi tiết
    const [openDetailDialog, setOpenDetailDialog] = useState(false);
    const [selectedLog, setSelectedLog] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                const studentsData = await getTeacherStudents();
                setStudents(studentsData);
                if (studentsData.length > 0) {
                    const classId = studentsData[0].ClassID;
                    const progressData = await getClassDailyProgress(classId);
                    const progressMap = {};
                    progressData.forEach(progress => {
                        if (!progressMap[progress.StudentID]) progressMap[progress.StudentID] = [];
                        progressMap[progress.StudentID].push(progress);
                    });
                    setDailyProgress(progressMap);
                }
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    const handleViewLogs = (student) => {
        setSelectedStudent(student);
        setOpenDialog(true);
    };

    const handleCloseDialog = () => {
        setOpenDialog(false);
        setSelectedStudent(null);
        setEditLog(null);
        setCreatingNew(false);
    };

    // Xử lý mở dialog chi tiết
    const handleViewDetail = (log) => {
        setSelectedLog(log);
        setOpenDetailDialog(true);
    };

    const handleCloseDetailDialog = () => {
        setOpenDetailDialog(false);
        setSelectedLog(null);
    };

    const handleEditLog = (log) => {
        setEditLog(log);
        setEditForm({
            Date: format(parseISO(log.Date), 'yyyy-MM-dd'),
            Overall: log.Overall || '',
            Attendance: log.Attendance || '',
            StudyOutcome: log.StudyOutcome || '',
            Reprimand: log.Reprimand || ''
        });
    };

    const handleCancelEdit = () => {
        setEditLog(null);
    };

    const handleSaveEdit = async () => {
        try {
            const data = {
                ...editForm,
                StudentID: selectedStudent.StudentID
            };
            const response = await createOrUpdateDailyProgress(data);
            setDailyProgress(prev => {
                const arr = prev[selectedStudent.StudentID] ? [...prev[selectedStudent.StudentID]] : [];
                const idx = arr.findIndex(l => l.DailyID === response.DailyID);
                if (idx !== -1) {
                    arr[idx] = response;
                } else {
                    arr.unshift(response);
                }
                return { ...prev, [selectedStudent.StudentID]: arr };
            });
            setEditLog(null);
        } catch (err) {
            setError(err.message);
        }
    };

    const handleCreateNew = async () => {
        try {
            const data = {
                ...newForm,
                StudentID: selectedStudent.StudentID
            };
            const response = await createOrUpdateDailyProgress(data);
            setDailyProgress(prev => {
                const arr = prev[selectedStudent.StudentID] ? [...prev[selectedStudent.StudentID]] : [];
                arr.unshift(response);
                return { ...prev, [selectedStudent.StudentID]: arr };
            });
            setCreatingNew(false);
            setNewForm({
                Date: format(new Date(), 'yyyy-MM-dd'),
                Overall: '',
                Attendance: '',
                StudyOutcome: '',
                Reprimand: ''
            });
        } catch (err) {
            setError(err.message);
        }
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
                Quản Lý Sổ Liên Lạc Hằng Ngày
            </Typography>

            <TableContainer component={Paper}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Họ và tên</TableCell>
                            <TableCell>Lớp</TableCell>
                            <TableCell>Email</TableCell>
                            <TableCell>Số điện thoại</TableCell>
                            <TableCell>Địa chỉ</TableCell>
                            <TableCell>Ngày sinh</TableCell>
                            <TableCell>Giới tính</TableCell>
                            <TableCell align="center">Xem sổ liên lạc</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {students.map((student) => (
                            <TableRow key={student.StudentID}>
                                <TableCell>{`${student.LastName} ${student.FirstName}`}</TableCell>
                                <TableCell>{student.ClassName}</TableCell>
                                <TableCell>{student.Email}</TableCell>
                                <TableCell>{student.PhoneNumber}</TableCell>
                                <TableCell>{student.Address}</TableCell>
                                <TableCell>
                                    {student.DateOfBirth ? format(new Date(student.DateOfBirth), 'dd/MM/yyyy') : ''}
                                </TableCell>
                                <TableCell>
                                    {student.Gender === 'MALE' ? 'Nam' : student.Gender === 'FEMALE' ? 'Nữ' : ''}
                                </TableCell>
                                <TableCell align="center">
                                    <Button variant="outlined" onClick={() => handleViewLogs(student)}>
                                        Xem tất cả
                                    </Button>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>

            {/* Dialog hiển thị danh sách sổ liên lạc */}
            <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
                <DialogTitle>
                    Sổ liên lạc - {selectedStudent && `${selectedStudent.LastName} ${selectedStudent.FirstName}`}
                </DialogTitle>
                <DialogContent dividers sx={{ maxHeight: '70vh', overflowY: 'auto' }}>
                    <Box mb={2} textAlign="right">
                        {!creatingNew && (
                            <Button variant="contained" onClick={() => setCreatingNew(true)}>
                                Tạo sổ liên lạc mới
                            </Button>
                        )}
                    </Box>
                    {creatingNew && (
                        <Card sx={{ mb: 2 }}>
                            <CardContent>
                                <Typography variant="h6" color="primary" gutterBottom>
                                    Tạo sổ liên lạc mới
                                </Typography>
                                <Grid container spacing={2}>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Ngày"
                                            type="date"
                                            name="Date"
                                            value={newForm.Date}
                                            onChange={e => setNewForm(f => ({ ...f, Date: e.target.value }))}
                                            InputLabelProps={{ shrink: true }}
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Điểm danh"
                                            name="Attendance"
                                            value={newForm.Attendance}
                                            onChange={e => setNewForm(f => ({ ...f, Attendance: e.target.value }))}
                                            multiline
                                            rows={2}
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Kết quả học tập"
                                            name="StudyOutcome"
                                            value={newForm.StudyOutcome}
                                            onChange={e => setNewForm(f => ({ ...f, StudyOutcome: e.target.value }))}
                                            multiline
                                            rows={2}
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Nhận xét chung"
                                            name="Overall"
                                            value={newForm.Overall}
                                            onChange={e => setNewForm(f => ({ ...f, Overall: e.target.value }))}
                                            multiline
                                            rows={2}
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Nhắc nhở"
                                            name="Reprimand"
                                            value={newForm.Reprimand}
                                            onChange={e => setNewForm(f => ({ ...f, Reprimand: e.target.value }))}
                                            multiline
                                            rows={2}
                                        />
                                    </Grid>
                                </Grid>
                                <Box mt={2} textAlign="right">
                                    <Button onClick={() => setCreatingNew(false)} sx={{ mr: 1 }}>Hủy</Button>
                                    <Button
                                        onClick={handleCreateNew}
                                        variant="contained"
                                        startIcon={<SaveIcon />}
                                    >
                                        Lưu
                                    </Button>
                                </Box>
                            </CardContent>
                        </Card>
                    )}
                    {selectedStudent && (dailyProgress[selectedStudent.StudentID]?.length > 0) ? (
                        dailyProgress[selectedStudent.StudentID]
                            .slice()
                            .sort((a, b) => new Date(b.Date) - new Date(a.Date))
                            .map((log, idx, arr) => (
                                <Card key={log.DailyID} sx={{ mb: 2 }}>
                                    <CardContent>
                                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                                            <Typography variant="h6" color="primary">
                                                Ngày: {format(parseISO(log.Date), 'dd/MM/yyyy')}
                                            </Typography>
                                            <Box>
                                                <Chip 
                                                    label={log.Reprimand ? "Có nhắc nhở" : "Bình thường"}
                                                    color={log.Reprimand ? "warning" : "success"}
                                                    sx={{ mr: 1 }}
                                                />
                                                <Tooltip title="Xem chi tiết">
                                                    <IconButton onClick={() => handleViewDetail(log)}>
                                                        <VisibilityIcon />
                                                    </IconButton>
                                                </Tooltip>
                                            </Box>
                                        </Box>
                                        <Divider sx={{ mb: 2 }} />
                                        {editLog && editLog.DailyID === log.DailyID ? (
                                            <Grid container spacing={2}>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        label="Ngày"
                                                        type="date"
                                                        name="Date"
                                                        value={editForm.Date}
                                                        onChange={e => setEditForm(f => ({ ...f, Date: e.target.value }))}
                                                        InputLabelProps={{ shrink: true }}
                                                    />
                                                </Grid>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        label="Điểm danh"
                                                        name="Attendance"
                                                        value={editForm.Attendance}
                                                        onChange={e => setEditForm(f => ({ ...f, Attendance: e.target.value }))}
                                                        multiline
                                                        rows={2}
                                                    />
                                                </Grid>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        label="Kết quả học tập"
                                                        name="StudyOutcome"
                                                        value={editForm.StudyOutcome}
                                                        onChange={e => setEditForm(f => ({ ...f, StudyOutcome: e.target.value }))}
                                                        multiline
                                                        rows={2}
                                                    />
                                                </Grid>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        label="Nhận xét chung"
                                                        name="Overall"
                                                        value={editForm.Overall}
                                                        onChange={e => setEditForm(f => ({ ...f, Overall: e.target.value }))}
                                                        multiline
                                                        rows={2}
                                                    />
                                                </Grid>
                                                <Grid item xs={12}>
                                                    <TextField
                                                        fullWidth
                                                        label="Nhắc nhở"
                                                        name="Reprimand"
                                                        value={editForm.Reprimand}
                                                        onChange={e => setEditForm(f => ({ ...f, Reprimand: e.target.value }))}
                                                        multiline
                                                        rows={2}
                                                    />
                                                </Grid>
                                            </Grid>
                                        ) : (
                                            <Grid container spacing={2}>
                                                <Grid item xs={12} md={6}>
                                                    <Typography variant="subtitle1" color="textSecondary" gutterBottom>
                                                        Điểm danh
                                                    </Typography>
                                                    <Typography variant="body1" sx={{ backgroundColor: 'rgba(0,0,0,0.03)', p: 1, borderRadius: 1 }}>
                                                        {log.Attendance || 'Chưa có thông tin'}
                                                    </Typography>
                                                </Grid>
                                                <Grid item xs={12} md={6}>
                                                    <Typography variant="subtitle1" color="textSecondary" gutterBottom>
                                                        Kết quả học tập
                                                    </Typography>
                                                    <Typography variant="body1" sx={{ backgroundColor: 'rgba(0,0,0,0.03)', p: 1, borderRadius: 1 }}>
                                                        {log.StudyOutcome || 'Chưa có thông tin'}
                                                    </Typography>
                                                </Grid>
                                            </Grid>
                                        )}
                                        {!editLog && idx === 0 && (
                                            <Box mt={2} textAlign="right">
                                                <Button 
                                                    variant="outlined" 
                                                    startIcon={<EditIcon />} 
                                                    onClick={() => handleEditLog(log)}
                                                >
                                                    Chỉnh sửa bản mới nhất
                                                </Button>
                                            </Box>
                                        )}
                                        {editLog && editLog.DailyID === log.DailyID && (
                                            <Box mt={2} textAlign="right">
                                                <Button onClick={handleCancelEdit} sx={{ mr: 1 }}>Hủy</Button>
                                                <Button 
                                                    onClick={handleSaveEdit}
                                                    variant="contained"
                                                    startIcon={<SaveIcon />}
                                                >
                                                    Lưu
                                                </Button>
                                            </Box>
                                        )}
                                    </CardContent>
                                </Card>
                            ))
                    ) : (
                        <Alert severity="info">Chưa có dữ liệu sổ liên lạc</Alert>
                    )}
                </DialogContent>
            </Dialog>

            {/* Dialog chi tiết sổ liên lạc */}
            <Dialog 
                open={openDetailDialog} 
                onClose={handleCloseDetailDialog} 
                maxWidth="sm" 
                fullWidth
            >
                <DialogTitle>
                    Chi tiết sổ liên lạc - {selectedLog && format(parseISO(selectedLog.Date), 'dd/MM/yyyy')}
                </DialogTitle>
                <DialogContent dividers sx={{ maxHeight: '60vh', overflowY: 'auto' }}>
                    {selectedLog && (
                        <Grid container spacing={2}>
                            <Grid item xs={12}>
                                <Typography variant="subtitle1" color="textSecondary" gutterBottom>
                                    Điểm danh
                                </Typography>
                                <Typography variant="body1" sx={{ backgroundColor: 'rgba(0,0,0,0.03)', p: 2, borderRadius: 1 }}>
                                    {selectedLog.Attendance || 'Chưa có thông tin'}
                                </Typography>
                            </Grid>
                            <Grid item xs={12}>
                                <Typography variant="subtitle1" color="textSecondary" gutterBottom>
                                    Kết quả học tập
                                </Typography>
                                <Typography variant="body1" sx={{ backgroundColor: 'rgba(0,0,0,0.03)', p: 2, borderRadius: 1 }}>
                                    {selectedLog.StudyOutcome || 'Chưa có thông tin'}
                                </Typography>
                            </Grid>
                            <Grid item xs={12}>
                                <Typography variant="subtitle1" color="textSecondary" gutterBottom>
                                    Nhận xét chung
                                </Typography>
                                <Typography variant="body1" sx={{ backgroundColor: 'rgba(0,0,0,0.03)', p: 2, borderRadius: 1 }}>
                                    {selectedLog.Overall || 'Chưa có thông tin'}
                                </Typography>
                            </Grid>
                            {selectedLog.Reprimand && (
                                <Grid item xs={12}>
                                    <Typography variant="subtitle1" color="error" gutterBottom>
                                        Nhắc nhở
                                    </Typography>
                                    <Typography variant="body1" color="error" sx={{ backgroundColor: 'rgba(211,47,47,0.08)', p: 2, borderRadius: 1 }}>
                                        {selectedLog.Reprimand}
                                    </Typography>
                                </Grid>
                            )}
                        </Grid>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseDetailDialog}>Đóng</Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};

export default ManageDailyLogPage;