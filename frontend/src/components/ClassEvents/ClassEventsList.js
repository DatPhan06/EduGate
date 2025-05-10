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

const ClassEventsList = ({ classId, isHomeRoomTeacher = false, onEditPost, onDeletePost }) => {
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
    
    // State
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [posts, setPosts] = useState([]);
    const [filteredPosts, setFilteredPosts] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [searchQuery, setSearchQuery] = useState('');
    const [typeFilter, setTypeFilter] = useState('');
    
    // Constants
    const ITEMS_PER_PAGE = 5;
    
    // Load class events
    useEffect(() => {
        const fetchClassPosts = async () => {
            if (!classId) return;
            
            setLoading(true);
            try {
                // Call the backend API to get posts for this class
                const response = await classPostService.getClassPostsByClass(classId, 1, 100, searchQuery);
                
                if (response && response.items) {
                    // Sort posts by creation date (newest first)
                    const sortedPosts = response.items.sort((a, b) => 
                        new Date(b.CreatedAt) - new Date(a.CreatedAt)
                    );
                    
                    setPosts(sortedPosts);
                    
                    // Apply initial filtering
                    const filtered = filterPosts(sortedPosts, typeFilter);
                    setFilteredPosts(filtered);
                    setTotalPages(Math.ceil(filtered.length / ITEMS_PER_PAGE));
                } else {
                    setPosts([]);
                    setFilteredPosts([]);
                    setTotalPages(1);
                }
                
                setError('');
            } catch (err) {
                console.error('Error fetching class posts:', err);
                setError('Không thể tải thông báo lớp học. Vui lòng thử lại sau.');
                setPosts([]);
                setFilteredPosts([]);
                setTotalPages(1);
            } finally {
                setLoading(false);
            }
        };
        
        fetchClassPosts();
    }, [classId, searchQuery]);
    
    // Filter posts when type filter changes
    useEffect(() => {
        const filtered = filterPosts(posts, typeFilter);
        setFilteredPosts(filtered);
        setTotalPages(Math.ceil(filtered.length / ITEMS_PER_PAGE));
        setCurrentPage(1); // Reset to first page when filters change
    }, [typeFilter, posts]);
    
    // Filter posts based on type
    const filterPosts = (allPosts, type) => {
        if (!type) return allPosts;
        return allPosts.filter(post => post.Type === type);
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
    
    // Get paginated posts for current page
    const getPaginatedPosts = () => {
        const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
        return filteredPosts.slice(startIndex, startIndex + ITEMS_PER_PAGE);
    };
    
    // Handle post editing
    const handleEditPost = (post) => {
        if (onEditPost) {
            onEditPost(post);
        }
    };
    
    // Handle post deletion
    const handleDeletePost = (postId) => {
        if (onDeletePost) {
            onDeletePost(postId);
        }
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
                    {/* Post count and summary */}
                    <Box sx={{ mb: 2 }}>
                        <Typography variant="body2" color="text.secondary">
                            Tìm thấy {filteredPosts.length} thông báo 
                            {typeFilter && getEventTypeLabel(typeFilter) !== 'Tất cả' ? ` loại "${getEventTypeLabel(typeFilter)}"` : ''}
                            {searchQuery && ` chứa từ khóa "${searchQuery}"`}
                        </Typography>
                    </Box>
                    
                    {/* No posts message */}
                    {filteredPosts.length === 0 && (
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
                    
                    {/* Posts list */}
                    <Stack spacing={2} sx={{ mb: 4 }}>
                        {getPaginatedPosts().map((post) => (
                            <ClassEventCard 
                                key={post.PostID}
                                post={post}
                                canEdit={isHomeRoomTeacher}
                                onEdit={isHomeRoomTeacher ? handleEditPost : undefined}
                                onDelete={isHomeRoomTeacher ? handleDeletePost : undefined}
                            />
                        ))}
                    </Stack>
                    
                    {/* Pagination */}
                    {filteredPosts.length > ITEMS_PER_PAGE && (
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