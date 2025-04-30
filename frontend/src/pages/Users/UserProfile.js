import React, { useState, useEffect } from 'react';
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
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { Edit as EditIcon, Save as SaveIcon, Lock as LockIcon } from '@mui/icons-material';
import userService from '../../services/userService';
import authService from '../../services/authService';

const UserProfile = () => {
    const navigate = useNavigate();
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [success, setSuccess] = useState(null);
    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        dob: '',
        placeOfBirth: '',
        gender: '',
        address: '',
    });
    const [passwordData, setPasswordData] = useState({
        currentPassword: '',
        newPassword: '',
        confirmPassword: '',
    });

    useEffect(() => {
        fetchUserData();
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
            console.log('API Response:', response);

            if (response) {
                const userData = response;
                console.log('User Data:', userData);
                setUser(userData);
                setFormData({
                    firstName: userData.FirstName || '',
                    lastName: userData.LastName || '',
                    email: userData.Email || '',
                    phoneNumber: userData.PhoneNumber || '',
                    dob: userData.DOB ? new Date(userData.DOB).toISOString().split('T')[0] : '',
                    placeOfBirth: userData.PlaceOfBirth || '',
                    gender: userData.Gender || '',
                    address: userData.Address || '',
                });
            } else {
                console.error('Invalid response:', response);
                setError('Không thể tải thông tin người dùng: Dữ liệu không hợp lệ');
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

    const handleUpdateProfile = async (e) => {
        e.preventDefault();
        try {
            setLoading(true);
            const response = await userService.updateUser(user.UserID, {
                FirstName: formData.firstName,
                LastName: formData.lastName,
                Email: formData.email,
                PhoneNumber: formData.phoneNumber,
                DOB: formData.dob,
                PlaceOfBirth: formData.placeOfBirth,
                Gender: formData.gender,
                Address: formData.address,
            });

            if (response && response.data) {
                setUser(response.data);
                setSuccess('Cập nhật thông tin thành công');
                setTimeout(() => setSuccess(null), 3000);
            }
        } catch (error) {
            console.error('Error updating profile:', error);
            if (error.response?.status === 401) {
                setError('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại');
                setTimeout(() => {
                    authService.logout();
                    navigate('/login');
                }, 2000);
            } else {
                setError(error.response?.data?.detail || 'Có lỗi xảy ra khi cập nhật thông tin');
            }
        } finally {
            setLoading(false);
        }
    };

    const handleChangePassword = async (e) => {
        e.preventDefault();
        if (passwordData.newPassword !== passwordData.confirmPassword) {
            setError('Mật khẩu mới không khớp');
            return;
        }

        try {
            setLoading(true);
            const response = await userService.changePassword({
                currentPassword: passwordData.currentPassword,
                newPassword: passwordData.newPassword,
            });

            if (response && response.data) {
                setSuccess('Đổi mật khẩu thành công');
                setPasswordData({
                    currentPassword: '',
                    newPassword: '',
                    confirmPassword: '',
                });
                setTimeout(() => setSuccess(null), 3000);
            }
        } catch (error) {
            console.error('Error changing password:', error);
            if (error.response?.status === 401) {
                setError('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại');
                setTimeout(() => {
                    authService.logout();
                    navigate('/login');
                }, 2000);
            } else {
                setError(error.response?.data?.detail || 'Có lỗi xảy ra khi đổi mật khẩu');
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
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="80vh">
                <Alert severity="error">{error}</Alert>
            </Box>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Grid container spacing={3}>
                {/* Profile Header */}
                <Grid item xs={12}>
                    <Paper elevation={3} sx={{ p: 4, mb: 3, background: 'linear-gradient(45deg, #2196F3 30%, #21CBF3 90%)' }}>
                        <Box display="flex" alignItems="center" justifyContent="space-between">
                            <Box display="flex" alignItems="center">
                                <Avatar
                                    sx={{ 
                                        width: 100, 
                                        height: 100, 
                                        mr: 3,
                                        border: '4px solid white',
                                        boxShadow: '0 0 10px rgba(0,0,0,0.2)'
                                    }}
                                    alt={`${user?.FirstName} ${user?.LastName}`}
                                />
                                <Box>
                                    <Typography variant="h4" component="h1" sx={{ color: 'white', fontWeight: 'bold' }}>
                                        {user?.FirstName} {user?.LastName}
                                    </Typography>
                                    <Typography variant="subtitle1" sx={{ color: 'white', opacity: 0.9 }}>
                                        {user?.Email}
                                    </Typography>
                                </Box>
                            </Box>
                            <Box>
                                <Typography variant="body2" sx={{ color: 'white', opacity: 0.9 }}>
                                    ID: {user?.UserID}
                                </Typography>
                                <Typography variant="body2" sx={{ color: 'white', opacity: 0.9 }}>
                                    Trạng thái: {user?.Status === 'ACTIVE' ? 'Đang hoạt động' : 'Không hoạt động'}
                                </Typography>
                            </Box>
                        </Box>
                    </Paper>
                </Grid>

                {/* Main Content */}
                <Grid item xs={12} md={8}>
                    <Card elevation={3}>
                        <CardHeader
                            title="Thông tin cá nhân"
                            action={
                                <Tooltip title="Lưu thông tin">
                                    <IconButton color="primary" onClick={handleUpdateProfile} disabled={loading}>
                                        <SaveIcon />
                                    </IconButton>
                                </Tooltip>
                            }
                        />
                        <CardContent>
                            {success && (
                                <Alert severity="success" sx={{ mb: 2 }}>
                                    {success}
                                </Alert>
                            )}
                            <form>
                                <Grid container spacing={3}>
                                    <Grid item xs={12} sm={6}>
                                        <TextField
                                            fullWidth
                                            label="Họ"
                                            value={formData.firstName}
                                            onChange={(e) => setFormData({ ...formData, firstName: e.target.value })}
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <TextField
                                            fullWidth
                                            label="Tên"
                                            value={formData.lastName}
                                            onChange={(e) => setFormData({ ...formData, lastName: e.target.value })}
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Email"
                                            type="email"
                                            value={formData.email}
                                            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Số điện thoại"
                                            value={formData.phoneNumber}
                                            onChange={(e) => setFormData({ ...formData, phoneNumber: e.target.value })}
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <TextField
                                            fullWidth
                                            label="Ngày sinh"
                                            type="date"
                                            value={formData.dob}
                                            onChange={(e) => setFormData({ ...formData, dob: e.target.value })}
                                            InputLabelProps={{ shrink: true }}
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <TextField
                                            fullWidth
                                            label="Nơi sinh"
                                            value={formData.placeOfBirth}
                                            onChange={(e) => setFormData({ ...formData, placeOfBirth: e.target.value })}
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <FormControl fullWidth variant="outlined">
                                            <InputLabel>Giới tính</InputLabel>
                                            <Select
                                                value={formData.gender}
                                                label="Giới tính"
                                                onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
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
                                            multiline
                                            rows={3}
                                            value={formData.address}
                                            onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                                            variant="outlined"
                                        />
                                    </Grid>
                                </Grid>
                            </form>
                        </CardContent>
                    </Card>
                </Grid>

                {/* Password Change Section */}
                <Grid item xs={12} md={4}>
                    <Card elevation={3}>
                        <CardHeader
                            title="Đổi mật khẩu"
                            avatar={<LockIcon color="primary" />}
                        />
                        <CardContent>
                            <form onSubmit={handleChangePassword}>
                                <Grid container spacing={2}>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Mật khẩu hiện tại"
                                            type="password"
                                            value={passwordData.currentPassword}
                                            onChange={(e) =>
                                                setPasswordData({ ...passwordData, currentPassword: e.target.value })
                                            }
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Mật khẩu mới"
                                            type="password"
                                            value={passwordData.newPassword}
                                            onChange={(e) =>
                                                setPasswordData({ ...passwordData, newPassword: e.target.value })
                                            }
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <TextField
                                            fullWidth
                                            label="Xác nhận mật khẩu mới"
                                            type="password"
                                            value={passwordData.confirmPassword}
                                            onChange={(e) =>
                                                setPasswordData({ ...passwordData, confirmPassword: e.target.value })
                                            }
                                            required
                                            variant="outlined"
                                        />
                                    </Grid>
                                    <Grid item xs={12}>
                                        <Button
                                            type="submit"
                                            variant="contained"
                                            color="primary"
                                            fullWidth
                                            disabled={loading}
                                            startIcon={<LockIcon />}
                                        >
                                            Đổi mật khẩu
                                        </Button>
                                    </Grid>
                                </Grid>
                            </form>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
        </Container>
    );
};

export default UserProfile; 