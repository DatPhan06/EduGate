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

// Thêm các hàm khác nếu cần (ví dụ: getRewardsByStudent, getRewardsByClass, etc.)
// const getStudentRewards = (studentId) => {
//     return api.get(`${API_URL}/student/${studentId}`, { headers: getAuthHeaders() });
// };

const rewardPunishmentService = {
    createStudentRewardPunishment,
    createClassRewardPunishment,
    // getStudentRewards,
};

export default rewardPunishmentService;