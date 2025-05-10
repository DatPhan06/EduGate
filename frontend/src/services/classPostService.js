import axios from 'axios';
import authService from './authService';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

class ClassPostService {
    // Get auth header
    getAuthHeader() {
        const token = localStorage.getItem('token');
        return {
            headers: {
                Authorization: `Bearer ${token}`
            }
        };
    }

    // Handle token refresh for expired tokens
    async handleTokenRefresh(error) {
        if (error.response && error.response.status === 401) {
            try {
                await authService.refreshToken();
                return true; // Token refreshed successfully
            } catch (refreshError) {
                authService.logout();
                window.location.href = '/login';
                return false; // Token refresh failed
            }
        }
        return false; // Not a token issue
    }

    // Create a new class post
    async createClassPost(postData) {
        try {
            const response = await axios.post(
                `${API_URL}/class-posts/`, 
                postData, 
                this.getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.post(
                    `${API_URL}/class-posts/`, 
                    postData, 
                    this.getAuthHeader()
                );
                return response.data;
            }
            throw error;
        }
    }

    // Get a specific class post by ID
    async getClassPost(postId) {
        try {
            const response = await axios.get(
                `${API_URL}/class-posts/${postId}`, 
                this.getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.get(
                    `${API_URL}/class-posts/${postId}`, 
                    this.getAuthHeader()
                );
                return response.data;
            }
            throw error;
        }
    }

    // Update an existing class post
    async updateClassPost(postId, postData) {
        try {
            const response = await axios.put(
                `${API_URL}/class-posts/${postId}`, 
                postData, 
                this.getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.put(
                    `${API_URL}/class-posts/${postId}`, 
                    postData, 
                    this.getAuthHeader()
                );
                return response.data;
            }
            throw error;
        }
    }

    // Delete a class post
    async deleteClassPost(postId) {
        try {
            const response = await axios.delete(
                `${API_URL}/class-posts/${postId}`, 
                this.getAuthHeader()
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.delete(
                    `${API_URL}/class-posts/${postId}`, 
                    this.getAuthHeader()
                );
                return response.data;
            }
            throw error;
        }
    }

    // Get all class posts for a specific class with pagination and search
    async getClassPostsByClass(classId, page = 1, size = 10, search = '') {
        try {
            const response = await axios.get(
                `${API_URL}/class-posts/class/${classId}`, {
                    ...this.getAuthHeader(),
                    params: {
                        page,
                        size,
                        search
                    }
                }
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.get(
                    `${API_URL}/class-posts/class/${classId}`, {
                        ...this.getAuthHeader(),
                        params: {
                            page,
                            size,
                            search
                        }
                    }
                );
                return response.data;
            }
            throw error;
        }
    }

    // Get all class posts created by the current teacher
    async getMyClassPosts(page = 1, size = 10, search = '') {
        try {
            const response = await axios.get(
                `${API_URL}/class-posts/teacher/my-posts`, {
                    ...this.getAuthHeader(),
                    params: {
                        page,
                        size,
                        search
                    }
                }
            );
            return response.data;
        } catch (error) {
            if (await this.handleTokenRefresh(error)) {
                // Retry the request with new token
                const response = await axios.get(
                    `${API_URL}/class-posts/teacher/my-posts`, {
                        ...this.getAuthHeader(),
                        params: {
                            page,
                            size,
                            search
                        }
                    }
                );
                return response.data;
            }
            throw error;
        }
    }
}

const classPostService = new ClassPostService();
export default classPostService;