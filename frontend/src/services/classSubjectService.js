import { api } from './api';

// Lấy danh sách lớp-môn học
const getClassSubjects = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get('/class-subjects', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching class subjects:', error);
    throw error;
  }
};

// Lấy chi tiết một lớp-môn học
const getClassSubjectById = async (classSubjectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/class-subjects/${classSubjectId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching class subject:', error);
    throw error;
  }
};

// Tạo mới lớp-môn học
const createClassSubject = async (classSubjectData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.post('/class-subjects', classSubjectData, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error creating class subject:', error);
    throw error;
  }
};

// Cập nhật lớp-môn học
const updateClassSubject = async (classSubjectId, classSubjectData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.put(`/class-subjects/${classSubjectId}`, classSubjectData, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error updating class subject:', error);
    throw error;
  }
};

// Xóa lớp-môn học
const deleteClassSubject = async (classSubjectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.delete(`/class-subjects/${classSubjectId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error deleting class subject:', error);
    throw error;
  }
};

// Khởi tạo cấu trúc điểm cho lớp-môn học
const initializeGradesForClassSubject = async (classSubjectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.post(`/class-subjects/${classSubjectId}/initialize-grades`, {}, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error initializing grades for class subject:', error);
    throw error;
  }
};

export {
  getClassSubjects,
  getClassSubjectById,
  createClassSubject,
  updateClassSubject,
  deleteClassSubject,
  initializeGradesForClassSubject
}; 