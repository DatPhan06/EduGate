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

    // --- Parent-Student Link Functions ---

    linkParentToStudent: async (studentUserId, parentUserId) => {
        try {
            const payload = { parent_user_id: parentUserId };
            const response = await api.post(`${API_BASE_URL}/students/${studentUserId}/parents`, payload);
            return response.data; // e.g., {"message": "Parent linked successfully"}
        } catch (error) {
            console.error(`Error linking parent ${parentUserId} to student ${studentUserId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    unlinkParentFromStudent: async (studentUserId, parentUserId) => {
        try {
            await api.delete(`${API_BASE_URL}/students/${studentUserId}/parents/${parentUserId}`);
        } catch (error) {
            console.error(`Error unlinking parent ${parentUserId} from student ${studentUserId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    getStudentParents: async (studentUserId) => {
        try {
            const response = await api.get(`${API_BASE_URL}/students/${studentUserId}/parents`);
            return response.data; // Should be List[ParentBasicInfo]
        } catch (error) {
            console.error(`Error fetching parents for student ${studentUserId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    getParentStudents: async (parentUserId) => {
        try {
            const response = await api.get(`${API_BASE_URL}/parents/${parentUserId}/students`);
            return response.data; // Should be List[StudentBasicInfo]
        } catch (error) {
            console.error(`Error fetching students for parent ${parentUserId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // --- Function to upload users from Excel ---
    uploadUsersExcel: async (file) => {
        const formData = new FormData();
        formData.append('file', file);

        try {
            // Sử dụng api instance đã cấu hình sẵn (bao gồm cả auth header nếu cần)
            // Endpoint là /users/upload_excel, không có / ở cuối
            const response = await api.post(`${API_BASE_URL}/users/upload_excel`, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });
            return response.data; // Should be { message, created_count, errors? }
        } catch (error) {
            console.error('Error uploading users Excel:', error.response ? error.response.data : error.message);
            throw error; // Re-throw để component có thể xử lý
        }
    },
};

export default userService; 