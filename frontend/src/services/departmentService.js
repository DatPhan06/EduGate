import axios from 'axios';
import authService from './authService';
import { api } from './api';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

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

const departmentService = {
    // Get all departments
    getAllDepartments: async () => {
        try {
            const response = await axios.get(`${API_URL}/departments/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/departments/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching departments:', error.response?.data || error.message);
            throw error;
        }
    },

    // Get department by ID
    getDepartmentById: async (departmentId) => {
        try {
            const response = await axios.get(`${API_URL}/departments/${departmentId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/departments/${departmentId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching department ${departmentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Create new department
    createDepartment: async (departmentData) => {
        try {
            const response = await axios.post(`${API_URL}/departments/`, departmentData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/departments/`, departmentData, getAuthHeader());
                return response.data;
            }
            console.error('Error creating department:', error.response?.data || error.message);
            throw error;
        }
    },

    // Update department
    updateDepartment: async (departmentId, departmentData) => {
        try {
            const response = await axios.put(`${API_URL}/departments/${departmentId}`, departmentData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/departments/${departmentId}`, departmentData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating department ${departmentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Delete department
    deleteDepartment: async (departmentId) => {
        try {
            const response = await axios.delete(`${API_URL}/departments/${departmentId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/departments/${departmentId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error deleting department ${departmentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Add teacher to department
    addTeacherToDepartment: async (departmentId, teacherUserId) => {
        try {
            const response = await axios.post(
                `${API_URL}/departments/${departmentId}/teachers`, 
                { teacher_user_id: teacherUserId },
                getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(
                    `${API_URL}/departments/${departmentId}/teachers`, 
                    { teacher_user_id: teacherUserId },
                    getAuthHeader()
                );
                return response.data;
            }
            console.error(`Error adding teacher to department:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Remove teacher from department
    removeTeacherFromDepartment: async (departmentId, teacherUserId) => {
        try {
            const response = await axios.delete(
                `${API_URL}/departments/${departmentId}/teachers/${teacherUserId}`,
                getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(
                    `${API_URL}/departments/${departmentId}/teachers/${teacherUserId}`,
                    getAuthHeader()
                );
                return response.data;
            }
            console.error(`Error removing teacher from department:`, error.response?.data || error.message);
            throw error;
        }
    }
};

export default departmentService; 