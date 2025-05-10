import { api } from './api';
import authService from './authService';

const API_BASE_URL = ''; // FastAPI routers are at root relative to API_URL in api.js

const studentService = {
    // Get student details by user ID
    getStudentById: async (studentUserId) => {
        try {
            const response = await api.get(`${API_BASE_URL}/students/${studentUserId}`);
            return response.data;
        } catch (error) {
            console.error(`Error fetching student details for user ID ${studentUserId}:`, error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Get all students with optional filters
    getStudents: async (params = {}) => {
        try {
            const response = await api.get(`${API_BASE_URL}/students/`, { params });
            return response.data;
        } catch (error) {
            console.error('Error fetching students:', error.response ? error.response.data : error.message);
            throw error;
        }
    },

    // Get current logged-in student details (if user is a student)
    getCurrentStudentDetails: async () => {
        try {
            // First get the current user to check if it's a student and get the UserID
            const currentUser = authService.getCurrentUser();
            
            if (!currentUser || currentUser.role !== 'student') {
                throw new Error('Current user is not a student');
            }
            
            // Use the UserID to fetch detailed student information including ClassID
            const studentDetails = await studentService.getStudentById(currentUser.UserID);
            return studentDetails;
        } catch (error) {
            console.error('Error fetching current student details:', error);
            throw error;
        }
    }
};

export default studentService;