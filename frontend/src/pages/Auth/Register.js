import React, { useState } from 'react';
import { useNavigate, Link as RouterLink } from 'react-router-dom';
import {
    Container,
    Box,
    Typography,
    TextField,
    Button,
    Link,
    Paper,
    Alert,
    Grid,
    FormControl,
    InputLabel,
    Select,
    MenuItem
} from '@mui/material';
import authService from '../../services/authService';

const Register = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        FirstName: '',
        LastName: '',
        Email: '',
        Password: '',
        ConfirmPassword: '',
        PhoneNumber: '',
        DOB: '',
        PlaceOfBirth: '',
        Gender: null,
        Address: '',
        Status: 'ACTIVE',
        role: 'parent'
    });
    const [error, setError] = useState('');
    const [validationErrors, setValidationErrors] = useState({});

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value === '' ? null : value
        }));
        // Clear validation error when user types
        if (validationErrors[name]) {
            setValidationErrors(prev => ({
                ...prev,
                [name]: ''
            }));
        }
    };

    const validateForm = () => {
        const errors = {};
        if (!formData.FirstName.trim()) {
            errors.FirstName = 'Họ là bắt buộc';
        }
        if (!formData.LastName.trim()) {
            errors.LastName = 'Tên là bắt buộc';
        }
        if (!formData.Email.trim()) {
            errors.Email = 'Email là bắt buộc';
        } else if (!/\S+@\S+\.\S+/.test(formData.Email)) {
            errors.Email = 'Email không hợp lệ';
        }
        if (!formData.Password) {
            errors.Password = 'Mật khẩu là bắt buộc';
        } else if (formData.Password.length < 6) {
            errors.Password = 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        if (formData.Password !== formData.ConfirmPassword) {
            errors.ConfirmPassword = 'Mật khẩu không khớp';
        }
        setValidationErrors(errors);
        return Object.keys(errors).length === 0;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        
        if (!validateForm()) {
            return;
        }

        try {
            // Format data before sending
            const formattedData = {
                FirstName: formData.FirstName.trim(),
                LastName: formData.LastName.trim(),
                Email: formData.Email.trim(),
                Password: formData.Password,
                PhoneNumber: formData.PhoneNumber.trim() || null,
                DOB: formData.DOB ? new Date(formData.DOB).toISOString() : null,
                PlaceOfBirth: formData.PlaceOfBirth.trim() || null,
                Gender: formData.Gender === '' ? null : formData.Gender,
                Address: formData.Address.trim() || null,
                Status: formData.Status,
                role: formData.role
            };
            
            await authService.register(formattedData);
            navigate('/login');
        } catch (err) {
            console.error('Registration error:', err);
            setError(err.message || 'Đăng ký thất bại');
        }
    };

    return (
        <Container component="main" maxWidth="sm">
            <Box
                sx={{
                    marginTop: 8,
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                }}
            >
                <Paper elevation={3} sx={{ p: 4, width: '100%' }}>
                    <Typography component="h1" variant="h5" align="center" gutterBottom>
                        Đăng ký tài khoản
                    </Typography>
                    {error && (
                        <Alert severity="error" sx={{ mb: 2 }}>
                            {error}
                        </Alert>
                    )}
                    <Box component="form" onSubmit={handleSubmit} noValidate>
                        <Grid container spacing={2}>
                            <Grid item xs={12} sm={6}>
                                <TextField
                                    required
                                    fullWidth
                                    label="Họ"
                                    name="FirstName"
                                    value={formData.FirstName}
                                    onChange={handleChange}
                                    error={!!validationErrors.FirstName}
                                    helperText={validationErrors.FirstName}
                                />
                            </Grid>
                            <Grid item xs={12} sm={6}>
                                <TextField
                                    required
                                    fullWidth
                                    label="Tên"
                                    name="LastName"
                                    value={formData.LastName}
                                    onChange={handleChange}
                                    error={!!validationErrors.LastName}
                                    helperText={validationErrors.LastName}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    required
                                    fullWidth
                                    label="Email"
                                    name="Email"
                                    type="email"
                                    value={formData.Email}
                                    onChange={handleChange}
                                    error={!!validationErrors.Email}
                                    helperText={validationErrors.Email}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    fullWidth
                                    label="Số điện thoại"
                                    name="PhoneNumber"
                                    value={formData.PhoneNumber}
                                    onChange={handleChange}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <FormControl fullWidth required>
                                    <InputLabel>Vai trò</InputLabel>
                                    <Select
                                        name="role"
                                        value={formData.role}
                                        onChange={handleChange}
                                        label="Vai trò"
                                    >
                                        <MenuItem value="parent">Phụ huynh</MenuItem>
                                        <MenuItem value="teacher">Giáo viên</MenuItem>
                                        <MenuItem value="student">Học sinh</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    fullWidth
                                    label="Mật khẩu"
                                    name="Password"
                                    type="password"
                                    value={formData.Password}
                                    onChange={handleChange}
                                    error={!!validationErrors.Password}
                                    helperText={validationErrors.Password}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    fullWidth
                                    label="Xác nhận mật khẩu"
                                    name="ConfirmPassword"
                                    type="password"
                                    value={formData.ConfirmPassword}
                                    onChange={handleChange}
                                    error={!!validationErrors.ConfirmPassword}
                                    helperText={validationErrors.ConfirmPassword}
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    fullWidth
                                    label="Ngày sinh"
                                    name="DOB"
                                    type="date"
                                    InputLabelProps={{ shrink: true }}
                                    value={formData.DOB}
                                    onChange={handleChange}
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
                                <TextField
                                    fullWidth
                                    label="Giới tính"
                                    name="Gender"
                                    select
                                    SelectProps={{ native: true }}
                                    value={formData.Gender || ''}
                                    onChange={handleChange}
                                >
                                    <option value="">Chọn giới tính</option>
                                    <option value="MALE">Nam</option>
                                    <option value="FEMALE">Nữ</option>
                                    <option value="OTHER">Khác</option>
                                </TextField>
                            </Grid>
                            <Grid item xs={12}>
                                <TextField
                                    fullWidth
                                    label="Địa chỉ"
                                    name="Address"
                                    multiline
                                    rows={2}
                                    value={formData.Address}
                                    onChange={handleChange}
                                />
                            </Grid>
                        </Grid>
                        <Button
                            type="submit"
                            fullWidth
                            variant="contained"
                            sx={{ mt: 3, mb: 2 }}
                        >
                            Đăng ký
                        </Button>
                        <Box sx={{ textAlign: 'center' }}>
                            <Link component={RouterLink} to="/login" variant="body2">
                                Đã có tài khoản? Đăng nhập ngay
                            </Link>
                        </Box>
                    </Box>
                </Paper>
            </Box>
        </Container>
    );
};

export default Register; 