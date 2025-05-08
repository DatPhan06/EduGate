import { api } from './api'; // Assuming api.js exports the configured axios instance

const API_BASE_URL = ''; // FastAPI routers are at root relative to API_URL in api.js

// Teacher API
export const getTeachers = async () => {
    try {
        const response = await api.get(`${API_BASE_URL}/teachers/`);
        return response.data;
    } catch (error) {
        console.error('Error fetching teachers:', error.response ? error.response.data : error.message);
        throw error;
    }
};

// Class APIs
export const getClasses = async (params = {}) => {
    try {
        const response = await api.get(`${API_BASE_URL}/classes/`, { params });
        return response.data;
    } catch (error) {
        console.error('Error fetching classes:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const createClass = async (classData) => {
    try {
        const response = await api.post(`${API_BASE_URL}/classes/`, classData);
        return response.data;
    } catch (error) {
        console.error('Error creating class:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const updateClass = async (classId, classData) => {
    try {
        const response = await api.put(`${API_BASE_URL}/classes/${classId}/`, classData);
        return response.data;
    } catch (error) {
        console.error('Error updating class:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const deleteClass = async (classId) => {
    try {
        await api.delete(`${API_BASE_URL}/classes/${classId}/`);
        // Delete might not return content, so just confirm success or handle error
    } catch (error) {
        console.error('Error deleting class:', error.response ? error.response.data : error.message);
        throw error;
    }
};

// Student APIs
export const getStudents = async (params = {}) => {
    try {
        const response = await api.get(`${API_BASE_URL}/students/`, { params });
        return response.data;
    } catch (error) {
        console.error('Error fetching students:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const createStudent = async (studentData) => {
    try {
        // Student creation on the backend expects UserCreate schema
        const response = await api.post(`${API_BASE_URL}/students/`, studentData);
        return response.data;
    } catch (error) {
        console.error('Error creating student:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const updateStudent = async (studentUserId, studentData) => {
    try {
        // Student update on the backend expects UserUpdate schema
        const response = await api.put(`${API_BASE_URL}/students/${studentUserId}/`, studentData);
        return response.data;
    } catch (error) {
        console.error('Error updating student:', error.response ? error.response.data : error.message);
        throw error;
    }
};

export const deleteStudent = async (studentUserId) => {
    try {
        await api.delete(`${API_BASE_URL}/students/${studentUserId}/`);
        // Delete might not return content
    } catch (error) {
        console.error('Error deleting student:', error.response ? error.response.data : error.message);
        throw error;
    }
}; 