import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Box, Typography, Container, Paper, Grid, Card, CardContent,
  CardActions, Button, Chip, TextField, FormControl, Tabs, Tab,
  InputLabel, MenuItem, Select, CircularProgress, 
  Pagination, Divider, Alert, IconButton
} from '@mui/material';
import {
  Event as EventIcon,
  Search as SearchIcon,
  CalendarMonth as CalendarIcon,
  School as SchoolIcon,
  Schedule as ScheduleIcon,
  ArrowForward as ArrowForwardIcon
} from '@mui/icons-material';
import { format } from 'date-fns';
import vi from 'date-fns/locale/vi';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider, DatePicker } from '@mui/x-date-pickers';
import eventService from '../../services/eventService';
import TimetableViewComponent from '../../components/Timetable/TimetableViewComponent';

// TabPanel component for switching between Event List and Timetable views
function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`timetable-tabpanel-${index}`}
      aria-labelledby={`timetable-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ pt: 3 }}>
          {children}
        </Box>
      )}
    </div>
  );
}

const EventSchedulePage = () => {
  const navigate = useNavigate();
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  // Tab state
  const [tabValue, setTabValue] = useState(0);

  // Các state cho bộ lọc
  const [search, setSearch] = useState('');
  const [eventType, setEventType] = useState('');
  const [dateFilter, setDateFilter] = useState(null);
  
  // Phân trang
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalEvents, setTotalEvents] = useState(0);
  const eventsPerPage = 6;

  // Các loại sự kiện
  const eventTypes = [
    { value: 'school', label: 'Sự kiện toàn trường', color: 'primary' },
    { value: 'academic', label: 'Học thuật', color: 'secondary' },
    { value: 'activity', label: 'Hoạt động ngoại khóa', color: 'success' },
    { value: 'competition', label: 'Cuộc thi', color: 'warning' },
    { value: 'announcement', label: 'Thông báo', color: 'info' },
    { value: 'other', label: 'Khác', color: 'default' }
  ];
  
  // Handle tab change
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  // Fetch events từ API
  useEffect(() => {
    if (tabValue === 0) {
      fetchEvents();
    }
  }, [tabValue, page, search, eventType, dateFilter]);
  
  const fetchEvents = async () => {
    setLoading(true);
    try {
      // Chuẩn bị params
      const params = {
        page,
        limit: eventsPerPage
      };
      
      if (search) params.search = search;
      if (eventType) params.event_type = eventType;
      if (dateFilter) {
        // Format date để filter
        const formattedDate = format(dateFilter, 'yyyy-MM-dd');
        params.date = formattedDate;
      }
      
      const response = await eventService.getEvents(params);
      
      setEvents(response.data || []);
      setTotalPages(response.total_pages || 1);
      setTotalEvents(response.total || 0);
      setError(null);
    } catch (err) {
      console.error('Error fetching events:', err);
      setError('Không thể tải danh sách sự kiện. Vui lòng thử lại sau.');
    } finally {
      setLoading(false);
    }
  };

  // Reset page khi thay đổi filter
  useEffect(() => {
    setPage(1);
  }, [search, eventType, dateFilter]);

  // Hiển thị loại sự kiện
  const displayEventType = (type) => {
    const eventType = eventTypes.find(et => et.value === type);
    return eventType || { label: type, color: 'default' };
  };

  // Định dạng nội dung để hiển thị dạng tóm tắt
  const formatContent = (content, maxLength = 150) => {
    if (!content) return 'Không có nội dung';
    return content.length > maxLength 
      ? content.substring(0, maxLength) + '...' 
      : content;
  };

  // Chuyển đến trang chi tiết sự kiện
  const handleViewEventDetail = (eventId) => {
    navigate(`/event-schedule/${eventId}`);
  };

  // Render event list
  const renderEventList = () => {
    return (
      <>
        {/* Bộ lọc */}
        <Paper sx={{ p: 2, mb: 4 }}>
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} md={4}>
              <TextField
                fullWidth
                label="Tìm kiếm theo tiêu đề"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                InputProps={{
                  endAdornment: <SearchIcon color="action" />
                }}
                size="small"
              />
            </Grid>
            <Grid item xs={12} md={3}>
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
            <Grid item xs={12} md={3}>
              <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
                <DatePicker
                  label="Ngày"
                  value={dateFilter}
                  onChange={setDateFilter}
                  slotProps={{ textField: { size: 'small', fullWidth: true } }}
                />
              </LocalizationProvider>
            </Grid>
            <Grid item xs={12} md={2}>
              <Button
                fullWidth
                variant="outlined"
                onClick={() => {
                  setSearch('');
                  setEventType('');
                  setDateFilter(null);
                }}
              >
                Đặt lại
              </Button>
            </Grid>
          </Grid>
        </Paper>

        {/* Hiển thị lỗi nếu có */}
        {error && (
          <Alert severity="error" sx={{ mb: 3 }}>
            {error}
          </Alert>
        )}

        {/* Kết quả tìm kiếm */}
        <Typography variant="h6" sx={{ mb: 2 }}>
          {loading ? 'Đang tải...' : `Tìm thấy ${totalEvents} sự kiện`}
        </Typography>

        {/* Danh sách sự kiện */}
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', my: 5 }}>
            <CircularProgress />
          </Box>
        ) : events.length === 0 ? (
          <Paper sx={{ p: 4, textAlign: 'center' }}>
            <SchoolIcon sx={{ fontSize: 60, color: 'text.secondary', mb: 2 }} />
            <Typography variant="h6" color="text.secondary">
              Không tìm thấy sự kiện nào
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
              Thử thay đổi các tiêu chí tìm kiếm
            </Typography>
          </Paper>
        ) : (
          <Grid container spacing={3}>
            {events.map((event) => {
              const eventType = displayEventType(event.Type);
              
              return (
                <Grid item xs={12} md={6} lg={4} key={event.EventID}>
                  <Card 
                    sx={{ 
                      height: '100%', 
                      display: 'flex', 
                      flexDirection: 'column',
                      transition: 'transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out',
                      '&:hover': {
                        transform: 'translateY(-5px)',
                        boxShadow: 6
                      }
                    }}
                  >
                    <CardContent sx={{ flexGrow: 1 }}>
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 2 }}>
                        <Chip 
                          label={eventType.label}
                          color={eventType.color}
                          size="small"
                          icon={<EventIcon />}
                        />
                        <Typography variant="caption" color="text.secondary">
                          {format(new Date(event.CreatedAt), 'dd/MM/yyyy')}
                        </Typography>
                      </Box>
                      
                      <Typography 
                        variant="h6" 
                        component="h2" 
                        gutterBottom
                        sx={{ 
                          mb: 1, 
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          display: '-webkit-box',
                          WebkitLineClamp: 2,
                          WebkitBoxOrient: 'vertical',
                          minHeight: '60px'
                        }}
                      >
                        {event.Title}
                      </Typography>
                      
                      <Typography 
                        variant="body2" 
                        color="text.secondary"
                        sx={{ 
                          mb: 2,
                          display: 'flex',
                          alignItems: 'center'
                        }}
                      >
                        <CalendarIcon sx={{ mr: 1, fontSize: 16 }} />
                        {format(new Date(event.EventDate), 'EEEE, dd/MM/yyyy HH:mm', { locale: vi })}
                      </Typography>
                      
                      <Divider sx={{ my: 1 }} />
                      
                      <Typography 
                        variant="body2" 
                        color="text.secondary"
                        sx={{
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          display: '-webkit-box',
                          WebkitLineClamp: 3,
                          WebkitBoxOrient: 'vertical',
                          minHeight: '60px'
                        }}
                      >
                        {formatContent(event.Content)}
                      </Typography>
                    </CardContent>
                    
                    <CardActions sx={{ justifyContent: 'flex-end', p: 2, pt: 0 }}>
                      <Button 
                        size="small" 
                        endIcon={<ArrowForwardIcon />}
                        onClick={() => handleViewEventDetail(event.EventID)}
                      >
                        Xem chi tiết
                      </Button>
                    </CardActions>
                  </Card>
                </Grid>
              );
            })}
          </Grid>
        )}

        {/* Phân trang */}
        {totalPages > 1 && (
          <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
            <Pagination 
              count={totalPages} 
              page={page} 
              onChange={(e, value) => setPage(value)}
              color="primary"
              size="large"
            />
          </Box>
        )}
      </>
    );
  };

  return (
    <Container maxWidth="lg">
      <Box sx={{ my: 4 }}>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
          <CalendarIcon sx={{ fontSize: 32, mr: 2, color: 'primary.main' }} />
          <Typography variant="h4" component="h1">
            Lịch và Sự kiện Trường học
          </Typography>
        </Box>
        
        {/* Tabs for switching between Events and Timetable */}
        <Paper sx={{ mb: 3 }}>
          <Tabs
            value={tabValue}
            onChange={handleTabChange}
            variant="fullWidth"
            indicatorColor="primary"
            textColor="primary"
            aria-label="schedule tabs"
          >
            <Tab icon={<EventIcon />} label="Sự kiện" />
            <Tab icon={<ScheduleIcon />} label="Thời khóa biểu" />
          </Tabs>
        </Paper>
        
        {/* Event List Panel */}
        <TabPanel value={tabValue} index={0}>
          {renderEventList()}
        </TabPanel>
        
        {/* Timetable Panel */}
        <TabPanel value={tabValue} index={1}>
          <TimetableViewComponent />
        </TabPanel>
      </Box>
    </Container>
  );
};

export default EventSchedulePage; 