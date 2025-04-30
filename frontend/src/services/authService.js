import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

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
                throw new Error(error.response.data.detail || error.response.data.message || 'Đăng ký thất bại');
            } else if (error.request) {
                throw new Error('Không thể kết nối đến máy chủ');
            } else {
                throw new Error('Có lỗi xảy ra khi đăng ký');
            }
        }
    },

    // Đăng nhập
    login: async (credentials) => {
        try {
            const response = await axios.post(`${API_URL}/auth/login`, credentials, {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            });
            if (response.data.access_token) {
                localStorage.setItem('token', response.data.access_token);
                // Lấy thông tin user sau khi đăng nhập
                const userResponse = await axios.get(`${API_URL}/users/me`, {
                    headers: {
                        'Authorization': `Bearer ${response.data.access_token}`
                    }
                });
                if (userResponse.data) {
                    localStorage.setItem('user', JSON.stringify(userResponse.data));
                }
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
        localStorage.removeItem('token');
    },

    // Lấy thông tin user hiện tại
    getCurrentUser: () => {
        const user = localStorage.getItem('user');
        return user ? JSON.parse(user) : null;
    },

    // Lấy token
    getToken: () => {
        return localStorage.getItem('token');
    },

    // Kiểm tra đã đăng nhập chưa
    isAuthenticated: () => {
        return !!localStorage.getItem('token');
    },

    // Làm mới token
    refreshToken: async () => {
        try {
            const token = localStorage.getItem('token');
            if (!token) return null;

            const response = await axios.post(`${API_URL}/auth/refresh`, {}, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });

            if (response.data.access_token) {
                localStorage.setItem('token', response.data.access_token);
                return response.data.access_token;
            }
            return null;
        } catch (error) {
            console.error('Error refreshing token:', error);
            return null;
        }
    }
};

export default authService; 