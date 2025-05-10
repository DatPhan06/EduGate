import React, { useState, useEffect, useCallback } from 'react';
import {
  Box, Typography, Container, Paper, Tabs, Tab, Button, TextField, Grid,
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton,
  Dialog, DialogActions, DialogContent, DialogTitle, DialogContentText,
  FormControl, InputLabel, Select, MenuItem, Chip, Alert, CircularProgress,
  Snackbar, List, ListItem, ListItemText, ListItemSecondaryAction, Divider,
  Card, CardContent, CardActions, Tooltip, Stack
} from '@mui/material';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider, DateTimePicker } from '@mui/x-date-pickers';
import {
  Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon, Event as EventIcon,
  Upload as UploadIcon, AttachFile as AttachFileIcon, Description as DescriptionIcon,
  Schedule as ScheduleIcon, Category as CategoryIcon, Refresh as RefreshIcon,
  CloudDownload as DownloadIcon
} from '@mui/icons-material';
import { format } from 'date-fns';
import vi from 'date-fns/locale/vi';
import eventService from '../../services/eventService';
import authService from '../../services/authService';

const EventManagementPage = () => {
  // State cho danh sách sự kiện
  const [events, setEvents] = useState([]);
  const [selectedEvent, setSelectedEvent] = useState(null);
  const [loading, setLoading] = useState(false);
  const [refreshTrigger, setRefreshTrigger] = useState(0);

  // State cho việc phân trang và tìm kiếm
  const [search, setSearch] = useState('');
  const [eventType, setEventType] = useState('');
  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);

  // State cho dialog
  const [openDialog, setOpenDialog] = useState(false);
  const [dialogMode, setDialogMode] = useState('add'); // 'add', 'edit', 'view', 'delete', 'upload'
  const [eventFiles, setEventFiles] = useState([]);
  const [selectedFile, setSelectedFile] = useState(null);

  // State cho form dữ liệu
  const [formData, setFormData] = useState({
    Title: '',
    Type: '',
    Content: '',
    EventDate: new Date()
  });

  // State cho thông báo
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: '',
    severity: 'info'
  });

  // Các loại sự kiện
  const eventTypes = [
    { value: 'school', label: 'Sự kiện toàn trường' },
    { value: 'academic', label: 'Học thuật' },
    { value: 'activity', label: 'Hoạt động ngoại khóa' },
    { value: 'competition', label: 'Cuộc thi' },
    { value: 'announcement', label: 'Thông báo' },
    { value: 'other', label: 'Khác' }
  ];

  // Lấy danh sách sự kiện
  const fetchEvents = useCallback(async () => {
    setLoading(true);
    try {
      const params = {};
      if (search) params.search = search;
      if (eventType) params.event_type = eventType;
      if (startDate) params.start_date = startDate.toISOString();
      if (endDate) params.end_date = endDate.toISOString();

      const response = await eventService.getEvents(params);
      setEvents(response.data || []);
    } catch (error) {
      console.error('Error fetching events:', error);
      showSnackbar('Lỗi khi tải danh sách sự kiện', 'error');
    } finally {
      setLoading(false);
    }
  }, [search, eventType, startDate, endDate]);

  // Load danh sách sự kiện khi component mount hoặc khi refreshTrigger thay đổi
  useEffect(() => {
    fetchEvents();
  }, [fetchEvents, refreshTrigger]);

  // Kiểm tra quyền admin
  const [isAdmin, setIsAdmin] = useState(false);
  useEffect(() => {
    const checkAdminRole = () => {
      const user = authService.getCurrentUser();
      if (user && user.role === 'admin') {
        setIsAdmin(true);
      } else {
        setIsAdmin(false);
        showSnackbar('Bạn không có quyền truy cập trang này', 'error');
      }
    };
    checkAdminRole();
  }, []);

  // Hiển thị thông báo
  const showSnackbar = (message, severity = 'info') => {
    setSnackbar({
      open: true,
      message,
      severity
    });
  };

  // Reset form
  const resetForm = () => {
    setFormData({
      Title: '',
      Type: '',
      Content: '',
      EventDate: new Date()
    });
    setSelectedFile(null);
  };

  // Mở dialog để thêm sự kiện mới
  const handleAddEvent = () => {
    setDialogMode('add');
    resetForm();
    setOpenDialog(true);
  };

  // Mở dialog để chỉnh sửa sự kiện
  const handleEditEvent = (event) => {
    setDialogMode('edit');
    setSelectedEvent(event);
    setFormData({
      Title: event.Title,
      Type: event.Type,
      Content: event.Content || '',
      EventDate: new Date(event.EventDate)
    });
    setOpenDialog(true);
  };

  // Mở dialog để xem chi tiết sự kiện
  const handleViewEvent = async (event) => {
    setDialogMode('view');
    setSelectedEvent(event);
    setFormData({
      Title: event.Title,
      Type: event.Type,
      Content: event.Content || '',
      EventDate: new Date(event.EventDate)
    });
    
    try {
      // Lấy danh sách file của sự kiện
      const files = await eventService.getEventFiles(event.EventID);
      setEventFiles(files || []);
    } catch (error) {
      console.error('Error fetching event files:', error);
      showSnackbar('Lỗi khi tải danh sách file đính kèm', 'error');
    }
    
    setOpenDialog(true);
  };

  // Mở dialog để xác nhận xóa sự kiện
  const handleDeleteConfirm = (event) => {
    setDialogMode('delete');
    setSelectedEvent(event);
    setOpenDialog(true);
  };

  // Mở dialog để tải lên file đính kèm
  const handleUploadFile = (event) => {
    setDialogMode('upload');
    setSelectedEvent(event);
    setSelectedFile(null);
    setOpenDialog(true);
  };

  // Xử lý khi đóng dialog
  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedEvent(null);
    resetForm();
  };

  // Xử lý thay đổi trong form
  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  // Xử lý thay đổi ngày sự kiện
  const handleDateChange = (newDate) => {
    setFormData({
      ...formData,
      EventDate: newDate
    });
  };

  // Xử lý khi chọn file
  const handleFileChange = (e) => {
    if (e.target.files[0]) {
      setSelectedFile(e.target.files[0]);
    }
  };

  // Xử lý lưu form (thêm/sửa sự kiện)
  const handleSaveEvent = async () => {
    try {
      if (dialogMode === 'add') {
        // Thêm sự kiện mới
        await eventService.createEvent(formData);
        showSnackbar('Thêm sự kiện thành công', 'success');
      } else if (dialogMode === 'edit') {
        // Cập nhật sự kiện
        await eventService.updateEvent(selectedEvent.EventID, formData);
        showSnackbar('Cập nhật sự kiện thành công', 'success');
      }
      
      // Đóng dialog và làm mới danh sách
      handleCloseDialog();
      setRefreshTrigger(prev => prev + 1);
    } catch (error) {
      console.error('Error saving event:', error);
      showSnackbar('Lỗi khi lưu sự kiện', 'error');
    }
  };

  // Xử lý xóa sự kiện
  const handleDeleteEvent = async () => {
    try {
      await eventService.deleteEvent(selectedEvent.EventID);
      showSnackbar('Xóa sự kiện thành công', 'success');
      handleCloseDialog();
      setRefreshTrigger(prev => prev + 1);
    } catch (error) {
      console.error('Error deleting event:', error);
      showSnackbar('Lỗi khi xóa sự kiện', 'error');
    }
  };

  // Xử lý tải lên file đính kèm
  const handleUploadSubmit = async () => {
    if (!selectedFile) {
      showSnackbar('Vui lòng chọn file để tải lên', 'warning');
      return;
    }
    
    try {
      await eventService.uploadEventFile(selectedEvent.EventID, selectedFile);
      showSnackbar('Tải lên file thành công', 'success');
      handleCloseDialog();
      setRefreshTrigger(prev => prev + 1);
    } catch (error) {
      console.error('Error uploading file:', error);
      showSnackbar('Lỗi khi tải lên file', 'error');
    }
  };

  // Xử lý xóa file đính kèm
  const handleDeleteFile = async (fileId) => {
    if (window.confirm('Bạn có chắc chắn muốn xóa file này không?')) {
      try {
        await eventService.deleteEventFile(selectedEvent.EventID, fileId);
        // Cập nhật lại danh sách file
        const updatedFiles = eventFiles.filter(file => file.FileID !== fileId);
        setEventFiles(updatedFiles);
        showSnackbar('Xóa file thành công', 'success');
      } catch (error) {
        console.error('Error deleting file:', error);
        showSnackbar('Lỗi khi xóa file', 'error');
      }
    }
  };

  // Xử lý tải xuống file đính kèm
  const handleDownloadFile = async (fileId, fileName) => {
    try {
      await eventService.downloadEventFile(selectedEvent.EventID, fileId, fileName);
      showSnackbar('Tải xuống file thành công', 'success');
    } catch (error) {
      console.error('Error downloading file:', error);
      showSnackbar('Lỗi khi tải xuống file', 'error');
    }
  };

  // Hiển thị loại sự kiện
  const displayEventType = (type) => {
    const eventType = eventTypes.find(et => et.value === type);
    return eventType ? eventType.label : type;
  };

  return (
    <Container maxWidth="xl">
      {!isAdmin ? (
        <Alert severity="error" sx={{ mt: 2 }}>
          Bạn không có quyền truy cập trang này
        </Alert>
      ) : (
        <Box sx={{ mt: 3, mb: 5 }}>
          <Typography variant="h4" component="h1" gutterBottom>
            Quản lý Sự kiện Trường học
          </Typography>

          {/* Thanh công cụ và tìm kiếm */}
          <Paper sx={{ p: 2, mb: 3 }}>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} md={3}>
                <TextField
                  fullWidth
                  label="Tìm kiếm theo tiêu đề"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  variant="outlined"
                  size="small"
                />
              </Grid>
              <Grid item xs={12} md={2}>
                <FormControl fullWidth size="small">
                  <InputLabel>Loại sự kiện</InputLabel>
                  <Select
                    value={eventType}
                    onChange={(e) => setEventType(e.target.value)}
                    label="Loại sự kiện"
                  >
                    <MenuItem value="">Tất cả</MenuItem>
                    {eventTypes.map((type) => (
                      <MenuItem key={type.value} value={type.value}>
                        {type.label}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid item xs={12} md={2}>
                <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
                  <DateTimePicker
                    label="Từ ngày"
                    value={startDate}
                    onChange={setStartDate}
                    slotProps={{ textField: { size: 'small', fullWidth: true } }}
                  />
                </LocalizationProvider>
              </Grid>
              <Grid item xs={12} md={2}>
                <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
                  <DateTimePicker
                    label="Đến ngày"
                    value={endDate}
                    onChange={setEndDate}
                    slotProps={{ textField: { size: 'small', fullWidth: true } }}
                  />
                </LocalizationProvider>
              </Grid>
              <Grid item xs={6} md={1}>
                <Button
                  fullWidth
                  variant="outlined"
                  onClick={() => {
                    setSearch('');
                    setEventType('');
                    setStartDate(null);
                    setEndDate(null);
                  }}
                >
                  Đặt lại
                </Button>
              </Grid>
              <Grid item xs={6} md={1}>
                <Button
                  fullWidth
                  variant="contained"
                  onClick={fetchEvents}
                  startIcon={<RefreshIcon />}
                >
                  Lọc
                </Button>
              </Grid>
              <Grid item xs={12} md={1}>
                <Button
                  fullWidth
                  variant="contained"
                  color="primary"
                  startIcon={<AddIcon />}
                  onClick={handleAddEvent}
                >
                  Thêm
                </Button>
              </Grid>
            </Grid>
          </Paper>

          {/* Danh sách sự kiện */}
          <Paper sx={{ width: '100%', overflow: 'hidden' }}>
            {loading ? (
              <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}>
                <CircularProgress />
              </Box>
            ) : events.length === 0 ? (
              <Box sx={{ p: 3, textAlign: 'center' }}>
                <Typography variant="body1">Không có sự kiện nào</Typography>
              </Box>
            ) : (
              <TableContainer sx={{ maxHeight: 600 }}>
                <Table stickyHeader>
                  <TableHead>
                    <TableRow>
                      <TableCell width="5%">ID</TableCell>
                      <TableCell width="20%">Tiêu đề</TableCell>
                      <TableCell width="15%">Loại</TableCell>
                      <TableCell width="20%">Ngày sự kiện</TableCell>
                      <TableCell width="15%">Ngày tạo</TableCell>
                      <TableCell width="25%" align="center">Thao tác</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {events.map((event) => (
                      <TableRow key={event.EventID} hover>
                        <TableCell>{event.EventID}</TableCell>
                        <TableCell>{event.Title}</TableCell>
                        <TableCell>
                          <Chip 
                            label={displayEventType(event.Type)} 
                            size="small"
                            color={event.Type === 'school' ? 'primary' : 
                                  event.Type === 'academic' ? 'secondary' : 
                                  event.Type === 'activity' ? 'success' : 
                                  event.Type === 'competition' ? 'warning' : 'default'}
                          />
                        </TableCell>
                        <TableCell>{format(new Date(event.EventDate), 'dd/MM/yyyy HH:mm')}</TableCell>
                        <TableCell>{format(new Date(event.CreatedAt), 'dd/MM/yyyy')}</TableCell>
                        <TableCell align="center">
                          <Stack direction="row" spacing={1} justifyContent="center">
                            <Tooltip title="Xem chi tiết">
                              <IconButton 
                                color="primary" 
                                size="small"
                                onClick={() => handleViewEvent(event)}
                              >
                                <DescriptionIcon />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Chỉnh sửa">
                              <IconButton 
                                color="secondary" 
                                size="small"
                                onClick={() => handleEditEvent(event)}
                              >
                                <EditIcon />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Tải lên file">
                              <IconButton 
                                color="success" 
                                size="small"
                                onClick={() => handleUploadFile(event)}
                              >
                                <UploadIcon />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Xóa">
                              <IconButton 
                                color="error" 
                                size="small"
                                onClick={() => handleDeleteConfirm(event)}
                              >
                                <DeleteIcon />
                              </IconButton>
                            </Tooltip>
                          </Stack>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            )}
          </Paper>

          {/* Dialog thêm/sửa sự kiện */}
          <Dialog open={openDialog && ['add', 'edit'].includes(dialogMode)} onClose={handleCloseDialog} maxWidth="md" fullWidth>
            <DialogTitle>
              {dialogMode === 'add' ? 'Thêm sự kiện mới' : 'Chỉnh sửa sự kiện'}
            </DialogTitle>
            <DialogContent>
              <Grid container spacing={2} sx={{ mt: 1 }}>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="Tiêu đề"
                    name="Title"
                    value={formData.Title}
                    onChange={handleFormChange}
                    required
                  />
                </Grid>
                <Grid item xs={12} md={6}>
                  <FormControl fullWidth>
                    <InputLabel>Loại sự kiện</InputLabel>
                    <Select
                      name="Type"
                      value={formData.Type}
                      onChange={handleFormChange}
                      label="Loại sự kiện"
                      required
                    >
                      {eventTypes.map((type) => (
                        <MenuItem key={type.value} value={type.value}>
                          {type.label}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                </Grid>
                <Grid item xs={12} md={6}>
                  <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
                    <DateTimePicker
                      label="Ngày sự kiện"
                      value={formData.EventDate}
                      onChange={handleDateChange}
                      slotProps={{ textField: { fullWidth: true } }}
                    />
                  </LocalizationProvider>
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="Nội dung"
                    name="Content"
                    value={formData.Content}
                    onChange={handleFormChange}
                    multiline
                    rows={6}
                  />
                </Grid>
              </Grid>
            </DialogContent>
            <DialogActions>
              <Button onClick={handleCloseDialog}>Hủy</Button>
              <Button 
                onClick={handleSaveEvent} 
                variant="contained" 
                color="primary"
                disabled={!formData.Title || !formData.Type}
              >
                Lưu
              </Button>
            </DialogActions>
          </Dialog>

          {/* Dialog xem chi tiết sự kiện */}
          <Dialog open={openDialog && dialogMode === 'view'} onClose={handleCloseDialog} maxWidth="md" fullWidth>
            <DialogTitle>
              Chi tiết sự kiện
            </DialogTitle>
            <DialogContent>
              <Grid container spacing={2} sx={{ mt: 1 }}>
                <Grid item xs={12}>
                  <Typography variant="h5" gutterBottom>{formData.Title}</Typography>
                </Grid>
                <Grid item xs={12} md={6}>
                  <Typography variant="subtitle1" sx={{ display: 'flex', alignItems: 'center' }}>
                    <CategoryIcon sx={{ mr: 1, color: 'text.secondary' }} />
                    Loại sự kiện: {displayEventType(formData.Type)}
                  </Typography>
                </Grid>
                <Grid item xs={12} md={6}>
                  <Typography variant="subtitle1" sx={{ display: 'flex', alignItems: 'center' }}>
                    <ScheduleIcon sx={{ mr: 1, color: 'text.secondary' }} />
                    Ngày sự kiện: {format(new Date(formData.EventDate), 'dd/MM/yyyy HH:mm')}
                  </Typography>
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle1" sx={{ mb: 1 }}>Nội dung:</Typography>
                  <Paper variant="outlined" sx={{ p: 2, bgcolor: 'background.paper' }}>
                    <Typography variant="body1" style={{ whiteSpace: 'pre-wrap' }}>
                      {formData.Content || 'Không có nội dung'}
                    </Typography>
                  </Paper>
                </Grid>

                {/* Danh sách file đính kèm */}
                <Grid item xs={12} sx={{ mt: 2 }}>
                  <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
                    <AttachFileIcon sx={{ mr: 1 }} />
                    File đính kèm
                  </Typography>
                  {eventFiles.length > 0 ? (
                    <List>
                      {eventFiles.map((file) => (
                        <React.Fragment key={file.FileID}>
                          <ListItem>
                            <ListItemText
                              primary={file.FileName}
                              secondary={`Kích thước: ${(file.FileSize / 1024).toFixed(2)} KB`}
                            />
                            <ListItemSecondaryAction>
                              <Stack direction="row" spacing={1}>
                                <Tooltip title="Tải xuống">
                                  <IconButton 
                                    edge="end" 
                                    aria-label="download" 
                                    onClick={() => handleDownloadFile(file.FileID, file.FileName)}
                                    color="primary"
                                  >
                                    <DownloadIcon />
                                  </IconButton>
                                </Tooltip>
                                <Tooltip title="Xóa file">
                                  <IconButton 
                                    edge="end" 
                                    aria-label="delete" 
                                    onClick={() => handleDeleteFile(file.FileID)}
                                    color="error"
                                  >
                                    <DeleteIcon />
                                  </IconButton>
                                </Tooltip>
                              </Stack>
                            </ListItemSecondaryAction>
                          </ListItem>
                          <Divider />
                        </React.Fragment>
                      ))}
                    </List>
                  ) : (
                    <Typography variant="body2" color="text.secondary">
                      Không có file đính kèm
                    </Typography>
                  )}
                </Grid>
              </Grid>
            </DialogContent>
            <DialogActions>
              <Button onClick={() => handleUploadFile(selectedEvent)} startIcon={<UploadIcon />}>
                Thêm file
              </Button>
              <Button onClick={() => handleEditEvent(selectedEvent)} startIcon={<EditIcon />}>
                Chỉnh sửa
              </Button>
              <Button onClick={handleCloseDialog}>Đóng</Button>
            </DialogActions>
          </Dialog>

          {/* Dialog xác nhận xóa sự kiện */}
          <Dialog open={openDialog && dialogMode === 'delete'} onClose={handleCloseDialog}>
            <DialogTitle>Xác nhận xóa</DialogTitle>
            <DialogContent>
              <DialogContentText>
                Bạn có chắc chắn muốn xóa sự kiện "{selectedEvent?.Title}"? 
                Thao tác này không thể hoàn tác và sẽ xóa tất cả file đính kèm.
              </DialogContentText>
            </DialogContent>
            <DialogActions>
              <Button onClick={handleCloseDialog}>Hủy</Button>
              <Button onClick={handleDeleteEvent} color="error" variant="contained">
                Xóa
              </Button>
            </DialogActions>
          </Dialog>

          {/* Dialog tải lên file đính kèm */}
          <Dialog open={openDialog && dialogMode === 'upload'} onClose={handleCloseDialog}>
            <DialogTitle>Tải lên file đính kèm</DialogTitle>
            <DialogContent>
              <DialogContentText sx={{ mb: 2 }}>
                Chọn file để tải lên cho sự kiện "{selectedEvent?.Title}".
              </DialogContentText>
              <Button
                variant="outlined"
                component="label"
                fullWidth
                startIcon={<UploadIcon />}
              >
                Chọn file
                <input
                  type="file"
                  hidden
                  onChange={handleFileChange}
                />
              </Button>
              {selectedFile && (
                <Box sx={{ mt: 2 }}>
                  <Typography variant="body2">
                    File đã chọn: {selectedFile.name}
                  </Typography>
                  <Typography variant="body2">
                    Kích thước: {(selectedFile.size / 1024).toFixed(2)} KB
                  </Typography>
                </Box>
              )}
            </DialogContent>
            <DialogActions>
              <Button onClick={handleCloseDialog}>Hủy</Button>
              <Button 
                onClick={handleUploadSubmit} 
                color="primary" 
                variant="contained"
                disabled={!selectedFile}
              >
                Tải lên
              </Button>
            </DialogActions>
          </Dialog>

          {/* Snackbar thông báo */}
          <Snackbar
            open={snackbar.open}
            autoHideDuration={5000}
            onClose={() => setSnackbar({ ...snackbar, open: false })}
            anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
          >
            <Alert 
              onClose={() => setSnackbar({ ...snackbar, open: false })} 
              severity={snackbar.severity}
              variant="filled"
              sx={{ width: '100%' }}
            >
              {snackbar.message}
            </Alert>
          </Snackbar>
        </Box>
      )}
    </Container>
  );
};

export default EventManagementPage; 