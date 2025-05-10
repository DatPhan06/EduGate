import { api } from './api'; // Sử dụng instance axios đã cấu hình từ api.js
import authService from './authService'; // Sử dụng authService để lấy token

const API_URL = '/reward-punishments'; // Endpoint prefix từ backend router

const getAuthHeaders = () => {
    const token = authService.getToken();
    if (!token) {
        // Xử lý trường hợp không có token (ví dụ: redirect tới login)
        console.error("No auth token found");
        // Hoặc throw error để component gọi xử lý
        throw new Error("Authentication required.");
    }
    return { Authorization: `Bearer ${token}` };
};

const createStudentRewardPunishment = (data) => {
    return api.post(`${API_URL}/student`, data, { headers: getAuthHeaders() });
};

const createClassRewardPunishment = (data) => {
    return api.post(`${API_URL}/class`, data, { headers: getAuthHeaders() });
};

const getStudentRewardPunishments = (studentId) => {
    return api.get(`${API_URL}/student/${studentId}`, { headers: getAuthHeaders() });
};

const getClassRewardPunishments = (classId) => {
    return api.get(`${API_URL}/class/${classId}`, { headers: getAuthHeaders() });
};

const getMyRewardsPunishments = () => {
    return api.get(`${API_URL}/me`, { headers: getAuthHeaders() });
};

const viewStudentRewardPunishments = (studentId) => {
    return api.get(`${API_URL}/student/${studentId}/view`, { headers: getAuthHeaders() });
};

const getAllRewardPunishments = () => {
    return api.get(`${API_URL}`, { headers: getAuthHeaders() });
};

// Thêm các hàm khác nếu cần

const rewardPunishmentService = {
    createStudentRewardPunishment,
    createClassRewardPunishment,
    getStudentRewardPunishments,
    getClassRewardPunishments,
    getMyRewardsPunishments,      
    viewStudentRewardPunishments,
    getAllRewardPunishments,
};

export default rewardPunishmentService;