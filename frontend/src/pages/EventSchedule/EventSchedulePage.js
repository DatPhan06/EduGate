import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Box, Typography, Container, Paper, Grid, Card, CardContent,
  CardActions, Button, Chip, TextField, FormControl, Tabs, Tab,
  InputLabel, MenuItem, Select, CircularProgress, 
  Pagination, Divider, Alert, IconButton, useTheme, alpha, 
  CardMedia, Tooltip, Avatar, Zoom, Fade
} from '@mui/material';
import {
  Event as EventIcon,
  Search as SearchIcon,
  CalendarMonth as CalendarIcon,
  School as SchoolIcon,
  Schedule as ScheduleIcon,
  ArrowForward as ArrowForwardIcon,
  Today as TodayIcon,
  AccessTime as AccessTimeIcon,
  FilterAlt as FilterAltIcon
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
  const theme = useTheme();
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

  // Renders event cards in a modern style
  const renderEventCard = (event) => {
    const eventType = displayEventType(event.Type);
    const eventDate = new Date(event.EventDate);
    const isUpcoming = eventDate > new Date();
    
    // Placeholder image based on event type
    const getEventImage = (type) => {
      switch (type) {
        case 'school':
          return 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&q=80';
        case 'academic':
          return 'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&q=80';
        case 'activity':
          return 'https://images.unsplash.com/photo-1511988617509-a57c8a288659?auto=format&fit=crop&q=80';
        case 'competition':
          return 'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&q=80';
        case 'announcement':
          return 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80';
        default:
          return 'https://images.unsplash.com/photo-1492538368677-f6e0afe31dcc?auto=format&fit=crop&q=80';
      }
    };

    return (
      <Zoom in={true} style={{ transitionDelay: '100ms' }}>
        <Card 
          elevation={3}
          sx={{ 
            height: '100%', 
            display: 'flex', 
            flexDirection: 'column',
            borderRadius: 2,
            overflow: 'hidden',
            transition: 'all 0.3s ease',
            position: 'relative',
            '&:hover': {
              transform: 'translateY(-8px)',
              boxShadow: 8,
              '& .MuiCardMedia-root': {
                transform: 'scale(1.05)'
              }
            }
          }}
        >
          {/* Event Type Badge */}
          <Chip 
            label={eventType.label}
            color={eventType.color}
            size="small"
            icon={<EventIcon />}
            sx={{ 
              position: 'absolute', 
              top: 12, 
              left: 12, 
              zIndex: 10,
              fontWeight: 'bold',
              boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
              '& .MuiChip-icon': {
                fontSize: '0.8rem'
              }
            }}
          />
          
          {/* Event Image */}
          <CardMedia
            component="img"
            height="160"
            image={getEventImage(event.Type)}
            alt={event.Title}
            sx={{ 
              transition: 'transform 0.5s ease',
              filter: isUpcoming ? 'none' : 'grayscale(40%)'
            }}
          />
          
          {/* Date Indicator */}
          <Box 
            sx={{ 
              position: 'absolute', 
              top: 10, 
              right: 10,
              bgcolor: 'rgba(255,255,255,0.9)',
              borderRadius: 1,
              p: 0.8,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              minWidth: '48px',
              boxShadow: '0 2px 8px rgba(0,0,0,0.15)'
            }}
          >
            <Typography variant="caption" color="primary" sx={{ fontWeight: 'bold' }}>
              {format(eventDate, 'MMM', { locale: vi }).toUpperCase()}
            </Typography>
            <Typography variant="h6" color="text.primary" sx={{ lineHeight: 1 }}>
              {format(eventDate, 'dd')}
            </Typography>
          </Box>
          
          <CardContent sx={{ flexGrow: 1, pt: 2 }}>
            {/* Title */}
            <Typography 
              variant="h6" 
              component="h2" 
              gutterBottom
              sx={{ 
                mb: 1.5, 
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                display: '-webkit-box',
                WebkitLineClamp: 2,
                WebkitBoxOrient: 'vertical',
                fontWeight: 'bold',
                height: '3.6em'
              }}
            >
              {event.Title}
            </Typography>
            
            {/* Time information */}
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 2, color: theme.palette.text.secondary }}>
              <AccessTimeIcon sx={{ mr: 1, fontSize: 18, color: theme.palette.primary.main }} />
              <Typography variant="body2">
                {format(eventDate, 'HH:mm')}
              </Typography>
            </Box>
            
            <Divider sx={{ my: 1.5 }} />
            
            {/* Content Summary */}
            <Typography 
              variant="body2" 
              color="text.secondary"
              sx={{
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                display: '-webkit-box',
                WebkitLineClamp: 3,
                WebkitBoxOrient: 'vertical',
                height: '4.5em',
                mb: 1
              }}
            >
              {formatContent(event.Content)}
            </Typography>
          </CardContent>
          
          <CardActions sx={{ justifyContent: 'space-between', p: 2, pt: 0 }}>
            <Typography variant="caption" color="text.secondary" sx={{ display: 'flex', alignItems: 'center' }}>
              <TodayIcon sx={{ mr: 0.5, fontSize: 16 }} />
              {format(new Date(event.CreatedAt), 'dd/MM/yyyy')}
            </Typography>
            
            <Button 
              variant="outlined"
              size="small" 
              endIcon={<ArrowForwardIcon />}
              onClick={() => handleViewEventDetail(event.EventID)}
              sx={{
                borderRadius: 4,
                px: 1.5,
                '&:hover': {
                  backgroundColor: alpha(theme.palette.primary.main, 0.1)
                }
              }}
            >
              Xem chi tiết
            </Button>
          </CardActions>
          
          {!isUpcoming && (
            <Box 
              sx={{ 
                position: 'absolute',
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                backgroundColor: 'rgba(0,0,0,0.03)',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                pointerEvents: 'none'
              }}>
              <Chip 
                label="Đã diễn ra" 
                size="small" 
                sx={{ 
                  backgroundColor: 'rgba(255,255,255,0.7)', 
                  fontWeight: 'bold',
                  color: 'text.secondary'
                }} 
              />
            </Box>
          )}
        </Card>
      </Zoom>
    );
  };

  // Render event list
  const renderEventList = () => {
    return (
      <Fade in={true} timeout={500}>
        <Box>
          {/* Bộ lọc */}
          <Paper 
            elevation={3}
            sx={{ 
              p: 3, 
              mb: 4, 
              borderRadius: 2,
              background: `linear-gradient(to right, ${alpha(theme.palette.primary.light, 0.1)}, ${alpha(theme.palette.background.paper, 0.8)})`
            }}
          >
            <Typography variant="h6" gutterBottom sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
              <FilterAltIcon sx={{ mr: 1 }} />
              Bộ lọc sự kiện
            </Typography>
            
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} md={4}>
                <TextField
                  fullWidth
                  label="Tìm kiếm theo tiêu đề"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  InputProps={{
                    startAdornment: <SearchIcon color="action" sx={{ mr: 1 }} />,
                    sx: { borderRadius: 2 }
                  }}
                  variant="outlined"
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
                    sx={{ borderRadius: 2 }}
                  >
                    <MenuItem value="">Tất cả</MenuItem>
                    {eventTypes.map((type) => (
                      <MenuItem key={type.value} value={type.value}>
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                          <Avatar 
                            sx={{ 
                              width: 24, 
                              height: 24, 
                              mr: 1, 
                              bgcolor: `${type.color}.main` 
                            }}
                          >
                            <EventIcon sx={{ fontSize: 16 }} />
                          </Avatar>
                          {type.label}
                        </Box>
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
                    slotProps={{ 
                      textField: { 
                        size: 'small', 
                        fullWidth: true,
                        sx: { borderRadius: 2 }
                      }
                    }}
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
                  sx={{ 
                    borderRadius: 2,
                    height: '40px'
                  }}
                >
                  Đặt lại
                </Button>
              </Grid>
            </Grid>
          </Paper>

          {/* Hiển thị lỗi nếu có */}
          {error && (
            <Alert severity="error" sx={{ mb: 3, borderRadius: 2 }}>
              {error}
            </Alert>
          )}

          {/* Kết quả tìm kiếm */}
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 'bold' }}>
              {loading ? (
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <CircularProgress size={24} sx={{ mr: 1 }} />
                  Đang tải...
                </Box>
              ) : (
                <>Tìm thấy {totalEvents} sự kiện</>
              )}
            </Typography>
            
            {!loading && events.length > 0 && (
              <Tooltip title="Sắp xếp theo thời gian gần nhất">
                <Chip 
                  icon={<TodayIcon />} 
                  label="Mới nhất" 
                  color="primary" 
                  variant="outlined"
                  sx={{ borderRadius: 4 }}
                />
              </Tooltip>
            )}
          </Box>

          {/* Danh sách sự kiện */}
          {loading ? (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', py: 8 }}>
              <CircularProgress />
            </Box>
          ) : events.length === 0 ? (
            <Paper 
              elevation={3} 
              sx={{ 
                p: 5, 
                textAlign: 'center', 
                borderRadius: 2, 
                background: `linear-gradient(to bottom, ${alpha(theme.palette.background.paper, 0.8)}, ${alpha(theme.palette.background.paper, 0.9)})` 
              }}
            >
              <SchoolIcon sx={{ fontSize: 80, color: alpha(theme.palette.primary.main, 0.3), mb: 2 }} />
              <Typography variant="h5" color="text.secondary" gutterBottom>
                Không tìm thấy sự kiện nào
              </Typography>
              <Typography variant="body1" color="text.secondary" sx={{ mt: 1, mb: 3 }}>
                Thử thay đổi các tiêu chí tìm kiếm hoặc quay lại sau
              </Typography>
              <Button 
                variant="outlined" 
                color="primary"
                onClick={() => {
                  setSearch('');
                  setEventType('');
                  setDateFilter(null);
                }}
                sx={{ borderRadius: 2 }}
              >
                Xem tất cả sự kiện
              </Button>
            </Paper>
          ) : (
            <Grid container spacing={3}>
              {events.map((event) => (
                <Grid item xs={12} sm={6} md={4} key={event.EventID}>
                  {renderEventCard(event)}
                </Grid>
              ))}
            </Grid>
          )}

          {/* Phân trang */}
          {totalPages > 1 && (
            <Box sx={{ display: 'flex', justifyContent: 'center', mt: 5, mb: 2 }}>
              <Pagination 
                count={totalPages} 
                page={page} 
                onChange={(e, value) => setPage(value)}
                color="primary"
                size="large"
                showFirstButton
                showLastButton
                sx={{
                  '& .MuiPaginationItem-root': {
                    borderRadius: 1
                  }
                }}
              />
            </Box>
          )}
        </Box>
      </Fade>
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