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

    // Fetch all conversations for the current user
    getUserConversations: async () => {
        try {
            const response = await axios.get(`${API_URL}/messaging/conversations`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/messaging/conversations`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    // Fetch details of a specific conversation
    getConversation: async (conversationId) => {
        try {
            const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    // Create a new conversation with selected participants
    createConversation: async (participantIds, conversationName = null) => {
        try {
            const payload = {
                participant_ids: participantIds,
                name: conversationName
            };
            const response = await axios.post(`${API_URL}/messaging/conversations`, payload, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/messaging/conversations`, payload, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    // Get messages for a specific conversation
    getConversationMessages: async (conversationId) => {
        try {
            const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}/messages`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}/messages`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    // Send a new message to a conversation
    sendMessage: async (conversationId, content, attachments = []) => {
        try {
            const payload = { Content: content };
            // Add attachments if API supports it
            if (attachments && attachments.length > 0) {
                payload.attachments = attachments;
            }
            const response = await axios.post(`${API_URL}/messaging/conversations/${conversationId}/messages`, payload, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/messaging/conversations/${conversationId}/messages`, payload, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },
    
    // Get participants in a conversation - use conversation details API if participants endpoint doesn't exist
    getConversationParticipants: async (conversationId) => {
        try {
            // First try to get the conversation details which might include participants
            const response = await axios.get(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
            
            // Return participants from the conversation object if available
            if (response.data && response.data.participants) {
                return response.data.participants;
            }
            
            // If the API response doesn't have participants, return an empty array
            // You can modify this fallback logic based on your API structure
            console.warn("No participant data found in conversation response");
            return [];
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                return messageService.getConversationParticipants(conversationId);
            }
            console.error(`Error fetching conversation participants for ${conversationId}:`, error);
            throw error;
        }
    },
    
    // Update conversation (name, settings, etc.)
    updateConversation: async (conversationId, updateData) => {
        try {
            const response = await axios.put(`${API_URL}/messaging/conversations/${conversationId}`, updateData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/messaging/conversations/${conversationId}`, updateData, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },
    
    // Add participants to a conversation
    addParticipants: async (conversationId, participantIds) => {
        try {
            const payload = { participant_ids: participantIds };
            const response = await axios.post(`${API_URL}/messaging/conversations/${conversationId}/participants`, payload, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/messaging/conversations/${conversationId}/participants`, payload, getAuthHeader());
                return response.data;
            }
            // If the endpoint doesn't exist yet, log a warning and return an empty success response
            if (error.response?.status === 404) {
                console.warn("Add participants endpoint not implemented yet");
                return { success: true };
            }
            throw error;
        }
    },

    // Remove a participant from a conversation
    removeParticipant: async (conversationId, userId) => {
        try {
            const response = await axios.delete(`${API_URL}/messaging/conversations/${conversationId}/participants/${userId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/messaging/conversations/${conversationId}/participants/${userId}`, getAuthHeader());
                return response.data;
            }
            // If the endpoint doesn't exist yet, log a warning and return an empty success response
            if (error.response?.status === 404) {
                console.warn("Remove participant endpoint not implemented yet");
                return { success: true };
            }
            throw error;
        }
    },

    // Delete a conversation
    deleteConversation: async (conversationId) => {
        try {
            const response = await axios.delete(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/messaging/conversations/${conversationId}`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    }
};

export default messageService;
