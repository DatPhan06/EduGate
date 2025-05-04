import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const getAuthHeader = () => {
    const token = authService.getToken();
    console.log('Token:', token); // Log token
    if (!token) {
        throw new Error('No authentication token found');
    }
    return {
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    };
};

const petitionService = {
    /**
     * Lấy danh sách đơn thỉnh cầu của phụ huynh
     * @param {number} parentId - ID của phụ huynh
     * @param {number} page - Số trang
     * @param {number} size - Số lượng đơn trên mỗi trang
     * @returns {Promise<Object>} - Danh sách đơn và thông tin phân trang
     */
    getParentPetitions: async (parentId, page = 1, size = 10) => {
        if (!parentId || isNaN(parentId)) {
            throw new Error('Invalid parentId: parentId must be a valid number');
        }
        try {
            const response = await axios.get(`${API_URL}/petitions/parent/${parentId}`, {
                ...getAuthHeader(),
                params: { page, size }
            });
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/petitions/parent/${parentId}`, {
                    ...getAuthHeader(),
                    params: { page, size }
                });
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to fetch parent petitions';
        }
    },

    /**
     * Lấy tất cả đơn thỉnh cầu (dành cho admin)
     * @param {Object} filters - Các bộ lọc
     * @param {string} filters.status - Trạng thái đơn
     * @param {number} filters.parentId - ID phụ huynh
     * @param {string} filters.startDate - Ngày bắt đầu
     * @param {string} filters.endDate - Ngày kết thúc
     * @param {number} page - Số trang
     * @param {number} size - Số lượng đơn trên mỗi trang
     * @returns {Promise<Object>} - Danh sách đơn và thông tin phân trang
     */
    getAllPetitions: async (filters = {}, page = 1, size = 10) => {
        try {
            const response = await axios.get(`${API_URL}/petitions/`, {
                ...getAuthHeader(),
                params: { ...filters, page, size }
            });
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/petitions/`, {
                    ...getAuthHeader(),
                    params: { ...filters, page, size }
                });
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to fetch all petitions';
        }
    },

    /**
     * Lấy thông tin chi tiết một đơn thỉnh cầu
     * @param {number} petitionId - ID của đơn thỉnh cầu
     * @returns {Promise<Object>} - Thông tin chi tiết đơn
     */
    getPetitionById: async (petitionId) => {
        if (!petitionId || isNaN(petitionId)) {
            throw new Error('Invalid petitionId: petitionId must be a valid number');
        }
        try {
            const response = await axios.get(`${API_URL}/petitions/${petitionId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/petitions/${petitionId}`, getAuthHeader());
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to fetch petition details';
        }
    },

    /**
     * Tạo đơn thỉnh cầu mới
     * @param {Object} petition - Thông tin đơn thỉnh cầu
     * @param {string} petition.Title - Tiêu đề đơn
     * @param {string} petition.Content - Nội dung đơn
     * @param {number} petition.ParentID - ID phụ huynh
     * @returns {Promise<Object>} - Đơn thỉnh cầu đã được tạo
     */
    createPetition: async (petition) => {
        if (!petition.ParentID || isNaN(petition.ParentID)) {
            throw new Error('Invalid ParentID: ParentID must be a valid number');
        }
        try {
            const response = await axios.post(`${API_URL}/petitions`, petition, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.post(`${API_URL}/petitions`, petition, getAuthHeader());
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to create petition';
        }
    },

    /**
     * Cập nhật trạng thái đơn thỉnh cầu
     * @param {number} petitionId - ID của đơn thỉnh cầu
     * @param {Object} update - Thông tin cập nhật
     * @param {string} update.Status - Trạng thái mới
     * @param {string} update.Notes - Ghi chú/lý do
     * @returns {Promise<Object>} - Đơn thỉnh cầu đã được cập nhật
     */
    updatePetitionStatus: async (petitionId, update) => {
        if (!petitionId || isNaN(petitionId)) {
            throw new Error('Invalid petitionId: petitionId must be a valid number');
        }
        try {
            const response = await axios.put(`${API_URL}/petitions/${petitionId}`, update, getAuthHeader());
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.put(`${API_URL}/petitions/${petitionId}`, update, getAuthHeader());
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to update petition status';
        }
    },

    /**
     * Lấy thống kê đơn thỉnh cầu
     * @param {Object} filters - Các bộ lọc
     * @param {string} filters.startDate - Ngày bắt đầu
     * @param {string} filters.endDate - Ngày kết thúc
     * @returns {Promise<Object>} - Thống kê số lượng đơn theo trạng thái
     */
    getPetitionStatistics: async (filters = {}) => {
        try {
            const response = await axios.get(`${API_URL}/petitions/statistics/`, {
                ...getAuthHeader(),
                params: filters
            });
            return response.data;
        } catch (error) {
            if (error.response?.status === 401) {
                await authService.refreshToken();
                const response = await axios.get(`${API_URL}/petitions/statistics/`, {
                    ...getAuthHeader(),
                    params: filters
                });
                return response.data;
            }
            throw error.response?.data?.detail || error.message || 'Failed to fetch petition statistics';
        }
    }
};

export default petitionService;