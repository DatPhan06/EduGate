import { api } from './api';

// Get homeroom classes for a teacher
const getTeacherHomeroomClasses = async (teacherId) => {
  try {
    console.log('getTeacherHomeroomClasses called with teacherId:', teacherId);
    const token = localStorage.getItem('token');
    console.log('Using token:', token ? 'Token exists' : 'No token found');
    
    const response = await api.get(`/teachers/${teacherId}/homeroom-classes`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    console.log('API response for homeroom classes:', response);
    return response.data;
  } catch (error) {
    console.error('Error fetching homeroom classes:', error);
    if (error.response) {
      console.error('Response error data:', error.response.data);
      console.error('Response error status:', error.response.status);
    }
    throw error;
  }
};

// Get students from a teacher's homeroom class
const getHomeroomClassStudents = async (teacherId, classId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/teachers/${teacherId}/homeroom-classes/${classId}/students`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching homeroom class students:', error);
    throw error;
  }
};

// Get grades for a student
const getStudentGrades = async (studentId, semester) => {
  try {
    const token = localStorage.getItem('token');
    let url = `/grades/student/${studentId}`;
    if (semester) {
      url += `?semester=${encodeURIComponent(semester)}`;
    }
    
    const response = await api.get(url, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching student grades:', error);
    throw error;
  }
};

// Update grade component
const updateGradeComponent = async (componentId, data) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.put(`/grades/components/${componentId}`, data, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error updating grade component:', error);
    throw error;
  }
};

export {
  getTeacherHomeroomClasses,
  getHomeroomClassStudents,
  getStudentGrades,
  updateGradeComponent
}; 