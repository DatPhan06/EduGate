import axios from 'axios';
import authService from './authService';

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

const timetableService = {
    // Subject services
    getAllSubjects: async () => {
        try {
            const response = await axios.get(`${API_URL}/subjects/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/subjects/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching subjects:', error.response?.data || error.message);
            throw error;
        }
    },

    getSubjectById: async (subjectId) => {
        try {
            const response = await axios.get(`${API_URL}/subjects/${subjectId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/subjects/${subjectId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching subject ${subjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    createSubject: async (subjectData) => {
        try {
            const response = await axios.post(`${API_URL}/subjects/`, subjectData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/subjects/`, subjectData, getAuthHeader());
                return response.data;
            }
            console.error('Error creating subject:', error.response?.data || error.message);
            throw error;
        }
    },

    updateSubject: async (subjectId, subjectData) => {
        try {
            const response = await axios.put(`${API_URL}/subjects/${subjectId}`, subjectData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/subjects/${subjectId}`, subjectData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating subject ${subjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    deleteSubject: async (subjectId) => {
        try {
            const response = await axios.delete(`${API_URL}/subjects/${subjectId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/subjects/${subjectId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error deleting subject ${subjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Class-subject assignment services
    getAllClassSubjects: async () => {
        try {
            const response = await axios.get(`${API_URL}/timetable/class-subjects/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/class-subjects/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching class subjects:', error.response?.data || error.message);
            throw error;
        }
    },

    getClassSubjectById: async (classSubjectId) => {
        try {
            const response = await axios.get(`${API_URL}/timetable/class-subjects/${classSubjectId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/class-subjects/${classSubjectId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching class subject ${classSubjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    getClassSubjectsByClass: async (classId) => {
        try {
            const response = await axios.get(`${API_URL}/timetable/classes/${classId}/subjects`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/classes/${classId}/subjects`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching class subjects for class ${classId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    getClassSubjectsByTeacher: async (teacherId) => {
        try {
            const response = await axios.get(`${API_URL}/timetable/teachers/${teacherId}/class-subjects`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/teachers/${teacherId}/class-subjects`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching class subjects for teacher ${teacherId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    createClassSubject: async (classSubjectData) => {
        try {
            const response = await axios.post(`${API_URL}/timetable/class-subjects/`, classSubjectData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/timetable/class-subjects/`, classSubjectData, getAuthHeader());
                return response.data;
            }
            console.error('Error creating class subject:', error.response?.data || error.message);
            throw error;
        }
    },

    updateClassSubject: async (classSubjectId, classSubjectData) => {
        try {
            const response = await axios.put(`${API_URL}/timetable/class-subjects/${classSubjectId}`, classSubjectData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/timetable/class-subjects/${classSubjectId}`, classSubjectData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating class subject ${classSubjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    deleteClassSubject: async (classSubjectId) => {
        try {
            const response = await axios.delete(`${API_URL}/timetable/class-subjects/${classSubjectId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/timetable/class-subjects/${classSubjectId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error deleting class subject ${classSubjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    // Schedule services
    getAllSchedules: async () => {
        try {
            const response = await axios.get(`${API_URL}/timetable/schedules/`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/schedules/`, getAuthHeader());
                return response.data;
            }
            console.error('Error fetching schedules:', error.response?.data || error.message);
            throw error;
        }
    },

    getScheduleById: async (scheduleId) => {
        try {
            const response = await axios.get(`${API_URL}/timetable/schedules/${scheduleId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/schedules/${scheduleId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching schedule ${scheduleId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    getSchedulesByClassSubject: async (classSubjectId) => {
        try {
            const response = await axios.get(`${API_URL}/timetable/class-subjects/${classSubjectId}/schedules`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/timetable/class-subjects/${classSubjectId}/schedules`, getAuthHeader());
                return response.data;
            }
            console.error(`Error fetching schedules for class subject ${classSubjectId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    createSchedule: async (scheduleData) => {
        try {
            const response = await axios.post(`${API_URL}/timetable/schedules/`, scheduleData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/timetable/schedules/`, scheduleData, getAuthHeader());
                return response.data;
            }
            console.error('Error creating schedule:', error.response?.data || error.message);
            throw error;
        }
    },

    updateSchedule: async (scheduleId, scheduleData) => {
        try {
            const response = await axios.put(`${API_URL}/timetable/schedules/${scheduleId}`, scheduleData, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/timetable/schedules/${scheduleId}`, scheduleData, getAuthHeader());
                return response.data;
            }
            console.error(`Error updating schedule ${scheduleId}:`, error.response?.data || error.message);
            throw error;
        }
    },

    deleteSchedule: async (scheduleId) => {
        try {
            const response = await axios.delete(`${API_URL}/timetable/schedules/${scheduleId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.delete(`${API_URL}/timetable/schedules/${scheduleId}`, getAuthHeader());
                return response.data;
            }
            console.error(`Error deleting schedule ${scheduleId}:`, error.response?.data || error.message);
            throw error;
        }
    }
};

export default timetableService; 