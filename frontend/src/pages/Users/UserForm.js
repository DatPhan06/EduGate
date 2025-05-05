import React, { useState, useEffect } from 'react';
import {
    Box,
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    TextField,
    MenuItem,
    Grid,
    FormControl,
    InputLabel,
    Select
} from '@mui/material';
import userService from '../../services/userService';

const UserForm = ({ open, handleClose, user, onSuccess }) => {
    const [formData, setFormData] = useState({
        FirstName: '',
        LastName: '',
        Email: '',
        Password: '',
        Street: '',
        District: '',
        City: '',
        PhoneNumber: '',
        DOB: '',
        PlaceOfBirth: '',
        Gender: 'MALE',
        Address: '',
        Status: 'ACTIVE',
        role: 'student',
        // Student specific fields
        ClassID: '',
        YtDate: '',
        // Teacher specific fields
        DepartmentID: '',
        Graduate: '',
        Degree: '',
        Position: '',
        // Parent specific fields
        Occupation: '',
    });

    useEffect(() => {
        if (user) {
            setFormData({
                FirstName: user.FirstName || '',
                LastName: user.LastName || '',
                Email: user.Email || '',
                Password: '',
                Street: user.Street || '',
                District: user.District || '',
                City: user.City || '',
                PhoneNumber: user.PhoneNumber || '',
                DOB: user.DOB ? new Date(user.DOB).toISOString().split('T')[0] : '',
                PlaceOfBirth: user.PlaceOfBirth || '',
                Gender: user.Gender || 'MALE',
                Address: user.Address || '',
                Status: user.Status || 'ACTIVE',
                role: user.role || 'student',
                // Role-specific fields
                ClassID: user.student?.ClassID || '',
                YtDate: user.student?.YtDate ? new Date(user.student.YtDate).toISOString().split('T')[0] : '',
                DepartmentID: user.teacher?.DepartmentID || user.administrative_staff?.DepartmentID || '',
                Graduate: user.teacher?.Graduate || '',
                Degree: user.teacher?.Degree || '',
                Position: user.teacher?.Position || user.administrative_staff?.Position || '',
                Occupation: user.parent?.Occupation || '',
            });
        } else {
            setFormData({
                FirstName: '',
                LastName: '',
                Email: '',
                Password: '',
                Street: '',
                District: '',
                City: '',
                PhoneNumber: '',
                DOB: '',
                PlaceOfBirth: '',
                Gender: 'MALE',
                Address: '',
                Status: 'ACTIVE',
                role: 'student',
                // Role-specific fields
                ClassID: '',
                YtDate: '',
                DepartmentID: '',
                Graduate: '',
                Degree: '',
                Position: '',
                Occupation: '',
            });
        }
    }, [user]);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            // Prepare data for submission
            const submitData = { ...formData };
            
            // Format empty and numeric fields properly
            if (submitData.ClassID === '') submitData.ClassID = null;
            if (submitData.DepartmentID === '') submitData.DepartmentID = null;
            if (submitData.YtDate === '') submitData.YtDate = null;
            if (submitData.Gender === '') submitData.Gender = null;
            
            // Convert numeric strings to numbers if not empty
            if (submitData.ClassID !== null && submitData.ClassID !== '') {
                submitData.ClassID = parseInt(submitData.ClassID, 10);
            }
            if (submitData.DepartmentID !== null && submitData.DepartmentID !== '') {
                submitData.DepartmentID = parseInt(submitData.DepartmentID, 10);
            }
            
            if (user) {
                await userService.updateUser(user.UserID, submitData);
            } else {
                await userService.createUser(submitData);
            }
            onSuccess();
            handleClose();
        } catch (error) {
            console.error('Error saving user:', error);
            console.error('Error response:', error.response?.data);
            // TODO: Add error handling/notification
        }
    };

    return (
        <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
            <DialogTitle>{user ? 'Edit User' : 'Add New User'}</DialogTitle>
            <form onSubmit={handleSubmit}>
                <DialogContent>
                    <Grid container spacing={2}>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Email"
                                name="Email"
                                value={formData.Email}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Password"
                                name="Password"
                                type="password"
                                value={formData.Password}
                                onChange={handleChange}
                                required={!user}
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="First Name"
                                name="FirstName"
                                value={formData.FirstName}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={6}>
                            <TextField
                                fullWidth
                                label="Last Name"
                                name="LastName"
                                value={formData.LastName}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <FormControl fullWidth>
                                <InputLabel>Role</InputLabel>
                                <Select
                                    name="role"
                                    value={formData.role}
                                    onChange={handleChange}
                                    required
                                >
                                    <MenuItem value="admin">Admin</MenuItem>
                                    <MenuItem value="teacher">Teacher</MenuItem>
                                    <MenuItem value="student">Student</MenuItem>
                                    <MenuItem value="parent">Parent</MenuItem>
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs={6}>
                            <FormControl fullWidth>
                                <InputLabel>Gender</InputLabel>
                                <Select
                                    name="Gender"
                                    value={formData.Gender}
                                    onChange={handleChange}
                                    required
                                >
                                    <MenuItem value="MALE">Male</MenuItem>
                                    <MenuItem value="FEMALE">Female</MenuItem>
                                    <MenuItem value="OTHER">Other</MenuItem>
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs={6}>
                            <FormControl fullWidth>
                                <InputLabel>Status</InputLabel>
                                <Select
                                    name="Status"
                                    value={formData.Status}
                                    onChange={handleChange}
                                    required
                                >
                                    <MenuItem value="ACTIVE">Active</MenuItem>
                                    <MenuItem value="INACTIVE">Inactive</MenuItem>
                                </Select>
                            </FormControl>
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Street"
                                name="Street"
                                value={formData.Street}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="District"
                                name="District"
                                value={formData.District}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="City"
                                name="City"
                                value={formData.City}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Phone Number"
                                name="PhoneNumber"
                                value={formData.PhoneNumber}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Date of Birth"
                                name="DOB"
                                type="date"
                                value={formData.DOB}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Place of Birth"
                                name="PlaceOfBirth"
                                value={formData.PlaceOfBirth}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                label="Address"
                                name="Address"
                                value={formData.Address}
                                onChange={handleChange}
                                required
                            />
                        </Grid>
                        {/* General information fields */}
                        
                        {/* Role-specific fields */}
                        {formData.role === 'student' && (
                            <>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Lớp"
                                        name="ClassID"
                                        value={formData.ClassID}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Ngày chuyển trường"
                                        name="YtDate"
                                        type="date"
                                        value={formData.YtDate}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                        InputLabelProps={{ shrink: true }}
                                    />
                                </Grid>
                            </>
                        )}
                        
                        {formData.role === 'teacher' && (
                            <>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Phòng ban"
                                        name="DepartmentID"
                                        value={formData.DepartmentID}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Trình độ học vấn"
                                        name="Graduate"
                                        value={formData.Graduate}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Bằng cấp"
                                        name="Degree"
                                        value={formData.Degree}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Chức vụ"
                                        name="Position"
                                        value={formData.Position}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                            </>
                        )}
                        
                        {formData.role === 'parent' && (
                            <Grid item xs={12} md={6}>
                                <TextField
                                    fullWidth
                                    label="Nghề nghiệp"
                                    name="Occupation"
                                    value={formData.Occupation}
                                    onChange={handleChange}
                                    variant="outlined"
                                    margin="normal"
                                />
                            </Grid>
                        )}

                        {formData.role === 'admin' && (
                            <>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Phòng ban"
                                        name="DepartmentID"
                                        value={formData.DepartmentID}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <TextField
                                        fullWidth
                                        label="Chức vụ"
                                        name="Position"
                                        value={formData.Position}
                                        onChange={handleChange}
                                        variant="outlined"
                                        margin="normal"
                                    />
                                </Grid>
                            </>
                        )}
                    </Grid>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleClose}>Cancel</Button>
                    <Button type="submit" variant="contained" color="primary">
                        {user ? 'Update' : 'Create'}
                    </Button>
                </DialogActions>
            </form>
        </Dialog>
    );
};

export default UserForm; 