import React, { useState } from 'react';
import {
    Card,
    CardContent,
    CardHeader,
    CardActions,
    Typography,
    Avatar,
    IconButton,
    Chip,
    Box,
    Menu,
    MenuItem,
    ListItemIcon,
    ListItemText,
    Divider,
    Collapse,
    Button
} from '@mui/material';
import {
    MoreVert as MoreVertIcon,
    Edit as EditIcon,
    Delete as DeleteIcon,
    Event as EventIcon,
    ExpandMore as ExpandMoreIcon,
    ExpandLess as ExpandLessIcon
} from '@mui/icons-material';
import { formatDistanceToNow } from 'date-fns';
import vi from 'date-fns/locale/vi';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeRaw from 'rehype-raw';
import './MarkdownStyles.css';

// Event type mapping for display
const EVENT_TYPES = {
    'ANNOUNCEMENT': { label: 'Thông báo chung', color: 'primary' },
    'HOMEWORK': { label: 'Bài tập về nhà', color: 'success' },
    'EXAM': { label: 'Lịch kiểm tra', color: 'error' },
    'EVENT': { label: 'Sự kiện lớp', color: 'secondary' },
    'PARENT_MEETING': { label: 'Họp phụ huynh', color: 'warning' },
    'OTHER': { label: 'Khác', color: 'default' }
};

const ClassEventCard = ({ post, canEdit = false, onEdit, onDelete }) => {
    // Add this guard to prevent error if post is undefined
    if (!post) {
        // console.warn("ClassEventCard: post prop is undefined. Skipping render.");
        return null; 
    }

    // State
    const [anchorEl, setAnchorEl] = useState(null);
    const [expanded, setExpanded] = useState(false);
    
    // Format dates
    const formattedCreatedAt = formatDistanceToNow(new Date(post.CreatedAt), { 
        addSuffix: true,
        locale: vi 
    });
    
    const formattedEventDate = post.EventDate ? new Date(post.EventDate).toLocaleDateString('vi-VN', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }) : null;

    // Handle menu open/close
    const handleMenuClick = (event) => {
        event.stopPropagation();
        setAnchorEl(event.currentTarget);
    };

    const handleMenuClose = () => {
        setAnchorEl(null);
    };

    // Handle edit button
    const handleEdit = () => {
        handleMenuClose();
        if (onEdit) {
            onEdit(post);
        }
    };

    // Handle delete button
    const handleDelete = () => {
        handleMenuClose();
        if (onDelete) {
            onDelete(post.PostID);
        }
    };

    // Handle expand toggle
    const handleExpandToggle = () => {
        setExpanded(!expanded);
    };

    // Get event type display information
    const eventTypeInfo = EVENT_TYPES[post.Type] || EVENT_TYPES.OTHER;

    return (
        <Card 
            elevation={1} 
            sx={{ 
                mb: 3, 
                borderRadius: 2,
                transition: 'all 0.3s ease',
                '&:hover': {
                    boxShadow: '0 6px 12px rgba(0, 0, 0, 0.08)',
                    transform: 'translateY(-3px)'
                }
            }}
        >
            <CardHeader
                avatar={
                    <Avatar sx={{ bgcolor: `${eventTypeInfo.color}.main` }}>
                        {post.teacher_name?.charAt(0) || 'T'}
                    </Avatar>
                }
                action={
                    canEdit && (
                        <>
                            <IconButton 
                                aria-label="settings" 
                                onClick={handleMenuClick}
                                sx={{ 
                                    '&:hover': { 
                                        bgcolor: 'rgba(0, 0, 0, 0.04)' 
                                    } 
                                }}
                            >
                                <MoreVertIcon />
                            </IconButton>
                            <Menu
                                anchorEl={anchorEl}
                                open={Boolean(anchorEl)}
                                onClose={handleMenuClose}
                                transformOrigin={{ horizontal: 'right', vertical: 'top' }}
                                anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
                            >
                                <MenuItem onClick={handleEdit}>
                                    <ListItemIcon>
                                        <EditIcon fontSize="small" />
                                    </ListItemIcon>
                                    <ListItemText>Chỉnh sửa</ListItemText>
                                </MenuItem>
                                <MenuItem onClick={handleDelete}>
                                    <ListItemIcon>
                                        <DeleteIcon fontSize="small" color="error" />
                                    </ListItemIcon>
                                    <ListItemText primary="Xóa" primaryTypographyProps={{ color: 'error' }} />
                                </MenuItem>
                            </Menu>
                        </>
                    )
                }
                title={
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <Typography variant="h6" component="div" sx={{ fontWeight: 500 }}>
                            {post.Title}
                        </Typography>
                    </Box>
                }
                subheader={
                    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5, mt: 0.5 }}>
                        <Typography variant="body2" color="text.secondary">
                            {post.teacher_name} • {formattedCreatedAt}
                        </Typography>
                        <Box sx={{ display: 'flex', gap: 1, alignItems: 'center', mt: 0.5 }}>
                            <Chip 
                                label={eventTypeInfo.label} 
                                color={eventTypeInfo.color} 
                                size="small" 
                                variant="outlined"
                            />
                            {post.EventDate && (
                                <Chip 
                                    icon={<EventIcon fontSize="small" />}
                                    label={formattedEventDate}
                                    size="small"
                                    variant="outlined"
                                    color="info"
                                />
                            )}
                        </Box>
                    </Box>
                }
            />

            <Divider />

            <CardContent sx={{ pt: 1.5, pb: 0 }}>
                <Box 
                    className="markdown-preview"
                    sx={{ 
                        position: 'relative',
                        maxHeight: expanded ? 'none' : '200px',
                        overflow: expanded ? 'visible' : 'hidden',
                        '& img': {
                            maxWidth: '100%',
                            height: 'auto',
                            borderRadius: 1,
                        },
                        '& code': {
                            backgroundColor: 'rgba(0, 0, 0, 0.04)',
                            borderRadius: 1,
                            p: 0.5,
                            fontFamily: 'monospace',
                        },
                    }}
                >
                    <ReactMarkdown 
                        remarkPlugins={[remarkGfm]} 
                        rehypePlugins={[rehypeRaw]}
                    >
                        {post.Content}
                    </ReactMarkdown>

                    {!expanded && post.Content.length > 300 && (
                        <Box 
                            sx={{ 
                                position: 'absolute',
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: '80px',
                                background: 'linear-gradient(rgba(255,255,255,0), rgba(255,255,255,1))',
                                pointerEvents: 'none'
                            }}
                        />
                    )}
                </Box>
            </CardContent>

            <CardActions sx={{ justifyContent: 'flex-end', p: 1.5 }}>
                {post.Content.length > 300 && (
                    <Button 
                        size="small" 
                        onClick={handleExpandToggle}
                        endIcon={expanded ? <ExpandLessIcon /> : <ExpandMoreIcon />}
                    >
                        {expanded ? 'Thu gọn' : 'Xem thêm'}
                    </Button>
                )}
            </CardActions>
        </Card>
    );
};

export default ClassEventCard;