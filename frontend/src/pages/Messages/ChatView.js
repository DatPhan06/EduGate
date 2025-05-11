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
  useTheme,
  useMediaQuery,
  Alert
} from '@mui/material';
import SendIcon from '@mui/icons-material/Send';
import messageService from '../../services/messageService';
import moment from 'moment';

const POLLING_INTERVAL = 5000; // Poll every 5 seconds

const ChatView = ({ conversationId, currentUser, onMessageSent, onConversationUpdated }) => {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));

  const [conversation, setConversation] = useState(null);
  const [messages, setMessages] = useState([]);
  const messagesRef = useRef(messages); // Ref to keep track of messages for polling comparison
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const [error, setError] = useState('');
  const messagesEndRef = useRef(null);
  const [lastMessageId, setLastMessageId] = useState(null);

  // Update messagesRef whenever messages state changes
  useEffect(() => {
    messagesRef.current = messages;
    
    // Update lastMessageId when messages change
    if (messages.length > 0) {
      const newLastMessageId = messages[messages.length - 1].MessageID;
      setLastMessageId(newLastMessageId);
    }
  }, [messages]);
  
  // Fetch conversation when conversationId changes
  useEffect(() => {
    const fetchConversation = async () => {
      if (!conversationId) return;
      
      try {
        setLoading(true);
        setError('');
        
        // Get conversation details using the conversation ID
        const data = await messageService.getConversation(conversationId);
        console.log("Fetched conversation data:", data);
        
        if (data) {
          setConversation(data);
          // Make sure we handle both arrays or undefined for messages
          if (Array.isArray(data.messages)) {
            setMessages(data.messages);
          } else {
            console.warn("No messages array in API response");
            setMessages([]);
          }
          
          // Notify parent component about conversation updates
          if (onConversationUpdated) {
            onConversationUpdated(data);
          }
        } else {
          setError('Failed to load conversation data.');
        }
      } catch (err) {
        console.error(`Error fetching conversation ${conversationId}:`, err);
        setError('Failed to load conversation. Please try again.');
      } finally {
        setLoading(false);
      }
    };
    
    fetchConversation();
  }, [conversationId, onConversationUpdated]); // Add onConversationUpdated to dependencies

  // Polling for new messages
  useEffect(() => {
    if (!conversationId || loading) {
      return; // No conversation selected or still loading, so no polling
    }

    const fetchLatestMessages = async () => {
      try {
        // Get latest conversation data
        const data = await messageService.getConversation(conversationId);
        
        if (data) {
          // Always update the conversation object to get the latest name
          setConversation(data);
          
          if (Array.isArray(data.messages)) {
            // Check if there are new messages by comparing with lastMessageId
            if (data.messages.length > 0) {
              const newestMessageId = data.messages[data.messages.length - 1].MessageID;
              
              if (lastMessageId === null || newestMessageId > lastMessageId) {
                console.log("New messages detected:", data.messages);
                // Update messages
                setMessages(data.messages);
              }
            }
          }
        }
      } catch (err) {
        console.warn(`Failed to poll for new messages in conversation ${conversationId}:`, err);
      }
    };

    const intervalId = setInterval(fetchLatestMessages, POLLING_INTERVAL);

    // Cleanup function to clear the interval
    return () => {
      clearInterval(intervalId);
    };
  }, [conversationId, loading, lastMessageId]); // Re-run if conversationId or lastMessageId changes

  // Scroll to bottom when messages change
  useEffect(() => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages]);

  const handleMessageChange = (e) => {
    setNewMessage(e.target.value);
  };
  
  const handleSendMessage = async (e) => {
    e.preventDefault();
    if (!newMessage.trim() || !conversationId || !currentUser) return;
    
    try {
      setSending(true);
      const sentMessage = await messageService.sendMessage(conversationId, newMessage.trim());
      console.log("Sent message response:", sentMessage);
      
      // Add the sent message to the local state (handle different API response formats)
      if (sentMessage) {
        // If the API returns the complete message object
        if (sentMessage.MessageID) {
          setMessages(prev => [...prev, sentMessage]);
        } 
        // If the API returns a success message, create a temporary message object
        else {
          const tempMessage = {
            Content: newMessage.trim(),
            MessageID: Date.now(), // Temporary ID
            UserID: currentUser.UserID,
            SentAt: new Date().toISOString(),
            user: {
              UserID: currentUser.UserID,
              FirstName: currentUser.FirstName || '',
              LastName: currentUser.LastName || '',
              Email: currentUser.Email || ''
            }
          };
          setMessages(prev => [...prev, tempMessage]);
        }
      }
      
      setNewMessage(''); // Clear input
      
      // Notify parent component
      if (onMessageSent) {
        onMessageSent(conversationId, sentMessage || { Content: newMessage.trim() });
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
    if (!Array.isArray(messages) || messages.length === 0) {
      return [];
    }
    
    const groups = {};
    messages.forEach(message => {
      if (!message.SentAt) {
        console.warn("Message missing SentAt timestamp:", message);
        return;
      }
      
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
    if (!conversation || !conversation.participants) return 'Unknown User';
    
    const participant = conversation.participants.find(p => p.UserID === userId);
    return participant ? `${participant.FirstName} ${participant.LastName}` : 'Unknown User';
  };

  // Get participant avatar (first letter of first and last name)
  const getParticipantAvatar = (userId) => {
    if (!conversation || !conversation.participants) return '';
    
    const participant = conversation.participants.find(p => p.UserID === userId);
    if (!participant) return '?';
    
    return `${participant.FirstName ? participant.FirstName.charAt(0) : ''}${participant.LastName ? participant.LastName.charAt(0) : ''}`;
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

  // Make sure messages is always an array
  const safeMessages = Array.isArray(messages) ? messages : [];
  const messageGroups = groupMessagesByDate();
  
  return (
    <Box sx={{ 
      display: 'flex', 
      flexDirection: 'column', 
      height: '100%',
      overflow: 'hidden'
    }}>
      {/* Messages container */}
      <Box sx={{ 
        flexGrow: 1, 
        overflowY: 'auto', 
        p: 2,
        display: 'flex',
        flexDirection: 'column'
      }}>
        {messageGroups.length === 0 ? (
          <Box sx={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center', 
            height: '100%' 
          }}>
            <Typography variant="body1" color="text.secondary">
              No messages yet. Start a conversation!
            </Typography>
          </Box>
        ) : (
          messageGroups.map((group, groupIndex) => (
            <Box key={groupIndex} sx={{ mb: 3 }}>
              <Box sx={{ 
                display: 'flex', 
                justifyContent: 'center', 
                mb: 2 
              }}>
                <Typography 
                  variant="caption" 
                  sx={{ 
                    bgcolor: 'background.paper', 
                    px: 2, 
                    py: 0.5, 
                    borderRadius: 10,
                    boxShadow: 1
                  }}
                >
                  {formatMessageDate(group.date)}
                </Typography>
              </Box>
              
              {group.messages.map((message, messageIndex) => {
                const isCurrentUser = message.UserID === currentUser.UserID;
                const showAvatar = messageIndex === 0 || 
                                  group.messages[messageIndex - 1].UserID !== message.UserID;
                const senderName = getParticipantName(message.UserID);
                
                return (
                  <Box 
                    key={message.MessageID || messageIndex} 
                    sx={{ 
                      display: 'flex',
                      flexDirection: isCurrentUser ? 'row-reverse' : 'row',
                      mb: 1.5,
                      alignItems: 'flex-end'
                    }}
                  >
                    {!isCurrentUser && (
                      <Box sx={{ mr: 1, visibility: showAvatar ? 'visible' : 'hidden' }}>
                        <Avatar sx={{ width: 36, height: 36, bgcolor: isCurrentUser ? 'primary.main' : 'secondary.main' }}>
                          {getParticipantAvatar(message.UserID)}
                        </Avatar>
                      </Box>
                    )}
                    
                    <Box sx={{ maxWidth: '70%' }}>
                      {showAvatar && !isCurrentUser && (
                        <Typography 
                          variant="caption" 
                          sx={{ 
                            ml: 1,
                            mb: 0.5, 
                            display: 'block', 
                            color: 'text.secondary',
                            fontWeight: 'medium'
                          }}
                        >
                          {senderName}
                        </Typography>
                      )}
                      
                      <Paper 
                        elevation={0}
                        sx={{ 
                          p: 1.5,
                          borderRadius: 2,
                          bgcolor: isCurrentUser ? 'primary.light' : 'grey.100',
                          color: isCurrentUser ? 'primary.contrastText' : 'text.primary',
                          ml: isCurrentUser ? 0 : 1,
                          mr: isCurrentUser ? 1 : 0,
                          position: 'relative'
                        }}
                      >
                        <Typography variant="body1" sx={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
                          {message.Content}
                        </Typography>
                        <Typography 
                          variant="caption" 
                          sx={{ 
                            display: 'block',
                            textAlign: 'right',
                            mt: 0.5,
                            color: isCurrentUser ? 'rgba(255,255,255,0.7)' : 'text.secondary',
                            fontSize: '0.7rem'
                          }}
                        >
                          {formatMessageTime(message.SentAt)}
                        </Typography>
                      </Paper>
                    </Box>
                    
                    {isCurrentUser && (
                      <Box sx={{ ml: 1, visibility: showAvatar ? 'visible' : 'hidden' }}>
                        <Avatar sx={{ width: 36, height: 36, bgcolor: 'primary.main' }}>
                          {getParticipantAvatar(message.UserID)}
                        </Avatar>
                      </Box>
                    )}
                  </Box>
                );
              })}
            </Box>
          ))
        )}
        <div ref={messagesEndRef} /> {/* Empty div for scrolling to bottom */}
      </Box>
      
      {/* Message input */}
      <Box 
        component="form" 
        onSubmit={handleSendMessage}
        sx={{ 
          p: 2, 
          bgcolor: 'background.paper',
          borderTop: `1px solid ${theme.palette.divider}`
        }}
      >
        <Box sx={{ 
          display: 'flex',
          alignItems: 'center'
        }}>
          <TextField
            fullWidth
            variant="outlined"
            placeholder="Type a message..."
            value={newMessage}
            onChange={handleMessageChange}
            multiline
            maxRows={3}
            size="small"
            disabled={sending}
            sx={{ mr: 1 }}
          />
          <Button
            variant="contained"
            color="primary"
            type="submit"
            disabled={!newMessage.trim() || sending}
            sx={{ minWidth: isMobile ? 40 : 'auto', ml: 1 }}
          >
            {isMobile ? <SendIcon /> : 'Send'}
          </Button>
        </Box>
      </Box>
    </Box>
  );
};

export default ChatView;