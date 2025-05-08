import React from 'react';
import { List, ListItem, ListItemAvatar, Avatar, ListItemText, Typography, Divider, Box } from '@mui/material';
import { styled } from '@mui/material/styles';
import moment from 'moment';

// Custom styling for selected conversation
const StyledListItem = styled(ListItem)(({ theme, selected }) => ({
  borderRadius: '8px',
  cursor: 'pointer',
  marginBottom: '8px',
  backgroundColor: selected ? theme.palette.action.selected : 'transparent',
  '&:hover': {
    backgroundColor: selected ? theme.palette.action.selected : theme.palette.action.hover,
  },
}));

const ConversationList = ({ conversations, onSelectConversation, selectedConversationId, currentUser }) => {
  const getConversationName = (conversation) => {
    // If conversation has a name, use it
    if (conversation.Name) return conversation.Name;
    
    // Otherwise, for two-person chats, use the other person's name
    if (conversation.participants && conversation.participants.length === 2) {
      const otherPerson = conversation.participants.find(p => p.UserID !== currentUser.UserID);
      if (otherPerson) {
        return `${otherPerson.FirstName} ${otherPerson.LastName}`;
      }
    }
    
    // For group chats without a name, compile the names
    if (conversation.participants && conversation.participants.length > 2) {
      const participantNames = conversation.participants
        .filter(p => p.UserID !== currentUser.UserID)
        .map(p => p.FirstName)
        .join(', ');
      return participantNames;
    }
    
    return 'Unnamed Conversation';
  };
  
  const formatTimestamp = (timestamp) => {
    const messageDate = moment(timestamp);
    const now = moment();
    
    if (now.diff(messageDate, 'days') < 1) {
      // If message is from today, show only time
      return messageDate.format('h:mm A');
    } else if (now.diff(messageDate, 'days') < 7) {
      // If message is from this week, show day name
      return messageDate.format('ddd');
    } else {
      // Otherwise show the date
      return messageDate.format('MMM D');
    }
  };

  return (
    <List sx={{ width: '100%', bgcolor: 'background.paper', overflowY: 'auto' }}>
      {conversations.length === 0 ? (
        <Typography variant="body2" sx={{ textAlign: 'center', py: 3, color: 'text.secondary' }}>
          No conversations yet. Start a new one!
        </Typography>
      ) : (
        conversations.map((conversation) => (
          <React.Fragment key={conversation.ConversationID}>
            <StyledListItem
              alignItems="flex-start"
              selected={selectedConversationId === conversation.ConversationID}
              onClick={() => onSelectConversation(conversation)}
              sx={{ py: 1 }}
            >
              <ListItemAvatar>
                <Avatar alt={getConversationName(conversation)} />
              </ListItemAvatar>
              <ListItemText
                primary={
                  <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <Typography component="span" variant="body1" fontWeight="medium">
                      {getConversationName(conversation)}
                    </Typography>
                    {conversation.last_message && (
                      <Typography component="span" variant="caption" color="text.secondary">
                        {formatTimestamp(conversation.UpdatedAt)}
                      </Typography>
                    )}
                  </Box>
                }
                secondary={
                  conversation.last_message ? (
                    <React.Fragment>
                      <Typography
                        component="span"
                        variant="body2"
                        color="text.primary"
                        sx={{ 
                          display: 'inline',
                          fontWeight: conversation.last_message.UserID !== currentUser.UserID ? 'bold' : 'normal'
                        }}
                      >
                        {conversation.last_message.UserID === currentUser.UserID ? 'You: ' : ''}
                      </Typography>
                      <Typography
                        component="span"
                        variant="body2"
                        color="text.secondary"
                        sx={{
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          display: '-webkit-box',
                          WebkitLineClamp: 1,
                          WebkitBoxOrient: 'vertical',
                        }}
                      >
                        {conversation.last_message.Content}
                      </Typography>
                    </React.Fragment>
                  ) : (
                    <Typography component="span" variant="body2" color="text.secondary">
                      No messages yet
                    </Typography>
                  )
                }
              />
            </StyledListItem>
            <Divider variant="inset" component="li" />
          </React.Fragment>
        ))
      )}
    </List>
  );
};

export default ConversationList;