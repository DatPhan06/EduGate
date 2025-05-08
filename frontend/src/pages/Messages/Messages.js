import React, { useState, useEffect, useCallback } from 'react';
import { Box, Typography, Grid, Paper, CircularProgress, Alert, Button, Fab, useTheme, useMediaQuery } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import messageService from '../../services/messageService';
import authService from '../../services/authService';
import ConversationList from './ConversationList'; 
import ChatView from './ChatView';
import UserSelectionModal from './UserSelectionModal';
import { useNavigate } from 'react-router-dom';

const Messages = () => {
    const navigate = useNavigate();
    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm')); // Changed to 'sm' for a more common mobile breakpoint

    const [currentUser, setCurrentUser] = useState(null);
    const [conversations, setConversations] = useState([]);
    const [selectedConversation, setSelectedConversation] = useState(null);
    const [loadingConversations, setLoadingConversations] = useState(true);
    const [error, setError] = useState('');
    const [isUserSelectionModalOpen, setIsUserSelectionModalOpen] = useState(false);

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

    useEffect(() => {
        if (currentUser) {
            fetchConversations();
        }
    }, [currentUser, fetchConversations]);

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
                Messages
                {isMobile && selectedConversation && (
                    <Button
                        onClick={() => setSelectedConversation(null)}
                        sx={{ ml: 2, fontSize: '0.8rem' }}
                    >
                        Back to conversations
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
                        <Box sx={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            p: 2,
                            borderBottom: `1px solid ${theme.palette.divider}`
                        }}>
                            <Typography variant="h6">Conversations</Typography>
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
                                No conversations yet. Start a new one!
                            </Typography>
                        ) : (
                            <ConversationList
                                conversations={conversations}
                                onSelectConversation={handleSelectConversation}
                                selectedConversationId={selectedConversation?.ConversationID}
                                currentUser={currentUser}
                            />
                        )}
                    </Paper>
                </Grid>

                <Grid
                    item
                    xs={12} // Full width on mobile if visible
                    md={9}  // 9/12 = 75% on medium screens and up
                    lg={9}  // 9/12 = 75% on large screens
                    sx={{
                        display: showChatViewPane ? 'flex' : 'none',
                        flexDirection: 'column',
                        height: '100%',
                        flexGrow: 1, // Ensure this item tries to grow
                        minWidth: 0, // Allow shrinking below content size if necessary for flex calculation
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
                            width: '100%' // Ensure Paper takes full width of the Grid item
                        }}
                    >
                        {selectedConversation ? (
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
                                    {isMobile ? 'Select a conversation to start chatting.' : 'Select a conversation to start chatting or create a new one.'}
                                </Typography>
                            </Box>
                        )}
                    </Paper>
                </Grid>
            </Grid>

            {currentUser &&
                <UserSelectionModal
                    open={isUserSelectionModalOpen}
                    onClose={handleCloseUserSelectionModal}
                    currentUserId={currentUser.UserID}
                    onConversationCreated={handleConversationCreated}
                />
            }
        </Box>
    );
};

export default Messages;