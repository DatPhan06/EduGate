import React, { useState, useEffect, useCallback, useRef } from 'react';
import { 
    Box, Typography, Grid, Paper, CircularProgress, Alert, Button, Fab, 
    useTheme, useMediaQuery, Tabs, Tab, List, ListItem, ListItemAvatar, 
    ListItemText, Avatar, Divider, IconButton, InputBase, TextField,
    Dialog, DialogTitle, DialogContent, DialogActions, Menu, MenuItem,
    Drawer, Tooltip, ListItemIcon, Badge
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import SearchIcon from '@mui/icons-material/Search';
import CloseIcon from '@mui/icons-material/Close';
import PersonIcon from '@mui/icons-material/Person';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import EditIcon from '@mui/icons-material/Edit';
import GroupIcon from '@mui/icons-material/Group';
import DeleteIcon from '@mui/icons-material/Delete';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import SettingsIcon from '@mui/icons-material/Settings';
import InfoIcon from '@mui/icons-material/Info';
import messageService from '../../services/messageService';
import authService from '../../services/authService';
import userService from '../../services/userService';
import ConversationList from './ConversationList'; 
import ChatView from './ChatView';
import UserSelectionModal from './UserSelectionModal';
import { useNavigate } from 'react-router-dom';

const Messages = () => {
    const navigate = useNavigate();
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
    const isTablet = useMediaQuery(theme.breakpoints.down('md'));

    const [currentUser, setCurrentUser] = useState(null);
    const [conversations, setConversations] = useState([]);
    const [selectedConversation, setSelectedConversation] = useState(null);
    const [loadingConversations, setLoadingConversations] = useState(true);
    const [error, setError] = useState('');
    const [isUserSelectionModalOpen, setIsUserSelectionModalOpen] = useState(false);
    
    // Add new states for user list
    const [users, setUsers] = useState([]);
    const [loadingUsers, setLoadingUsers] = useState(false);
    const [activeTab, setActiveTab] = useState(0); // 0 for conversations, 1 for users
    const [searchTerm, setSearchTerm] = useState('');
    const [filteredUsers, setFilteredUsers] = useState([]);

    // Add states for participants sidebar and conversation editing
    const [showParticipants, setShowParticipants] = useState(!isMobile && !isTablet);
    const [participants, setParticipants] = useState([]);
    const [loadingParticipants, setLoadingParticipants] = useState(false);
    const [editDialogOpen, setEditDialogOpen] = useState(false);
    const [newConversationName, setNewConversationName] = useState('');
    const [conversationMenuAnchor, setConversationMenuAnchor] = useState(null);

    useEffect(() => {
        const user = authService.getCurrentUser();
        if (!user || !user.UserID) {
            setError("User not found. Please log in.");
            navigate('/login');
            return;
        }
        setCurrentUser(user);
    }, [navigate]);

    const fetchConversations = useCallback(async () => {
        if (!currentUser) return;
        setLoadingConversations(true);
        setError('');
        try {
            const convs = await messageService.getUserConversations();
            setConversations(convs || []);
        } catch (err) {
            console.error("Failed to fetch conversations:", err);
            setError(err.response?.data?.detail || err.message || "Failed to load conversations. Please try again.");
            if (err.response?.status === 401) {
                authService.logout();
                navigate('/login');
            }
        } finally {
            setLoadingConversations(false);
        }
    }, [currentUser, navigate]);

    // Add function to fetch conversation participants
    const fetchParticipants = useCallback(async (conversationId) => {
        if (!conversationId) return;
        
        setLoadingParticipants(true);
        try {
            const response = await messageService.getConversationParticipants(conversationId);
            setParticipants(response || []);
        } catch (err) {
            console.error("Failed to fetch conversation participants:", err);
        } finally {
            setLoadingParticipants(false);
        }
    }, []);

    // Add function to fetch all users
    const fetchUsers = useCallback(async () => {
        if (!currentUser) return;
        setLoadingUsers(true);
        try {
            const response = await userService.getAllUsers();
            // Filter out the current user from the list
            const otherUsers = response.filter(user => 
                user.UserID !== currentUser.UserID && 
                user.id !== currentUser.UserID && 
                user.userId !== currentUser.UserID
            );
            setUsers(otherUsers);
            setFilteredUsers(otherUsers);
        } catch (err) {
            console.error("Failed to fetch users:", err);
            if (err.response?.status === 401) {
                authService.logout();
                navigate('/login');
            }
        } finally {
            setLoadingUsers(false);
        }
    }, [currentUser, navigate]);

    useEffect(() => {
        if (currentUser) {
            fetchConversations();
            if (activeTab === 1) {
                fetchUsers();
            }
        }
    }, [currentUser, fetchConversations, fetchUsers, activeTab]);

    // Fetch participants when conversation changes
    useEffect(() => {
        if (selectedConversation && selectedConversation.ConversationID) {
            fetchParticipants(selectedConversation.ConversationID);
            
            // Set the current conversation name for the edit dialog
            setNewConversationName(selectedConversation.ConversationName || '');
        }
    }, [selectedConversation, fetchParticipants]);

    // Add effect to filter users based on search term
    useEffect(() => {
        if (searchTerm.trim() === '') {
            setFilteredUsers(users);
        } else {
            const lowerCaseSearch = searchTerm.toLowerCase();
            const filtered = users.filter(user => {
                const fullName = `${user.FirstName || ''} ${user.LastName || ''}`.toLowerCase();
                const username = (user.Username || '').toLowerCase();
                const email = (user.Email || '').toLowerCase();
                
                return fullName.includes(lowerCaseSearch) || 
                       username.includes(lowerCaseSearch) || 
                       email.includes(lowerCaseSearch);
            });
            setFilteredUsers(filtered);
        }
    }, [searchTerm, users]);

    // Add function to update conversation name
    const handleUpdateConversationName = async () => {
        if (!selectedConversation || !newConversationName.trim()) return;
        
        try {
            const updatedConversation = await messageService.updateConversation(
                selectedConversation.ConversationID, 
                { Name: newConversationName.trim() }
            );
            
            // Cập nhật tên trong danh sách đoạn chat
            setConversations(prevConvs => 
                prevConvs.map(c => 
                    c.ConversationID === updatedConversation.ConversationID 
                        ? { 
                            ...c, 
                            Name: updatedConversation.Name,
                            ConversationName: updatedConversation.Name 
                          }
                        : c
                )
            );
            
            // Cập nhật tên đoạn chat hiện tại
            setSelectedConversation(prev => ({
                ...prev,
                Name: updatedConversation.Name,
                ConversationName: updatedConversation.Name
            }));
            
            // Close dialog
            setEditDialogOpen(false);
        } catch (err) {
            console.error("Failed to update conversation name:", err);
            setError("Không thể cập nhật tên đoạn chat. Vui lòng thử lại sau.");
        }
    };

    const handleSelectConversation = (conversation) => {
        setSelectedConversation(conversation);
    };

    const handleOpenUserSelectionModal = () => {
        setIsUserSelectionModalOpen(true);
    };

    const handleCloseUserSelectionModal = () => {
        setIsUserSelectionModalOpen(false);
    };

    const handleConversationCreated = (newConversation) => {
        setConversations(prev => [newConversation, ...prev.filter(c => c.ConversationID !== newConversation.ConversationID)]);
        setSelectedConversation(newConversation);
        fetchConversations();
    };
    
    const handleMessageSent = (updatedConversation) => {
        setConversations(prevConvs => 
            prevConvs.map(c => c.ConversationID === updatedConversation.ConversationID ? updatedConversation : c)
                     .sort((a, b) => new Date(b.UpdatedAt) - new Date(a.UpdatedAt))
        );
        if (selectedConversation && selectedConversation.ConversationID === updatedConversation.ConversationID) {
            setSelectedConversation(updatedConversation);
        }
    };

    // Add handler for tab change
    const handleTabChange = (event, newValue) => {
        setActiveTab(newValue);
        if (newValue === 1 && users.length === 0) {
            fetchUsers();
        }
    };

    // Add handler for starting a conversation with a user
    const handleStartConversation = async (userId) => {
        try {
            const result = await messageService.createConversation([userId]);
            handleConversationCreated(result);
            setActiveTab(0); // Switch back to conversations tab
        } catch (err) {
            console.error("Failed to create conversation:", err);
            setError(err.response?.data?.detail || err.message || "Failed to create conversation. Please try again.");
        }
    };

    // Add handler for opening conversation menu
    const handleOpenConversationMenu = (event) => {
        setConversationMenuAnchor(event.currentTarget);
    };

    // Add handler for closing conversation menu
    const handleCloseConversationMenu = () => {
        setConversationMenuAnchor(null);
    };

    // Add handler for opening edit conversation dialog
    const handleOpenEditDialog = () => {
        setNewConversationName(selectedConversation?.Name || selectedConversation?.ConversationName || '');
        setEditDialogOpen(true);
        handleCloseConversationMenu();
    };

    // Add handler for toggling participants sidebar
    const handleToggleParticipants = () => {
        setShowParticipants(prev => !prev);
    };

    const showConversationListPane = !isMobile || !selectedConversation;
    const showChatViewPane = !isMobile || selectedConversation;

    return (
        <Box sx={{
            height: 'calc(100vh - 64px - 48px)', // Assuming 64px for Navbar, 48px for Footer
            display: 'flex',
            flexDirection: 'column',
            overflow: 'hidden',
            width: '100%'
        }}>
            <Typography variant="h4" gutterBottom sx={{ p: 2, pb: 1 }}>
                Tin nhắn
                {isMobile && selectedConversation && (
                    <Button
                        onClick={() => setSelectedConversation(null)}
                        sx={{ ml: 2, fontSize: '0.8rem' }}
                    >
                        Quay lại danh sách
                    </Button>
                )}
            </Typography>

            {error && <Alert severity="error" sx={{ m: 2 }}>{error}</Alert>}

            <Grid container sx={{ flexGrow: 1, overflow: 'hidden', width: '100%' }}>
                <Grid
                    item
                    xs={12}
                    md={3}
                    lg={3}
                    sx={{
                        display: showConversationListPane ? 'flex' : 'none',
                        flexDirection: 'column',
                        height: '100%',
                        borderRight: !isMobile ? `1px solid ${theme.palette.divider}` : 'none'
                    }}
                >
                    <Paper 
                        elevation={0}
                        square
                        sx={{
                            flexGrow: 1,
                            overflowY: 'auto',
                            display: 'flex',
                            flexDirection: 'column',
                            height: '100%'
                        }}
                    >
                        {/* Add tabs for conversations and users */}
                        <Tabs 
                            value={activeTab} 
                            onChange={handleTabChange}
                            variant="fullWidth"
                            sx={{ borderBottom: `1px solid ${theme.palette.divider}` }}
                        >
                            <Tab label="Đoạn chat" />
                            <Tab label="Danh bạ" />
                        </Tabs>

                        {/* Conditionally render based on active tab */}
                        {activeTab === 0 ? (
                            <>
                                <Box sx={{
                                    display: 'flex',
                                    justifyContent: 'space-between',
                                    alignItems: 'center',
                                    p: 2,
                                    borderBottom: `1px solid ${theme.palette.divider}`
                                }}>
                                    <Typography variant="h6">Đoạn chat</Typography>
                                    <Fab
                                        color="primary"
                                        size="small"
                                        aria-label="add"
                                        onClick={handleOpenUserSelectionModal}
                                    >
                                        <AddIcon />
                                    </Fab>
                                </Box>
                                {loadingConversations ? (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', flexGrow: 1 }}>
                                        <CircularProgress />
                                    </Box>
                                ) : conversations.length === 0 && !error ? (
                                    <Typography sx={{ textAlign: 'center', p: 2 }}>
                                        Chưa có cuộc trò chuyện nào. Hãy bắt đầu một cuộc trò chuyện mới!
                                    </Typography>
                                ) : (
                                    <ConversationList
                                        conversations={conversations}
                                        onSelectConversation={handleSelectConversation}
                                        selectedConversationId={selectedConversation?.ConversationID}
                                        currentUser={currentUser}
                                    />
                                )}
                            </>
                        ) : (
                            <>
                                <Box sx={{
                                    p: 2,
                                    borderBottom: `1px solid ${theme.palette.divider}`
                                }}>
                                    <Typography variant="h6" sx={{ mb: 2 }}>Danh sách người dùng</Typography>
                                    <Paper
                                        elevation={0}
                                        sx={{ 
                                            p: '2px 4px', 
                                            display: 'flex', 
                                            alignItems: 'center', 
                                            border: `1px solid ${theme.palette.divider}`,
                                            borderRadius: 1
                                        }}
                                    >
                                        <SearchIcon sx={{ p: '10px', color: 'action.active' }} />
                                        <InputBase
                                            sx={{ ml: 1, flex: 1 }}
                                            placeholder="Tìm kiếm người dùng"
                                            value={searchTerm}
                                            onChange={(e) => setSearchTerm(e.target.value)}
                                        />
                                        {searchTerm && (
                                            <IconButton 
                                                size="small" 
                                                onClick={() => setSearchTerm('')}
                                                sx={{ p: '5px' }}
                                            >
                                                <CloseIcon fontSize="small" />
                                            </IconButton>
                                        )}
                                    </Paper>
                                </Box>
                                {loadingUsers ? (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', flexGrow: 1, p: 3 }}>
                                        <CircularProgress />
                                    </Box>
                                ) : filteredUsers.length === 0 ? (
                                    <Typography sx={{ textAlign: 'center', p: 3 }}>
                                        {searchTerm ? 'Không tìm thấy người dùng nào phù hợp.' : 'Không có người dùng nào.'}
                                    </Typography>
                                ) : (
                                    <List sx={{ width: '100%', bgcolor: 'background.paper', p: 0 }}>
                                        {filteredUsers.map((user, index) => (
                                            <React.Fragment key={user.UserID || user.id || index}>
                                                <ListItem 
                                                    alignItems="flex-start"
                                                    button
                                                    onClick={() => handleStartConversation(user.UserID || user.id)}
                                                    sx={{ 
                                                        '&:hover': { 
                                                            bgcolor: 'action.hover' 
                                                        },
                                                        py: 1.5
                                                    }}
                                                >
                                                    <ListItemAvatar>
                                                        <Avatar>
                                                            {user.Avatar ? (
                                                                <img 
                                                                    src={user.Avatar} 
                                                                    alt={`${user.FirstName || ''} ${user.LastName || ''}`}
                                                                    style={{ width: '100%', height: '100%' }}
                                                                />
                                                            ) : (
                                                                <PersonIcon />
                                                            )}
                                                        </Avatar>
                                                    </ListItemAvatar>
                                                    <ListItemText
                                                        primary={`${user.FirstName || ''} ${user.LastName || ''}`}
                                                        secondary={user.Email || user.Username || ''}
                                                    />
                                                </ListItem>
                                                {index < filteredUsers.length - 1 && <Divider variant="inset" component="li" />}
                                            </React.Fragment>
                                        ))}
                                    </List>
                                )}
                            </>
                        )}
                    </Paper>
                </Grid>

                <Grid
                    item
                    xs={12}
                    md={showParticipants ? 6 : 9}
                    lg={showParticipants ? 6 : 9}
                    sx={{
                        display: showChatViewPane ? 'flex' : 'none',
                        flexDirection: 'column',
                        height: '100%',
                        flexGrow: 1,
                        minWidth: 0,
                    }}
                >
                    <Paper 
                        elevation={0}
                        square
                        sx={{
                            flexGrow: 1,
                            overflowY: 'hidden',
                            display: 'flex',
                            flexDirection: 'column',
                            height: '100%',
                            width: '100%'
                        }}
                    >
                        {selectedConversation ? (
                            <>
                                {/* Add chat header with conversation name and options */}
                                <Box sx={{ 
                                    p: 2, 
                                    borderBottom: `1px solid ${theme.palette.divider}`,
                                    display: 'flex',
                                    justifyContent: 'space-between',
                                    alignItems: 'center'
                                }}>
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <Typography variant="h6">
                                            {selectedConversation.Name || selectedConversation.ConversationName || 
                                             'Đoạn chat chưa có tên'}
                                        </Typography>
                                        <Tooltip title="Chỉnh sửa tên đoạn chat">
                                            <IconButton 
                                                size="small" 
                                                onClick={handleOpenEditDialog}
                                                sx={{ ml: 1 }}
                                            >
                                                <EditIcon fontSize="small" />
                                            </IconButton>
                                        </Tooltip>
                                    </Box>
                                    <Box>
                                        <Tooltip title={showParticipants ? "Ẩn thành viên" : "Hiển thị thành viên"}>
                                            <IconButton onClick={handleToggleParticipants}>
                                                <GroupIcon />
                                            </IconButton>
                                        </Tooltip>
                                        <IconButton onClick={handleOpenConversationMenu}>
                                            <MoreVertIcon />
                                        </IconButton>
                                        <Menu
                                            anchorEl={conversationMenuAnchor}
                                            open={Boolean(conversationMenuAnchor)}
                                            onClose={handleCloseConversationMenu}
                                        >
                                            <MenuItem onClick={handleOpenEditDialog}>
                                                <ListItemIcon>
                                                    <EditIcon fontSize="small" />
                                                </ListItemIcon>
                                                <ListItemText>Đổi tên đoạn chat</ListItemText>
                                            </MenuItem>
                                            <MenuItem onClick={handleToggleParticipants}>
                                                <ListItemIcon>
                                                    <GroupIcon fontSize="small" />
                                                </ListItemIcon>
                                                <ListItemText>
                                                    {showParticipants ? "Ẩn thành viên" : "Hiển thị thành viên"}
                                                </ListItemText>
                                            </MenuItem>
                                            <Divider />
                                            <MenuItem onClick={handleCloseConversationMenu}>
                                                <ListItemIcon>
                                                    <DeleteIcon fontSize="small" color="error" />
                                                </ListItemIcon>
                                                <ListItemText sx={{ color: 'error.main' }}>
                                                    Xóa đoạn chat
                                                </ListItemText>
                                            </MenuItem>
                                        </Menu>
                                    </Box>
                                </Box>
                                
                                {/* Chat view */}
                                <ChatView
                                    key={`${selectedConversation.ConversationID}-${selectedConversation.UpdatedAt}`}
                                    conversationId={selectedConversation.ConversationID}
                                    currentUser={currentUser}
                                    onMessageSent={(convId, newMsg) => {
                                        fetchConversations();
                                        const newTimestamp = newMsg.SentAt || new Date().toISOString();
                                        setConversations(prevConvs =>
                                            prevConvs.map(c =>
                                                c.ConversationID === convId
                                                    ? { ...c, UpdatedAt: newTimestamp, last_message: newMsg }
                                                    : c
                                            ).sort((a, b) => new Date(b.UpdatedAt) - new Date(a.UpdatedAt))
                                        );
                                        if (selectedConversation && selectedConversation.ConversationID === convId) {
                                            setSelectedConversation(prevSelConv => ({
                                                ...prevSelConv,
                                                UpdatedAt: newTimestamp,
                                                last_message: newMsg,
                                            }));
                                        }
                                    }}
                                />
                            </>
                        ) : (
                            <Box sx={{
                                display: 'flex',
                                justifyContent: 'center',
                                alignItems: 'center',
                                height: '100%',
                                p: 3,
                                textAlign: 'center'
                            }}>
                                <Typography variant="h6" color="textSecondary">
                                    {isMobile ? 'Chọn một đoạn chat để bắt đầu trò chuyện.' : 'Chọn một đoạn chat để bắt đầu trò chuyện hoặc tạo một đoạn chat mới.'}
                                </Typography>
                            </Box>
                        )}
                    </Paper>
                </Grid>

                {/* Add participants sidebar */}
                {showParticipants && selectedConversation && (
                    <Grid
                        item
                        xs={12}
                        md={3}
                        lg={3}
                        sx={{
                            display: showChatViewPane ? 'flex' : 'none',
                            flexDirection: 'column',
                            height: '100%',
                            borderLeft: !isMobile ? `1px solid ${theme.palette.divider}` : 'none',
                            display: { xs: 'none', md: 'flex' }
                        }}
                    >
                        <Paper
                            elevation={0}
                            square
                            sx={{
                                flexGrow: 1,
                                overflowY: 'auto',
                                display: 'flex',
                                flexDirection: 'column',
                                height: '100%',
                                width: '100%'
                            }}
                        >
                            <Box sx={{ 
                                p: 2, 
                                borderBottom: `1px solid ${theme.palette.divider}`,
                                display: 'flex',
                                justifyContent: 'space-between',
                                alignItems: 'center'
                            }}>
                                <Typography variant="h6">
                                    Thành viên ({participants.length})
                                </Typography>
                                
                            </Box>
                            
                            {loadingParticipants ? (
                                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', p: 3 }}>
                                    <CircularProgress size={30} />
                                </Box>
                            ) : participants.length === 0 ? (
                                <Typography sx={{ textAlign: 'center', p: 3 }}>
                                    Không có thành viên nào trong đoạn chat này.
                                </Typography>
                            ) : (
                                <List>
                                    {participants.map((user, index) => (
                                        <React.Fragment key={user.UserID || user.id || index}>
                                            <ListItem
                                                sx={{ py: 1.5 }}
                                                secondaryAction={
                                                    <IconButton edge="end" size="small">
                                                        <MoreVertIcon fontSize="small" />
                                                    </IconButton>
                                                }
                                            >
                                                <ListItemAvatar>
                                                    <Badge
                                                        overlap="circular"
                                                        anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
                                                        badgeContent={
                                                            user.isAdmin ? (
                                                                <Tooltip title="Quản trị viên">
                                                                    <SettingsIcon fontSize="small" color="primary" />
                                                                </Tooltip>
                                                            ) : user.isOnline ? (
                                                                <Box
                                                                    sx={{
                                                                        width: 10,
                                                                        height: 10,
                                                                        bgcolor: 'success.main',
                                                                        borderRadius: '50%',
                                                                        border: `2px solid ${theme.palette.background.paper}`
                                                                    }}
                                                                />
                                                            ) : null
                                                        }
                                                    >
                                                        <Avatar>
                                                            {user.Avatar ? (
                                                                <img 
                                                                    src={user.Avatar} 
                                                                    alt={`${user.FirstName || ''} ${user.LastName || ''}`}
                                                                    style={{ width: '100%', height: '100%' }}
                                                                />
                                                            ) : (
                                                                <PersonIcon />
                                                            )}
                                                        </Avatar>
                                                    </Badge>
                                                </ListItemAvatar>
                                                <ListItemText
                                                    primary={
                                                        <Typography variant="body1">
                                                            {`${user.FirstName || ''} ${user.LastName || ''}`}
                                                            {user.UserID === currentUser.UserID && ' (Bạn)'}
                                                        </Typography>
                                                    }
                                                    secondary={user.Email || user.Username || user.Role || ''}
                                                />
                                            </ListItem>
                                            {index < participants.length - 1 && <Divider component="li" variant="inset" />}
                                        </React.Fragment>
                                    ))}
                                </List>
                            )}
                        </Paper>
                    </Grid>
                )}
            </Grid>

            {/* Edit conversation name dialog */}
            <Dialog
                open={editDialogOpen}
                onClose={() => setEditDialogOpen(false)}
                fullWidth
                maxWidth="xs"
            >
                <DialogTitle>Đổi tên đoạn chat</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Tên đoạn chat mới"
                        fullWidth
                        variant="outlined"
                        value={newConversationName}
                        onChange={(e) => setNewConversationName(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setEditDialogOpen(false)}>Hủy</Button>
                    <Button 
                        onClick={handleUpdateConversationName} 
                        variant="contained"
                        color="primary"
                        disabled={!newConversationName.trim()}
                    >
                        Lưu
                    </Button>
                </DialogActions>
            </Dialog>

            {/* User selection modal */}
            {currentUser &&
                <UserSelectionModal
                    open={isUserSelectionModalOpen}
                    onClose={handleCloseUserSelectionModal}
                    currentUserId={currentUser.UserID}
                    onConversationCreated={handleConversationCreated}
                    existingParticipantIds={selectedConversation ? participants.map(p => p.UserID || p.id) : []}
                    conversationId={selectedConversation?.ConversationID}
                />
            }

            {/* Mobile participants drawer */}
            {isMobile && (
                <Drawer
                    anchor="right"
                    open={showParticipants && selectedConversation !== null}
                    onClose={() => setShowParticipants(false)}
                >
                    <Box sx={{ width: 280 }}>
                        <Box sx={{ 
                            p: 2, 
                            borderBottom: `1px solid ${theme.palette.divider}`,
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center'
                        }}>
                            <Typography variant="h6">
                                Thành viên ({participants.length})
                            </Typography>
                            <IconButton onClick={() => setShowParticipants(false)}>
                                <CloseIcon />
                            </IconButton>
                        </Box>
                        
                        {loadingParticipants ? (
                            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', p: 3 }}>
                                <CircularProgress size={30} />
                            </Box>
                        ) : participants.length === 0 ? (
                            <Typography sx={{ textAlign: 'center', p: 3 }}>
                                Không có thành viên nào trong đoạn chat này.
                            </Typography>
                        ) : (
                            <List>
                                {participants.map((user, index) => (
                                    <React.Fragment key={user.UserID || user.id || index}>
                                        <ListItem sx={{ py: 1.5 }}>
                                            <ListItemAvatar>
                                                <Avatar>
                                                    {user.Avatar ? (
                                                        <img 
                                                            src={user.Avatar} 
                                                            alt={`${user.FirstName || ''} ${user.LastName || ''}`}
                                                            style={{ width: '100%', height: '100%' }}
                                                        />
                                                    ) : (
                                                        <PersonIcon />
                                                    )}
                                                </Avatar>
                                            </ListItemAvatar>
                                            <ListItemText
                                                primary={
                                                    <Typography variant="body1">
                                                        {`${user.FirstName || ''} ${user.LastName || ''}`}
                                                        {user.UserID === currentUser.UserID && ' (Bạn)'}
                                                    </Typography>
                                                }
                                                secondary={user.Email || user.Username || ''}
                                            />
                                        </ListItem>
                                        {index < participants.length - 1 && <Divider component="li" variant="inset" />}
                                    </React.Fragment>
                                ))}
                            </List>
                        )}
                    </Box>
                </Drawer>
            )}
        </Box>
    );
};

export default Messages;