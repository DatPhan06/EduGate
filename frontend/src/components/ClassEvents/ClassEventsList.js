import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Paper,
    TextField,
    InputAdornment,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    CircularProgress,
    Alert,
    Pagination,
    Chip,
    Stack,
    Divider,
    useMediaQuery,
    useTheme
} from '@mui/material';
import { 
    Search as SearchIcon, 
    Event as EventIcon,
    Announcement as AnnouncementIcon,
    Assignment as AssignmentIcon,
    School as SchoolIcon,
    People as PeopleIcon,
    Info as InfoIcon
} from '@mui/icons-material';
import classPostService from '../../services/classPostService';
import ClassEventCard from './ClassEventCard';

// Event type options
const EVENT_TYPES = [
    { value: '', label: 'Tất cả', icon: null },
    { value: 'ANNOUNCEMENT', label: 'Thông báo chung', icon: <AnnouncementIcon fontSize="small" /> },
    { value: 'HOMEWORK', label: 'Bài tập về nhà', icon: <AssignmentIcon fontSize="small" /> },
    { value: 'EXAM', label: 'Lịch kiểm tra', icon: <SchoolIcon fontSize="small" /> },
    { value: 'EVENT', label: 'Sự kiện lớp', icon: <EventIcon fontSize="small" /> },
    { value: 'PARENT_MEETING', label: 'Họp phụ huynh', icon: <PeopleIcon fontSize="small" /> },
    { value: 'OTHER', label: 'Khác', icon: <InfoIcon fontSize="small" /> },
];

// Helper function to get event type icon
const getEventTypeIcon = (type) => {
    const eventType = EVENT_TYPES.find(t => t.value === type);
    return eventType ? eventType.icon : <InfoIcon fontSize="small" />;
};

// Helper function to get event type label
const getEventTypeLabel = (type) => {
    const eventType = EVENT_TYPES.find(t => t.value === type);
    return eventType ? eventType.label : 'Khác';
};

const ClassEventsList = ({ classId, isHomeRoomTeacher = false }) => {
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
    
    // State
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [events, setEvents] = useState([]);
    const [filteredEvents, setFilteredEvents] = useState([]);
    const [selectedEvent, setSelectedEvent] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [searchQuery, setSearchQuery] = useState('');
    const [typeFilter, setTypeFilter] = useState('');
    
    // Constants
    const ITEMS_PER_PAGE = 5;
    
    // Load class events
    useEffect(() => {
        const fetchClassEvents = async () => {
            if (!classId) return;
            
            setLoading(true);
            try {
                // This would be replaced with a real API call
                const eventsData = await fetchClassEventsFromAPI(classId);
                setEvents(eventsData);
                
                // Apply initial filtering
                const filtered = filterEvents(eventsData, searchQuery, typeFilter);
                setFilteredEvents(filtered);
                setTotalPages(Math.ceil(filtered.length / ITEMS_PER_PAGE));
                
                setError('');
            } catch (err) {
                console.error('Error fetching class events:', err);
                setError('Không thể tải thông báo lớp học. Vui lòng thử lại sau.');
            } finally {
                setLoading(false);
            }
        };
        
        fetchClassEvents();
    }, [classId]);
    
    // Filter events when search query or type filter changes
    useEffect(() => {
        const filtered = filterEvents(events, searchQuery, typeFilter);
        setFilteredEvents(filtered);
        setTotalPages(Math.ceil(filtered.length / ITEMS_PER_PAGE));
        setCurrentPage(1); // Reset to first page when filters change
    }, [searchQuery, typeFilter, events]);
    
    // Mock function to fetch class events from API
    const fetchClassEventsFromAPI = async (classId) => {
        // This would be replaced with an actual API call
        // Example: return await classPostService.getClassPosts(classId);
        
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 500));
        
        // Return mock data for now
        return [
            {
                id: '1',
                Title: 'Thông báo lịch thi cuối kỳ học kỳ 1',
                Content: '## Lịch thi cuối kỳ học kỳ 1\n\nCác em học sinh lưu ý lịch thi cuối kỳ sẽ bắt đầu từ ngày **15/01/2025**. Danh sách phòng thi và số báo danh sẽ được thông báo sau.\n\n### Lịch thi cụ thể\n\n- **15/01/2025**: Toán, Ngữ văn\n- **16/01/2025**: Tiếng Anh, Vật lý\n- **17/01/2025**: Hóa học, Sinh học\n- **18/01/2025**: Lịch sử, Địa lý\n\nCác em chuẩn bị thật tốt cho kỳ thi quan trọng này.',
                Type: 'EXAM',
                CreatedAt: '2023-12-05T08:30:00Z',
                UpdatedAt: '2023-12-05T08:30:00Z',
                EventDate: '2025-01-15T07:00:00Z',
                Author: {
                    id: '101',
                    name: 'Nguyễn Văn Giáo',
                    avatar: null
                }
            },
            {
                id: '2',
                Title: 'Bài tập về nhà môn Toán',
                Content: 'Các em học sinh làm bài tập sau:\n\n1. Trang 45, bài 1, 2, 3\n2. Trang 46, bài 4, 5\n\nHạn nộp: Thứ Hai tuần sau.',
                Type: 'HOMEWORK',
                CreatedAt: '2023-12-03T14:20:00Z',
                UpdatedAt: '2023-12-03T14:20:00Z',
                EventDate: null,
                Author: {
                    id: '102',
                    name: 'Trần Thị Toán',
                    avatar: null
                }
            },
            {
                id: '3',
                Title: 'Thông báo họp phụ huynh giữa học kỳ',
                Content: 'Kính gửi quý phụ huynh,\n\nNhà trường tổ chức buổi họp phụ huynh giữa học kỳ 1 vào ngày 20/12/2024, từ 8:00 - 11:30.\n\nThời gian cụ thể:\n- 8:00 - 9:00: Họp chung toàn trường tại Hội trường\n- 9:15 - 11:30: Họp lớp với giáo viên chủ nhiệm\n\nRất mong quý phụ huynh thu xếp thời gian tham dự đầy đủ.',
                Type: 'PARENT_MEETING',
                CreatedAt: '2023-12-01T09:45:00Z',
                UpdatedAt: '2023-12-01T10:15:00Z',
                EventDate: '2024-12-20T08:00:00Z',
                Author: {
                    id: '101',
                    name: 'Nguyễn Văn Giáo',
                    avatar: null
                }
            },
            {
                id: '4',
                Title: 'Kế hoạch dã ngoại cuối học kỳ',
                Content: '# Kế hoạch dã ngoại cuối học kỳ\n\nLớp ta sẽ tổ chức chuyến dã ngoại đến Vườn Quốc gia Ba Vì vào ngày 28/01/2025.\n\n## Lịch trình\n- 7:00: Tập trung tại trường\n- 7:30: Khởi hành\n- 9:30: Đến Vườn Quốc gia Ba Vì\n- 11:30: Ăn trưa\n- 15:00: Khởi hành về trường\n- 17:00: Dự kiến về đến trường\n\n## Các em cần chuẩn bị\n- Áo lớp\n- Mũ, nón\n- Bình nước\n- Đồ ăn nhẹ\n\nPhí tham gia: 200.000đ/học sinh. Hạn đăng ký và nộp phí: 20/01/2025.',
                Type: 'EVENT',
                CreatedAt: '2023-11-25T16:00:00Z',
                UpdatedAt: '2023-11-26T09:30:00Z',
                EventDate: '2025-01-28T07:00:00Z',
                Author: {
                    id: '101',
                    name: 'Nguyễn Văn Giáo',
                    avatar: null
                }
            },
            {
                id: '5',
                Title: 'Thông báo chung về nề nếp lớp học',
                Content: 'Các em học sinh lưu ý:\n\n1. Đi học đúng giờ, không đi trễ quá 3 lần/tháng\n2. Mặc đồng phục đúng quy định vào thứ Hai và thứ Sáu\n3. Vệ sinh lớp học sau mỗi buổi học\n4. Không sử dụng điện thoại trong giờ học\n\nLớp trưởng có trách nhiệm nhắc nhở và báo cáo với GVCN các trường hợp vi phạm.',
                Type: 'ANNOUNCEMENT',
                CreatedAt: '2023-11-20T08:00:00Z',
                UpdatedAt: '2023-11-20T08:00:00Z',
                EventDate: null,
                Author: {
                    id: '101',
                    name: 'Nguyễn Văn Giáo',
                    avatar: null
                }
            },
            {
                id: '6',
                Title: 'Thông báo thu tiền mua sách bài tập',
                Content: 'Các em cần nộp tiền mua sách bài tập cho các môn sau:\n\n1. Toán: 35.000đ\n2. Văn: 30.000đ\n3. Anh: 40.000đ\n4. Lý: 25.000đ\n5. Hóa: 25.000đ\n\nTổng: 155.000đ\n\nHạn nộp: trước ngày 30/11/2024.',
                Type: 'ANNOUNCEMENT',
                CreatedAt: '2023-11-15T13:20:00Z',
                UpdatedAt: '2023-11-15T13:20:00Z',
                EventDate: null,
                Author: {
                    id: '101',
                    name: 'Nguyễn Văn Giáo',
                    avatar: null
                }
            },
        ];
    };
    
    // Filter events based on search query and type
    const filterEvents = (allEvents, query, type) => {
        return allEvents.filter(event => {
            // Filter by search query
            const matchesSearch = query === '' || 
                event.Title.toLowerCase().includes(query.toLowerCase()) ||
                event.Content.toLowerCase().includes(query.toLowerCase());
            
            // Filter by event type
            const matchesType = type === '' || event.Type === type;
            
            return matchesSearch && matchesType;
        });
    };
    
    // Handle search input change
    const handleSearchChange = (e) => {
        setSearchQuery(e.target.value);
    };
    
    // Handle event type filter change
    const handleTypeFilterChange = (e) => {
        setTypeFilter(e.target.value);
    };
    
    // Handle page change
    const handlePageChange = (event, value) => {
        setCurrentPage(value);
    };
    
    // Get paginated events for current page
    const getPaginatedEvents = () => {
        const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
        return filteredEvents.slice(startIndex, startIndex + ITEMS_PER_PAGE);
    };
    
    return (
        <Box>
            {/* Filters */}
            <Paper 
                elevation={0} 
                sx={{ 
                    p: 3, 
                    mb: 3, 
                    borderRadius: 2, 
                    display: 'flex',
                    flexDirection: { xs: 'column', sm: 'row' },
                    gap: 2
                }}
            >
                <TextField
                    placeholder="Tìm kiếm thông báo..."
                    variant="outlined"
                    fullWidth
                    value={searchQuery}
                    onChange={handleSearchChange}
                    size="small"
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        ),
                    }}
                />
                
                <FormControl 
                    variant="outlined" 
                    size="small"
                    sx={{ minWidth: { xs: '100%', sm: 200 } }}
                >
                    <InputLabel>Loại thông báo</InputLabel>
                    <Select
                        value={typeFilter}
                        onChange={handleTypeFilterChange}
                        label="Loại thông báo"
                    >
                        {EVENT_TYPES.map((type) => (
                            <MenuItem key={type.value} value={type.value}>
                                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                    {type.icon && <Box sx={{ mr: 1 }}>{type.icon}</Box>}
                                    {type.label}
                                </Box>
                            </MenuItem>
                        ))}
                    </Select>
                </FormControl>
            </Paper>
            
            {/* Error message */}
            {error && (
                <Alert severity="error" sx={{ mb: 3 }}>
                    {error}
                </Alert>
            )}
            
            {/* Loading state */}
            {loading ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
                    <CircularProgress />
                </Box>
            ) : (
                <>
                    {/* Event count and summary */}
                    <Box sx={{ mb: 2 }}>
                        <Typography variant="body2" color="text.secondary">
                            Tìm thấy {filteredEvents.length} thông báo {typeFilter && getEventTypeLabel(typeFilter) !== 'Tất cả' ? `loại "${getEventTypeLabel(typeFilter)}"` : ''}
                            {searchQuery && ` chứa từ khóa "${searchQuery}"`}
                        </Typography>
                    </Box>
                    
                    {/* No events message */}
                    {filteredEvents.length === 0 && (
                        <Paper
                            elevation={0}
                            sx={{
                                p: 5,
                                textAlign: 'center',
                                borderRadius: 2,
                                bgcolor: theme.palette.background.paper,
                            }}
                        >
                            <Typography variant="h6" color="text.secondary" gutterBottom>
                                Không tìm thấy thông báo nào
                            </Typography>
                            <Typography variant="body2" color="text.secondary">
                                Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm
                            </Typography>
                        </Paper>
                    )}
                    
                    {/* Events list */}
                    <Stack spacing={2} sx={{ mb: 4 }}>
                        {getPaginatedEvents().map((event) => (
                            <ClassEventCard 
                                key={event.id}
                                event={event}
                                isHomeRoomTeacher={isHomeRoomTeacher}
                                onDelete={() => {/* Handle delete */}}
                                onEdit={() => {/* Handle edit */}}
                            />
                        ))}
                    </Stack>
                    
                    {/* Pagination */}
                    {filteredEvents.length > 0 && (
                        <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4, mb: 2 }}>
                            <Pagination
                                count={totalPages}
                                page={currentPage}
                                onChange={handlePageChange}
                                color="primary"
                                showFirstButton
                                showLastButton={!isMobile}
                            />
                        </Box>
                    )}
                </>
            )}
        </Box>
    );
};

export default ClassEventsList;