import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const getAuthHeader = () => {
    const token = authService.getToken();
    // Removed the console.warn for brevity, can be added back if needed
    return {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    };
};

const gradeService = {
    // Grade APIs
    getGrades: async (params = {}) => {
        try {
            const response = await axios.get(`${API_URL}/grades/`, { ...getAuthHeader(), params });
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/grades/`, { ...getAuthHeader(), params });
                return response.data;
            }
            console.error('Error fetching grades:', error.response?.data || error.message);
            throw error;
        }
    },

    getStudentGrades: async (studentId, semester = null) => {
        try {
            const requestParams = semester ? { semester } : {};
            const response = await axios.get(`${API_URL}/grades/student/${studentId}`, { ...getAuthHeader(), params: requestParams });
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const requestParams = semester ? { semester } : {};
                const response = await axios.get(`${API_URL}/grades/student/${studentId}`, { ...getAuthHeader(), params: requestParams });
                return response.data;
            }
            console.error(`Error fetching grades for student ${studentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    getGradeById: async (gradeId) => {
        try {
            const response = await axios.get(`${API_URL}/grades/${gradeId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/grades/${gradeId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching grade ${gradeId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    createGrade: async (gradeData) => {
        try {
            const response = await axios.post(`${API_URL}/grades/`, gradeData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/grades/`, gradeData, getAuthHeader());
                return response.data;
            }
            console.error('Error creating grade:', error.response?.data || error.message);
            throw error;
        }
    },

    updateGrade: async (gradeId, gradeData) => {
        try {
            const response = await axios.put(`${API_URL}/grades/${gradeId}`, gradeData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/grades/${gradeId}`, gradeData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating grade ${gradeId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    deleteGrade: async (gradeId) => {
        try {
            await axios.delete(`${API_URL}/grades/${gradeId}`, getAuthHeader());
            return true; // Indicate success
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                await axios.delete(`${API_URL}/grades/${gradeId}`, getAuthHeader());
                return true;
            }
            console.error(`Error deleting grade ${gradeId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Grade Component APIs
    addGradeComponent: async (gradeId, componentData) => {
        try {
            const response = await axios.post(`${API_URL}/grades/${gradeId}/components`, componentData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/grades/${gradeId}/components`, componentData, getAuthHeader());
                return response.data;
            }
            console.error(`Error adding component to grade ${gradeId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    updateGradeComponent: async (componentId, componentData) => {
        try {
            const response = await axios.put(`${API_URL}/grades/components/${componentId}`, componentData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/grades/components/${componentId}`, componentData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating component ${componentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    deleteGradeComponent: async (componentId) => {
        try {
            await axios.delete(`${API_URL}/grades/components/${componentId}`, getAuthHeader());
            return true; // Indicate success
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                await axios.delete(`${API_URL}/grades/components/${componentId}`, getAuthHeader());
                return true;
            }
            console.error(`Error deleting component ${componentId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Support APIs for Grade Management UI
    getStudentsForGrading: async () => {
        try {
            const response = await axios.get(`${API_URL}/students/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/students/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching students for grading:', error.response?.data || error.message);
            throw error;
        }
    },

    getClassSubjectsForGrading: async () => {
        try {
            // Corrected endpoint from previous step
            const response = await axios.get(`${API_URL}/timetable/class-subjects/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/class-subjects/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching class subjects for grading:', error.response?.data || error.message);
            throw error;
        }
    }
};

export default gradeService; 