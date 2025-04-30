import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const getAuthHeader = () => {
    const token = authService.getToken();
    if (!token) {
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

const userService = {
    getAllUsers: async () => {
        try {
            const response = await axios.get(`${API_URL}/users`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/users`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    getUserById: async (id) => {
        try {
            const response = await axios.get(`${API_URL}/users/${id}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/users/${id}`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    getCurrentUser: async () => {
        try {
            const response = await axios.get(`${API_URL}/users/me`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/users/me`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    createUser: async (userData) => {
        try {
            const response = await axios.post(`${API_URL}/users`, userData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/users`, userData, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    updateUser: async (id, userData) => {
        try {
            const response = await axios.put(`${API_URL}/users/${id}`, userData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/users/${id}`, userData, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    deleteUser: async (id) => {
        try {
            const response = await axios.delete(`${API_URL}/users/${id}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/users/${id}`, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    },

    changePassword: async (passwordData) => {
        try {
            const response = await axios.post(`${API_URL}/auth/change-password`, passwordData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/auth/change-password`, passwordData, getAuthHeader());
                return response.data;
            }
            throw error;
        }
    }
};

export default userService; 