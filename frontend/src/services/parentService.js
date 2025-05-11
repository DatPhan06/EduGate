import axios from 'axios';

// Get API base URL from environment variables
const API_BASE_URL = process.env.REACT_APP_API_URL || '';

// Get all students associated with a parent
export const getParentStudents = async (parentUserId) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/parents/${parentUserId}/students`);
    return response.data;
  } catch (error) {
    console.error('Error fetching parent students:', error);
    throw error;
  }
};

// Get a specific student's information
export const getParentStudentById = async (parentUserId, studentId) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/parents/${parentUserId}/students/${studentId}`);
    return response.data;
  } catch (error) {
    console.error('Error fetching parent student by ID:', error);
    throw error;
  }
};

// Get the grades of a specific student for a parent
export const getParentStudentGrades = async (parentUserId, studentId, semester, academicYear) => {
  try {
    let url = `${API_BASE_URL}/parents/${parentUserId}/students/${studentId}/grades`;
    
    // Add query parameters if provided
    if (semester || academicYear) {
      url += '?';
      if (semester) url += `semester=${semester}`;
      if (semester && academicYear) url += '&';
      if (academicYear) url += `academicYear=${academicYear}`;
    }
    
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.error('Error fetching parent student grades:', error);
    throw error;
  }
};

// Get the attendance records of a specific student for a parent
export const getParentStudentAttendance = async (parentUserId, studentId, startDate, endDate) => {
  try {
    let url = `${API_BASE_URL}/parents/${parentUserId}/students/${studentId}/attendance`;
    
    // Add query parameters if provided
    if (startDate || endDate) {
      url += '?';
      if (startDate) url += `startDate=${startDate}`;
      if (startDate && endDate) url += '&';
      if (endDate) url += `endDate=${endDate}`;
    }
    
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.error('Error fetching parent student attendance:', error);
    throw error;
  }
};

export default {
  getParentStudents,
  getParentStudentById,
  getParentStudentGrades,
  getParentStudentAttendance
}; 