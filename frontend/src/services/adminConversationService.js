import axios from 'axios';
import authService from './authService';

// Sử dụng REACT_APP_API_URL nếu có, nếu không thì mặc định là port 8000 cho backend FastAPI
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';
const ADMIN_API_PREFIX = '/admin'; // Prefix cho các API admin

const getAuthHeader = () => {
    const token = authService.getToken();
    if (!token) {
        console.warn('AdminConversationService: No auth token found for API request');
        // Có thể throw lỗi hoặc để API tự trả về 401 tùy theo logic xử lý chung
    }
    return {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
        }
    };
};

// Helper function để xử lý lỗi và refresh token (nếu muốn thêm sau)
// Hiện tại, chúng ta sẽ throw lỗi để component tự xử lý hoặc dùng interceptor chung nếu có
const handleApiError = (error) => {
    console.error('API Error in AdminConversationService:', error.response || error.message);
    // TODO: Logic refresh token có thể được thêm ở đây hoặc trong một interceptor của axios
    // Ví dụ: nếu error.response.status === 401, thử refresh token, rồi gọi lại request
    // Nếu refresh thất bại thì logout.
    if (error.response?.status === 401) {
        // authService.logout(); // Cân nhắc việc logout ngay lập tức
        // window.location.href = '/login';
    }
    throw error;
};

const adminConversationService = {
    /**
     * Lấy danh sách tất cả các cuộc trò chuyện (cho Admin).
     * @param {object} params - Query params (e.g., { skip, limit, search }).
     */
    getAllConversations: async (params = { skip: 0, limit: 100 }) => {
        try {
            const config = getAuthHeader();
            config.params = params; 
            const response = await axios.get(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations`, config);
            return response.data;
        } catch (error) {
            handleApiError(error);
        }
    },

    /**
     * Lấy chi tiết một cuộc trò chuyện (cho Admin).
     * @param {number|string} conversationId - ID của cuộc trò chuyện.
     */
    getConversationDetails: async (conversationId) => {
        try {
            const response = await axios.get(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations/${conversationId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            handleApiError(error);
        }
    },

    /**
     * Cập nhật tên của một cuộc trò chuyện (cho Admin).
     * @param {number|string} conversationId - ID của cuộc trò chuyện.
     * @param {{ Name: string }} nameData - Dữ liệu tên mới.
     */
    updateConversationName: async (conversationId, nameData) => {
        try {
            const response = await axios.put(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations/${conversationId}`, nameData, getAuthHeader());
            return response.data;
        } catch (error) {
            handleApiError(error);
        }
    },

    /**
     * Xóa một cuộc trò chuyện (cho Admin).
     * @param {number|string} conversationId - ID của cuộc trò chuyện.
     */
    deleteConversation: async (conversationId) => {
        try {
            // API trả về 204 No Content, response.data có thể không có
            await axios.delete(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations/${conversationId}`, getAuthHeader());
            return true; // Hoặc response.status === 204
        } catch (error) {
            handleApiError(error);
        }
    },

    /**
     * Thêm người tham gia vào một cuộc trò chuyện (cho Admin).
     * @param {number|string} conversationId - ID của cuộc trò chuyện.
     * @param {{ user_ids: number[] }} userIdsPayload - Payload chứa danh sách user ID.
     */
    addParticipants: async (conversationId, userIdsPayload) => {
        try {
            const response = await axios.post(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations/${conversationId}/participants`, userIdsPayload, getAuthHeader());
            return response.data;
        } catch (error) {
            handleApiError(error);
        }
    },

    /**
     * Xóa người tham gia khỏi một cuộc trò chuyện (cho Admin).
     * @param {number|string} conversationId - ID của cuộc trò chuyện.
     * @param {{ user_ids: number[] }} userIdsPayload - Payload chứa danh sách user ID.
     */
    removeParticipants: async (conversationId, userIdsPayload) => {
        try {
            const config = getAuthHeader();
            config.data = userIdsPayload; // axios.delete có thể gửi body qua config.data
            // API trả về ConversationRead, response.data sẽ có dữ liệu
            const response = await axios.delete(`${API_BASE_URL}${ADMIN_API_PREFIX}/conversations/${conversationId}/participants`, config);
            return response.data; 
        } catch (error) {
            handleApiError(error);
        }
    },
    
    /**
     * Lấy danh sách tất cả người dùng (ví dụ: để admin chọn thêm vào nhóm chat).
     * Hàm này có thể gọi lại userService.getUsers nếu phù hợp, hoặc có endpoint riêng.
     * @param {object} params - Query params (e.g., { role, search, limit, skip })
     */
    getAllUsersForManagement: async (params = {}) => {
        // Giả sử userService.getUsers có thể dùng được ở đây
        // Nếu không, bạn cần một endpoint backend phù hợp hoặc điều chỉnh userService
        // Để đơn giản, chúng ta sẽ gọi một endpoint user chung (nếu có)
        // hoặc bạn sẽ cần gọi userService.getUsers từ component.
        try {
            const config = getAuthHeader();
            config.params = params;
            // Giả sử endpoint /users tồn tại và trả về danh sách người dùng cho admin quản lý
            const response = await axios.get(`${API_BASE_URL}/users`, config); 
            return response.data;
        } catch (error) {
            // Không gọi handleApiError để tránh loop nếu lỗi từ chính hàm này
            console.error('Error fetching users for management:', error.response || error.message);
            throw error;
        }
    }
};

export default adminConversationService; 