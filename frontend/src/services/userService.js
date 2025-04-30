import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const userService = {
    getAllUsers: async () => {
        const token = localStorage.getItem('token');
        return axios.get(`${API_URL}/users`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    },

    getUserById: async (userId) => {
        const token = localStorage.getItem('token');
        return axios.get(`${API_URL}/users/${userId}`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    },

    createUser: async (userData) => {
        const token = localStorage.getItem('token');
        return axios.post(`${API_URL}/users`, userData, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    },

    updateUser: async (userId, userData) => {
        const token = localStorage.getItem('token');
        return axios.put(`${API_URL}/users/${userId}`, userData, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    },

    deleteUser: async (userId) => {
        const token = localStorage.getItem('token');
        return axios.delete(`${API_URL}/users/${userId}`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    },

    login: async (email, password) => {
        return axios.post(`${API_URL}/users/login`, {
            email,
            password
        });
    },

    getCurrentUser: async () => {
        const token = localStorage.getItem('token');
        return axios.get(`${API_URL}/users/me`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
    }
};

export default userService; 