import React, { useState, useEffect, useRef } from 'react';
import {
    Box,
    Container,
    Typography,
    Avatar,
    TextField,
    Button,
    Grid,
    Paper,
    CircularProgress,
    Alert,
    Divider,
    MenuItem,
    FormControl,
    InputLabel,
    Select,
    Card,
    CardContent,
    CardHeader,
    IconButton,
    Tooltip,
    Snackbar,
    Slide,
    Tabs,
    Tab,
    Chip,
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { Edit as EditIcon, Save as SaveIcon, Lock as LockIcon, Close as CloseIcon, Person as PersonIcon, Security as SecurityIcon } from '@mui/icons-material';
import userService from '../../services/userService';
import authService from '../../services/authService';

// Animation for alert
function SlideTransition(props) {
    return <Slide {...props} direction="left" />;
}

const UserProfile = () => {
    const navigate = useNavigate();
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const [openAlert, setOpenAlert] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');
    const [alertSeverity, setAlertSeverity] = useState('success');
    const [activeTab, setActiveTab] = useState(0);
    const [formData, setFormData] = useState({
        FirstName: '',
        LastName: '',
        Email: '',
        Street: '',
        District: '',
        City: '',
        PhoneNumber: '',
        DOB: '',
        PlaceOfBirth: '',
        Gender: '',
        Address: '',
        Status: '',
        role: '',
    });
    const [formErrors, setFormErrors] = useState({});
    const [passwordData, setPasswordData] = useState({
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
    });
    const [passwordErrors, setPasswordErrors] = useState({});
    const passwordSectionRef = useRef(null);

    const showAlert = (message, severity = 'success') => {
        setAlertMessage(message);
        setAlertSeverity(severity);
        setOpenAlert(true);
    };

    const handleCloseAlert = (event, reason) => {
        if (reason === 'clickaway') {
            return;
        }
        setOpenAlert(false);
    };

    const handleTabChange = (event, newValue) => {
        setActiveTab(newValue);
    };

    const validateForm = () => {
        const errors = {};
        if (!formData.FirstName.trim()) {
            errors.FirstName = 'Họ không được để trống';
        }
        if (!formData.LastName.trim()) {
            errors.LastName = 'Tên không được để trống';
        }
        if (formData.PhoneNumber && !/^\d{10}$/.test(formData.PhoneNumber)) {
            errors.PhoneNumber = 'Số điện thoại phải có 10 chữ số';
        }
        if (formData.DOB && new Date(formData.DOB) > new Date()) {
            errors.DOB = 'Ngày sinh không được lớn hơn ngày hiện tại';
        }
        setFormErrors(errors);
        return Object.keys(errors).length === 0;
    };

    const validatePassword = () => {
        const errors = {};
        if (!passwordData.currentPassword) {
            errors.currentPassword = 'Mật khẩu hiện tại không được để trống';
        }
        if (!passwordData.newPassword) {
            errors.newPassword = 'Mật khẩu mới không được để trống';
        } else if (passwordData.newPassword.length < 6) {
            errors.newPassword = 'Mật khẩu mới phải có ít nhất 6 ký tự';
        }
        if (!passwordData.confirmPassword) {
            errors.confirmPassword = 'Xác nhận mật khẩu không được để trống';
        } else if (passwordData.newPassword !== passwordData.confirmPassword) {
            errors.confirmPassword = 'Mật khẩu mới không khớp';
        }
        setPasswordErrors(errors);
        return Object.keys(errors).length === 0;
    };

    useEffect(() => {
        fetchUserData();
        
        if (window.location.hash === '#change-password') {
            setTimeout(() => {
                passwordSectionRef.current?.scrollIntoView({ behavior: 'smooth' });
                setActiveTab(1);
            }, 100);
        }
    }, []);

    const fetchUserData = async () => {
        try {
            setLoading(true);
            const token = authService.getToken();
            if (!token) {
                setError('Vui lòng đăng nhập để xem thông tin cá nhân');
                setTimeout(() => {
                    authService.logout();
                    navigate('/login');
                }, 2000);
                return;
            }

            const response = await userService.getCurrentUser();
            if (response) {
                setUser(response);
                setFormData({
                    FirstName: response.FirstName || '',
                    LastName: response.LastName || '',
                    Email: response.Email || '',
                    Street: response.Street || '',
                    District: response.District || '',
                    City: response.City || '',
                    PhoneNumber: response.PhoneNumber || '',
                    DOB: response.DOB ? new Date(response.DOB).toISOString().split('T')[0] : '',
                    PlaceOfBirth: response.PlaceOfBirth || '',
                    Gender: response.Gender || '',
                    Address: response.Address || '',
                    Status: response.Status || '',
                    role: response.role || '',
                });
            }
        } catch (error) {
            console.error('Error fetching user data:', error);
            if (error.response) {
                console.error('Error response:', error.response);
                if (error.response.status === 401) {
                    setError('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại');
                    setTimeout(() => {
                        authService.logout();
                        navigate('/login');
                    }, 2000);
                } else {
                    setError(error.response.data?.detail || 'Có lỗi xảy ra khi tải thông tin người dùng');
                }
            } else if (error.request) {
                console.error('Error request:', error.request);
                setError('Không thể kết nối đến máy chủ');
            } else {
                setError('Có lỗi xảy ra: ' + error.message);
            }
        } finally {
            setLoading(false);
        }
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
        // Clear error when user starts typing
        if (formErrors[name]) {
            setFormErrors({
                ...formErrors,
                [name]: '',
            });
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validateForm()) {
            return;
        }

        try {
            setLoading(true);
            await userService.updateUser(user.UserID, formData);
            showAlert('Cập nhật thông tin thành công');
            fetchUserData();
        } catch (error) {
            console.error('Error updating user:', error);
            if (error.response) {
                showAlert(error.response.data?.detail || 'Có lỗi xảy ra khi cập nhật thông tin', 'error');
            } else {
                showAlert('Không thể kết nối đến máy chủ', 'error');
            }
        } finally {
            setLoading(false);
        }
    };

    const handleChangePassword = async (e) => {
        e.preventDefault();
        if (!validatePassword()) {
            return;
        }

        try {
            setLoading(true);
            const response = await userService.changePassword({
                currentPassword: passwordData.currentPassword,
                newPassword: passwordData.newPassword,
            });

            if (response && response.message) {
                showAlert('Đổi mật khẩu thành công');
                setPasswordData({
                    currentPassword: '',
                    newPassword: '',
                    confirmPassword: '',
                });
            }
        } catch (error) {
            console.error('Error changing password:', error);
            if (error.response?.status === 401) {
                showAlert('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại', 'error');
                setTimeout(() => {
                    authService.logout();
                    navigate('/login');
                }, 2000);
            } else {
                showAlert(error.response?.data?.detail || 'Có lỗi xảy ra khi đổi mật khẩu', 'error');
            }
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="80vh">
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
        <Container maxWidth="lg" sx={{ py: 4 }}>
            {/* Profile Header */}
            <Paper elevation={3} sx={{ p: 4, mb: 3, background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)' }}>
                <Grid container spacing={3} alignItems="center">
                    <Grid item xs={12} sm="auto">
                        <Avatar
                            sx={{ 
                                width: 100, 
                                height: 100, 
                                border: '4px solid white',
                                boxShadow: '0 0 10px rgba(0,0,0,0.2)'
                            }}
                            alt={`${user?.FirstName} ${user?.LastName}`}
                        />
                    </Grid>
                    <Grid item xs={12} sm>
                        <Box>
                            <Typography variant="h4" component="h1" sx={{ color: 'white', fontWeight: 'bold' }}>
                                {user?.FirstName} {user?.LastName}
                            </Typography>
                            <Typography variant="subtitle1" sx={{ color: 'white', opacity: 0.9 }}>
                                {user?.Email}
                            </Typography>
                            <Box sx={{ mt: 1 }}>
                                <Chip 
                                    label={user?.Status === 'ACTIVE' ? 'Đang hoạt động' : 'Không hoạt động'} 
                                    color={user?.Status === 'ACTIVE' ? 'success' : 'error'}
                                    sx={{ mr: 1 }}
                                />
                                <Chip 
                                    label={user?.role === 'admin' ? 'Quản trị viên' : 
                                          user?.role === 'teacher' ? 'Giáo viên' :
                                          user?.role === 'parent' ? 'Phụ huynh' : 'Học sinh'}
                                    color="primary"
                                />
                            </Box>
                        </Box>
                    </Grid>
                    <Grid item xs={12} sm="auto">
                        <Box sx={{ textAlign: 'right' }}>
                            <Typography variant="body2" sx={{ color: 'white', opacity: 0.9 }}>
                                ID: {user?.UserID}
                            </Typography>
                            <Typography variant="body2" sx={{ color: 'white', opacity: 0.9 }}>
                                Ngày tạo: {new Date(user?.CreatedAt).toLocaleString()}
                            </Typography>
                            <Typography variant="body2" sx={{ color: 'white', opacity: 0.9 }}>
                                Cập nhật: {new Date(user?.UpdatedAt).toLocaleString()}
                            </Typography>
                        </Box>
                    </Grid>
                </Grid>
            </Paper>

            {/* Tabs */}
            <Paper elevation={3} sx={{ mb: 3 }}>
                <Tabs 
                    value={activeTab} 
                    onChange={handleTabChange}
                    variant="fullWidth"
                    sx={{ 
                        borderBottom: 1, 
                        borderColor: 'divider',
                        '& .MuiTab-root': {
                            minHeight: 60,
                        }
                    }}
                >
                    <Tab 
                        icon={<PersonIcon />} 
                        label="Thông tin cá nhân" 
                        iconPosition="start"
                    />
                    <Tab 
                        icon={<SecurityIcon />} 
                        label="Bảo mật" 
                        iconPosition="start"
                    />
                </Tabs>
            </Paper>

            {/* Tab Content */}
            <Box sx={{ mt: 3 }}>
                {activeTab === 0 && (
                    <Paper elevation={3} sx={{ p: 4 }}>
                        <form onSubmit={handleSubmit}>
                            <Grid container spacing={3}>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Họ"
                                        name="FirstName"
                                        value={formData.FirstName}
                                        onChange={handleChange}
                                        error={!!formErrors.FirstName}
                                        helperText={formErrors.FirstName}
                                        required
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Tên"
                                        name="LastName"
                                        value={formData.LastName}
                                        onChange={handleChange}
                                        error={!!formErrors.LastName}
                                        helperText={formErrors.LastName}
                                        required
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Email"
                                        name="Email"
                                        type="email"
                                        value={formData.Email}
                                        onChange={handleChange}
                                        required
                                        disabled
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Đường"
                                        name="Street"
                                        value={formData.Street}
                                        onChange={handleChange}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Quận/Huyện"
                                        name="District"
                                        value={formData.District}
                                        onChange={handleChange}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Thành phố"
                                        name="City"
                                        value={formData.City}
                                        onChange={handleChange}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Số điện thoại"
                                        name="PhoneNumber"
                                        value={formData.PhoneNumber}
                                        onChange={handleChange}
                                        error={!!formErrors.PhoneNumber}
                                        helperText={formErrors.PhoneNumber}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Ngày sinh"
                                        name="DOB"
                                        type="date"
                                        value={formData.DOB}
                                        onChange={handleChange}
                                        error={!!formErrors.DOB}
                                        helperText={formErrors.DOB}
                                        InputLabelProps={{ shrink: true }}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Nơi sinh"
                                        name="PlaceOfBirth"
                                        value={formData.PlaceOfBirth}
                                        onChange={handleChange}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <FormControl fullWidth>
                                        <InputLabel>Giới tính</InputLabel>
                                        <Select
                                            name="Gender"
                                            value={formData.Gender}
                                            onChange={handleChange}
                                            label="Giới tính"
                                        >
                                            <MenuItem value="MALE">Nam</MenuItem>
                                            <MenuItem value="FEMALE">Nữ</MenuItem>
                                            <MenuItem value="OTHER">Khác</MenuItem>
                                        </Select>
                                    </FormControl>
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Địa chỉ"
                                        name="Address"
                                        multiline
                                        rows={3}
                                        value={formData.Address}
                                        onChange={handleChange}
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <Box display="flex" justifyContent="flex-end" mt={2}>
                                        <Button
                                            type="submit"
                                            variant="contained"
                                            color="primary"
                                            size="large"
                                            startIcon={<SaveIcon />}
                                            disabled={loading}
                                        >
                                            {loading ? 'Đang cập nhật...' : 'Cập nhật thông tin'}
                                        </Button>
                                    </Box>
                                </Grid>
                            </Grid>
                        </form>
                    </Paper>
                )}

                {activeTab === 1 && (
                    <Paper elevation={3} sx={{ p: 4 }} ref={passwordSectionRef}>
                        <Typography variant="h6" gutterBottom>
                            Đổi mật khẩu
                        </Typography>
                        <Divider sx={{ mb: 3 }} />
                        <form onSubmit={handleChangePassword}>
                            <Grid container spacing={3}>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Mật khẩu hiện tại"
                                        type="password"
                                        name="currentPassword"
                                        value={passwordData.currentPassword}
                                        onChange={(e) => setPasswordData({ ...passwordData, currentPassword: e.target.value })}
                                        error={!!passwordErrors.currentPassword}
                                        helperText={passwordErrors.currentPassword}
                                        required
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Mật khẩu mới"
                                        type="password"
                                        name="newPassword"
                                        value={passwordData.newPassword}
                                        onChange={(e) => setPasswordData({ ...passwordData, newPassword: e.target.value })}
                                        error={!!passwordErrors.newPassword}
                                        helperText={passwordErrors.newPassword}
                                        required
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <TextField
                                        fullWidth
                                        label="Xác nhận mật khẩu mới"
                                        type="password"
                                        name="confirmPassword"
                                        value={passwordData.confirmPassword}
                                        onChange={(e) => setPasswordData({ ...passwordData, confirmPassword: e.target.value })}
                                        error={!!passwordErrors.confirmPassword}
                                        helperText={passwordErrors.confirmPassword}
                                        required
                                    />
                                </Grid>
                                <Grid item xs={12}>
                                    <Button
                                        type="submit"
                                        variant="contained"
                                        color="primary"
                                        fullWidth
                                        startIcon={<LockIcon />}
                                        disabled={loading}
                                    >
                                        {loading ? 'Đang đổi mật khẩu...' : 'Đổi mật khẩu'}
                                    </Button>
                                </Grid>
                            </Grid>
                        </form>
                    </Paper>
                )}
            </Box>

            <Snackbar
                open={openAlert}
                autoHideDuration={6000}
                onClose={handleCloseAlert}
                anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
                TransitionComponent={SlideTransition}
            >
                <Alert
                    onClose={handleCloseAlert}
                    severity={alertSeverity}
                    variant="filled"
                    sx={{ width: '100%' }}
                >
                    {alertMessage}
                </Alert>
            </Snackbar>
        </Container>
    );
};

export default UserProfile; 