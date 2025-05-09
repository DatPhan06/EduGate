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

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" component="h1" gutterBottom sx={{ mb: 3 }}>
                <GroupIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
                Giám sát & Quản lý Nhóm Chat
            </Typography>

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <TextField 
                    label="Tìm kiếm theo tên nhóm"
                    variant="outlined"
                    size="small"
                    value={searchTerm}
                    onChange={handleSearchChange}
                    sx={{ width: { xs: '100%', sm: '400px' } }}
                    InputProps={{
                        startAdornment: (
                            <SearchIcon sx={{ mr: 1, color: 'action.active' }} />
                        ),
                    }}
                />
                {/* Button tạo nhóm mới có thể thêm ở đây nếu cần */}
            </Box>

            <TableContainer component={Paper} sx={{ maxHeight: 600 }}>
                <Table stickyHeader>
                    <TableHead>
                        <TableRow>
                            <TableCell sx={{fontWeight: 'bold'}}>ID</TableCell>
                            <TableCell sx={{fontWeight: 'bold'}}>Tên Nhóm</TableCell>
                            <TableCell sx={{fontWeight: 'bold'}} align="center">Số thành viên</TableCell>
                            <TableCell sx={{fontWeight: 'bold'}}>Ngày tạo</TableCell>
                            <TableCell sx={{fontWeight: 'bold'}} align="right">Thao tác</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {loadingConversations ? (
                            <TableRow><TableCell colSpan={5} align="center"><CircularProgress size={24} sx={{my: 2}} /></TableCell></TableRow>
                        ) : filteredConversations.length > 0 ? (
                            filteredConversations.map((conv) => (
                                <TableRow key={conv.ConversationID} hover>
                                    <TableCell>{conv.ConversationID}</TableCell>
                                    <TableCell>{conv.Name || "(Chưa có tên)"}</TableCell>
                                    <TableCell align="center">{conv.participants?.length || 0}</TableCell>
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
                            <TableRow><TableCell colSpan={5} align="center">
                                {searchTerm ? "Không tìm thấy nhóm chat nào khớp." : "Chưa có nhóm chat nào."}
                            </TableCell></TableRow>
                        )}
                    </TableBody>
                </Table>
            </TableContainer>

            {/* View Details Dialog */}
            {selectedConversation && openDetailsDialog && (
                <Dialog open={openDetailsDialog} onClose={handleCloseDetailsDialog} maxWidth="md" fullWidth scroll="paper">
                    <DialogTitle>
                        Chi tiết Nhóm: {selectedConversation.Name || "(Chưa có tên)"} (ID: {selectedConversation.ConversationID})
                    </DialogTitle>
                    <DialogContent dividers>
                        {loadingDetails ? (
                            <Box sx={{ display: 'flex', justifyContent: 'center', my: 3 }}><CircularProgress /></Box>
                        ) : (
                            <Grid container spacing={2}>
                                <Grid item xs={12} md={4}>
                                    <Typography variant="h6" gutterBottom>Thành viên ({participants.length})</Typography>
                                    <Paper variant="outlined" sx={{ maxHeight: 400, overflow: 'auto' }}>
                                        <List dense>
                                            {participants.length > 0 ? participants.map(p => (
                                                <ListItem key={p.UserID}>
                                                    <ListItemText 
                                                        primary={`${p.FirstName} ${p.LastName}`}
                                                        secondary={p.Email}
                                                    />
                                                </ListItem>
                                            )) : <ListItem><ListItemText primary="Không có thành viên." /></ListItem>}
                                        </List>
                                    </Paper>
                                </Grid>
                                <Grid item xs={12} md={8}>
                                    <Typography variant="h6" gutterBottom>Tin nhắn ({messages.length})</Typography>
                                    <Paper variant="outlined" sx={{ maxHeight: 400, overflow: 'auto', p: 1, display: 'flex', flexDirection: 'column-reverse' }}>
                                        {messages.length > 0 ? (
                                            [...messages].reverse().map((msg, index) => { // Hiển thị tin mới nhất ở dưới
                                                const sender = participants.find(p => p.UserID === msg.UserID) || msg.user;
                                                const isAdminMsg = sender?.UserID === currentAdminUser?.UserID;
                                                return (
                                                    <Box key={msg.MessageID || index} sx={{
                                                        mb: 1,
                                                        display: 'flex',
                                                        flexDirection: isAdminMsg ? 'row-reverse' : 'row',
                                                    }}>
                                                        <Card sx={{
                                                            maxWidth: '70%',
                                                            bgcolor: isAdminMsg ? 'primary.light' : 'grey.200',
                                                            color: isAdminMsg ? 'primary.contrastText' : 'text.primary',
                                                        }}>
                                                            <CardContent sx={{ p: '8px !important' }}>
                                                                {!isAdminMsg && sender && (
                                                                    <Typography variant="caption" component="div" sx={{ fontWeight: 'bold' }}>
                                                                        {sender.FirstName} {sender.LastName}
                                                                    </Typography>
                                                                )}
                                                                <Typography variant="body2">{msg.Content}</Typography>
                                                                <Typography variant="caption" component="div" sx={{ textAlign: 'right', fontSize: '0.7rem', mt: 0.5 }}>
                                                                    {moment(msg.SentAt).format('HH:mm DD/MM/YY')}
                                                                </Typography>
                                                            </CardContent>
                                                        </Card>
                                                    </Box>
                                                );
                                            })
                                        ) : (
                                            <Box sx={{textAlign: 'center', color: 'text.secondary', py:2}}>
                                                <SmsFailedIcon sx={{fontSize: 40, mb:1}}/>
                                                <Typography>Chưa có tin nhắn nào trong nhóm này.</Typography>
                                            </Box>
                                        )}
                                    </Paper>
                                </Grid>
                            </Grid>
                        )}
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseDetailsDialog}>Đóng</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Edit Name Dialog */}
            {conversationToEdit && (
                <Dialog open={openEditNameDialog} onClose={handleCloseEditNameDialog} maxWidth="sm" fullWidth>
                    <DialogTitle>Đổi tên Nhóm Chat</DialogTitle>
                    <DialogContent>
                        <TextField
                            autoFocus
                            margin="dense"
                            label="Tên nhóm mới"
                            type="text"
                            fullWidth
                            variant="standard"
                            value={newConversationName}
                            onChange={(e) => setNewConversationName(e.target.value)}
                            sx={{mt:1}}
                        />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseEditNameDialog}>Hủy</Button>
                        <Button onClick={handleSaveConversationName} variant="contained">Lưu</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Manage Participants Dialog */}
            {selectedConversation && openManageParticipantsDialog && (
                 <Dialog open={openManageParticipantsDialog} onClose={handleCloseManageParticipantsDialog} maxWidth="md" fullWidth scroll="paper">
                    <DialogTitle>Quản lý Thành viên: {selectedConversation.Name || '(Chưa có tên)'}</DialogTitle>
                    <DialogContent dividers>
                        <Grid container spacing={2}>
                            <Grid item xs={12} md={6}>
                                <Typography variant="subtitle1" gutterBottom>Thành viên hiện tại ({participants.length})</Typography>
                                {loadingDetails ? <CircularProgress size={20}/> :
                                <List dense sx={{ maxHeight: 300, overflow: 'auto', border: '1px solid #ddd', borderRadius: 1, p:1}}>
                                    {participants.length > 0 ? participants.map(p => (
                                        <ListItem 
                                            key={p.UserID} 
                                            secondaryAction={
                                                <Tooltip title="Xóa khỏi nhóm">
                                                    <IconButton edge="end" size="small" onClick={() => handleRemoveParticipant(p.UserID)}>
                                                        <DeleteIcon fontSize="small" color="error" />
                                                    </IconButton>
                                                </Tooltip>
                                            }
                                        >
                                            <ListItemText primary={`${p.FirstName} ${p.LastName}`} secondary={p.Email} />
                                        </ListItem>
                                    )) : <ListItem><ListItemText primary="Không có thành viên nào." /></ListItem>}
                                </List>}
                            </Grid>
                            <Grid item xs={12} md={6}>
                                <Typography variant="subtitle1" gutterBottom>Thêm thành viên mới</Typography>
                                {loadingUsersForAutocomplete ? <CircularProgress size={20}/> :
                                <Autocomplete
                                    options={usersForAutocomplete.filter(user => 
                                        !participants.some(p => p.UserID === user.UserID) // Chỉ hiển thị user chưa có trong nhóm
                                    )}
                                    getOptionLabel={(option) => `${option.FirstName} ${option.LastName} (${option.Email} - ${option.role})`}
                                    value={selectedUserToManage}
                                    onChange={(event, newValue) => {
                                        setSelectedUserToManage(newValue);
                                    }}
                                    isOptionEqualToValue={(option, value) => option.UserID === value.UserID}
                                    renderInput={(params) => <TextField {...params} label="Tìm và chọn người dùng" variant="outlined" size="small" />}
                                    fullWidth
                                />}
                                <Button 
                                    variant="contained" 
                                    onClick={handleAddParticipant} 
                                    disabled={!selectedUserToManage}
                                    startIcon={<PersonAddIcon/>}
                                    sx={{mt:2}}
                                >
                                    Thêm vào nhóm
                                </Button>
                            </Grid>
                        </Grid>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseManageParticipantsDialog}>Đóng</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Delete Confirmation Dialog */}
            {conversationToDelete && (
                <Dialog open={openDeleteDialog} onClose={handleCloseDeleteDialog} maxWidth="xs">
                    <DialogTitle>Xác nhận Xóa</DialogTitle>
                    <DialogContent>
                        <Typography>
                            Bạn có chắc chắn muốn xóa nhóm 
                            <strong>"{conversationToDelete.Name || '(Không tên)'}"</strong> (ID: {conversationToDelete.ConversationID})?
                            Hành động này không thể hoàn tác.
                        </Typography>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseDeleteDialog}>Hủy</Button>
                        <Button onClick={handleDeleteConversation} color="error" variant="contained">Xóa</Button>
                    </DialogActions>
                </Dialog>
            )}

            {/* Snackbar */}
            <Snackbar open={snackbar.open} autoHideDuration={6000} onClose={handleCloseSnackbar} anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}>
                <Alert onClose={handleCloseSnackbar} severity={snackbar.severity} variant="filled" sx={{ width: '100%' }}>
                    {snackbar.message}
                </Alert>
            </Snackbar>
        </Box>
    );
};

export default ConversationMonitorPage; 