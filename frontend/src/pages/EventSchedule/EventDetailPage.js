import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  Box, Typography, Container, Paper, Button, CircularProgress,
  Divider, List, ListItem, ListItemText, ListItemIcon, Chip,
  Snackbar, Alert, IconButton
} from '@mui/material';
import {
  Description as DescriptionIcon,
  AttachFile as AttachFileIcon,
  Event as EventIcon,
  Category as CategoryIcon,
  Schedule as ScheduleIcon,
  ArrowBack as ArrowBackIcon,
  CloudDownload as DownloadIcon
} from '@mui/icons-material';
import { format } from 'date-fns';
import vi from 'date-fns/locale/vi';
import eventService from '../../services/eventService';

const EventDetailPage = () => {
  const { eventId } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState(null);
  const [eventFiles, setEventFiles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // State cho thông báo
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: '',
    severity: 'info'
  });

  // Hiển thị thông báo
  const showSnackbar = (message, severity = 'info') => {
    setSnackbar({
      open: true,
      message,
      severity
    });
  };

  // Các loại sự kiện
  const eventTypes = [
    { value: 'school', label: 'Sự kiện toàn trường', color: 'primary' },
    { value: 'academic', label: 'Học thuật', color: 'secondary' },
    { value: 'activity', label: 'Hoạt động ngoại khóa', color: 'success' },
    { value: 'competition', label: 'Cuộc thi', color: 'warning' },
    { value: 'announcement', label: 'Thông báo', color: 'info' },
    { value: 'other', label: 'Khác', color: 'default' }
  ];

  // Lấy thông tin sự kiện
  useEffect(() => {
    const fetchEventDetails = async () => {
      setLoading(true);
      try {
        const eventData = await eventService.getEventById(eventId);
        setEvent(eventData);
        
        // Lấy danh sách file đính kèm
        const files = await eventService.getEventFiles(eventId);
        setEventFiles(files || []);
        
        setError(null);
      } catch (err) {
        console.error('Error fetching event details:', err);
        setError('Không thể tải thông tin sự kiện. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };

    if (eventId) {
      fetchEventDetails();
    }
  }, [eventId]);

  // Xử lý tải xuống file đính kèm
  const handleDownloadFile = async (fileId, fileName) => {
    try {
      await eventService.downloadEventFile(eventId, fileId, fileName);
      showSnackbar('Tải xuống file thành công', 'success');
    } catch (error) {
      console.error('Error downloading file:', error);
      showSnackbar('Lỗi khi tải xuống file', 'error');
    }
  };

  // Hiển thị loại sự kiện
  const displayEventType = (type) => {
    const eventType = eventTypes.find(et => et.value === type);
    return eventType || { label: type, color: 'default' };
  };

  if (loading) {
    return (
      <Container maxWidth="md">
        <Box sx={{ display: 'flex', justifyContent: 'center', my: 5 }}>
          <CircularProgress />
        </Box>
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="md">
        <Alert severity="error" sx={{ mt: 3 }}>{error}</Alert>
        <Button 
          startIcon={<ArrowBackIcon />} 
          onClick={() => navigate('/event-schedule')}
          sx={{ mt: 2 }}
        >
          Quay lại
        </Button>
      </Container>
    );
  }

  if (!event) {
    return (
      <Container maxWidth="md">
        <Alert severity="info" sx={{ mt: 3 }}>Không tìm thấy sự kiện này</Alert>
        <Button 
          startIcon={<ArrowBackIcon />} 
          onClick={() => navigate('/event-schedule')}
          sx={{ mt: 2 }}
        >
          Quay lại
        </Button>
      </Container>
    );
  }

  const eventType = displayEventType(event.Type);

  return (
    <Container maxWidth="md">
      <Button 
        startIcon={<ArrowBackIcon />} 
        onClick={() => navigate('/event-schedule')}
        sx={{ mt: 3, mb: 2 }}
      >
        Quay lại
      </Button>
      
      <Paper elevation={3} sx={{ p: 3, mb: 4 }}>
        <Box sx={{ mb: 3 }}>
          <Chip 
            label={eventType.label}
            color={eventType.color}
            icon={<EventIcon />}
            sx={{ mb: 2 }}
          />
          <Typography variant="h4" component="h1" gutterBottom>
            {event.Title}
          </Typography>
          
          <Box sx={{ display: 'flex', alignItems: 'center', mb: 1, color: 'text.secondary' }}>
            <ScheduleIcon sx={{ mr: 1, fontSize: 20 }} />
            <Typography variant="body2">
              {format(new Date(event.EventDate), 'EEEE, dd/MM/yyyy HH:mm', { locale: vi })}
            </Typography>
          </Box>
          
          <Box sx={{ display: 'flex', alignItems: 'center', color: 'text.secondary' }}>
            <CategoryIcon sx={{ mr: 1, fontSize: 20 }} />
            <Typography variant="body2">
              Đăng ngày {format(new Date(event.CreatedAt), 'dd/MM/yyyy', { locale: vi })}
            </Typography>
          </Box>
        </Box>
        
        <Divider sx={{ my: 2 }} />
        
        <Box sx={{ mb: 3 }}>
          <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
            <DescriptionIcon sx={{ mr: 1 }} />
            Nội dung
          </Typography>
          <Paper 
            variant="outlined" 
            sx={{ p: 2, bgcolor: 'background.paper', minHeight: '100px' }}
          >
            <Typography variant="body1" component="div" sx={{ whiteSpace: 'pre-wrap' }}>
              {event.Content || 'Không có nội dung'}
            </Typography>
          </Paper>
        </Box>
        
        <Divider sx={{ my: 2 }} />
        
        <Box>
          <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center' }}>
            <AttachFileIcon sx={{ mr: 1 }} />
            File đính kèm
          </Typography>
          
          {eventFiles.length > 0 ? (
            <List>
              {eventFiles.map((file) => (
                <ListItem 
                  key={file.FileID}
                  secondaryAction={
                    <IconButton 
                      edge="end"
                      color="primary"
                      onClick={() => handleDownloadFile(file.FileID, file.FileName)}
                      title="Tải xuống"
                    >
                      <DownloadIcon />
                    </IconButton>
                  }
                >
                  <ListItemIcon>
                    <AttachFileIcon />
                  </ListItemIcon>
                  <ListItemText
                    primary={file.FileName}
                    secondary={`Kích thước: ${(file.FileSize / 1024).toFixed(2)} KB`}
                  />
                </ListItem>
              ))}
            </List>
          ) : (
            <Typography variant="body2" color="text.secondary">
              Không có file đính kèm
            </Typography>
          )}
        </Box>
      </Paper>
      
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
    </Container>
  );
};

export default EventDetailPage; 