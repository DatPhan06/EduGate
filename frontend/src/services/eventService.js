import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

// Helper function to get authentication headers
const getAuthHeader = () => {
    const token = authService.getToken();
    return {
        headers: {
            Authorization: `Bearer ${token}`
        }
    };
};

const eventService = {
    // Lấy danh sách sự kiện với phân trang và lọc
    getEvents: async (params = {}) => {
        try {
            const response = await axios.get(`${API_URL}/events/`, { 
                params,
                ...getAuthHeader()
            });
            return response.data;
        } catch (error) {
            console.error('Error fetching events:', error);
            throw error;
        }
    },

    // Lấy thông tin chi tiết của một sự kiện
    getEventById: async (eventId) => {
        try {
            const response = await axios.get(`${API_URL}/events/${eventId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error fetching event with ID ${eventId}:`, error);
            throw error;
        }
    },

    // Tạo sự kiện mới
    createEvent: async (eventData) => {
        try {
            const response = await axios.post(`${API_URL}/events/`, eventData, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error('Error creating event:', error);
            throw error;
        }
    },

    // Cập nhật sự kiện
    updateEvent: async (eventId, eventData) => {
        try {
            const response = await axios.put(`${API_URL}/events/${eventId}`, eventData, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error updating event with ID ${eventId}:`, error);
            throw error;
        }
    },

    // Xóa sự kiện
    deleteEvent: async (eventId) => {
        try {
            const response = await axios.delete(`${API_URL}/events/${eventId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error deleting event with ID ${eventId}:`, error);
            throw error;
        }
    },

    // Thêm file đính kèm cho sự kiện
    uploadEventFile: async (eventId, file) => {
        try {
            const formData = new FormData();
            formData.append('file', file);

            const response = await axios.post(
                `${API_URL}/events/${eventId}/files`, 
                formData, 
                {
                    headers: {
                        ...getAuthHeader().headers,
                        'Content-Type': 'multipart/form-data',
                    }
                }
            );
            return response.data;
        } catch (error) {
            console.error(`Error uploading file for event ${eventId}:`, error);
            throw error;
        }
    },

    // Lấy danh sách file đính kèm của sự kiện
    getEventFiles: async (eventId) => {
        try {
            const response = await axios.get(`${API_URL}/events/${eventId}/files`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error fetching files for event ${eventId}:`, error);
            throw error;
        }
    },

    // Xóa file đính kèm
    deleteEventFile: async (eventId, fileId) => {
        try {
            const response = await axios.delete(`${API_URL}/events/${eventId}/files/${fileId}`, getAuthHeader());
            return response.data;
        } catch (error) {
            console.error(`Error deleting file ${fileId} from event ${eventId}:`, error);
            throw error;
        }
    },

    // Tải xuống file đính kèm
    downloadEventFile: async (eventId, fileId, fileName) => {
        try {
            const response = await axios.get(
                `${API_URL}/events/${eventId}/files/${fileId}/download`, 
                {
                    ...getAuthHeader(),
                    responseType: 'blob' // Quan trọng: Cần responseType blob để xử lý dữ liệu nhị phân
                }
            );
            
            // Tạo URL tạm thời cho blob và tải xuống
            const url = window.URL.createObjectURL(new Blob([response.data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', fileName || 'download');
            document.body.appendChild(link);
            link.click();
            
            // Dọn dẹp
            link.parentNode.removeChild(link);
            window.URL.revokeObjectURL(url);
            
            return true;
        } catch (error) {
            console.error(`Error downloading file ${fileId} from event ${eventId}:`, error);
            throw error;
        }
    }
};

export default eventService; 