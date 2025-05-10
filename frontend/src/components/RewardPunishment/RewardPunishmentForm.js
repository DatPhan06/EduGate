import React, { useState, useEffect } from 'react';
import {
    Box,
    TextField,
    Button,
    Select,
    MenuItem,
    FormControl,
    InputLabel,
    Grid,
    Typography,
    CircularProgress,
    Alert,
    Snackbar
} from '@mui/material';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';
import rewardPunishmentService from '../../services/rewardPunishmentService';
// import studentService from '../../services/studentService'; // Optional: for fetching students
// import classService from '../../services/classService'; // Optional: for fetching classes

const RewardPunishmentForm = ({ targetType, onSuccess, onError }) => {
    
    const initialFormData = {
        Title: '',
        Type: 'REWARD', // Default to reward
        Description: '',
        Date: new Date(),
        Semester: '',
        Week: '',
        StudentID: '', // Only used if targetType is 'student'
        ClassID: '',   // Only used if targetType is 'class'
    };
    const [formData, setFormData] = useState(initialFormData);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const [currentUser, setCurrentUser] = useState(null);
    const [openSnackbar, setOpenSnackbar] = useState(false);
    const [snackbarMessage, setSnackbarMessage] = useState('');
    const [snackbarSeverity, setSnackbarSeverity] = useState('success');
    // Optional states for dropdowns
    // const [students, setStudents] = useState([]);
    // const [classes, setClasses] = useState([]);

    // Optional: Fetch students or classes for dropdowns
    // useEffect(() => { ... fetch logic ... }, [targetType]);
    useEffect(() => {
        try {
            const userJson = localStorage.getItem('user');
            if (userJson) {
                const user = JSON.parse(userJson);
                setCurrentUser(user);
            }
        } catch (error) {
            console.error('Error loading user from localStorage:', error);
        }
    }, []);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
        setError(''); // Clear error on change
        setSuccess(''); // Clear success on change
    };

    const handleDateChange = (newDate) => {
        setFormData(prev => ({ ...prev, Date: newDate }));
    };
    
    const handleCloseSnackbar = (event, reason) => {
        if (reason === 'clickaway') {
            return;
        }
        setOpenSnackbar(false);
    };
    
    const showNotification = (message, severity) => {
        setSnackbarMessage(message);
        setSnackbarSeverity(severity);
        setOpenSnackbar(true);
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        setSuccess('');
    
        // Điều chỉnh dữ liệu phù hợp với cấu trúc backend yêu cầu
        const dataToSend = {
            // Các trường trong RewardPunishmentBase
            title: formData.Title || "Khen thưởng/Kỷ luật",
            type: formData.Type === 'REWARD' ? 'reward' : 'punishment',
            description: formData.Description || "",
            date: formData.Date ? formData.Date.toISOString().split('T')[0] : new Date().toISOString().split('T')[0],
            issuer_id: currentUser?.id || currentUser?.UserID || 1,
            semester: formData.Semester || null,
            week: formData.Week ? parseInt(formData.Week, 10) : null,
            
            // Trường cho StudentRewardPunishmentCreate
            student_id: formData.StudentID ? parseInt(formData.StudentID, 10) : null,
        };
    
        try {
            let response;
            let successMsg = '';
            
            if (targetType === 'student') {
                if (!formData.StudentID) {
                    throw new Error("Vui lòng nhập ID Học sinh.");
                }
                
                console.log("Sending data to backend:", dataToSend); // Log để debug
                
                response = await rewardPunishmentService.createStudentRewardPunishment(dataToSend);
                successMsg = `Khen thưởng/Kỷ luật cho học sinh ID ${formData.StudentID} đã được tạo thành công!`;
                setSuccess(successMsg);
            } else if (targetType === 'class') {
                if (!formData.ClassID) {
                    throw new Error("Vui lòng nhập ID Lớp học.");
                }
                dataToSend.class_id = parseInt(formData.ClassID, 10);
                // Loại bỏ student_id khi gửi dữ liệu class_id
                delete dataToSend.student_id;
                
                response = await rewardPunishmentService.createClassRewardPunishment(dataToSend);
                successMsg = `Khen thưởng/Kỷ luật cho lớp ID ${formData.ClassID} đã được tạo thành công!`;
                setSuccess(successMsg);
            }

            showNotification(successMsg, 'success');
            setFormData(initialFormData);
            if (onSuccess) onSuccess(response.data);
        } catch (err) {
            console.error("Error creating reward/punishment:", err);
            const errorMsg = err.response?.data?.detail || err.message || 
                `Không thể tạo ${targetType === 'student' ? 'khen thưởng/kỷ luật học sinh' : 'khen thưởng/kỷ luật lớp'}.`;
            setError(errorMsg);
            showNotification(errorMsg, 'error');
            if (onError) onError(errorMsg);
        } finally {
            setLoading(false);
        }
    };

    return (
        <LocalizationProvider dateAdapter={AdapterDateFns}>
            <Box component="form" onSubmit={handleSubmit} sx={{ mt: 3 }}>
                <Typography variant="h6" gutterBottom>
                    Nhập thông tin {targetType === 'student' ? 'Khen thưởng/Kỷ luật Học sinh' : 'Khen thưởng/Kỷ luật Lớp học'}
                </Typography>
                {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
                {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
                <Grid container spacing={2}>
                    {targetType === 'student' && (
                        <Grid item xs={12}>
                            {/* TODO: Cân nhắc thay bằng Select nếu có danh sách học sinh */}
                            <TextField
                                required
                                fullWidth
                                id="StudentID"
                                label="ID Học sinh"
                                name="StudentID"
                                type="number" // Use number type for ID
                                value={formData.StudentID}
                                onChange={handleChange}
                                InputProps={{ inputProps: { min: 1 } }}
                            />
                        </Grid>
                    )}
                    {targetType === 'class' && (
                        <Grid item xs={12}>
                             {/* TODO: Cân nhắc thay bằng Select nếu có danh sách lớp */}
                            <TextField
                                required
                                fullWidth
                                id="ClassID"
                                label="ID Lớp học"
                                name="ClassID"
                                type="number"
                                value={formData.ClassID}
                                onChange={handleChange}
                                InputProps={{ inputProps: { min: 1 } }}
                            />
                        </Grid>
                    )}
                    <Grid item xs={12}>
                        <TextField
                            required
                            fullWidth
                            id="Title"
                            label="Tiêu đề"
                            name="Title"
                            value={formData.Title}
                            onChange={handleChange}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <FormControl fullWidth required>
                            <InputLabel id="type-select-label">Loại</InputLabel>
                            <Select
                                labelId="type-select-label"
                                id="Type"
                                name="Type"
                                value={formData.Type}
                                label="Loại"
                                onChange={handleChange}
                            >
                                <MenuItem value="REWARD">Khen thưởng</MenuItem>
                                <MenuItem value="PUNISHMENT">Kỷ luật</MenuItem>
                            </Select>
                        </FormControl>
                    </Grid>
                     <Grid item xs={12} sm={6}>
                        <DateTimePicker
                            label="Ngày"
                            value={formData.Date}
                            onChange={handleDateChange}
                            renderInput={(params) => <TextField {...params} fullWidth required />}
                        />
                    </Grid>
                    <Grid item xs={12}>
                        <TextField
                            fullWidth
                            id="Description"
                            label="Mô tả (Không bắt buộc)"
                            name="Description"
                            multiline
                            rows={3}
                            value={formData.Description}
                            onChange={handleChange}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            id="Semester"
                            label="Học kỳ (VD: Học kỳ 1)"
                            name="Semester"
                            value={formData.Semester}
                            onChange={handleChange}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            id="Week"
                            label="Tuần (Số)"
                            name="Week"
                            type="number"
                            value={formData.Week}
                            onChange={handleChange}
                            InputProps={{ inputProps: { min: 1 } }}
                        />
                    </Grid>
                </Grid>
                <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    sx={{ mt: 3, mb: 2 }}
                    disabled={loading}
                >
                    {loading ? <CircularProgress size={24} /> : `Tạo ${targetType === 'student' ? 'RNP Học sinh' : 'RNP Lớp'}`}
                </Button>

                {/* Thêm Snackbar hiển thị thông báo tạo thành công */}
                <Snackbar
                    open={openSnackbar}
                    autoHideDuration={6000}
                    onClose={handleCloseSnackbar}
                    anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
                >
                    <Alert onClose={handleCloseSnackbar} severity={snackbarSeverity} sx={{ width: '100%' }}>
                        {snackbarMessage}
                    </Alert>
                </Snackbar>

            </Box>
        </LocalizationProvider>
    );
};

export default RewardPunishmentForm;