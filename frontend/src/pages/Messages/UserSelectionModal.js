import React, { useState, useEffect } from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  List,
  ListItem,
  ListItemText,
  ListItemAvatar,
  Avatar,
  Typography,
  TextField,
  CircularProgress,
  Checkbox,
  Chip,
  Box,
  Alert
} from '@mui/material';
import messageService from '../../services/messageService';

const UserSelectionModal = ({ open, onClose, currentUserId, onConversationCreated }) => {
  const [users, setUsers] = useState([]);
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState('');

  // Fetch users when modal opens
  useEffect(() => {
    if (open) {
      fetchUsers();
    } else {
      // Reset when modal closes
      setSelectedUsers([]);
      setSearchQuery('');
      setError('');
    }
  }, [open]);

  // Filter users based on search query
  useEffect(() => {
    if (searchQuery.trim() === '') {
      setFilteredUsers(users);
    } else {
      const query = searchQuery.toLowerCase();
      const filtered = users.filter(
        user => 
          user.FirstName.toLowerCase().includes(query) || 
          user.LastName.toLowerCase().includes(query) ||
          user.Email.toLowerCase().includes(query)
      );
      setFilteredUsers(filtered);
    }
  }, [searchQuery, users]);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      setError('');
      // Get all users except the current user (handled on the backend)
      const data = await messageService.getAllUsers();
      setUsers(data || []);
      setFilteredUsers(data || []);
    } catch (err) {
      console.error("Error fetching users:", err);
      setError('Failed to load users. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleUserSelect = (user) => {
    setSelectedUsers(prev => {
      const isSelected = prev.some(u => u.UserID === user.UserID);
      if (isSelected) {
        // Remove user if already selected
        return prev.filter(u => u.UserID !== user.UserID);
      } else {
        // Add user if not already selected
        return [...prev, user];
      }
    });
  };

  const handleRemoveSelectedUser = (userId) => {
    setSelectedUsers(prev => prev.filter(user => user.UserID !== userId));
  };

  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };

  const handleCreateConversation = async () => {
    if (selectedUsers.length === 0) {
      setError('Please select at least one user to message.');
      return;
    }

    try {
      setCreating(true);
      setError('');
      
      // Extract just the UserIDs for the API
      const participantIds = selectedUsers.map(user => user.UserID);
      
      // Create a new conversation with selected users
      const newConversation = await messageService.createConversation(participantIds);
      
      // Notify parent component about the new conversation
      if (onConversationCreated) {
        onConversationCreated(newConversation);
      }
      
      // Close the modal
      onClose();
    } catch (err) {
      console.error("Error creating conversation:", err);
      setError('Failed to create conversation. Please try again.');
    } finally {
      setCreating(false);
    }
  };

  return (
    <Dialog 
      open={open} 
      onClose={onClose}
      fullWidth
      maxWidth="sm"
      aria-labelledby="user-selection-dialog-title"
    >
      <DialogTitle id="user-selection-dialog-title">
        New Conversation
      </DialogTitle>
      
      <DialogContent dividers>
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
        
        {/* Selected Users Display */}
        {selectedUsers.length > 0 && (
          <Box sx={{ mb: 2, display: 'flex', flexWrap: 'wrap', gap: 1 }}>
            {selectedUsers.map(user => (
              <Chip
                key={user.UserID}
                avatar={<Avatar>{user.FirstName[0]}</Avatar>}
                label={`${user.FirstName} ${user.LastName}`}
                onDelete={() => handleRemoveSelectedUser(user.UserID)}
                color="primary"
              />
            ))}
          </Box>
        )}
        
        {/* Search Input */}
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Search users..."
          value={searchQuery}
          onChange={handleSearchChange}
          sx={{ mb: 2 }}
        />
        
        {/* User List */}
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 4 }}>
            <CircularProgress />
          </Box>
        ) : filteredUsers.length === 0 ? (
          <Typography variant="body2" align="center" sx={{ py: 4 }}>
            {users.length === 0
              ? 'No users available.'
              : 'No users match your search criteria.'}
          </Typography>
        ) : (
          <List sx={{ overflow: 'auto', maxHeight: 300 }}>
            {filteredUsers.map(user => {
              const isSelected = selectedUsers.some(u => u.UserID === user.UserID);
              
              return (
                <ListItem
                  key={user.UserID}
                  button
                  onClick={() => handleUserSelect(user)}
                  dense
                  divider
                >
                  <Checkbox
                    edge="start"
                    checked={isSelected}
                    tabIndex={-1}
                    disableRipple
                  />
                  <ListItemAvatar>
                    <Avatar>{user.FirstName[0]}</Avatar>
                  </ListItemAvatar>
                  <ListItemText
                    primary={`${user.FirstName} ${user.LastName}`}
                    secondary={user.Email}
                  />
                </ListItem>
              );
            })}
          </List>
        )}
      </DialogContent>
      
      <DialogActions>
        <Button onClick={onClose} disabled={creating}>
          Cancel
        </Button>
        <Button 
          onClick={handleCreateConversation}
          variant="contained"
          disabled={selectedUsers.length === 0 || creating}
          startIcon={creating && <CircularProgress size={20} />}
        >
          {creating ? 'Creating...' : 'Start Conversation'}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default UserSelectionModal;