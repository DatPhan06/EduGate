import axios from 'axios';
import authService from './authService';
import { api } from './api';
import { getClasses as getClassList } from './classManagementService'; // Import getClasses

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';
const API_BASE_URL = ''; // Assuming User router is at root

const getAuthHeader = () => {
    const token = authService.getToken();
    if (!token) {
        console.warn('No auth token found for API request');
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
            const response = await axios.post(`${API_URL}/users/change-password`, passwordData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                authService.logout();
                window.location.href = '/login';
            }
            throw error;
        }
    },

    // ----- New/Updated Functions for User Management -----

    // Function to get a list of users with optional filters
    getUsers: async (params = {}) => {
        try {
            const response = await api.get(`${API_BASE_URL}/users/`, { params });
            return response.data;
        } catch (error) {
            console.error('Error fetching users:', error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to get a single user's details
    getUser: async (userId) => {
        try {
            const response = await api.get(`${API_BASE_URL}/users/${userId}/`);
            return response.data;
        } catch (error) {
            console.error(`Error fetching user ${userId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to create a user (likely used by specific role creations too)
    // Assumes backend POST /users/ handles role-specific creation via UserCreate schema
    createUser: async (userData) => {
        try {
            const response = await api.post(`${API_BASE_URL}/users/register`, userData); // Or use POST /users/ if preferred for admin creation
            return response.data;
        } catch (error) {
            console.error('Error creating user:', error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to update a user
    updateUser: async (userId, userData) => {
        try {
            // Backend expects UserUpdate schema
            const response = await api.put(`${API_BASE_URL}/users/${userId}/`, userData);
            return response.data;
        } catch (error) {
            console.error(`Error updating user ${userId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to delete a user
    deleteUser: async (userId) => {
        try {
            await api.delete(`${API_BASE_URL}/users/${userId}/`);
        } catch (error) {
            console.error(`Error deleting user ${userId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to get departments (needed for Teacher/Admin assignment)
    getDepartments: async () => {
        try {
            const response = await api.get(`/departments/`); // Assuming departments router is at root
            return response.data;
        } catch (error) {
            console.error('Error fetching departments:', error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Function to get classes (re-exporting for convenience in User Management)
    getClasses: async (params = {}) => {
        return getClassList(params); // Call the imported function
    },

    // Note: Specific student/teacher creation might still use the dedicated endpoints 
    // if they offer different behaviour or response models than the generic user creation.
    // However, the generic createUser should work if the backend service handles roles correctly.
};

export default userService; 