import axios from 'axios';
import authHeader from './authHeader';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

class ReportService {
  getStudentStatistics() {
    return axios.get(`${API_URL}/reports/student-statistics`, { headers: authHeader() });
  }

  getAttendanceData(year) {
    return axios.get(`${API_URL}/reports/attendance?year=${year}`, { headers: authHeader() });
  }

  getAcademicPerformance(filters = {}) {
    return axios.get(`${API_URL}/reports/academic-performance`, { 
      headers: authHeader(),
      params: filters
    });
  }

  getRewardsData(year) {
    return axios.get(`${API_URL}/reports/rewards-disciplines?year=${year}`, { headers: authHeader() });
  }

  getRecentEvents(limit = 5) {
    return axios.get(`${API_URL}/reports/recent-events?limit=${limit}`, { headers: authHeader() });
  }

  getTopClasses(limit = 5) {
    return axios.get(`${API_URL}/reports/top-classes?limit=${limit}`, { headers: authHeader() });
  }

  getTotalStats() {
    return axios.get(`${API_URL}/reports/total-stats`, { headers: authHeader() });
  }

  // Get all report data in a single request
  getAllReportData(filters = {}) {
    return axios.get(`${API_URL}/reports/all`, { 
      headers: authHeader(),
      params: filters
    });
  }
}

export default new ReportService(); 