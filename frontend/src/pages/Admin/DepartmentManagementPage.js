import React, { useState, useEffect } from 'react';
import { 
    Box, Typography, Paper, Button, TextField, Dialog, DialogActions, 
    DialogContent, DialogContentText, DialogTitle, Table, TableBody, 
    TableCell, TableContainer, TableHead, TableRow, IconButton, Snackbar, 
    Alert, Divider, Chip, InputAdornment, Tab, Tabs, Tooltip, useTheme,
    alpha, CircularProgress, FormControl, InputLabel, Select, MenuItem, ListItemIcon
} from '@mui/material';
import { 
    Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon,
    PersonAdd as PersonAddIcon, PersonRemove as PersonRemoveIcon,
    Search as SearchIcon, FilterList as FilterListIcon,
    MoreVert as MoreVertIcon, School as SchoolIcon,
    Sort as SortIcon, Business as BusinessIcon
} from '@mui/icons-material';
import departmentService from '../../services/departmentService';
import userService from '../../services/userService';

const DepartmentManagementPage = () => {
    const theme = useTheme();
    // State for departments
    const [departments, setDepartments] = useState([]);
    const [filteredDepartments, setFilteredDepartments] = useState([]);
    const [availableTeachers, setAvailableTeachers] = useState([]);
    const [loading, setLoading] = useState(true);
    
    // Search & Filter states
    const [searchQuery, setSearchQuery] = useState('');
    const [tabValue, setTabValue] = useState(0);
    
    // Form states
    const [openDepartmentDialog, setOpenDepartmentDialog] = useState(false);
    const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
    const [openTeacherDialog, setOpenTeacherDialog] = useState(false);
    const [currentDepartment, setCurrentDepartment] = useState(null);
    const [selectedTeacherId, setSelectedTeacherId] = useState('');
    const [formData, setFormData] = useState({
        DepartmentName: '',
        Description: ''
    });
    
    // Notification state
    const [notification, setNotification] = useState({
        open: false,
        message: '',
        severity: 'success'
    });

    // Fetch departments on component mount
    useEffect(() => {
        fetchDepartments();
        fetchAvailableTeachers();
    }, []);
    
    // Filter departments when search query changes
    useEffect(() => {
        if (!departments.length) {
            setFilteredDepartments([]);
            return;
        }
        
        const filtered = departments.filter(dept => 
            dept.DepartmentName.toLowerCase().includes(searchQuery.toLowerCase()) ||
            (dept.Description && dept.Description.toLowerCase().includes(searchQuery.toLowerCase())) ||
            (dept.teachers && dept.teachers.some(teacher => 
                `${teacher.FirstName} ${teacher.LastName}`.toLowerCase().includes(searchQuery.toLowerCase())
            ))
        );
        
        const sorted = [...filtered].sort((a, b) => {
            // Sort by tab selection
            if (tabValue === 1) { // Sort by teacher count
                return (b.teachers?.length || 0) - (a.teachers?.length || 0);
            } else if (tabValue === 2) { // Sort alphabetically
                return a.DepartmentName.localeCompare(b.DepartmentName);
            }
            return 0; // Default no sorting (All)
        });
        
        setFilteredDepartments(sorted);
    }, [departments, searchQuery, tabValue]);

    // Handle tab change
    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    // Fetch departments from API
    const fetchDepartments = async () => {
        setLoading(true);
        try {
            const data = await departmentService.getAllDepartments();
            setDepartments(data);
            setFilteredDepartments(data);
        } catch (error) {
            showNotification('Không thể tải danh sách phòng ban', 'error');
        } finally {
            setLoading(false);
        }
    };

    // Fetch available teachers
    const fetchAvailableTeachers = async () => {
        try {
            const users = await userService.getAllUsers();
            // Filter teachers
            const teachers = users.filter(user => user.role === 'teacher');
            setAvailableTeachers(teachers);
        } catch (error) {
            showNotification('Không thể tải danh sách giáo viên', 'error');
        }
    };

    // Handle opening department dialog for create/edit
    const handleOpenDepartmentDialog = (department = null) => {
        if (department) {
            setFormData({
                DepartmentName: department.DepartmentName,
                Description: department.Description || ''
            });
            setCurrentDepartment(department);
        } else {
            setFormData({
                DepartmentName: '',
                Description: ''
            });
            setCurrentDepartment(null);
        }
        setOpenDepartmentDialog(true);
    };

    // Handle closing department dialog
    const handleCloseDepartmentDialog = () => {
        setOpenDepartmentDialog(false);
    };

    // Handle form input change
    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value
        });
    };

    // Handle save department
    const handleSaveDepartment = async () => {
        try {
            if (currentDepartment) {
                // Update existing department
                await departmentService.updateDepartment(currentDepartment.DepartmentID, formData);
                showNotification('Cập nhật phòng ban thành công', 'success');
            } else {
                // Create new department
                await departmentService.createDepartment(formData);
                showNotification('Tạo phòng ban mới thành công', 'success');
            }
            handleCloseDepartmentDialog();
            fetchDepartments();
        } catch (error) {
            showNotification(
                currentDepartment 
                    ? 'Không thể cập nhật phòng ban' 
                    : 'Không thể tạo phòng ban mới',
                'error'
            );
        }
    };

    // Handle delete department
    const handleDeleteDepartment = (department) => {
        setCurrentDepartment(department);
        setOpenDeleteDialog(true);
    };

    // Confirm delete department
    const confirmDeleteDepartment = async () => {
        try {
            await departmentService.deleteDepartment(currentDepartment.DepartmentID);
            showNotification('Xóa phòng ban thành công', 'success');
            fetchDepartments();
        } catch (error) {
            showNotification('Không thể xóa phòng ban', 'error');
        } finally {
            setOpenDeleteDialog(false);
        }
    };

    // Open add teacher dialog
    const handleOpenTeacherDialog = (department) => {
        setCurrentDepartment(department);
        setSelectedTeacherId('');
        setOpenTeacherDialog(true);
    };

    // Add teacher to department
    const handleAddTeacherToDepartment = async () => {
        if (!selectedTeacherId || !currentDepartment) {
            showNotification('Vui lòng chọn giáo viên', 'error');
            return;
        }

        try {
            await departmentService.addTeacherToDepartment(
                currentDepartment.DepartmentID, 
                parseInt(selectedTeacherId)
            );
            showNotification('Thêm giáo viên vào phòng ban thành công', 'success');
            fetchDepartments();
            setOpenTeacherDialog(false);
        } catch (error) {
            showNotification('Không thể thêm giáo viên vào phòng ban', 'error');
        }
    };

    // Remove teacher from department
    const handleRemoveTeacherFromDepartment = async (departmentId, teacherId) => {
        try {
            await departmentService.removeTeacherFromDepartment(departmentId, teacherId);
            showNotification('Xóa giáo viên khỏi phòng ban thành công', 'success');
            fetchDepartments();
        } catch (error) {
            showNotification('Không thể xóa giáo viên khỏi phòng ban', 'error');
        }
    };

    // Show notification
    const showNotification = (message, severity) => {
        setNotification({
            open: true,
            message,
            severity
        });
    };

    // Close notification
    const handleCloseNotification = () => {
        setNotification({
            ...notification,
            open: false
        });
    };

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" component="h1" gutterBottom sx={{ mb: 3 }}>
                <BusinessIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                Quản lý Phòng Ban
            </Typography>

            <Paper sx={{ mb: 2 }}>
                <Tabs value={tabValue} onChange={handleTabChange} variant="scrollable" scrollButtons="auto">
                    <Tab icon={<BusinessIcon />} iconPosition="start" label="Tất cả" />
                    <Tab icon={<PersonAddIcon />} iconPosition="start" label="Theo số giáo viên" />
                    <Tab icon={<SortIcon />} iconPosition="start" label="A-Z" />
                </Tabs>
            </Paper>

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <TextField 
                    label="Tìm kiếm (Tên phòng ban, Mô tả, Giáo viên)"
                    variant="outlined"
                    size="small"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    sx={{ width: { xs: '100%', sm: '400px' } }}
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        ),
                    }}
                />
                <Button 
                    variant="contained"
                    startIcon={<AddIcon />}
                    onClick={() => handleOpenDepartmentDialog()}
                >
                    Thêm Phòng Ban
                </Button>
            </Box>

            <TableContainer component={Paper}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>ID</TableCell>
                            <TableCell>Tên phòng ban</TableCell>
                            <TableCell>Mô tả</TableCell>
                            <TableCell>Số lượng giáo viên</TableCell>
                            <TableCell>Giáo viên</TableCell>
                            <TableCell>Thao tác</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loading ? (
                            <TableRow>
                                <TableCell colSpan={6} align="center">
                                    <CircularProgress size={30} sx={{ my: 2 }} />
                                </TableCell>
                            </TableRow>
                        ) : filteredDepartments.length > 0 ? (
                            filteredDepartments.map((department) => (
                                <TableRow key={department.DepartmentID}>
                                    <TableCell>{department.DepartmentID}</TableCell>
                                    <TableCell>
                                        <Typography variant="body1" fontWeight="medium">
                                            {department.DepartmentName}
                                        </Typography>
                                    </TableCell>
                                    <TableCell>{department.Description || 'Không có mô tả'}</TableCell>
                                    <TableCell>{department.teachers?.length || 0}</TableCell>
                                    <TableCell>
                                        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, maxWidth: 350 }}>
                                            {department.teachers?.length > 0 ? (
                                                department.teachers.map((teacher) => (
                                                    <Chip
                                                        key={teacher.UserID}
                                                        size="small"
                                                        label={`${teacher.FirstName} ${teacher.LastName}`}
                                                        onDelete={() => handleRemoveTeacherFromDepartment(department.DepartmentID, teacher.UserID)}
                                                        sx={{ 
                                                            m: 0.2,
                                                            bgcolor: alpha(theme.palette.primary.main, 0.1)
                                                        }}
                                                    />
                                                ))
                                            ) : (
                                                <Typography variant="body2" color="text.secondary">
                                                    Chưa có giáo viên
                                                </Typography>
                                            )}
                                        </Box>
                                    </TableCell>
                                    <TableCell>
                                        <Tooltip title="Thêm giáo viên">
                                            <IconButton
                                                color="primary"
                                                onClick={() => handleOpenTeacherDialog(department)}
                                            >
                                                <PersonAddIcon />
                                            </IconButton>
                                        </Tooltip>
                                        <Tooltip title="Chỉnh sửa">
                                            <IconButton
                                                color="secondary"
                                                onClick={() => handleOpenDepartmentDialog(department)}
                                            >
                                                <EditIcon />
                                            </IconButton>
                                        </Tooltip>
                                        <Tooltip title="Xóa">
                                            <IconButton
                                                color="error"
                                                onClick={() => handleDeleteDepartment(department)}
                                            >
                                                <DeleteIcon />
                                            </IconButton>
                                        </Tooltip>
                                    </TableCell>
                                </TableRow>
                            ))
                        ) : (
                            <TableRow>
                                <TableCell colSpan={6} align="center">
                                    {searchQuery ? (
                                        <Box sx={{ py: 3 }}>
                                            <Typography variant="body1" gutterBottom>
                                                Không tìm thấy phòng ban nào phù hợp với từ khóa "{searchQuery}"
                                            </Typography>
                                            <Button 
                                                variant="text" 
                                                onClick={() => setSearchQuery('')}
                                                sx={{ mt: 1 }}
                                            >
                                                Xóa tìm kiếm
                                            </Button>
                                        </Box>
                                    ) : (
                                        <Box sx={{ py: 3 }}>
                                            <SchoolIcon sx={{ fontSize: 40, color: 'text.secondary', opacity: 0.5, mb: 1 }} />
                                            <Typography variant="body1" gutterBottom>
                                                Chưa có phòng ban nào. Hãy thêm phòng ban mới.
                                            </Typography>
                                            <Button 
                                                variant="contained" 
                                                startIcon={<AddIcon />}
                                                onClick={() => handleOpenDepartmentDialog()}
                                                sx={{ mt: 1 }}
                                            >
                                                Thêm phòng ban mới
                                            </Button>
                                        </Box>
                                    )}
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            {/* Department Dialog */}
            <Dialog open={openDepartmentDialog} onClose={handleCloseDepartmentDialog} maxWidth="sm" fullWidth>
                <DialogTitle>
                    {currentDepartment ? 'Chỉnh sửa Phòng Ban' : 'Thêm Phòng Ban Mới'}
                </DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        name="DepartmentName"
                        label="Tên Phòng Ban"
                        fullWidth
                        variant="outlined"
                        value={formData.DepartmentName}
                        onChange={handleInputChange}
                        required
                        sx={{ mb: 2, mt: 1 }}
                    />
                    <TextField
                        margin="dense"
                        name="Description"
                        label="Mô tả"
                        fullWidth
                        variant="outlined"
                        value={formData.Description}
                        onChange={handleInputChange}
                        multiline
                        rows={3}
                        placeholder="Nhập mô tả về phòng ban này..."
                    />
                </DialogContent>
                <DialogActions sx={{ px: 3, pb: 2 }}>
                    <Button onClick={handleCloseDepartmentDialog}>Hủy</Button>
                    <Button 
                        onClick={handleSaveDepartment} 
                        variant="contained" 
                        disabled={!formData.DepartmentName.trim()}
                    >
                        {currentDepartment ? 'Cập nhật' : 'Tạo mới'}
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Delete Confirmation Dialog */}
            <Dialog open={openDeleteDialog} onClose={() => setOpenDeleteDialog(false)}>
                <DialogTitle sx={{ color: theme.palette.error.main }}>
                    Xác nhận xóa
                </DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        Bạn có chắc chắn muốn xóa phòng ban <strong>"{currentDepartment?.DepartmentName}"</strong> không?
                        <br /><br />
                        Hành động này sẽ gỡ bỏ tất cả giáo viên khỏi phòng ban này và không thể hoàn tác.
                    </DialogContentText>
                </DialogContent>
                <DialogActions sx={{ px: 3, pb: 2 }}>
                    <Button onClick={() => setOpenDeleteDialog(false)}>Hủy</Button>
                    <Button 
                        onClick={confirmDeleteDepartment} 
                        variant="contained" 
                        color="error"
                    >
                        Xóa
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Add Teacher Dialog */}
            <Dialog open={openTeacherDialog} onClose={() => setOpenTeacherDialog(false)} maxWidth="sm" fullWidth>
                <DialogTitle>
                    Thêm Giáo Viên vào Phòng Ban
                </DialogTitle>
                <DialogContent>
                    <DialogContentText gutterBottom sx={{ mb: 2, mt: 1 }}>
                        Chọn giáo viên để thêm vào phòng ban <strong>"{currentDepartment?.DepartmentName}"</strong>
                    </DialogContentText>
                    <FormControl fullWidth>
                        <InputLabel>Chọn Giáo Viên</InputLabel>
                        <Select
                            value={selectedTeacherId}
                            label="Chọn Giáo Viên"
                            onChange={(e) => setSelectedTeacherId(e.target.value)}
                        >
                            <MenuItem value=""><em>-- Chọn giáo viên --</em></MenuItem>
                            {availableTeachers.map((teacher) => (
                                <MenuItem key={teacher.UserID} value={teacher.UserID}>
                                    {teacher.FirstName} {teacher.LastName} ({teacher.Email})
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </DialogContent>
                <DialogActions sx={{ px: 3, pb: 2 }}>
                    <Button onClick={() => setOpenTeacherDialog(false)}>Hủy</Button>
                    <Button 
                        onClick={handleAddTeacherToDepartment} 
                        variant="contained" 
                        color="primary"
                        disabled={!selectedTeacherId}
                    >
                        Thêm
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Notifications */}
            <Snackbar 
                open={notification.open} 
                autoHideDuration={4000} 
                onClose={handleCloseNotification}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert 
                    onClose={handleCloseNotification} 
                    severity={notification.severity}
                    variant="filled"
                    sx={{ width: '100%' }}
                >
                    {notification.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default DepartmentManagementPage; 