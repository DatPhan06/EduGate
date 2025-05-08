import React, { useState, useEffect, useCallback } from 'react';
import {
    Box, Typography, Paper, Tab, Tabs, Button, TextField, Grid, CircularProgress, 
    Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton,
    Dialog, DialogActions, DialogContent, DialogTitle, FormControl, InputLabel, Select, MenuItem,
    Snackbar, Alert, Chip, Autocomplete, List, ListItem, ListItemText, ListItemSecondaryAction, Divider
} from '@mui/material';
import {
    Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon, PeopleAlt as PeopleAltIcon,
    AdminPanelSettings as AdminIcon, School as SchoolIcon, Face as ParentIcon, Person as GenericUserIcon
} from '@mui/icons-material';
import userService, {
    linkParentToStudent, unlinkParentFromStudent, getStudentParents, getParentStudents 
} from '../../services/userService';

const UserManagementPage = () => {
    const [tabValue, setTabValue] = useState(0); // 0: All, 1: Admin, 2: Teacher, 3: Student, 4: Parent
    const [users, setUsers] = useState([]);
    const [departments, setDepartments] = useState([]);
    const [classes, setClasses] = useState([]);
    const [allParents, setAllParents] = useState([]); // For parent selection dropdown
    const [linkedParents, setLinkedParents] = useState([]); // Parents linked to current student in dialog
    const [selectedParentToLink, setSelectedParentToLink] = useState(null); // For Autocomplete

    // Loading states
    const [loadingUsers, setLoadingUsers] = useState(false);
    const [loadingAuxData, setLoadingAuxData] = useState(false);
    const [loadingParents, setLoadingParents] = useState(false);
    const [linkingParent, setLinkingParent] = useState(false);

    // Dialog states
    const [openUserDialog, setOpenUserDialog] = useState(false);
    const [dialogMode, setDialogMode] = useState('add'); // 'add' or 'edit'
    const [currentUser, setCurrentUser] = useState(null); // Holds data for add/edit form

    // Snackbar
    const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });

    // Filter/Search state
    const [searchTerm, setSearchTerm] = useState('');

    const roles = ['all', 'admin', 'teacher', 'student', 'parent'];
    const currentRoleFilter = roles[tabValue] === 'all' ? null : roles[tabValue];

    // --- Helper Functions ---
    const showErrorSnackbar = (message) => {
        setSnackbar({ open: true, message: message || 'Đã xảy ra lỗi', severity: 'error' });
    };
    const showSuccessSnackbar = (message) => {
        setSnackbar({ open: true, message, severity: 'success' });
    };
    const handleCloseSnackbar = () => {
        setSnackbar({ ...snackbar, open: false });
    };

    // --- Data Fetching ---
    const fetchAllParents = useCallback(async () => {
        setLoadingParents(true);
        try {
            const data = await userService.getUsers({ role: 'parent', limit: 1000 }); // Fetch all parents
            setAllParents(data || []);
        } catch (error) { /* handle error */ }
        finally { setLoadingParents(false); }
    }, []);

    const fetchAuxData = useCallback(async () => {
        setLoadingAuxData(true);
        try {
            const [deptData, classData, parentData] = await Promise.all([
                userService.getDepartments(),
                userService.getClasses(),
                userService.getUsers({ role: 'parent', limit: 1000 }) // Fetch all parents here too
            ]);
            setDepartments(deptData || []);
            setClasses(classData.map(c => ({ id: c.ClassID, name: c.ClassName })) || []);
            setAllParents(parentData || []);
        } catch (error) {
            showErrorSnackbar('Lỗi tải dữ liệu phòng ban, lớp học hoặc phụ huynh.');
        } finally {
            setLoadingAuxData(false);
        }
    }, []);

    const fetchUsers = useCallback(async () => {
        setLoadingUsers(true);
        try {
            const params = {
                role: currentRoleFilter,
                search: searchTerm,
                limit: 100,
                skip: 0
            };
            const data = await userService.getUsers(params);
            setUsers(data || []);
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách người dùng.');
            setUsers([]);
        } finally {
            setLoadingUsers(false);
        }
    }, [currentRoleFilter, searchTerm]);

    useEffect(() => {
        fetchAuxData();
    }, [fetchAuxData]);

    useEffect(() => {
        fetchUsers();
    }, [fetchUsers]); // Re-fetch when filter or search term changes

    // --- Handlers ---
    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    const handleSearchChange = (event) => {
        setSearchTerm(event.target.value);
    };

    const handleUserChange = (event) => {
        const { name, value } = event.target;
        setCurrentUser(prev => {
            if (!prev) return null; // Should not happen if dialog is open
            const newState = { ...prev, [name]: value };
            // Reset role-specific fields if role changes in add mode
            if (dialogMode === 'add' && name === 'role') {
                if (value !== 'student') newState.ClassID = '';
                if (value !== 'teacher' && value !== 'admin') newState.DepartmentID = '';
                if (value !== 'teacher') {
                    newState.Graduate = '';
                    newState.Degree = '';
                    // Keep Position separate as admin might use it
                }
                if (value !== 'admin' && value !== 'teacher') {
                    newState.Position = '';
                }
                if (value !== 'parent') newState.Occupation = '';
            }
            return newState;
        });
    };

    const handleOpenDialog = async (mode, user = null) => {
        setDialogMode(mode);
        setLinkedParents([]); // Reset linked parents list

        if (mode === 'edit' && user) {
            // Basic user data
            const userData = {
                UserID: user.UserID,
                FirstName: user.FirstName || '', LastName: user.LastName || '', Email: user.Email || '',
                PhoneNumber: user.PhoneNumber || '', DOB: user.DOB ? new Date(user.DOB).toISOString().split('T')[0] : null,
                Gender: user.Gender || '', Address: user.Address || '', Street: user.Street || '',
                District: user.District || '', City: user.City || '', Status: user.Status || 'ACTIVE',
                role: user.role || '', ClassID: user.ClassID ?? '', DepartmentID: user.DepartmentID ?? '',
                Graduate: user.Graduate ?? '', Degree: user.Degree ?? '', Position: user.Position ?? '',
                Occupation: user.Occupation ?? ''
            };
            setCurrentUser(userData);

            // If editing a student, fetch their linked parents
            if (user.role === 'student') {
                try {
                    setLoadingParents(true); // Use loadingParents for this specific fetch
                    const parents = await userService.getStudentParents(user.UserID);
                    setLinkedParents(parents || []);
                } catch (error) {
                    showErrorSnackbar('Lỗi tải danh sách phụ huynh liên kết.');
                } finally {
                    setLoadingParents(false);
                }
            }
             // TODO: If editing a parent, fetch their linked students (optional)

        } else { // Add mode
             setCurrentUser({
                FirstName: '', LastName: '', Email: '', Password: '', role: 'student', 
                Status: 'ACTIVE', PhoneNumber: '', DOB: null, Gender: '',
                Address: '', Street: '', District: '', City: '',
                ClassID: '', DepartmentID: '', Graduate: '', Degree: '', Position: '', Occupation: ''
            });
        }
        setOpenUserDialog(true);
    };

    const handleCloseDialog = () => {
        setOpenUserDialog(false);
        setCurrentUser(null);
    };

    const handleSaveUser = async () => {
        if (!currentUser || !currentUser.Email || !currentUser.FirstName || !currentUser.LastName || !currentUser.role) {
            showErrorSnackbar('Vui lòng điền thông tin bắt buộc (Họ, Tên, Email, Vai trò).');
            return;
        }
        if (dialogMode === 'add' && !currentUser.Password) {
             showErrorSnackbar('Vui lòng nhập Mật khẩu cho người dùng mới.');
            return;
        }

        // Construct base payload matching UserBase fields
        const payload = {
            FirstName: currentUser.FirstName,
            LastName: currentUser.LastName,
            Email: currentUser.Email,
            PhoneNumber: currentUser.PhoneNumber || null,
            DOB: currentUser.DOB ? new Date(currentUser.DOB).toISOString() : null,
            Gender: currentUser.Gender || null,
            Address: currentUser.Address || null,
            Street: currentUser.Street || null,
            District: currentUser.District || null,
            City: currentUser.City || null,
            Status: currentUser.Status,
            role: currentUser.role,
        };

        // Add role-specific fields ONLY if they are relevant to the selected role
        if (currentUser.role === 'student') {
            payload.ClassID = currentUser.ClassID ? Number(currentUser.ClassID) : null;
        }
        if (currentUser.role === 'teacher') {
            payload.DepartmentID = currentUser.DepartmentID ? Number(currentUser.DepartmentID) : null;
            payload.Graduate = currentUser.Graduate || null;
            payload.Degree = currentUser.Degree || null;
            payload.Position = currentUser.Position || null;
        }
        if (currentUser.role === 'parent') {
            payload.Occupation = currentUser.Occupation || null;
        }
        if (currentUser.role === 'admin') {
            payload.DepartmentID = currentUser.DepartmentID ? Number(currentUser.DepartmentID) : null;
            payload.Position = currentUser.Position || null;
        }

        try {
            if (dialogMode === 'add') {
                payload.Password = currentUser.Password;
                await userService.createUser(payload);
                showSuccessSnackbar('Thêm người dùng thành công!');
            } else {
                await userService.updateUser(currentUser.UserID, payload); 
                showSuccessSnackbar('Cập nhật người dùng thành công!');
            }
            fetchUsers();
            handleCloseDialog();
        } catch (error) {
            console.error("Save User Error:", error.response || error);
            // Attempt to parse validation errors nicely
            let errorDetail = 'Thao tác thất bại!';
            if (error.response?.data?.detail) {
                const detail = error.response.data.detail;
                if (Array.isArray(detail)) {
                    errorDetail = detail.map(err => `${err.loc.slice(-1)[0]}: ${err.msg}`).join('; ');
                } else if (typeof detail === 'string') {
                    errorDetail = detail;
                }
            }
            showErrorSnackbar(errorDetail);
        }
    };

    const handleDeleteUser = async (userId) => {
        if (window.confirm(`Bạn có chắc chắn muốn xóa người dùng ID: ${userId}?`)) {
            try {
                await userService.deleteUser(userId);
                showSuccessSnackbar('Đã xóa người dùng!');
                fetchUsers();
            } catch (error) {
                showErrorSnackbar(error.response?.data?.detail || 'Lỗi xóa người dùng!');
            }
        }
    };

    // Handler to link selected parent to the current student in the dialog
    const handleLinkParent = async () => {
        if (!selectedParentToLink || !currentUser || currentUser.role !== 'student') {
            showErrorSnackbar('Vui lòng chọn một phụ huynh hợp lệ để liên kết.');
            return;
        }
        setLinkingParent(true);
        try {
            await userService.linkParentToStudent(currentUser.UserID, selectedParentToLink.UserID);
            showSuccessSnackbar(`Đã liên kết phụ huynh ${selectedParentToLink.FirstName} ${selectedParentToLink.LastName}.`);
            // Refresh linked parents list
            const parents = await userService.getStudentParents(currentUser.UserID);
            setLinkedParents(parents || []);
            setSelectedParentToLink(null); // Reset autocomplete
        } catch (error) {
             showErrorSnackbar(error.response?.data?.detail || 'Lỗi liên kết phụ huynh.');
        } finally {
            setLinkingParent(false);
        }
    };

    // Handler to unlink a parent
    const handleUnlinkParent = async (parentUserId) => {
         if (!currentUser || currentUser.role !== 'student') return;
         if (window.confirm(`Bạn có chắc muốn bỏ liên kết phụ huynh ID: ${parentUserId}?`)) {
             try {
                 await userService.unlinkParentFromStudent(currentUser.UserID, parentUserId);
                 showSuccessSnackbar('Đã bỏ liên kết phụ huynh.');
                 // Refresh linked parents list
                 setLinkedParents(prev => prev.filter(p => p.UserID !== parentUserId));
             } catch (error) {
                 showErrorSnackbar(error.response?.data?.detail || 'Lỗi bỏ liên kết phụ huynh.');
             }
         }
    };

    // --- Render Logic ---
    const renderRoleSpecificFields = () => {
        if (!currentUser) return null;
        const role = currentUser.role;

        return (
            <>
                {role === 'student' && (
                    <Grid item xs={12} sm={6}>
                        <FormControl fullWidth>
                            <InputLabel>Lớp</InputLabel>
                            <Select name="ClassID" value={currentUser.ClassID || ''} label="Lớp" onChange={handleUserChange}>
                                <MenuItem value=""><em>Không chọn / Thôi học</em></MenuItem>
                                {classes.map((c) => <MenuItem key={c.id} value={c.id}>{c.name}</MenuItem>)}
                            </Select>
                        </FormControl>
                    </Grid>
                )}
                {(role === 'teacher' || role === 'admin') && (
                    <Grid item xs={12} sm={6}>
                        <FormControl fullWidth required={(role === 'teacher' && currentUser.DepartmentID === '') || (role === 'admin' && currentUser.DepartmentID === '')}>
                            <InputLabel>Phòng ban</InputLabel>
                            <Select name="DepartmentID" value={currentUser.DepartmentID || ''} label="Phòng ban" onChange={handleUserChange}>
                                <MenuItem value=""><em>Không chọn</em></MenuItem>
                                {departments.map((d) => <MenuItem key={d.DepartmentID} value={d.DepartmentID}>{d.Name}</MenuItem>)}
                            </Select>
                        </FormControl>
                    </Grid>
                )}
                {role === 'teacher' && (
                    <>
                        <Grid item xs={12} sm={6}><TextField fullWidth label="Tốt nghiệp (Trường)" name="Graduate" value={currentUser.Graduate || ''} onChange={handleUserChange} /></Grid>
                        <Grid item xs={12} sm={6}><TextField fullWidth label="Bằng cấp" name="Degree" value={currentUser.Degree || ''} onChange={handleUserChange} /></Grid>
                    </>
                )}
                 {(role === 'teacher' || role === 'admin') && (
                      <Grid item xs={12} sm={6}><TextField fullWidth label="Chức vụ" name="Position" value={currentUser.Position || ''} onChange={handleUserChange} /></Grid>
                 )}
                {role === 'parent' && (
                    <Grid item xs={12} sm={6}><TextField fullWidth label="Nghề nghiệp" name="Occupation" value={currentUser.Occupation || ''} onChange={handleUserChange} /></Grid>
                )}
            </>
        );
    };

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" component="h1" gutterBottom sx={{ mb: 3 }}>
                <PeopleAltIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                Quản lý Người dùng
            </Typography>

            <Paper sx={{ mb: 2 }}>
                 <Tabs value={tabValue} onChange={handleTabChange} centered variant="scrollable" scrollButtons="auto">
                    <Tab icon={<GenericUserIcon />} iconPosition="start" label="Tất cả" />
                    <Tab icon={<AdminIcon />} iconPosition="start" label="Quản trị viên" />
                    <Tab icon={<SchoolIcon />} iconPosition="start" label="Giáo viên" />
                    <Tab icon={<SchoolIcon />} iconPosition="start" label="Học sinh" />
                    <Tab icon={<ParentIcon />} iconPosition="start" label="Phụ huynh" />
                </Tabs>
            </Paper>

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <TextField 
                    label="Tìm kiếm (Tên, Email)"
                    variant="outlined"
                    size="small"
                    value={searchTerm}
                    onChange={handleSearchChange}
                    sx={{ width: { xs: '100%', sm: '400px' } }}
                />
                <Button 
                    variant="contained"
                    startIcon={<AddIcon />}
                    onClick={() => handleOpenDialog('add')}
                    sx={{ mt: { xs: 1, sm: 0 } }}
                >
                    Thêm Người dùng
                </Button>
            </Box>

            {/* User Table */} 
            <TableContainer component={Paper} sx={{ maxHeight: 600 }}> {/* Added max height */} 
                <Table stickyHeader>
                    <TableHead>
                        <TableRow>
                            <TableCell>ID</TableCell>
                            <TableCell>Họ tên</TableCell>
                            <TableCell>Email</TableCell>
                            <TableCell>Vai trò</TableCell>
                            <TableCell>Trạng thái</TableCell>
                            <TableCell align="right">Thao tác</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loadingUsers || loadingAuxData ? (
                            <TableRow><TableCell colSpan={6} align="center"><CircularProgress size={24} sx={{my: 2}} /></TableCell></TableRow>
                        ) : users.length > 0 ? (
                            users.map((user) => (
                                <TableRow key={user.UserID} hover>
                                    <TableCell>{user.UserID}</TableCell>
                                    <TableCell>{`${user.FirstName || ''} ${user.LastName || ''}`.trim()}</TableCell>
                                    <TableCell>{user.Email}</TableCell>
                                    <TableCell><Chip label={user.role || 'N/A'} size="small" variant="outlined"/></TableCell>
                                    <TableCell><Chip label={user.Status || 'N/A'} size="small" color={user.Status === 'ACTIVE' ? 'success' : 'default'} variant={user.Status === 'ACTIVE' ? 'filled' : 'outlined'}/></TableCell>
                                    <TableCell align="right">
                                        <IconButton size="small" color="secondary" onClick={() => handleOpenDialog('edit', user)} title="Chỉnh sửa">
                                            <EditIcon fontSize="small"/>
                                        </IconButton>
                                        <IconButton size="small" color="error" onClick={() => handleDeleteUser(user.UserID)} title="Xóa">
                                            <DeleteIcon fontSize="small"/>
                                        </IconButton>
                                    </TableCell>
                                </TableRow>
                            ))
                        ) : (
                            <TableRow><TableCell colSpan={6} align="center">Không tìm thấy người dùng nào.</TableCell></TableRow>
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            {/* User Add/Edit Dialog */} 
            {currentUser && (
                <Dialog open={openUserDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
                    <DialogTitle>{dialogMode === 'add' ? 'Thêm Người dùng mới' : `Chỉnh sửa Người dùng ID: ${currentUser.UserID}`}</DialogTitle>
                    <DialogContent>
                        <Grid container spacing={2} sx={{ mt: 1 }}>
                            {/* Common Fields */}
                            <Grid item xs={12} sm={6}><TextField InputLabelProps={{ shrink: true }} fullWidth label="Họ" name="FirstName" value={currentUser.FirstName} onChange={handleUserChange} required /></Grid>
                            <Grid item xs={12} sm={6}><TextField InputLabelProps={{ shrink: true }} fullWidth label="Tên" name="LastName" value={currentUser.LastName} onChange={handleUserChange} required /></Grid>
                            <Grid item xs={12}><TextField InputLabelProps={{ shrink: true }} fullWidth label="Email" name="Email" value={currentUser.Email} onChange={handleUserChange} required type="email"/></Grid>
                            {dialogMode === 'add' && (
                                <Grid item xs={12}><TextField InputLabelProps={{ shrink: true }} fullWidth label="Mật khẩu" name="Password" value={currentUser.Password || ''} onChange={handleUserChange} required type="password"/></Grid>
                            )}
                            <Grid item xs={12} sm={6}><TextField InputLabelProps={{ shrink: true }} fullWidth label="SĐT" name="PhoneNumber" value={currentUser.PhoneNumber || ''} onChange={handleUserChange} /></Grid>
                            <Grid item xs={12} sm={6}>
                               <TextField InputLabelProps={{ shrink: true }} fullWidth label="Ngày sinh" name="DOB" type="date" value={currentUser.DOB || ''} onChange={handleUserChange} />
                            </Grid>
                             <Grid item xs={12} sm={6}>
                                <FormControl fullWidth>
                                    <InputLabel>Giới tính</InputLabel>
                                    <Select name="Gender" value={currentUser.Gender || ''} label="Giới tính" onChange={handleUserChange}>
                                        <MenuItem value=""><em>Không chọn</em></MenuItem>
                                        <MenuItem value="MALE">Nam</MenuItem>
                                        <MenuItem value="FEMALE">Nữ</MenuItem>
                                        <MenuItem value="OTHER">Khác</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                             <Grid item xs={12} sm={6}>
                                <FormControl fullWidth required>
                                    <InputLabel>Vai trò</InputLabel>
                                    <Select name="role" value={currentUser.role || ''} label="Vai trò" onChange={handleUserChange} required disabled={dialogMode === 'edit'}>
                                        {roles.filter(r => r !== 'all').map(r => (
                                            <MenuItem key={r} value={r}>{r.charAt(0).toUpperCase() + r.slice(1)}</MenuItem>
                                        ))}
                                    </Select>
                                </FormControl>
                            </Grid>
                            <Grid item xs={12}><TextField InputLabelProps={{ shrink: true }} fullWidth label="Địa chỉ" name="Address" value={currentUser.Address || ''} onChange={handleUserChange} helperText="VD: 123 Đường ABC, Phường X, Quận Y"/></Grid>
                            {/* Street/District/City are separate fields in user model, can add if needed */}
                             <Grid item xs={12} sm={6}>
                                <FormControl fullWidth>
                                    <InputLabel>Trạng thái</InputLabel>
                                    <Select name="Status" value={currentUser.Status || 'ACTIVE'} label="Trạng thái" onChange={handleUserChange}>
                                        <MenuItem value="ACTIVE">Hoạt động</MenuItem>
                                        <MenuItem value="INACTIVE">Không hoạt động</MenuItem>
                                        <MenuItem value="SUSPENDED">Bị đình chỉ</MenuItem>
                                    </Select>
                                </FormControl>
                            </Grid>
                            
                            {/* Role Specific Fields - Rendered dynamically */} 
                            {renderRoleSpecificFields()}

                            {currentUser && currentUser.role === 'student' && dialogMode === 'edit' && (
                                <Grid item xs={12}>
                                    <Divider sx={{ my: 2 }}><Chip label="Quản lý Phụ huynh Liên kết" /></Divider>
                                    <Typography variant="subtitle1" gutterBottom>Phụ huynh Hiện tại:</Typography>
                                    {loadingParents ? (
                                        <CircularProgress size={20} />
                                    ) : linkedParents.length > 0 ? (
                                        <List dense>
                                            {linkedParents.map(parent => (
                                                <ListItem key={parent.UserID} secondaryAction={
                                                    <IconButton edge="end" aria-label="delete" size="small" onClick={() => handleUnlinkParent(parent.UserID)}>
                                                        <DeleteIcon fontSize="small" color="error" />
                                                    </IconButton>
                                                }>
                                                    <ListItemText primary={`${parent.FirstName} ${parent.LastName}`} secondary={parent.Email} />
                                                </ListItem>
                                            ))}
                                        </List>
                                    ) : (
                                        <Typography variant="body2" color="text.secondary">Chưa có phụ huynh nào được liên kết.</Typography>
                                    )}

                                    <Typography variant="subtitle1" gutterBottom sx={{ mt: 2 }}>Thêm Liên kết Phụ huynh:</Typography>
                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <Autocomplete
                                            options={allParents.filter(p => !linkedParents.some(lp => lp.UserID === p.UserID))} // Exclude already linked parents
                                            getOptionLabel={(option) => `${option.FirstName} ${option.LastName} (${option.Email})`}
                                            value={selectedParentToLink}
                                            onChange={(event, newValue) => {
                                                setSelectedParentToLink(newValue);
                                            }}
                                            isOptionEqualToValue={(option, value) => option.UserID === value.UserID}
                                            renderInput={(params) => <TextField {...params} label="Chọn Phụ huynh" size="small" />}
                                            sx={{ flexGrow: 1 }}
                                            disabled={linkingParent}
                                            size="small"
                                        />
                                        <Button 
                                            variant="outlined" 
                                            size="small" 
                                            onClick={handleLinkParent}
                                            disabled={!selectedParentToLink || linkingParent}
                                        >
                                            {linkingParent ? <CircularProgress size={20}/> : "Liên kết"}
                                        </Button>
                                    </Box>
                                </Grid>
                            )}

                        </Grid>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseDialog}>Hủy</Button>
                        <Button onClick={handleSaveUser} variant="contained" color="primary">{dialogMode === 'add' ? 'Thêm' : 'Lưu'}</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Snackbar */} 
            <Snackbar open={snackbar.open} autoHideDuration={6000} onClose={handleCloseSnackbar} anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}>
                <Alert onClose={handleCloseSnackbar} severity={snackbar.severity} variant="filled">
                    {snackbar.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default UserManagementPage; 