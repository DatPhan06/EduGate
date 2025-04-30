import axios from 'axios';

const API_URL = 'http://localhost:8000';

const authService = {
    // Đăng ký
    register: async (userData) => {
        try {
            const response = await axios.post(`${API_URL}/users/register`, userData, {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            if (error.response) {
                // The request was made and the server responded with a status code
                // that falls out of the range of 2xx
                throw new Error(error.response.data.detail || error.response.data.message || 'Đăng ký thất bại');
            } else if (error.request) {
                // The request was made but no response was received
                throw new Error('Không thể kết nối đến máy chủ');
            } else {
                // Something happened in setting up the request that triggered an Error
                throw new Error('Có lỗi xảy ra khi đăng ký');
            }
        }
    },

    // Đăng nhập
    login: async (credentials) => {
        try {
            const response = await axios.post(`${API_URL}/users/login`, credentials, {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            });
            if (response.data.access_token) {
                localStorage.setItem('user', JSON.stringify(response.data));
            }
            return response.data;
        } catch (error) {
            if (error.response) {
                throw new Error(error.response.data.detail || error.response.data.message || 'Đăng nhập thất bại');
            } else if (error.request) {
                throw new Error('Không thể kết nối đến máy chủ');
            } else {
                throw new Error('Có lỗi xảy ra khi đăng nhập');
            }
        }
    },

    // Đăng xuất
    logout: () => {
        localStorage.removeItem('user');
    },

    // Lấy thông tin user hiện tại
    getCurrentUser: () => {
        const user = localStorage.getItem('user');
        return user ? JSON.parse(user) : null;
    }
};

export default authService; 