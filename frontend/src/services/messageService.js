import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const getAuthHeader = () => {
    const token = authService.getToken();
    if (!token) {
        // This should ideally not happen if pages requiring auth are protected
        console.error('No authentication token found. Redirecting to login.');
        throw new Error('No authentication token found');
    }
    return {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    };
};

const messageService = {
    // Get list of users to message (excluding current user)
    getAllUsers: async () => {
        try {
            const response = await axios.get(`${API_URL}/messaging/users`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error("Error fetching users for messaging:", error);
            throw error;
        }
    },

    // Get all conversations for the current user
    getUserConversations: async () => {
        try {
            const response = await axios.get(`${API_URL}/messaging/conversations`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error("Error fetching conversations:", error);
            throw error;
        }
    },

    // Get conversation by ID with messages
    getConversationById: async (conversationId) => {
        try {
            const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error fetching conversation ${conversationId}:`, error);
            throw error;
        }
    },

    // Create a new conversation with selected users
    createConversation: async (participantIds) => {
        try {
            const response = await axios.post(
                `${API_URL}/messaging/conversations`,
                { participant_ids: participantIds },
                getAuthHeader()
            );
            return response.data;
        } catch (error) {
            console.error("Error creating conversation:", error);
            throw error;
        }
    },

    // Send message to a conversation
    sendMessage: async (conversationId, content) => {
        try {
            const response = await axios.post(
                `${API_URL}/messaging/conversations/${conversationId}/messages`,
                { Content: content },
                getAuthHeader()
            );
            return response.data;
        } catch (error) {
            console.error(`Error sending message to conversation ${conversationId}:`, error);
            throw error;
        }
    }
};

export default messageService;
