import React, { useState, useEffect, useCallback } from 'react';
import {
    Box, Typography, Paper, Button, TextField, Grid, CircularProgress,
    Table, TableBody, TableCell, TableContainer, TableHead, TableRow, IconButton,
    Dialog, DialogActions, DialogContent, DialogTitle, FormControl, InputLabel, Select, MenuItem,
    Snackbar, Alert, Chip, Autocomplete, List, ListItem, ListItemText, ListItemSecondaryAction, Divider,
    Tooltip, Avatar, Stack, Card, CardContent
} from '@mui/material';
import {
    Chat as ChatIcon, Group as GroupIcon, Edit as EditIcon, Delete as DeleteIcon, 
    Visibility as VisibilityIcon, PersonAddAlt1 as PersonAddIcon, NoMeetingRoom as NoMeetingRoomIcon,
    Send as SendIcon, SmsFailed as SmsFailedIcon, Search as SearchIcon
} from '@mui/icons-material';
import adminConversationService from '../../services/adminConversationService';
import userService from '../../services/userService'; // Để lấy danh sách user khi thêm thành viên
import authService from '../../services/authService'; // Để lấy thông tin admin hiện tại (nếu cần)
import moment from 'moment'; // Để format ngày tháng

const ConversationMonitorPage = () => {
    // State cho danh sách cuộc trò chuyện
    const [conversations, setConversations] = useState([]);
    const [loadingConversations, setLoadingConversations] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');

    // State cho dialog chi tiết cuộc trò chuyện
    const [openDetailsDialog, setOpenDetailsDialog] = useState(false);
    const [selectedConversation, setSelectedConversation] = useState(null);
    const [loadingDetails, setLoadingDetails] = useState(false);
    const [messages, setMessages] = useState([]);
    const [participants, setParticipants] = useState([]);
    const messagesEndRef = React.useRef(null); // Ref for scrolling to bottom

    // State cho dialog đổi tên
    const [openEditNameDialog, setOpenEditNameDialog] = useState(false);
    const [conversationToEdit, setConversationToEdit] = useState(null);
    const [newConversationName, setNewConversationName] = useState('');

    // State cho dialog quản lý thành viên
    const [openManageParticipantsDialog, setOpenManageParticipantsDialog] = useState(false);
    const [usersForAutocomplete, setUsersForAutocomplete] = useState([]);
    const [selectedUserToManage, setSelectedUserToManage] = useState(null);
    const [loadingUsersForAutocomplete, setLoadingUsersForAutocomplete] = useState(false);

    // State cho dialog xác nhận xóa
    const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
    const [conversationToDelete, setConversationToDelete] = useState(null);

    // Snackbar
    const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });

    const showErrorSnackbar = (message) => {
        setSnackbar({ open: true, message: message || 'Đã xảy ra lỗi', severity: 'error' });
    };
    const showSuccessSnackbar = (message) => {
        setSnackbar({ open: true, message, severity: 'success' });
    };
    const handleCloseSnackbar = () => {
        setSnackbar({ ...snackbar, open: false });
    };

    // Fetching data
    const fetchConversations = useCallback(async () => {
        setLoadingConversations(true);
        try {
            // TODO: Thêm param search vào API backend nếu cần, hiện tại service chưa có
            const data = await adminConversationService.getAllConversations({ skip: 0, limit: 200 /* Tăng limit */ });
            setConversations(data || []);
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách cuộc trò chuyện.');
            setConversations([]);
        } finally {
            setLoadingConversations(false);
        }
    }, []); // Thêm searchTerm vào dependencies nếu API hỗ trợ search

    useEffect(() => {
        fetchConversations();
    }, [fetchConversations]);

    const fetchConversationDetails = async (conversationId) => {
        setLoadingDetails(true);
        try {
            const details = await adminConversationService.getConversationDetails(conversationId);
            if (details) {
                setMessages(details.messages || []);
                setParticipants(details.participants || []);
            }
        } catch (error) {
            showErrorSnackbar('Lỗi tải chi tiết cuộc trò chuyện.');
            setMessages([]);
            setParticipants([]);
        } finally {
            setLoadingDetails(false);
        }
    };

    const fetchAllUsersForAdding = useCallback(async () => {
        setLoadingUsersForAutocomplete(true);
        try {
            // Lấy tất cả user, có thể cần params để filter (ví dụ: trừ những người đã trong nhóm)
            const usersData = await userService.getUsers({ limit: 1000 }); 
            setUsersForAutocomplete(usersData || []);
        } catch (error) {
            showErrorSnackbar('Lỗi tải danh sách người dùng để thêm.');
        } finally {
            setLoadingUsersForAutocomplete(false);
        }
    }, []);

    // Handlers for main page actions
    const handleSearchChange = (event) => {
        setSearchTerm(event.target.value);
        // Implement client-side filtering or re-fetch if API supports search
    };

    const filteredConversations = conversations.filter(conv => 
        conv.Name?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    // View Details Dialog
    const handleOpenDetailsDialog = (conversation) => {
        setSelectedConversation(conversation);
        fetchConversationDetails(conversation.ConversationID);
        setOpenDetailsDialog(true);
    };
    const handleCloseDetailsDialog = () => {
        setOpenDetailsDialog(false);
        setSelectedConversation(null);
        setMessages([]);
        setParticipants([]);
    };

    // Edit Name Dialog
    const handleOpenEditNameDialog = (conversation) => {
        setConversationToEdit(conversation);
        setNewConversationName(conversation.Name || '');
        setOpenEditNameDialog(true);
    };
    const handleCloseEditNameDialog = () => {
        setOpenEditNameDialog(false);
        setConversationToEdit(null);
        setNewConversationName('');
    };
    const handleSaveConversationName = async () => {
        if (!conversationToEdit || !newConversationName.trim()) {
            showErrorSnackbar('Tên nhóm không được để trống.');
            return;
        }
        try {
            await adminConversationService.updateConversationName(conversationToEdit.ConversationID, { Name: newConversationName.trim() });
            showSuccessSnackbar('Đổi tên nhóm thành công!');
            fetchConversations(); // Refresh list
            handleCloseEditNameDialog();
        } catch (error) {
            showErrorSnackbar(error.response?.data?.detail || 'Lỗi đổi tên nhóm.');
        }
    };

    // Manage Participants Dialog
    const handleOpenManageParticipantsDialog = (conversation) => {
        setSelectedConversation(conversation); // Dùng lại state này vì context là conversation hiện tại
        // Fetch current participants for this conversation if not already loaded with details
        if (!participants.length || selectedConversation?.ConversationID !== conversation.ConversationID) {
             fetchConversationDetails(conversation.ConversationID); // Lấy cả messages và participants
        }
        fetchAllUsersForAdding();
        setOpenManageParticipantsDialog(true);
    };
    const handleCloseManageParticipantsDialog = () => {
        setOpenManageParticipantsDialog(false);
        setSelectedConversation(null);
        setSelectedUserToManage(null);
        setParticipants([]); // Reset participants khi đóng dialog
    };

    const handleAddParticipant = async () => {
        if (!selectedConversation || !selectedUserToManage) {
            showErrorSnackbar('Vui lòng chọn người dùng để thêm.');
            return;
        }
        try {
            await adminConversationService.addParticipants(selectedConversation.ConversationID, { user_ids: [selectedUserToManage.UserID] });
            showSuccessSnackbar(`${selectedUserToManage.FirstName} đã được thêm vào nhóm.`);
            fetchConversationDetails(selectedConversation.ConversationID); // Refresh participant list
            setSelectedUserToManage(null); // Reset autocomplete
        } catch (error) {
            showErrorSnackbar(error.response?.data?.detail || 'Lỗi thêm thành viên.');
        }
    };

    const handleRemoveParticipant = async (userIdToRemove) => {
        if (!selectedConversation) return;
        if (window.confirm(`Bạn có chắc muốn xóa thành viên ID: ${userIdToRemove} khỏi nhóm này?`)) {
            try {
                await adminConversationService.removeParticipants(selectedConversation.ConversationID, { user_ids: [userIdToRemove] });
                showSuccessSnackbar('Đã xóa thành viên khỏi nhóm.');
                fetchConversationDetails(selectedConversation.ConversationID); // Refresh participant list
            } catch (error) {
                showErrorSnackbar(error.response?.data?.detail || 'Lỗi xóa thành viên.');
            }
        }
    };

    // Delete Conversation Dialog
    const handleOpenDeleteDialog = (conversation) => {
        setConversationToDelete(conversation);
        setOpenDeleteDialog(true);
    };
    const handleCloseDeleteDialog = () => {
        setOpenDeleteDialog(false);
        setConversationToDelete(null);
    };
    const handleDeleteConversation = async () => {
        if (!conversationToDelete) return;
        try {
            await adminConversationService.deleteConversation(conversationToDelete.ConversationID);
            showSuccessSnackbar('Đã xóa cuộc trò chuyện!');
            fetchConversations(); // Refresh list
            handleCloseDeleteDialog();
        } catch (error) {
            showErrorSnackbar(error.response?.data?.detail || 'Lỗi xóa cuộc trò chuyện.');
        }
    };
    
    // Get current admin user (ví dụ để hiển thị tin nhắn của admin)
    const currentAdminUser = authService.getCurrentUser();

    // Effect to scroll to bottom of messages
    useEffect(() => {
        if (openDetailsDialog && messagesEndRef.current) {
            messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
        }
    }, [messages, openDetailsDialog]); // Rerun when messages change or dialog opens

    return (
        <Box sx={{ p: 3 }}>
            <Paper elevation={1} sx={{ p: 3, mb: 3 }}>
                <Typography variant="h4" component="h1" gutterBottom sx={{ 
                    mb: 3, 
                    display: 'flex', 
                    alignItems: 'center',
                    color: 'primary.main' 
                }}>
                    <GroupIcon sx={{ mr: 1, fontSize: 32 }} />
                    Giám sát & Quản lý Nhóm Chat
                </Typography>

                <Box sx={{ 
                    display: 'flex', 
                    justifyContent: 'space-between', 
                    alignItems: 'center', 
                    mb: 2,
                    flexWrap: 'wrap',
                    gap: 2
                }}>
                    <TextField 
                        label="Tìm kiếm theo tên nhóm"
                        variant="outlined"
                        size="small"
                        value={searchTerm}
                        onChange={handleSearchChange}
                        sx={{ 
                            width: { xs: '100%', sm: '400px' },
                            bgcolor: 'background.paper',
                            '& .MuiOutlinedInput-root': {
                                '& fieldset': {
                                    borderColor: 'primary.light',
                                },
                                '&:hover fieldset': {
                                    borderColor: 'primary.main',
                                },
                            }
                        }}
                        InputProps={{
                            startAdornment: (
                                <SearchIcon sx={{ mr: 1, color: 'primary.main' }} />
                            ),
                        }}
                    />
                    <Box sx={{ display: 'flex', gap: 1 }}>
                        <Chip 
                            icon={<ChatIcon />} 
                            label={`Tổng số: ${conversations.length} nhóm`} 
                            variant="outlined" 
                            color="primary"
                        />
                    </Box>
                </Box>
            </Paper>

            <Paper elevation={3} sx={{ overflow: 'hidden', borderRadius: 2 }}>
                <TableContainer sx={{ maxHeight: 600 }}>
                    <Table stickyHeader>
                        <TableHead>
                            <TableRow sx={{ bgcolor: 'primary.light' }}>
                                <TableCell sx={{fontWeight: 'bold', color: 'primary.dark'}}>ID</TableCell>
                                <TableCell sx={{fontWeight: 'bold', color: 'primary.dark'}}>Tên Nhóm</TableCell>
                                <TableCell sx={{fontWeight: 'bold', color: 'primary.dark'}} align="center">Số thành viên</TableCell>
                                <TableCell sx={{fontWeight: 'bold', color: 'primary.dark'}}>Ngày tạo</TableCell>
                                <TableCell sx={{fontWeight: 'bold', color: 'primary.dark'}} align="right">Thao tác</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {loadingConversations ? (
                                <TableRow><TableCell colSpan={5} align="center"><CircularProgress size={24} sx={{my: 2}} /></TableCell></TableRow>
                            ) : filteredConversations.length > 0 ? (
                                filteredConversations.map((conv) => (
                                    <TableRow 
                                        key={conv.ConversationID} 
                                        hover
                                        sx={{
                                            '&:nth-of-type(even)': {
                                                backgroundColor: 'action.hover',
                                            },
                                        }}
                                    >
                                        <TableCell>{conv.ConversationID}</TableCell>
                                        <TableCell>
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <Avatar sx={{ width: 24, height: 24, bgcolor: 'primary.main', fontSize: '0.8rem' }}>
                                                    {(conv.Name || "C")[0].toUpperCase()}
                                                </Avatar>
                                                <Typography variant="body2" sx={{ fontWeight: 'medium' }}>
                                                    {conv.Name || "(Chưa có tên)"}
                                                </Typography>
                                            </Box>
                                        </TableCell>
                                        <TableCell align="center">
                                            <Chip 
                                                label={conv.participants?.length || 0} 
                                                size="small" 
                                                color={conv.participants?.length > 0 ? "primary" : "default"}
                                                variant={conv.participants?.length > 0 ? "filled" : "outlined"}
                                            />
                                        </TableCell>
                                        <TableCell>{moment(conv.CreatedAt).format('DD/MM/YYYY HH:mm')}</TableCell>
                                        <TableCell align="right">
                                            <Tooltip title="Xem chi tiết & Tin nhắn">
                                                <IconButton size="small" color="primary" onClick={() => handleOpenDetailsDialog(conv)}>
                                                    <VisibilityIcon fontSize="small"/>
                                                </IconButton>
                                            </Tooltip>
                                            <Tooltip title="Đổi tên nhóm">
                                                <IconButton size="small" color="secondary" onClick={() => handleOpenEditNameDialog(conv)}>
                                                    <EditIcon fontSize="small"/>
                                                </IconButton>
                                            </Tooltip>
                                            <Tooltip title="Quản lý thành viên">
                                                <IconButton size="small" sx={{color: 'info.main'}} onClick={() => handleOpenManageParticipantsDialog(conv)}>
                                                    <PersonAddIcon fontSize="small"/>
                                                </IconButton>
                                            </Tooltip>
                                            <Tooltip title="Xóa nhóm">
                                                <IconButton size="small" color="error" onClick={() => handleOpenDeleteDialog(conv)}>
                                                    <DeleteIcon fontSize="small"/>
                                                </IconButton>
                                            </Tooltip>
                                        </TableCell>
                                    </TableRow>
                                ))
                            ) : (
                                <TableRow><TableCell colSpan={5} align="center" sx={{ py: 4 }}>
                                    <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 1, color: 'text.secondary' }}>
                                        <SmsFailedIcon sx={{ fontSize: 40 }} />
                                        {searchTerm ? "Không tìm thấy nhóm chat nào khớp." : "Chưa có nhóm chat nào."}
                                    </Box>
                                </TableCell></TableRow>
                            )}
                        </TableBody>
                    </Table>
                </TableContainer>
            </Paper>

            {/* View Details Dialog */}
            {selectedConversation && openDetailsDialog && (
                <Dialog 
                    open={openDetailsDialog} 
                    onClose={handleCloseDetailsDialog} 
                    maxWidth="lg"
                    fullWidth
                    sx={{
                        '& .MuiDialog-paper': {
                            width: '100%',
                            maxWidth: { xs: '95%', sm: '90%', md: '80%' },
                            maxHeight: '90vh',
                            m: { xs: 1, sm: 2 },
                            borderRadius: 1,
                            overflow: 'hidden'
                        }
                    }}
                >
                    <DialogTitle sx={{ 
                        py: 2, 
                        px: 3, 
                        bgcolor: 'primary.light', 
                        color: 'primary.dark',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'space-between'
                    }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <ChatIcon />
                            <Typography variant="h6" component="div">
                                Chi tiết Nhóm: {selectedConversation.Name || "(Chưa có tên)"}
                            </Typography>
                        </Box>
                        <Chip 
                            label={`ID: ${selectedConversation.ConversationID}`}
                            size="small"
                            variant="outlined"
                            sx={{ bgcolor: 'background.paper' }}
                        />
                    </DialogTitle>
                    <DialogContent dividers sx={{ p: 0, display: 'flex', flexDirection: 'column', height: '70vh' }}>
                        {loadingDetails ? (
                            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
                                <CircularProgress />
                            </Box>
                        ) : (
                            <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, height: '100%', overflow: 'hidden' }}>
                                {/* Members Panel */}
                                <Box sx={{ 
                                    width: { xs: '100%', md: '30%' }, 
                                    borderRight: { xs: 'none', md: '1px solid rgba(0, 0, 0, 0.12)' },
                                    borderBottom: { xs: '1px solid rgba(0, 0, 0, 0.12)', md: 'none' },
                                    height: { xs: 'auto', md: '100%' },
                                    display: 'flex',
                                    flexDirection: 'column'
                                }}>
                                    <Box sx={{ p: 2, borderBottom: '1px solid rgba(0, 0, 0, 0.12)' }}>
                                        <Typography variant="subtitle1" sx={{ fontWeight: 'bold', display: 'flex', alignItems: 'center', gap: 1 }}>
                                            <GroupIcon fontSize="small" color="primary" />
                                            Thành viên ({participants.length})
                                        </Typography>
                                    </Box>
                                    <Box sx={{ overflow: 'auto', flexGrow: 1 }}>
                                        <List dense>
                                            {participants.length > 0 ? participants.map(p => (
                                                <ListItem key={p.UserID} divider>
                                                    <ListItemText 
                                                        primary={
                                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                                <Avatar sx={{ width: 24, height: 24, bgcolor: 'secondary.main', fontSize: '0.8rem' }}>
                                                                    {p.FirstName[0].toUpperCase()}
                                                                </Avatar>
                                                                <Typography variant="body2" sx={{ fontWeight: 'medium' }}>
                                                                    {`${p.FirstName} ${p.LastName}`}
                                                                </Typography>
                                                            </Box>
                                                        }
                                                        secondary={p.Email}
                                                    />
                                                </ListItem>
                                            )) : (
                                                <ListItem>
                                                    <ListItemText 
                                                        primary={
                                                            <Box sx={{ textAlign: 'center', color: 'text.secondary', py: 2 }}>
                                                                <Typography>Không có thành viên.</Typography>
                                                            </Box>
                                                        } 
                                                    />
                                                </ListItem>
                                            )}
                                        </List>
                                    </Box>
                                </Box>
                                
                                {/* Messages Panel */}
                                <Box sx={{ 
                                    width: { xs: '100%', md: '70%' }, 
                                    height: { xs: 'calc(70vh - 200px)', md: '100%' },
                                    display: 'flex',
                                    flexDirection: 'column'
                                }}>
                                    <Box sx={{ p: 2, borderBottom: '1px solid rgba(0, 0, 0, 0.12)' }}>
                                        <Typography variant="subtitle1" sx={{ fontWeight: 'bold', display: 'flex', alignItems: 'center', gap: 1 }}>
                                            <ChatIcon fontSize="small" color="primary" />
                                            Tin nhắn ({messages.length})
                                        </Typography>
                                    </Box>
                                    <Box sx={{ p: 2, overflow: 'auto', flexGrow: 1 }}>
                                        {messages.length > 0 ? (
                                            messages.map((msg, index) => {
                                                const sender = participants.find(p => p.UserID === msg.UserID) || msg.user;
                                                const isAdminMsg = sender?.UserID === currentAdminUser?.UserID;
                                                const senderName = sender ? `${sender.FirstName} ${sender.LastName}` : 'Unknown User';
                                                
                                                return (
                                                    <Box 
                                                        key={msg.MessageID || index} 
                                                        sx={{
                                                            display: 'flex',
                                                            flexDirection: 'row',
                                                            alignItems: 'flex-start',
                                                            mb: 2,
                                                            alignSelf: isAdminMsg ? 'flex-end' : 'flex-start',
                                                            justifyContent: isAdminMsg ? 'flex-end' : 'flex-start',
                                                            width: '100%'
                                                        }}
                                                    >
                                                        <Box sx={{ 
                                                            display: 'flex', 
                                                            maxWidth: '75%',
                                                            flexDirection: isAdminMsg ? 'row-reverse' : 'row',
                                                            alignItems: 'flex-start',
                                                            gap: 1
                                                        }}>
                                                            <Avatar sx={{ 
                                                                bgcolor: isAdminMsg ? 'primary.main' : 'secondary.main',
                                                                width: 32, 
                                                                height: 32
                                                            }}>
                                                                {senderName.charAt(0).toUpperCase()}
                                                            </Avatar>
                                                            <Card sx={{
                                                                maxWidth: '100%',
                                                                bgcolor: isAdminMsg ? 'primary.light' : 'grey.100',
                                                                color: isAdminMsg ? 'primary.contrastText' : 'text.primary',
                                                                borderRadius: '12px',
                                                                boxShadow: 1
                                                            }}>
                                                                <CardContent sx={{ p: '8px 12px !important' }}>
                                                                    {!isAdminMsg && (
                                                                        <Typography variant="caption" component="div" sx={{ fontWeight: 'bold', mb: 0.5 }}>
                                                                            {senderName}
                                                                        </Typography>
                                                                    )}
                                                                    <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
                                                                        {msg.Content}
                                                                    </Typography>
                                                                    <Typography variant="caption" component="div" sx={{ 
                                                                        textAlign: 'right', 
                                                                        fontSize: '0.65rem', 
                                                                        color: isAdminMsg ? 'rgba(255,255,255,0.7)' : 'text.secondary', 
                                                                        mt: 0.5 
                                                                    }}>
                                                                        {moment(msg.SentAt).format('HH:mm DD/MM/YY')}
                                                                    </Typography>
                                                                </CardContent>
                                                            </Card>
                                                        </Box>
                                                    </Box>
                                                );
                                            })
                                        ) : (
                                            <Box sx={{textAlign: 'center', color: 'text.secondary', py:2}}>
                                                <SmsFailedIcon sx={{fontSize: 40, mb:1}}/>
                                                <Typography>Chưa có tin nhắn nào trong nhóm này.</Typography>
                                            </Box>
                                        )}
                                        <div ref={messagesEndRef} /> {/* Element to scroll to */}
                                    </Box>
                                </Box>
                            </Box>
                        )}
                    </DialogContent>
                    <DialogActions sx={{ p: 2, borderTop: '1px solid rgba(0, 0, 0, 0.12)' }}>
                        <Button onClick={handleCloseDetailsDialog} variant="outlined">Đóng</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Edit Name Dialog */}
            {conversationToEdit && (
                <Dialog 
                    open={openEditNameDialog} 
                    onClose={handleCloseEditNameDialog} 
                    maxWidth="sm" 
                    fullWidth
                    sx={{
                        '& .MuiDialog-paper': {
                            width: '100%',
                            maxWidth: { xs: '95%', sm: '500px' },
                            maxHeight: '90vh',
                            m: { xs: 1, sm: 2 },
                            borderRadius: 1
                        }
                    }}
                >
                    <DialogTitle sx={{ py: 2, bgcolor: 'secondary.light', color: 'secondary.dark' }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <EditIcon fontSize="small" />
                            Đổi tên Nhóm Chat
                        </Box>
                    </DialogTitle>
                    <DialogContent sx={{ p: 3, mt: 1 }}>
                        <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                            Nhập tên mới cho nhóm chat ID: {conversationToEdit.ConversationID}
                        </Typography>
                        <TextField
                            autoFocus
                            margin="dense"
                            label="Tên nhóm mới"
                            type="text"
                            fullWidth
                            variant="outlined"
                            value={newConversationName}
                            onChange={(e) => setNewConversationName(e.target.value)}
                            sx={{mt:1}}
                        />
                    </DialogContent>
                    <DialogActions sx={{ p: 2, borderTop: '1px solid rgba(0, 0, 0, 0.12)' }}>
                        <Button onClick={handleCloseEditNameDialog} color="inherit">Hủy</Button>
                        <Button 
                            onClick={handleSaveConversationName} 
                            variant="contained" 
                            color="secondary"
                            disabled={!newConversationName.trim()}
                        >
                            Lưu
                        </Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Manage Participants Dialog */}
            {selectedConversation && openManageParticipantsDialog && (
                <Dialog 
                    open={openManageParticipantsDialog} 
                    onClose={handleCloseManageParticipantsDialog} 
                    maxWidth="md" 
                    fullWidth 
                    sx={{
                        '& .MuiDialog-paper': {
                            width: '100%',
                            maxWidth: { xs: '95%', sm: '90%', md: '800px' },
                            maxHeight: '90vh',
                            m: { xs: 1, sm: 2 },
                            borderRadius: 1
                        }
                    }}
                >
                    <DialogTitle sx={{ py: 2, bgcolor: 'info.light', color: 'info.dark' }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <PersonAddIcon fontSize="small" />
                            Quản lý Thành viên: {selectedConversation.Name || '(Chưa có tên)'}
                        </Box>
                    </DialogTitle>
                    <DialogContent dividers sx={{ p: 0 }}>
                        <Grid container sx={{ height: '100%' }}>
                            <Grid item xs={12} md={6} sx={{ borderRight: { xs: 'none', md: '1px solid rgba(0, 0, 0, 0.12)' } }}>
                                <Box sx={{ p: 2, borderBottom: '1px solid rgba(0, 0, 0, 0.12)' }}>
                                    <Typography variant="subtitle1" sx={{ fontWeight: 'bold', mb: 1, display: 'flex', alignItems: 'center', gap: 1 }}>
                                        <GroupIcon fontSize="small" color="info" />
                                        Thành viên hiện tại ({participants.length})
                                    </Typography>
                                </Box>
                                <Box sx={{ p: 2 }}>
                                    {loadingDetails ? (
                                        <Box sx={{ display: 'flex', justifyContent: 'center', py: 2 }}>
                                            <CircularProgress size={24} />
                                        </Box>
                                    ) : (
                                        <List dense sx={{ maxHeight: 350, overflow: 'auto', border: '1px solid #eee', borderRadius: 1 }}>
                                            {participants.length > 0 ? participants.map(p => (
                                                <ListItem 
                                                    key={p.UserID} 
                                                    divider
                                                    secondaryAction={
                                                        <Tooltip title="Xóa khỏi nhóm">
                                                            <IconButton edge="end" size="small" onClick={() => handleRemoveParticipant(p.UserID)}>
                                                                <DeleteIcon fontSize="small" color="error" />
                                                            </IconButton>
                                                        </Tooltip>
                                                    }
                                                >
                                                    <ListItemText 
                                                        primary={
                                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                                <Avatar sx={{ width: 24, height: 24, bgcolor: 'info.main', fontSize: '0.8rem' }}>
                                                                    {p.FirstName[0].toUpperCase()}
                                                                </Avatar>
                                                                <Typography variant="body2" sx={{ fontWeight: 'medium' }}>
                                                                    {`${p.FirstName} ${p.LastName}`}
                                                                </Typography>
                                                            </Box>
                                                        }
                                                        secondary={p.Email} 
                                                    />
                                                </ListItem>
                                            )) : (
                                                <ListItem>
                                                    <ListItemText primary={
                                                        <Box sx={{ textAlign: 'center', color: 'text.secondary', py: 2 }}>
                                                            <Typography>Không có thành viên nào.</Typography>
                                                        </Box>
                                                    } />
                                                </ListItem>
                                            )}
                                        </List>
                                    )}
                                </Box>
                            </Grid>
                            <Grid item xs={12} md={6} sx={{ p: 2 }}>
                                <Typography variant="subtitle1" sx={{ fontWeight: 'bold', mb: 2, display: 'flex', alignItems: 'center', gap: 1 }}>
                                    <PersonAddIcon fontSize="small" color="info" />
                                    Thêm thành viên mới
                                </Typography>
                                
                                {loadingUsersForAutocomplete ? (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', py: 2 }}>
                                        <CircularProgress size={24} />
                                    </Box>
                                ) : (
                                    <>
                                        <Autocomplete
                                            options={usersForAutocomplete.filter(user => 
                                                !participants.some(p => p.UserID === user.UserID)
                                            )}
                                            getOptionLabel={(option) => `${option.FirstName} ${option.LastName} (${option.Email} - ${option.role})`}
                                            value={selectedUserToManage}
                                            onChange={(event, newValue) => {
                                                setSelectedUserToManage(newValue);
                                            }}
                                            isOptionEqualToValue={(option, value) => option.UserID === value.UserID}
                                            renderInput={(params) => 
                                                <TextField 
                                                    {...params} 
                                                    label="Tìm và chọn người dùng" 
                                                    variant="outlined" 
                                                    size="small"
                                                    fullWidth
                                                />
                                            }
                                            renderOption={(props, option) => (
                                                <li {...props}>
                                                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                        <Avatar sx={{ width: 24, height: 24, bgcolor: 'info.main', fontSize: '0.8rem' }}>
                                                            {option.FirstName[0].toUpperCase()}
                                                        </Avatar>
                                                        <Box>
                                                            <Typography variant="body2">{`${option.FirstName} ${option.LastName}`}</Typography>
                                                            <Typography variant="caption" color="text.secondary">
                                                                {option.Email} - {option.role}
                                                            </Typography>
                                                        </Box>
                                                    </Box>
                                                </li>
                                            )}
                                        />
                                        <Button 
                                            variant="contained" 
                                            color="info"
                                            onClick={handleAddParticipant} 
                                            disabled={!selectedUserToManage}
                                            startIcon={<PersonAddIcon/>}
                                            sx={{mt:3}}
                                            fullWidth
                                        >
                                            Thêm vào nhóm
                                        </Button>
                                    </>
                                )}
                            </Grid>
                        </Grid>
                    </DialogContent>
                    <DialogActions sx={{ p: 2, borderTop: '1px solid rgba(0, 0, 0, 0.12)' }}>
                        <Button onClick={handleCloseManageParticipantsDialog} variant="outlined">Đóng</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Delete Confirmation Dialog */}
            {conversationToDelete && (
                <Dialog 
                    open={openDeleteDialog} 
                    onClose={handleCloseDeleteDialog} 
                    maxWidth="xs"
                    sx={{
                        '& .MuiDialog-paper': {
                            width: '100%',
                            maxWidth: { xs: '95%', sm: '400px' },
                            m: { xs: 1, sm: 2 },
                            borderRadius: 1
                        }
                    }}
                >
                    <DialogTitle sx={{ py: 2, bgcolor: 'error.light', color: 'error.dark' }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <DeleteIcon fontSize="small" />
                            Xác nhận Xóa
                        </Box>
                    </DialogTitle>
                    <DialogContent sx={{ p: 3, mt: 1 }}>
                        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', mb: 2 }}>
                            <NoMeetingRoomIcon sx={{ fontSize: 48, color: 'error.main', mb: 2 }} />
                            <Typography variant="subtitle1" sx={{ fontWeight: 'bold', textAlign: 'center' }}>
                                Bạn có chắc chắn muốn xóa nhóm này?
                            </Typography>
                        </Box>
                        <Paper variant="outlined" sx={{ p: 2, bgcolor: 'background.default', mb: 2 }}>
                            <Typography variant="body2" sx={{ mb: 1 }}>
                                <strong>Tên nhóm:</strong> {conversationToDelete.Name || '(Không tên)'}
                            </Typography>
                            <Typography variant="body2">
                                <strong>ID:</strong> {conversationToDelete.ConversationID}
                            </Typography>
                        </Paper>
                        <Typography variant="body2" color="error" sx={{ fontStyle: 'italic' }}>
                            Lưu ý: Hành động này không thể hoàn tác và tất cả tin nhắn trong nhóm sẽ bị xóa.
                        </Typography>
                    </DialogContent>
                    <DialogActions sx={{ p: 2, borderTop: '1px solid rgba(0, 0, 0, 0.12)', justifyContent: 'space-between' }}>
                        <Button onClick={handleCloseDeleteDialog} color="inherit">Hủy</Button>
                        <Button 
                            onClick={handleDeleteConversation} 
                            color="error" 
                            variant="contained"
                            startIcon={<DeleteIcon />}
                        >
                            Xóa
                        </Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Snackbar */}
            <Snackbar 
                open={snackbar.open} 
                autoHideDuration={6000} 
                onClose={handleCloseSnackbar} 
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert 
                    onClose={handleCloseSnackbar} 
                    severity={snackbar.severity} 
                    variant="filled" 
                    sx={{ width: '100%' }}
                >
                    {snackbar.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default ConversationMonitorPage; 