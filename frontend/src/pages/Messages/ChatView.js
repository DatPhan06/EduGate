import React, { useState, useEffect, useRef } from 'react';
import { 
  Box, 
  Typography, 
  TextField, 
  Button, 
  Paper, 
  CircularProgress, 
  Avatar, 
  Divider,
  IconButton,
  useTheme, // Import useTheme
  useMediaQuery // Import useMediaQuery
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';
import messageService from '../../services/messageService';
import moment from 'moment';

const POLLING_INTERVAL = 5000; // Poll every 5 seconds

const ChatView = ({ conversationId, currentUser, onMessageSent, onMessageReceivedByPolling }) => {
  const theme = useTheme(); // Add this
  const isMobile = useMediaQuery(theme.breakpoints.down('sm')); // Add this

  const [conversation, setConversation] = useState(null);
  const [messages, setMessages] = useState([]);
  const messagesRef = useRef(messages); // Ref to keep track of messages for polling comparison
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState('');
  const messagesEndRef = useRef(null);

  // Update messagesRef whenever messages state changes
  useEffect(() => {
    messagesRef.current = messages;
  }, [messages]);
  
  // Fetch conversation when conversationId changes
  useEffect(() => {
    const fetchConversation = async () => {
      if (!conversationId) return;
      
      try {
        setLoading(true);
        setError('');
        const data = await messageService.getConversationById(conversationId);
        setConversation(data);
        setMessages(data.messages || []);
      } catch (err) {
        console.error(`Error fetching conversation ${conversationId}:`, err);
        setError('Failed to load conversation. Please try again.');
      } finally {
        setLoading(false);
      }
    };
    
    fetchConversation();
    // Cleanup function for when conversationId changes or component unmounts
    return () => {
      // Optional: any cleanup specific to conversation change before new one loads
    };
  }, [conversationId]); // Only re-fetch when conversationId changes

  // Polling for new messages
  useEffect(() => {
    if (!conversationId) {
      return; // No conversation selected, so no polling
    }

    const fetchLatestMessages = async () => {
      try {
        const data = await messageService.getConversationById(conversationId);
        // Update conversation details and messages
        setConversation(data); 
        setMessages(data.messages || []);
      } catch (err) {
        // Log polling errors to the console, avoid disrupting UI with major error.
        console.warn(`Failed to poll for new messages in conversation ${conversationId}:`, err);
      }
    };

    const intervalId = setInterval(fetchLatestMessages, POLLING_INTERVAL);

    // Cleanup function to clear the interval
    return () => {
      clearInterval(intervalId);
    };
  }, [conversationId]); // Re-run if conversationId changes

  // Scroll to bottom when messages change
  useEffect(() => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages]);
  
  // useEffect for polling new messages
  useEffect(() => {
    // Only start polling if there's a conversationId and initial loading is complete
    if (!conversationId || loading) {
      return; // Exit if no conversation ID or if currently loading initial data
    }

    const pollMessages = async () => {
      try {
        const data = await messageService.getConversationById(conversationId); // Ensure messageService is accessible
        if (data && data.messages) {
          // Use functional update to access the latest `messages` state
          setMessages(currentMessages => {
            const newFetchedMessages = data.messages;

            // Check if messages have actually changed to avoid unnecessary re-renders
            // This assumes messages have a unique 'MessageID' and are sorted.
            // Adjust if your message object structure is different.
            const lastCurrentMessage = currentMessages[currentMessages.length - 1];
            const lastNewFetchedMessage = newFetchedMessages[newFetchedMessages.length - 1];

            if (currentMessages.length !== newFetchedMessages.length ||
                (lastCurrentMessage && lastNewFetchedMessage && lastCurrentMessage.MessageID !== lastNewFetchedMessage.MessageID) ||
                (currentMessages.length === 0 && newFetchedMessages.length > 0) || // From no messages to some
                (!lastCurrentMessage && lastNewFetchedMessage) // Also from no messages to some
               ) {
              return newFetchedMessages; // Update state with new messages
            }
            return currentMessages; // No change, return current state
          });
        }
      } catch (err) {
        console.error(`Error polling for messages in conversation ${conversationId}:`, err);
        // Avoid setting a general error that might overwrite a more specific one (e.g., send error)
      }
    };

    const intervalId = setInterval(pollMessages, 5000); // Poll every 5 seconds

    // Cleanup function: clear interval when component unmounts or dependencies change
    return () => {
      clearInterval(intervalId);
    };
  }, [conversationId, loading, messageService]); // Dependencies for re-running the effect

  const handleMessageChange = (e) => {
    setNewMessage(e.target.value);
  };
  
  const handleSendMessage = async (e) => {
    e.preventDefault();
    if (!newMessage.trim() || !conversationId || !currentUser) return;
    
    try {
      setSending(true);
      const sentMessage = await messageService.sendMessage(conversationId, newMessage.trim());
      
      // Add the sent message to the local state
      setMessages(prev => [...prev, sentMessage]);
      setNewMessage(''); // Clear input
      
      // Notify parent component
      if (onMessageSent) {
        onMessageSent(conversationId, sentMessage);
      }
    } catch (err) {
      console.error('Error sending message:', err);
      setError('Failed to send message. Please try again.');
    } finally {
      setSending(false);
    }
  };
  
  const formatMessageTime = (timestamp) => {
    return moment(timestamp).format('h:mm A');
  };
  
  const formatMessageDate = (timestamp) => {
    const messageDate = moment(timestamp).startOf('day');
    const today = moment().startOf('day');
    const yesterday = moment().subtract(1, 'day').startOf('day');
    
    if (messageDate.isSame(today)) {
      return 'Today';
    } else if (messageDate.isSame(yesterday)) {
      return 'Yesterday';
    } else {
      return messageDate.format('MMMM D, YYYY');
    }
  };
  
  // Group messages by date
  const groupMessagesByDate = () => {
    const groups = {};
    messages.forEach(message => {
      const dateKey = moment(message.SentAt).startOf('day').format('YYYY-MM-DD');
      if (!groups[dateKey]) {
        groups[dateKey] = [];
      }
      groups[dateKey].push(message);
    });
    
    return Object.entries(groups).map(([dateKey, msgs]) => ({
      date: msgs[0].SentAt,
      messages: msgs
    }));
  };
  
  // Get participant name and details
  const getParticipantName = (userId) => {
    if (!conversation || !conversation.participants) return '';
    
    const participant = conversation.participants.find(p => p.UserID === userId);
    return participant ? `${participant.FirstName} ${participant.LastName}` : 'Unknown User';
  };
  
  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
        <CircularProgress />
      </Box>
    );
  }
  
  if (error) {
    return (
      <Box sx={{ p: 3, textAlign: 'center' }}>
        <Typography color="error" gutterBottom>{error}</Typography>
        <Button 
          variant="outlined" 
          onClick={() => window.location.reload()}
        >
          Try Again
        </Button>
      </Box>
    );
  }
  
  if (!conversation) {
    return (
      <Box sx={{ p: 3, textAlign: 'center' }}>
        <Typography variant="body1">No conversation selected.</Typography>
      </Box>
    );
  }

  const messageGroups = groupMessagesByDate();
  
  return (
    <Box sx={{ 
      display: 'flex', 
      flexDirection: 'column', 
      height: '100%',
      width: '100%'
    }}>
      {/* Conversation Header */}
      <Box sx={{ p: 2, borderBottom: '1px solid rgba(0, 0, 0, 0.12)' }}>
        <Typography variant="h6" component="div">
          {conversation.Name || getParticipantName(
            conversation.participants.find(p => p.UserID !== currentUser.UserID)?.UserID
          )}
        </Typography>
        <Typography variant="body2" color="text.secondary">
          {conversation.participants.length} participants
        </Typography>
      </Box>
      
      {/* Messages Area */}
      <Box sx={{ 
        flexGrow: 1, 
        overflowY: 'auto', 
        overflowX: 'hidden', // Add this to prevent horizontal scrollbar here
        p: isMobile ? 0.5 : 1, // Overall padding for the messages area
        display: 'flex',
        flexDirection: 'column',
        bgcolor: theme.palette.grey[50],
        width: '100%'
      }}>
        {messages.length === 0 ? (
          <Box sx={{ 
            display: 'flex', 
            flexDirection: 'column', 
            alignItems: 'center', 
            justifyContent: 'center',
            height: '100%' 
          }}>
            <Typography variant="body1" color="text.secondary">
              No messages yet. Send one to start the conversation!
            </Typography>
          </Box>
        ) : (
          messageGroups.map((group, groupIndex) => (
            <Box key={`group-${groupIndex}`} sx={{ mb: 3, width: '100%' }}>
              {/* Date Divider */}
              <Box sx={{ 
                display: 'flex', 
                alignItems: 'center', 
                justifyContent: 'center',
                my: 2 
              }}>
                <Divider sx={{ flexGrow: 1 }} />
                <Typography 
                  variant="caption" 
                  sx={{ px: 2, color: 'text.secondary' }}
                >
                  {formatMessageDate(group.date)}
                </Typography>
                <Divider sx={{ flexGrow: 1 }} />
              </Box>
              
              {/* Messages */}
              {group.messages.map((message, index) => {
                const isCurrentUser = message.UserID === currentUser.UserID;
                
                return (
                  <Box 
                    key={message.MessageID} 
                    sx={{ 
                      display: 'flex',
                      flexDirection: isCurrentUser ? 'row-reverse' : 'row',
                      mb: 1.5,
                      alignItems: 'flex-end',
                      width: '100%',
                      px: { xs: 1, sm: 2 }, // Padding for each message row
                    }}
                  >
                    {/* Avatar */}
                    {!isCurrentUser && (
                      <Avatar 
                        sx={{ width: 32, height: 32, mr: 1, flexShrink: 0 }}
                        alt={getParticipantName(message.UserID)}
                      >
                        {getParticipantName(message.UserID)[0]}
                      </Avatar>
                    )}
                    
                    {/* Message Bubble */}
                    <Paper
                      elevation={1}
                      sx={{
                        p: 1.5,
                        maxWidth: isMobile ? '80%' : '75%', // Bubble max width
                        minWidth: '80px', // Ensure very short messages still have some width
                        width: 'auto',
                        borderRadius: 2,
                        bgcolor: isCurrentUser ? 'primary.light' : 'background.paper',
                        color: isCurrentUser ? 'common.white' : 'text.primary',
                        borderTopLeftRadius: !isCurrentUser ? 0 : 2,
                        borderTopRightRadius: isCurrentUser ? 0 : 2,
                        boxShadow: theme.shadows[1],
                        wordBreak: 'break-word'
                      }}
                    >
                      {!isCurrentUser && (
                        <Typography variant="caption" sx={{ fontWeight: 'bold', display: 'block', mb: 0.5 }}>
                          {getParticipantName(message.UserID)}
                        </Typography>
                      )}
                      <Typography variant="body1">{message.Content}</Typography>
                      <Typography 
                        variant="caption" 
                        sx={{ 
                          display: 'block', 
                          textAlign: isCurrentUser ? 'right' : 'left',
                          color: isCurrentUser ? 'rgba(255, 255, 255, 0.7)' : 'text.secondary',
                          mt: 0.5
                        }}
                      >
                        {formatMessageTime(message.SentAt)}
                      </Typography>
                    </Paper>
                    
                    {/* Spacer for sender's messages instead of avatar */}
                    {isCurrentUser && <Box sx={{ width: 32, ml: 1, flexShrink: 0 }} />}
                  </Box>
                );
              })}
            </Box>
          ))
        )}
        <div ref={messagesEndRef} />
      </Box>
      
      {/* Message Input */}
      <Box 
        component="form"
        onSubmit={handleSendMessage}
        sx={{ 
          p: isMobile ? 1 : 2, 
          borderTop: '1px solid rgba(0, 0, 0, 0.12)',
          display: 'flex',
          alignItems: 'center',
          backgroundColor: theme.palette.background.paper,
          position: 'sticky',
          bottom: 0,
          width: '100%',
        }}
      >
        <Box sx={{ // Wrapper for input field and button to allow padding
          display: 'flex', 
          width: '100%', 
          alignItems: 'center',
          px: { xs: 0, sm: 1 } // Horizontal padding for the input area
        }}>
          <TextField
            fullWidth
            variant="outlined"
            placeholder="Type a message"
            value={newMessage}
            onChange={handleMessageChange}
            disabled={sending}
            size="small"
            sx={{ mr: 1 }}
            autoComplete="off"
          />
          <IconButton 
            color="primary" 
            type="submit"
            disabled={!newMessage.trim() || sending}
            sx={{ 
              ml: 1,
              width: 45,
              height: 45
            }}
          >
            {sending ? <CircularProgress size={24} /> : <SendIcon />}
          </IconButton>
        </Box>
      </Box>
    </Box>
  );
};

export default ChatView;