import React, { useState, useEffect, useCallback } from 'react';
import { Box, Typography, Grid, Paper, CircularProgress, Alert, Button, Fab } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import messageService from '../../services/messageService';
import authService from '../../services/authService';
import ConversationList from './ConversationList'; // Will be created
import ChatView from './ChatView'; // Will be created
import UserSelectionModal from './UserSelectionModal'; // Will be created
import { useNavigate } from 'react-router-dom';

const Messages = () => {
    const navigate = useNavigate();
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
        // Add to list and select it
        setConversations(prev => [newConversation, ...prev.filter(c => c.ConversationID !== newConversation.ConversationID)]);
        setSelectedConversation(newConversation);
        fetchConversations(); // Re-fetch to ensure list is up-to-date and sorted
    };
    
    const handleMessageSent = (updatedConversation) => {
        // Update the conversation in the list, primarily its UpdatedAt and last_message
        setConversations(prevConvs => 
            prevConvs.map(c => c.ConversationID === updatedConversation.ConversationID ? updatedConversation : c)
                     .sort((a, b) => new Date(b.UpdatedAt) - new Date(a.UpdatedAt)) // Re-sort
        );
         // If the currently selected conversation is the one where message was sent, refresh its view
        if (selectedConversation && selectedConversation.ConversationID === updatedConversation.ConversationID) {
            setSelectedConversation(updatedConversation);
        }
        // Optionally, re-fetch all conversations to get the absolute latest state from server
        // fetchConversations(); 
    };


    if (!currentUser && !error) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '80vh' }}>
                <CircularProgress />
                <Typography sx={{ ml: 2 }}>Loading user information...</Typography>
            </Box>
        );
    }
    
    if (error && !loadingConversations) { // Show error prominently if not loading
        return (
            <Box sx={{ p: 3 }}>
                <Alert severity="error">{error}</Alert>
                {error.includes("log in") && <Button onClick={() => navigate('/login')} sx={{mt: 2}}>Go to Login</Button>}
            </Box>
        );
    }


    return (
        <Box sx={{ p: 2, height: 'calc(100vh - 64px - 48px)', display: 'flex', flexDirection: 'column' }}> {/* Adjust height based on Navbar/Footer */}
            <Typography variant="h4" gutterBottom sx={{ mb: 2 }}>
                Messages
            </Typography>
            {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
            <Grid container spacing={2} sx={{ flexGrow: 1, overflow: 'hidden' }}>
                <Grid item xs={12} md={4} sx={{ display: 'flex', flexDirection: 'column', height: '100%'}}>
                    <Paper sx={{ p: 2, flexGrow: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column' }}>
                        <Box sx={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 1}}>
                            <Typography variant="h6">Conversations</Typography>
                            <Fab color="primary" size="small" aria-label="add" onClick={handleOpenUserSelectionModal}>
                                <AddIcon />
                            </Fab>
                        </Box>
                        {loadingConversations ? (
                            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
                                <CircularProgress />
                            </Box>
                        ) : conversations.length === 0 && !error ? (
                             <Typography sx={{textAlign: 'center', mt: 2}}>No conversations yet. Start a new one!</Typography>
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
                <Grid item xs={12} md={8} sx={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
                    <Paper sx={{ p: 2, flexGrow: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column' }}>
                        {selectedConversation ? (
                            <ChatView
                                key={`${selectedConversation.ConversationID}-${selectedConversation.UpdatedAt}`} // Ensure ChatView re-mounts if UpdatedAt changes
                                conversationId={selectedConversation.ConversationID}
                                currentUser={currentUser}
                                onMessageSent={(convId, newMsg) => {
                                    // Fetch all conversations to get the latest state including sort order
                                    fetchConversations();
                                    
                                    // Optimistically update the local state for the sender for responsiveness
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
                                            // ChatView handles its own messages array internally through fetching,
                                            // but we update UpdatedAt here to ensure its key changes.
                                        }));
                                    }
                                }}
                            />
                        ) : (
                            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
                                <Typography variant="h6" color="textSecondary">
                                    Select a conversation to start chatting or create a new one.
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