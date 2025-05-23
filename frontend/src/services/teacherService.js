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
const getStudentGrades = async (studentId, semester, academicYear) => {
  try {
    const token = localStorage.getItem('token');
    const params = new URLSearchParams();
    
    if (semester) params.append('semester', semester);
    if (academicYear) params.append('academic_year', academicYear);
    
    let url = `/grades/student/${studentId}`;
    if (params.toString()) {
      url += `?${params}`;
    }
    
    const response = await api.get(url, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    console.log('API response for student grades:', response.data);
    
    // Process the data to include additional fields needed by the UI
    if (response.data && Array.isArray(response.data)) {
      // Enhance grade data with necessary fields
      const enhancedData = response.data.map(grade => {
        return {
          ...grade,
          id: grade.GradeID,
          studentId: grade.StudentID,
          subjectId: grade.subjectId || grade.ClassSubjectID, 
          subjectName: grade.subjectName || `Subject ${grade.ClassSubjectID}`,
          finalGrade: grade.FinalScore,
          semester: grade.Semester,
          components: grade.grade_components || []
        };
      });
      
      console.log('Enhanced grade data:', enhancedData);
      return enhancedData;
    }
    
    return response.data;
  } catch (error) {
    console.error('Error fetching student grades:', error);
    throw error;
  }
};

// Get grade components for a specific grade
const getGradeComponents = async (gradeId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/grades/${gradeId}/components`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching grade components:', error);
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

// Update an entire grade record
const updateGrade = async (gradeId, data) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.put(`/grades/${gradeId}`, data, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error updating grade:', error);
    throw error;
  }
};

// Delete an entire grade record
const deleteGrade = async (gradeId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.delete(`/grades/${gradeId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error deleting grade:', error);
    throw error;
  }
};

// Get class subjects with semester and academic year information
const getClassSubjectsInfo = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get('/timetable/class-subjects/', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching class subjects info:', error);
    throw error;
  }
};

// Get subjects taught by teacher
const getTeacherSubjects = async (teacherId) => {
  try {
    const token = localStorage.getItem('token');
    
    // Get teacher subjects
    const subjectsResponse = await api.get(`/teachers/${teacherId}/teaching-subjects`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    
    // Get class subjects info with semester and academic year
    const classSubjectsInfo = await getClassSubjectsInfo();
    
    // Create a lookup map for class subjects
    const classSubjectsMap = {};
    classSubjectsInfo.forEach(item => {
      classSubjectsMap[item.ClassSubjectID] = {
        semester: item.Semester,
        academic_year: item.AcademicYear
      };
    });
    
    // Enrich the teacher subjects data with semester and academic year info
    const enrichedData = subjectsResponse.data.map(classItem => ({
      ...classItem,
      subjects: classItem.subjects.map(subject => ({
        ...subject,
        semester: classSubjectsMap[subject.class_subject_id]?.semester || 'HK1',
        academic_year: classSubjectsMap[subject.class_subject_id]?.academic_year || '2023-2024'
      }))
    }));
    
    return enrichedData;
  } catch (error) {
    console.error('Error fetching teacher subjects:', error);
    throw error;
  }
};

// Get students in a class for a subject
const getStudentsInClassSubject = async (teacherId, classSubjectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/teachers/${teacherId}/class-subjects/${classSubjectId}/students`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching students for class-subject:', error);
    throw error;
  }
};

// Get student grades for subjects taught by teacher
const getStudentGradesForTeacher = async (teacherId, studentId, classSubjectId, semester) => {
  try {
    const token = localStorage.getItem('token');
    let url = `/teachers/${teacherId}/students/${studentId}/grades`;
    
    // Add query parameters if provided
    const params = new URLSearchParams();
    if (classSubjectId) params.append('class_subject_id', classSubjectId);
    if (semester) params.append('semester', semester);
    
    if (params.toString()) {
      url += `?${params.toString()}`;
    }
    
    const response = await api.get(url, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching student grades for teacher:', error);
    throw error;
  }
};

// Create a new grade component
const createGradeComponent = async (teacherId, gradeId, componentData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.post(`/teachers/${teacherId}/grades/components?grade_id=${gradeId}`, componentData, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error creating grade component:', error);
    throw error;
  }
};

// Update a grade component as a teacher
const updateTeacherGradeComponent = async (teacherId, componentId, data) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.put(`/teachers/${teacherId}/grades/components/${componentId}`, data, {
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

// Delete a grade component
const deleteGradeComponent = async (teacherId, componentId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.delete(`/teachers/${teacherId}/grades/components/${componentId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error deleting grade component:', error);
    throw error;
  }
};

// Initialize standard grade components
const initializeGradeComponents = async (teacherId, gradeId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.post(`/teachers/${teacherId}/initialize-grade-components?grade_id=${gradeId}`, {}, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error initializing grade components:', error);
    throw error;
  }
};

// Lấy danh sách điểm của tất cả học sinh trong lớp
const getClassGrades = async (teacherId, classId, semester, academicYear) => {
  try {
    const token = localStorage.getItem('token');
    let url = `/teachers/${teacherId}/homeroom-classes/${classId}/grades`;
    
    const params = new URLSearchParams();
    if (semester) params.append('semester', semester);
    if (academicYear) params.append('academic_year', academicYear);
    
    if (params.toString()) {
      url += `?${params.toString()}`;
    }
    
    const response = await api.get(url, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching class grades:', error);
    throw error;
  }
};

// Lấy danh sách tất cả các môn học của lớp
const getClassSubjects = async (classId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/classes/${classId}/subjects`, {
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

// Get student details by ID
const getStudentById = async (studentId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/students/${studentId}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching student details:', error);
    throw error;
  }
};

// Get subject information by class subject ID
const getSubjectByClassSubjectId = async (classSubjectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/class-subjects/${classSubjectId}/subject`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching subject information:', error);
    throw error;
  }
};

// Get grade components by grade ID
const getGradeComponentsByGradeId = async (gradeId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await api.get(`/grades/grade/${gradeId}/components`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching grade components:', error);
    throw error;
  }
};

export {
  getTeacherHomeroomClasses,
  getHomeroomClassStudents,
  getStudentGrades,
  getGradeComponents,
  updateGradeComponent,
  updateGrade,
  deleteGrade,
  getTeacherSubjects,
  getStudentsInClassSubject,
  getStudentGradesForTeacher,
  createGradeComponent,
  updateTeacherGradeComponent,
  deleteGradeComponent,
  initializeGradeComponents,
  getClassGrades,
  getClassSubjects,
  getStudentById,
  getClassSubjectsInfo,
  getSubjectByClassSubjectId,
  getGradeComponentsByGradeId
}; 