import { api } from './api';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

// Lấy danh sách học sinh của giáo viên chủ nhiệm
export const getTeacherStudents = async () => {
    try {
        const response = await api.get(`${API_BASE_URL}/daily-progress/teacher/students`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching teacher students:', error.response?.data || error.message);
        throw error;
    }
};

// Lấy sổ liên lạc của học sinh
export const getStudentDailyProgress = async (studentId) => {
    try {
        const response = await api.get(`${API_BASE_URL}/daily-progress/student/${studentId}`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching student daily progress:', error.response?.data || error.message);
        throw error;
    }
};

// Lấy sổ liên lạc của cả lớp
export const getClassDailyProgress = async (classId) => {
    try {
        const response = await api.get(`${API_BASE_URL}/daily-progress/class/${classId}`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching class daily progress:', error.response?.data || error.message);
        throw error;
    }
};

// Nhập/cập nhật sổ liên lạc
export const createOrUpdateDailyProgress = async (data) => {
    try {
        const response = await api.post(`${API_BASE_URL}/daily-progress/`, data, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error creating/updating daily progress:', error.response?.data || error.message);
        throw error;
    }
};

export const getParentChildren = async () => {
    try {
        const response = await api.get(`${API_BASE_URL}/daily-progress/parent/children`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching parent children:', error.response?.data || error.message);
        throw error;
    }
}; 