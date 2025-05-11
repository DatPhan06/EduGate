import React, { useState, useEffect } from 'react';
import { 
  Container, Typography, Box, CircularProgress, Alert, 
  Breadcrumbs, Link, Card, Divider, Grid, Button,
  Table, TableBody, TableCell, TableContainer, TableHead, TableRow, 
  Paper, FormControl, InputLabel, MenuItem, Select, Chip,
  Tab, Tabs, Stack, Tooltip, IconButton
} from '@mui/material';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, 
  Legend, ResponsiveContainer, PieChart, Pie, Cell
} from 'recharts';
import { 
  Download as DownloadIcon,
  Print as PrintIcon,
  FilterAlt as FilterIcon,
  CheckCircle as CheckCircleIcon,
  Cancel as CancelIcon,
  Info as InfoIcon,
  KeyboardArrowDown as KeyboardArrowDownIcon,
  KeyboardArrowUp as KeyboardArrowUpIcon
} from '@mui/icons-material';
import { getStudentGrades, getGradeComponentsByGradeId, getSubjectByClassSubjectId } from '../../services/teacherService';
import { getParentStudents } from '../../services/parentService';
import { useNavigate } from 'react-router-dom';

// Grade categories with color mapping
const GRADE_CATEGORIES = {
  EXCELLENT: { range: [8.5, 10], color: '#4caf50', label: 'Giỏi' },
  GOOD: { range: [7, 8.4], color: '#8bc34a', label: 'Khá' },
  AVERAGE: { range: [5.5, 6.9], color: '#ffeb3b', label: 'Trung bình' },
  BELOW_AVERAGE: { range: [4, 5.4], color: '#ff9800', label: 'Trung bình yếu' },
  POOR: { range: [0, 3.9], color: '#f44336', label: 'Yếu' }
};

// Helper functions for grade analysis
const getGradeCategory = (score) => {
  if (score === null || score === undefined) return null;
  
  for (const [category, details] of Object.entries(GRADE_CATEGORIES)) {
    if (score >= details.range[0] && score <= details.range[1]) {
      return { category, ...details };
    }
  }
  return null;
};

const calculateStats = (grades) => {
  if (!grades || grades.length === 0) return null;
  
  const validGrades = grades.filter(g => g.finalGrade !== null && g.finalGrade !== undefined);
  
  if (validGrades.length === 0) return null;
  
  const finalScores = validGrades.map(g => g.finalGrade);
  const sum = finalScores.reduce((acc, curr) => acc + curr, 0);
  const avg = sum / finalScores.length;
  const highest = Math.max(...finalScores);
  const lowest = Math.min(...finalScores);
  
  const categoryCounts = Object.keys(GRADE_CATEGORIES).reduce((acc, category) => {
    acc[category] = 0;
    return acc;
  }, {});
  
  validGrades.forEach(grade => {
    const category = getGradeCategory(grade.finalGrade);
    if (category) {
      categoryCounts[category.category]++;
    }
  });
  
  return {
    average: avg,
    highest,
    lowest,
    count: validGrades.length,
    categoryCounts
  };
};

const generateOverallGrade = (stats) => {
  if (!stats || stats.average === undefined) return null;
  
  return getGradeCategory(stats.average);
};

const StudentGradesViewPage = () => {
  const navigate = useNavigate();
  const [grades, setGrades] = useState([]);
  const [studentInfo, setStudentInfo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [activeSemester, setActiveSemester] = useState('HK1');
  const [activeAcademicYear, setActiveAcademicYear] = useState('2025-2026');
  const [activeTab, setActiveTab] = useState(0);
  const [showDetails, setShowDetails] = useState({});
  const [gradeStats, setGradeStats] = useState(null);
  const [selectedSubject, setSelectedSubject] = useState(null);
  
  // Add states for parent's children handling
  const [isParent, setIsParent] = useState(false);
  const [children, setChildren] = useState([]);
  const [selectedChildId, setSelectedChildId] = useState(null);
  const [loadingChildren, setLoadingChildren] = useState(false);

  // Get user data from localStorage with better parsing and error handling
  const getUserData = () => {
    try {
      const userString = localStorage.getItem('user');
      if (!userString) return {};
      
      const user = JSON.parse(userString);
      console.log('User data from localStorage:', user);
      return user;
    } catch (e) {
      console.error('Error parsing user data from localStorage:', e);
      return {};
    }
  };
  
  const user = getUserData();
  
  // Find user ID and determine if user is a parent
  const userId = user.id || user.UserID || user.userId || user.ID;
  const userRole = user.role || user.Role || user.user_role || '';
  
  // Check if user is a parent on component mount
  useEffect(() => {
    const checkIfParent = () => {
      const role = userRole.toLowerCase();
      const isUserParent = role === 'parent' || role.includes('parent');
      setIsParent(isUserParent);
      
      console.log('User role:', userRole);
      console.log('Is parent:', isUserParent);
    };
    
    checkIfParent();
  }, [userRole]);
  
  // Fetch parent's children if user is a parent
  useEffect(() => {
    const fetchChildrenForParent = async () => {
      if (!isParent || !userId) return;
      
      try {
        setLoadingChildren(true);
        console.log('Fetching children for parent with ID:', userId);
        const childrenData = await getParentStudents(userId);
        console.log('Children data received:', childrenData);
        
        if (childrenData && Array.isArray(childrenData) && childrenData.length > 0) {
          setChildren(childrenData);
          // Auto-select first child
          setSelectedChildId(childrenData[0].id || childrenData[0].UserID || childrenData[0].userId || childrenData[0].ID);
        } else {
          setError('Không tìm thấy thông tin học sinh con. Vui lòng liên hệ quản trị viên.');
        }
      } catch (error) {
        console.error('Error fetching parent\'s children:', error);
        setError('Không thể tải thông tin học sinh con. Vui lòng thử lại sau.');
      } finally {
        setLoadingChildren(false);
      }
    };
    
    if (isParent) {
      fetchChildrenForParent();
    }
  }, [isParent, userId]);
  
  // Find student ID based on user role
  const studentId = isParent ? selectedChildId : (user.id || user.UserID || user.userId || user.student_id || user.studentId || user.ID);
  
  // Handle child selection change
  const handleChildChange = (event) => {
    setSelectedChildId(event.target.value);
  };
  
  // Fetch student information when component mounts or when selectedChildId changes
  useEffect(() => {
    const fetchStudentInfo = async () => {
      if (isParent && selectedChildId) {
        // Find the selected child from the children array
        const selectedChild = children.find(child => 
          child.id === selectedChildId || 
          child.UserID === selectedChildId || 
          child.userId === selectedChildId || 
          child.ID === selectedChildId
        );
        
        if (selectedChild) {
          const firstName = selectedChild.FirstName || selectedChild.firstname || '';
          const lastName = selectedChild.LastName || selectedChild.lastname || '';
          const fullName = selectedChild.name || selectedChild.fullName || selectedChild.username || `${firstName} ${lastName}`.trim() || 'Học sinh';
          
          setStudentInfo({
            name: fullName,
            className: selectedChild.className || selectedChild.ClassName || selectedChild.class_name || selectedChild.ClassID || 'Lớp chưa xác định',
            studentId: selectedChildId,
            gender: selectedChild.gender || selectedChild.Gender || '-',
            dob: selectedChild.DateOfBirth || selectedChild.dob || selectedChild.DOB || '-',
            classGrade: selectedChild.classGrade || selectedChild.ClassGrade || selectedChild.Grade || '-'
          });
        }
      } else {
        // Extract student info from user data with fallbacks (original code for non-parent users)
        const firstName = user.FirstName || user.firstname || '';
        const lastName = user.LastName || user.lastname || '';
        const fullName = user.name || user.fullName || user.username || `${firstName} ${lastName}`.trim() || 'Học sinh';
        
        setStudentInfo({
          name: fullName,
          className: user.className || user.ClassName || user.class_name || user.ClassID || 'Lớp chưa xác định',
          studentId: studentId,
          gender: user.gender || user.Gender || '-',
          dob: user.DateOfBirth || user.dob || user.DOB || '-',
          classGrade: user.classGrade || user.ClassGrade || user.Grade || '-'
        });
      }
    };
    
    if ((isParent && selectedChildId) || (!isParent && studentId)) {
      fetchStudentInfo();
    } else if (isParent && !selectedChildId && children.length === 0 && !loadingChildren) {
      setError('Không tìm thấy thông tin học sinh con. Vui lòng liên hệ quản trị viên.');
    } else if (!isParent && !studentId) {
      setError('Không thể xác định thông tin học sinh.');
    }
  }, [studentId, user, isParent, selectedChildId, children, loadingChildren]);
  
  // Fetch grades by semester and academic year
  useEffect(() => {
    const fetchGrades = async () => {
      if (!studentId) return;
      
      try {
        setLoading(true);
        // Use semester and academic year in the API call
        const data = await getStudentGrades(studentId, activeSemester, activeAcademicYear);
        console.log('Student grades data received from API:', data);
        
        // Debug subject name issues
        if (data && data.length > 0) {
          console.log('Analyzing API response for subject name debugging:');
          data.forEach((gradeItem, index) => {
            console.log(`Grade item ${index} structure:`, {
              directSubjectName: gradeItem.subjectName,
              classSubjectPath: gradeItem.class_subject && gradeItem.class_subject.subject ? 
                gradeItem.class_subject.subject.SubjectName : 'not available',
              subjectObjectPath: gradeItem.subject ? 
                `${gradeItem.subject.SubjectName || gradeItem.subject.name || 'no name property'}` : 'not available',
              directSubjectNameProperty: gradeItem.SubjectName,
              nameProperty: gradeItem.name,
              subjectIdInfo: `ID: ${gradeItem.subjectId || gradeItem.SubjectID || 'none'}, ClassSubjectID: ${gradeItem.ClassSubjectID || 'none'}`
            });
          });
        }
        
        // Fetch subject names for grades with "Subject" placeholder
        const gradesWithSubjectNames = await Promise.all(data.map(async (grade) => {
          // If subject name is a placeholder, try to fetch the real name
          if (grade.subjectName && grade.subjectName.startsWith('Subject') && grade.ClassSubjectID) {
            try {
              console.log(`Fetching real subject name for ClassSubjectID ${grade.ClassSubjectID}...`);
              const subjectData = await getSubjectByClassSubjectId(grade.ClassSubjectID);
              console.log(`Subject data response:`, subjectData);
              
              if (subjectData) {
                // Extract subject_name from the response based on API format
                if (subjectData.subject_name) {
                  grade.subjectName = subjectData.subject_name;
                } else if (subjectData.subject && subjectData.subject.SubjectName) {
                  grade.subjectName = subjectData.subject.SubjectName;
                } else if (subjectData.SubjectName) {
                  grade.subjectName = subjectData.SubjectName;
                } else if (subjectData.name) {
                  grade.subjectName = subjectData.name;
                }
                console.log(`Updated subject name for ClassSubjectID ${grade.ClassSubjectID} to: ${grade.subjectName}`);
              }
            } catch (error) {
              console.error(`Error fetching subject name for ClassSubjectID ${grade.ClassSubjectID}:`, error);
            }
          }
          return grade;
        }));
        
        // Enhance grade data with components
        const enhancedData = await Promise.all(gradesWithSubjectNames.map(async (grade) => {
          let enhancedGrade = { ...grade };
          
          // Always fetch grade components for each grade
          if (grade.GradeID) {
            try {
              console.log(`Fetching components for grade ${grade.GradeID}...`);
              const components = await getGradeComponentsByGradeId(grade.GradeID);
              console.log(`Components received for grade ${grade.GradeID}:`, components);
              
              if (components && components.length > 0) {
                enhancedGrade.grade_components = components;
              } else {
                console.log(`No components found for grade ${grade.GradeID}`);
                enhancedGrade.grade_components = [];
              }
            } catch (error) {
              console.error(`Error fetching components for grade ${grade.GradeID}:`, error);
              enhancedGrade.grade_components = [];
            }
          }
          
          return enhancedGrade;
        }));
        
        console.log('Enhanced data with components and subject names:', enhancedData);
        setGrades(enhancedData);
        setError(null);
      } catch (error) {
        console.error('Error fetching grades:', error);
        setError('Không thể tải dữ liệu điểm số. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    };
    
    if (studentId && activeSemester && activeAcademicYear) {
      fetchGrades();
    }
  }, [studentId, activeSemester, activeAcademicYear]);

  // Fetch subject names for grades that need them
  useEffect(() => {
    const fetchSubjectNames = async () => {
      if (!grades.length) return;
      
      const updatedGrades = [...grades];
      let hasUpdates = false;
      
      // Process each grade to fetch subject name if needed
      for (let i = 0; i < updatedGrades.length; i++) {
        const grade = updatedGrades[i];
        
        // Skip if grade already has a non-placeholder subject name
        if (grade.subjectName && !grade.subjectName.startsWith('Subject')) {
          continue;
        }
        
        // Try to fetch subject name by ClassSubjectID
        if (grade.ClassSubjectID) {
          try {
            console.log(`Fetching subject name for ClassSubjectID ${grade.ClassSubjectID}...`);
            const subjectData = await getSubjectByClassSubjectId(grade.ClassSubjectID);
            console.log(`Fetched subject data for ClassSubjectID ${grade.ClassSubjectID}:`, subjectData);
            
            if (subjectData) {
              // Extract subject name from response based on available properties
              let subjectName = null;
              
              if (subjectData.subject_name) {
                subjectName = subjectData.subject_name;
              } else if (subjectData.subject && subjectData.subject.SubjectName) {
                subjectName = subjectData.subject.SubjectName;
              } else if (subjectData.SubjectName) {
                subjectName = subjectData.SubjectName;
              } else if (subjectData.name) {
                subjectName = subjectData.name;
              }
              
              if (subjectName) {
                updatedGrades[i] = {
                  ...grade,
                  subjectName: subjectName
                };
                hasUpdates = true;
                console.log(`Updated subject name for grade ${i} to: ${subjectName}`);
              }
            }
          } catch (error) {
            console.error(`Error fetching subject name for ClassSubjectID ${grade.ClassSubjectID}:`, error);
          }
        }
      }
      
      // Only update state if changes were made
      if (hasUpdates) {
        console.log('Updating grades with fetched subject names:', updatedGrades);
        setGrades(updatedGrades);
      }
    };
    
    fetchSubjectNames();
  }, [grades.length]); // Run only when the number of grades changes

  // Calculate statistics whenever grades change
  useEffect(() => {
    const subjectGrades = getGradesBySubject();
    const stats = calculateStats(subjectGrades);
    setGradeStats(stats);
  }, [grades]);
  
  const getGradesBySubject = () => {
    // Group grades by subject
    const subjectMap = {};
    
    console.log("Processing grades in getGradesBySubject:", grades);
    
    grades.forEach(grade => {
      // Try multiple paths to get the actual subject name
      let subjectName = null;
      
      // Option 1: Direct subjectName property
      if (grade.subjectName) {
        subjectName = grade.subjectName;
      } 
      // Option 2: From class_subject.subject.SubjectName path
      else if (grade.class_subject && grade.class_subject.subject && grade.class_subject.subject.SubjectName) {
        subjectName = grade.class_subject.subject.SubjectName;
      }
      // Option 3: Try subject.SubjectName path
      else if (grade.subject && grade.subject.SubjectName) {
        subjectName = grade.subject.SubjectName;
      }
      // Option 4: Try subject.name path
      else if (grade.subject && grade.subject.name) {
        subjectName = grade.subject.name;
      }
      // Option 5: Try SubjectName directly
      else if (grade.SubjectName) {
        subjectName = grade.SubjectName;
      }
      // Option 6: Try name property if it refers to subject name
      else if (grade.name && !grade.name.startsWith('Subject')) {
        subjectName = grade.name;
      }
      // Fallback to a placeholder with more information
      else {
        subjectName = `Subject ${grade.ClassSubjectID || grade.subjectId || grade.SubjectID || 'không xác định'}`;
        console.warn('Could not find subject name for grade:', grade);
      }
      
      if (!subjectMap[subjectName]) {
        subjectMap[subjectName] = {
          subjectName: subjectName,
          classSubjectId: grade.ClassSubjectID,
          gradeId: grade.GradeID || grade.id,
          components: [],
          // Handle both finalGrade and FinalScore formats
          finalGrade: grade.FinalScore !== undefined ? grade.FinalScore : grade.finalGrade,
          // Add subject code for reference
          subjectCode: grade.subjectId || grade.SubjectID,
          // Add category based on final grade
          category: getGradeCategory(grade.FinalScore !== undefined ? grade.FinalScore : grade.finalGrade)
        };
      }
      
      // Add component to the subject
      console.log(`Processing components for subject ${subjectName}, grade ${grade.GradeID || grade.id}:`, 
                 grade.grade_components || grade.components || []);
      
      const components = grade.grade_components || grade.components || [];
      if (components.length > 0) {
        components.forEach(component => {
          // Standardize component property naming to match API
          const componentId = component.ComponentID !== undefined ? component.ComponentID : component.id;
          const componentName = component.ComponentName !== undefined ? component.ComponentName : component.name;
          const weight = component.Weight !== undefined ? component.Weight : component.weight;
          const score = component.Score !== undefined ? component.Score : component.score;
          
          subjectMap[subjectName].components.push({
            key: `${grade.GradeID || grade.id}_${componentId}`,
            ComponentID: componentId,
            ComponentName: componentName,
            Score: score,
            Weight: weight,
            category: getGradeCategory(score)
          });
        });
        
        // Sort components by weight (descending) and then by name
        subjectMap[subjectName].components.sort((a, b) => {
          if (b.Weight !== a.Weight) {
            return b.Weight - a.Weight;
          }
          return a.ComponentName.localeCompare(b.ComponentName);
        });
      }
    });
    
    // Convert to array and sort by subject name
    const result = Object.values(subjectMap).sort((a, b) => 
      a.subjectName.localeCompare(b.subjectName)
    );
    
    console.log("Processed subjects:", result);
    return result;
  };
  
  const formatScore = (score) => {
    if (score === null || score === undefined) return '-';
    return parseFloat(score).toFixed(1);
  };
  
  const handleSemesterChange = (event) => {
    setActiveSemester(event.target.value);
  };
  
  const handleAcademicYearChange = (event) => {
    setActiveAcademicYear(event.target.value);
  };
  
  const formatDate = (dateStr) => {
    if (!dateStr || dateStr === '-') return '-';
    try {
      const date = new Date(dateStr);
      return date.toLocaleDateString('vi-VN');
    } catch (e) {
      return dateStr;
    }
  };
  
  if (loading && !studentInfo) {
    return (
      <Box display="flex" justifyContent="center" padding="50px">
        <CircularProgress size={60} />
        <Typography variant="h6" style={{ marginLeft: '16px' }}>
          Đang tải dữ liệu...
        </Typography>
      </Box>
    );
  }
  
  if (error) {
    return (
      <Alert severity="error">
        <Typography variant="subtitle1">{error}</Typography>
      </Alert>
    );
  }
  
  const subjectGrades = getGradesBySubject();

  // Handle tab change
  const handleTabChange = (event, newValue) => {
    setActiveTab(newValue);
  };

  // Toggle subject details view
  const toggleDetails = (subjectName) => {
    setShowDetails(prev => ({
      ...prev,
      [subjectName]: !prev[subjectName]
    }));
  };

  // Handle subject selection for detailed view
  const handleSubjectSelect = (subject) => {
    setSelectedSubject(subject);
    setActiveTab(1); // Switch to detailed view tab
  };

  // Format for printing
  const handlePrint = () => {
    window.print();
  };

  // Render detailed view of a student's grades for all subjects or a specific subject
  const renderDetailedView = () => {
    // If no subject selected, show detailed view of all subjects
    const subjectsToShow = selectedSubject ? [selectedSubject] : subjectGrades;
    
    return (
      <Box>
        {selectedSubject && (
          <Box sx={{ mb: 3, display: 'flex', alignItems: 'center' }}>
            <Button 
              variant="outlined" 
              size="small" 
              onClick={() => setSelectedSubject(null)}
              sx={{ mr: 2 }}
            >
              ← Xem tất cả môn học
            </Button>
            <Typography variant="h6">
              Chi tiết điểm môn: {selectedSubject.subjectName}
            </Typography>
          </Box>
        )}
        
        <Grid container spacing={3}>
          {subjectsToShow.map(subject => (
            <Grid item xs={12} key={subject.subjectName}>
              <Card variant="outlined">
                <Box sx={{ p: 2, borderBottom: '1px solid #eee' }}>
                  <Typography 
                    variant="h6"
                    sx={{
                      display: 'flex',
                      alignItems: 'center',
                      color: subject.subjectName.startsWith('Subject') ? 'warning.main' : 'inherit'
                    }}
                  >
                    {subject.subjectName}
                    {subject.subjectName.startsWith('Subject') && 
                      <Tooltip title="Tên môn học chưa được đồng bộ đầy đủ">
                        <InfoIcon fontSize="small" color="warning" sx={{ ml: 1 }} />
                      </Tooltip>
                    }
                    {subject.category && (
                      <Chip 
                        label={subject.category.label} 
                        size="small"
                        sx={{ 
                          ml: 2,
                          backgroundColor: subject.category.color,
                          color: '#fff',
                          fontWeight: 'bold'
                        }} 
                      />
                    )}
                  </Typography>
                  <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    Điểm trung bình: <strong style={{ color: subject.category?.color }}>{formatScore(subject.finalGrade)}</strong>
                  </Typography>
                </Box>
                
                {subject.components.length > 0 ? (
                  <TableContainer>
                    <Table>
                      <TableHead>
                        <TableRow sx={{ backgroundColor: '#f5f5f5' }}>
                          <TableCell width="50%" sx={{ fontWeight: 'bold' }}>Thành phần điểm</TableCell>
                          <TableCell align="center" width="15%" sx={{ fontWeight: 'bold' }}>Hệ số</TableCell>
                          <TableCell align="center" width="35%" sx={{ fontWeight: 'bold' }}>Điểm số</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {subject.components.map(component => (
                          <TableRow key={component.key}>
                            <TableCell>
                              <Typography variant="body1">
                                {component.ComponentName}
                              </Typography>
                              <Typography variant="caption" color="text.secondary">
                                {component.ComponentName.includes('hệ số') ? '' : `Điểm hệ số ${component.Weight}`}
                              </Typography>
                            </TableCell>
                            <TableCell align="center">
                              <Chip 
                                label={component.Weight} 
                                size="small"
                                variant="outlined"
                                color="primary"
                              />
                            </TableCell>
                            <TableCell align="center">
                              <Typography
                                variant="body1"
                                sx={{
                                  fontWeight: 'bold',
                                  fontSize: '1.1rem',
                                  color: component.Score !== null && component.Score !== undefined 
                                    ? (component.Score >= 5 ? '#4caf50' : '#f44336')
                                    : 'inherit'
                                }}
                              >
                                {formatScore(component.Score)}
                              </Typography>
                            </TableCell>
                          </TableRow>
                        ))}
                        <TableRow sx={{ backgroundColor: '#f0f8ff' }}>
                          <TableCell sx={{ fontWeight: 'bold' }}>
                            Điểm trung bình môn học
                          </TableCell>
                          <TableCell align="center">
                            <Chip 
                              label="TB" 
                              size="small"
                              sx={{ backgroundColor: '#2196f3', color: 'white' }}
                            />
                          </TableCell>
                          <TableCell align="center">
                            <Typography 
                              variant="h6"
                              sx={{ 
                                fontWeight: 'bold', 
                                color: subject.category?.color || 'inherit'
                              }}
                            >
                              {formatScore(subject.finalGrade)}
                            </Typography>
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </TableContainer>
                ) : (
                  <Box sx={{ p: 3, textAlign: 'center' }}>
                    <Alert severity="info">
                      <Typography variant="body2">
                        Chưa có thành phần điểm cho môn này
                      </Typography>
                    </Alert>
                  </Box>
                )}
                
                {/* Component chart */}
                {subject.components.length > 0 && (
                  <Box sx={{ p: 2, mt: 2, borderTop: '1px solid #eee' }}>
                    <Typography variant="subtitle2" gutterBottom>
                      Biểu đồ thành phần điểm
                    </Typography>
                    
                    <Box sx={{ height: 200, width: '100%' }}>
                      <ResponsiveContainer width="100%" height="100%">
                        <BarChart
                          data={subject.components.map(comp => ({
                            name: comp.ComponentName.length > 20 ? 
                              comp.ComponentName.substring(0, 20) + '...' : 
                              comp.ComponentName,
                            điểm: comp.Score || 0,
                            hệ_số: comp.Weight,
                            color: comp.Score !== null && comp.Score !== undefined 
                              ? (comp.Score >= 5 ? '#4caf50' : '#f44336')
                              : '#e0e0e0'
                          }))}
                          margin={{ top: 5, right: 30, left: 0, bottom: 40 }}
                        >
                          <CartesianGrid strokeDasharray="3 3" />
                          <XAxis 
                            dataKey="name" 
                            angle={-45}
                            textAnchor="end"
                            tick={{ fontSize: 10 }}
                            height={60}
                          />
                          <YAxis domain={[0, 10]} />
                          <RechartsTooltip />
                          <Legend />
                          <Bar dataKey="điểm" name="Điểm số">
                            {subject.components.map((comp, index) => (
                              <Cell 
                                key={`cell-${index}`} 
                                fill={comp.Score !== null && comp.Score !== undefined 
                                  ? (comp.Score >= 5 ? '#4caf50' : '#f44336')
                                  : '#e0e0e0'} 
                              />
                            ))}
                          </Bar>
                        </BarChart>
                      </ResponsiveContainer>
                    </Box>
                  </Box>
                )}
              </Card>
            </Grid>
          ))}
        </Grid>
      </Box>
    );
  };

  const renderDashboard = () => {
    const chartData = generateChartData(subjectGrades);
    const pieData = generatePieData(gradeStats);
    const overallGrade = generateOverallGrade(gradeStats);
    
    return (
      <Box>
        <Grid container spacing={3}>
          {/* Student semester statistics */}
          <Grid item xs={12} md={6}>
            <Card variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom>
                Tổng quan học kỳ
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Paper sx={{ p: 2, textAlign: 'center', bgcolor: 'background.default' }}>
                    <Typography variant="subtitle2" color="text.secondary">
                      Điểm trung bình
                    </Typography>
                    <Typography 
                      variant="h3" 
                      sx={{ 
                        mt: 1, 
                        fontWeight: 'bold',
                        color: overallGrade?.color || 'text.primary'
                      }}
                    >
                      {gradeStats?.average ? gradeStats.average.toFixed(1) : '-'}
                    </Typography>
                    {overallGrade && (
                      <Chip 
                        label={overallGrade.label} 
                        sx={{ 
                          mt: 1, 
                          backgroundColor: overallGrade.color,
                          color: '#fff',
                          fontWeight: 'bold'
                        }} 
                      />
                    )}
                  </Paper>
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <Paper sx={{ p: 2, textAlign: 'center', bgcolor: 'background.default' }}>
                    <Typography variant="subtitle2" color="text.secondary">
                      Tổng số môn học
                    </Typography>
                    <Typography variant="h3" sx={{ mt: 1, fontWeight: 'bold' }}>
                      {subjectGrades.length}
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                      {gradeStats?.count || 0} môn có điểm
                    </Typography>
                  </Paper>
                </Grid>
                
                <Grid item xs={6} sm={6}>
                  <Paper sx={{ p: 2, textAlign: 'center', bgcolor: 'background.default' }}>
                    <Typography variant="subtitle2" color="text.secondary">
                      Điểm cao nhất
                    </Typography>
                    <Typography 
                      variant="h4" 
                      sx={{ 
                        mt: 1, 
                        fontWeight: 'bold',
                        color: '#4caf50'
                      }}
                    >
                      {gradeStats?.highest ? gradeStats.highest.toFixed(1) : '-'}
                    </Typography>
                  </Paper>
                </Grid>
                
                <Grid item xs={6} sm={6}>
                  <Paper sx={{ p: 2, textAlign: 'center', bgcolor: 'background.default' }}>
                    <Typography variant="subtitle2" color="text.secondary">
                      Điểm thấp nhất
                    </Typography>
                    <Typography 
                      variant="h4" 
                      sx={{ 
                        mt: 1, 
                        fontWeight: 'bold',
                        color: gradeStats?.lowest < 5 ? '#f44336' : 'text.primary'
                      }}
                    >
                      {gradeStats?.lowest ? gradeStats.lowest.toFixed(1) : '-'}
                    </Typography>
                  </Paper>
                </Grid>
              </Grid>
            </Card>
          </Grid>
          
          {/* Grades chart */}
          <Grid item xs={12} md={6}>
            <Card variant="outlined" sx={{ p: 2, height: '100%' }}>
              <Typography variant="h6" gutterBottom>
                Biểu đồ điểm các môn học
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              {chartData.length > 0 ? (
                <Box sx={{ height: 300, width: '100%' }}>
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart
                      data={chartData}
                      margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="name" />
                      <YAxis domain={[0, 10]} />
                      <RechartsTooltip />
                      <Legend />
                      <Bar dataKey="điểm" name="Điểm trung bình">
                        {chartData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Bar>
                    </BarChart>
                  </ResponsiveContainer>
                </Box>
              ) : (
                <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: 300 }}>
                  <Typography variant="subtitle1" color="text.secondary">
                    Chưa có dữ liệu điểm
                  </Typography>
                </Box>
              )}
            </Card>
          </Grid>
          
          {/* Grade distribution */}
          <Grid item xs={12}>
            <Card variant="outlined" sx={{ p: 2 }}>
              <Typography variant="h6" gutterBottom>
                Phân bố điểm theo loại
              </Typography>
              <Divider sx={{ mb: 2 }} />
              
              <Grid container spacing={2}>
                {pieData.length > 0 ? (
                  <>
                    <Grid item xs={12} md={5}>
                      <Box sx={{ height: 260, width: '100%' }}>
                        <ResponsiveContainer width="100%" height="100%">
                          <PieChart>
                            <Pie
                              data={pieData}
                              cx="50%"
                              cy="50%"
                              innerRadius={60}
                              outerRadius={100}
                              paddingAngle={2}
                              dataKey="value"
                              label={({name, percent}) => `${name} ${(percent * 100).toFixed(0)}%`}
                            >
                              {pieData.map((entry, index) => (
                                <Cell key={`cell-${index}`} fill={entry.color} />
                              ))}
                            </Pie>
                            <RechartsTooltip />
                          </PieChart>
                        </ResponsiveContainer>
                      </Box>
                    </Grid>
                    
                    <Grid item xs={12} md={7}>
                      <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%', justifyContent: 'center' }}>
                        <Typography variant="subtitle1" gutterBottom>
                          Thang điểm đánh giá
                        </Typography>
                        
                        <Grid container spacing={1} sx={{ mt: 1 }}>
                          {Object.entries(GRADE_CATEGORIES).map(([key, category]) => (
                            <Grid item xs={12} sm={6} md={4} key={key}>
                              <Box 
                                sx={{ 
                                  p: 1, 
                                  borderRadius: 1, 
                                  border: 1, 
                                  borderColor: 'divider',
                                  display: 'flex',
                                  alignItems: 'center'
                                }}
                              >
                                <Box 
                                  sx={{ 
                                    width: 16, 
                                    height: 16, 
                                    bgcolor: category.color,
                                    borderRadius: '50%',
                                    mr: 1 
                                  }}
                                />
                                <Typography variant="body2">
                                  {category.label}: {category.range[0]} - {category.range[1]}
                                </Typography>
                              </Box>
                            </Grid>
                          ))}
                        </Grid>
                      </Box>
                    </Grid>
                  </>
                ) : (
                  <Grid item xs={12}>
                    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: 200 }}>
                      <Typography variant="subtitle1" color="text.secondary">
                        Chưa có dữ liệu điểm
                      </Typography>
                    </Box>
                  </Grid>
                )}
              </Grid>
            </Card>
          </Grid>
          
          {/* Subject summary table */}
          <Grid item xs={12}>
            <Card variant="outlined">
              <Box sx={{ p: 2 }}>
                <Typography variant="h6" gutterBottom>
                  Bảng điểm tổng hợp các môn học
                </Typography>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                  Nhấp vào tên môn học để xem chi tiết điểm thành phần
                </Typography>
              </Box>
              
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow sx={{ backgroundColor: '#f5f5f5' }}>
                      <TableCell width="40%" sx={{ fontWeight: 'bold' }}>Môn học</TableCell>
                      <TableCell width="15%" align="center" sx={{ fontWeight: 'bold' }}>Điểm trung bình</TableCell>
                      <TableCell width="25%" align="center" sx={{ fontWeight: 'bold' }}>Xếp loại</TableCell>
                      <TableCell width="20%" align="center" sx={{ fontWeight: 'bold' }}>Thao tác</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {subjectGrades.length === 0 ? (
                      <TableRow>
                        <TableCell colSpan={4} align="center">
                          <Typography variant="subtitle1" sx={{ py: 3 }}>
                            Chưa có dữ liệu điểm cho {activeSemester} {activeAcademicYear}
                          </Typography>
                        </TableCell>
                      </TableRow>
                    ) : (
                      subjectGrades.map((subject) => {
                        const gradeCategory = getGradeCategory(subject.finalGrade);
                        const hasComponents = subject.components && subject.components.length > 0;
                        
                        return (
                          <React.Fragment key={subject.subjectName}>
                            <TableRow 
                              hover
                              sx={{ 
                                cursor: hasComponents ? 'pointer' : 'default',
                                '&:hover': { bgcolor: hasComponents ? 'rgba(0, 0, 0, 0.04)' : 'inherit' }
                              }}
                              onClick={hasComponents ? () => toggleDetails(subject.subjectName) : undefined}
                            >
                              <TableCell>
                                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                  {hasComponents && (
                                    <IconButton 
                                      size="small" 
                                      sx={{ mr: 1 }}
                                      onClick={(e) => {
                                        e.stopPropagation();
                                        toggleDetails(subject.subjectName);
                                      }}
                                    >
                                      {showDetails[subject.subjectName] ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
                                    </IconButton>
                                  )}
                                  <Typography 
                                    variant="subtitle1"
                                    sx={{
                                      color: subject.subjectName.startsWith('Subject') ? 'warning.main' : 'inherit',
                                      display: 'flex',
                                      alignItems: 'center'
                                    }}
                                  >
                                    {subject.subjectName}
                                    {subject.subjectName.startsWith('Subject') && 
                                      <Tooltip title="Tên môn học chưa được đồng bộ đầy đủ">
                                        <InfoIcon fontSize="small" color="warning" sx={{ ml: 1 }} />
                                      </Tooltip>
                                    }
                                  </Typography>
                                </Box>
                              </TableCell>
                              <TableCell align="center">
                                <Typography 
                                  variant="h6" 
                                  sx={{ 
                                    fontWeight: 'bold',
                                    color: gradeCategory?.color || 'inherit'
                                  }}
                                >
                                  {subject.finalGrade !== null && subject.finalGrade !== undefined 
                                    ? formatScore(subject.finalGrade)
                                    : '-'}
                                </Typography>
                              </TableCell>
                              <TableCell align="center">
                                {gradeCategory ? (
                                  <Chip 
                                    label={gradeCategory.label} 
                                    sx={{ 
                                      backgroundColor: gradeCategory.color,
                                      color: '#fff',
                                      fontWeight: 'bold'
                                    }} 
                                  />
                                ) : (
                                  <Typography color="text.secondary">-</Typography>
                                )}
                              </TableCell>
                              <TableCell align="center">
                                <Button 
                                  variant="outlined" 
                                  size="small"
                                  disabled={!hasComponents}
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleSubjectSelect(subject);
                                  }}
                                >
                                  Xem chi tiết
                                </Button>
                              </TableCell>
                            </TableRow>
                            
                            {/* Expandable details */}
                            {showDetails[subject.subjectName] && hasComponents && (
                              <TableRow>
                                <TableCell colSpan={4} sx={{ py: 0, bgcolor: 'rgba(0, 0, 0, 0.02)' }}>
                                  <Box sx={{ py: 2, px: 2 }}>
                                    <Typography variant="subtitle2" gutterBottom>
                                      Điểm thành phần
                                    </Typography>
                                    
                                    <TableContainer component={Paper} variant="outlined">
                                      <Table size="small">
                                        <TableHead>
                                          <TableRow>
                                            <TableCell sx={{ fontWeight: 'bold' }}>Thành phần</TableCell>
                                            <TableCell align="center" sx={{ fontWeight: 'bold' }}>Hệ số</TableCell>
                                            <TableCell align="center" sx={{ fontWeight: 'bold' }}>Điểm số</TableCell>
                                          </TableRow>
                                        </TableHead>
                                        <TableBody>
                                          {subject.components.map((component) => (
                                            <TableRow key={component.key}>
                                              <TableCell>{component.ComponentName}</TableCell>
                                              <TableCell align="center">{component.Weight}</TableCell>
                                              <TableCell align="center">
                                                <Typography
                                                  sx={{
                                                    fontWeight: 'bold',
                                                    color: component.Score !== null && component.Score !== undefined 
                                                      ? (component.Score >= 5 ? '#4caf50' : '#f44336')
                                                      : 'inherit'
                                                  }}
                                                >
                                                  {formatScore(component.Score)}
                                                </Typography>
                                              </TableCell>
                                            </TableRow>
                                          ))}
                                          <TableRow sx={{ bgcolor: '#f0f8ff' }}>
                                            <TableCell colSpan={2} sx={{ fontWeight: 'bold' }}>
                                              Điểm tổng kết
                                            </TableCell>
                                            <TableCell align="center">
                                              <Typography 
                                                variant="subtitle1"
                                                sx={{ 
                                                  fontWeight: 'bold', 
                                                  color: gradeCategory?.color || 'inherit'
                                                }}
                                              >
                                                {subject.finalGrade !== null && subject.finalGrade !== undefined 
                                                  ? formatScore(subject.finalGrade)
                                                  : 'Chưa có'}
                                              </Typography>
                                            </TableCell>
                                          </TableRow>
                                        </TableBody>
                                      </Table>
                                    </TableContainer>
                                  </Box>
                                </TableCell>
                              </TableRow>
                            )}
                          </React.Fragment>
                        );
                      })
                    )}
                  </TableBody>
                </Table>
              </TableContainer>
            </Card>
          </Grid>
        </Grid>
      </Box>
    );
  };

  // Generate chart data
  const generateChartData = (subjects) => {
    return subjects.map(subject => ({
      name: subject.subjectName,
      điểm: subject.finalGrade || 0,
      color: subject.finalGrade ? getGradeCategory(subject.finalGrade)?.color : '#e0e0e0'
    }));
  };

  // Generate pie chart data for grade categories
  const generatePieData = (stats) => {
    if (!stats || !stats.categoryCounts) return [];
    
    return Object.entries(stats.categoryCounts).map(([category, count]) => ({
      name: GRADE_CATEGORIES[category].label,
      value: count,
      color: GRADE_CATEGORIES[category].color
    })).filter(item => item.value > 0);
  };

  return (
    <Container 
      style={{ padding: '24px' }}
      sx={{
        '@media print': {
          padding: 0,
          margin: 0
        }
      }}
    >
      <Box 
        sx={{ 
          display: 'flex', 
          justifyContent: 'space-between',
          mb: 3,
          '@media print': {
            display: 'none'
          }
        }}
      >
        <Breadcrumbs>
          <Link 
            component="button"
            variant="body1"
            onClick={() => navigate('/student/dashboard')}
            underline="hover"
          >
            Trang chủ
          </Link>
          <Typography color="textPrimary">Bảng điểm</Typography>
        </Breadcrumbs>
        
        <Box>
          <Button 
            variant="outlined" 
            startIcon={<PrintIcon />}
            onClick={handlePrint}
            sx={{ ml: 1 }}
          >
            In bảng điểm
          </Button>
        </Box>
      </Box>
      
      {/* Print header - only visible when printing */}
      <Box sx={{ display: 'none', '@media print': { display: 'block', mb: 3 } }}>
        <Typography variant="h4" align="center" gutterBottom>BÁO CÁO KẾT QUẢ HỌC TẬP</Typography>
        <Typography variant="h6" align="center" gutterBottom>
          Học kỳ: {activeSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'} • Năm học: {activeAcademicYear}
        </Typography>
        <Divider sx={{ my: 2 }} />
      </Box>
      
      {/* Display child selector for parents */}
      {isParent && (
        <Box mb={3}>
          <Card variant="outlined">
            <Box p={2}>
              <Typography variant="h6">Chọn học sinh</Typography>
              {loadingChildren ? (
                <Box display="flex" alignItems="center" mt={1}>
                  <CircularProgress size={24} />
                  <Typography variant="body2" sx={{ ml: 2 }}>
                    Đang tải danh sách học sinh...
                  </Typography>
                </Box>
              ) : children.length > 0 ? (
                <FormControl fullWidth margin="normal">
                  <InputLabel id="child-select-label">Học sinh</InputLabel>
                  <Select
                    labelId="child-select-label"
                    value={selectedChildId || ''}
                    label="Học sinh"
                    onChange={handleChildChange}
                  >
                    {children.map((child) => {
                      const childId = child.id || child.UserID || child.userId || child.ID;
                      const firstName = child.FirstName || child.firstname || '';
                      const lastName = child.LastName || child.lastname || '';
                      const fullName = child.name || child.fullName || child.username || `${firstName} ${lastName}`.trim() || 'Học sinh';
                      const className = child.className || child.ClassName || child.class_name || child.ClassID || '';
                      
                      return (
                        <MenuItem key={childId} value={childId}>
                          {fullName} {className ? `- ${className}` : ''}
                        </MenuItem>
                      );
                    })}
                  </Select>
                </FormControl>
              ) : (
                <Alert severity="info" sx={{ mt: 1 }}>
                  Không có thông tin học sinh. Vui lòng liên hệ quản trị viên.
                </Alert>
              )}
            </Box>
          </Card>
        </Box>
      )}
      
      {studentInfo && (
        <Box mb={3}>
          <Card variant="outlined" sx={{ '@media print': { boxShadow: 'none', border: 'none' } }}>
            <Box p={2}>
              <Typography variant="h5" gutterBottom>Thông tin học sinh</Typography>
              <Grid container spacing={2}>
                <Grid item xs={12} md={6}>
                  <Box display="flex" flexWrap="wrap">
                    <Box minWidth={300} mr={3}>
                      <Typography variant="body1"><strong>Họ và tên:</strong> {studentInfo.name}</Typography>
                      <Typography variant="body1"><strong>Mã học sinh:</strong> {studentInfo.studentId}</Typography>
                      <Typography variant="body1"><strong>Lớp:</strong> {studentInfo.className}</Typography>
                    </Box>
                    <Box minWidth={300}>
                      <Typography variant="body1">
                        <strong>Giới tính:</strong> {studentInfo.gender === 'MALE' ? 'Nam' : studentInfo.gender === 'FEMALE' ? 'Nữ' : '-'}
                      </Typography>
                      <Typography variant="body1">
                        <strong>Ngày sinh:</strong> {formatDate(studentInfo.dob)}
                      </Typography>
                      <Typography variant="body1"><strong>Khối:</strong> {studentInfo.classGrade}</Typography>
                    </Box>
                  </Box>
                </Grid>
                
                <Grid item xs={12} md={6}>
                  <Box 
                    sx={{ 
                      border: '1px dashed #ccc', 
                      borderRadius: 1, 
                      p: 2, 
                      display: 'flex', 
                      flexDirection: 'column',
                      alignItems: 'center',
                      justifyContent: 'center',
                      height: '100%',
                      '@media print': {
                        border: '1px solid #ccc'
                      }
                    }}
                  >
                    <Typography variant="subtitle1" align="center" gutterBottom>
                      <strong>Học kỳ:</strong> {activeSemester === 'HK1' ? 'Học kỳ 1' : 'Học kỳ 2'} • <strong>Năm học:</strong> {activeAcademicYear}
                    </Typography>
                    
                    {gradeStats && (
                      <Box sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <Typography variant="h6" sx={{ mr: 2 }}>
                          <strong>Điểm trung bình:</strong>
                        </Typography>
                        <Typography 
                          variant="h4" 
                          sx={{ 
                            fontWeight: 'bold',
                            color: generateOverallGrade(gradeStats)?.color || 'inherit'
                          }}
                        >
                          {gradeStats.average.toFixed(1)}
                        </Typography>
                        
                        {generateOverallGrade(gradeStats) && (
                          <Chip 
                            label={generateOverallGrade(gradeStats).label} 
                            sx={{ 
                              ml: 2,
                              backgroundColor: generateOverallGrade(gradeStats).color,
                              color: '#fff',
                              fontWeight: 'bold'
                            }} 
                          />
                        )}
                      </Box>
                    )}
                  </Box>
                </Grid>
              </Grid>
            </Box>
          </Card>
        </Box>
      )}
      
      <Box 
        sx={{ 
          mb: 3,
          '@media print': {
            display: 'none'
          }
        }}
      >
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
          <Tabs 
            value={activeTab} 
            onChange={handleTabChange}
            sx={{ borderBottom: 1, borderColor: 'divider', width: '100%' }}
          >
            <Tab label="Tổng quan" />
            <Tab label="Bảng điểm chi tiết" disabled={!subjectGrades.length} />
          </Tabs>
          
          <Box 
            sx={{ 
              display: 'flex', 
              alignItems: 'center',
              ml: 2
            }}
          >
            <FormControl variant="outlined" size="small" sx={{ width: 120, mr: 2 }}>
              <InputLabel id="semester-select-label">Học kỳ</InputLabel>
              <Select
                labelId="semester-select-label"
                value={activeSemester}
                onChange={handleSemesterChange}
                label="Học kỳ"
              >
                <MenuItem value="HK1">HK1</MenuItem>
                <MenuItem value="HK2">HK2</MenuItem>
              </Select>
            </FormControl>
            <FormControl variant="outlined" size="small" sx={{ width: 150 }}>
              <InputLabel id="academic-year-select-label">Năm học</InputLabel>
              <Select
                labelId="academic-year-select-label"
                value={activeAcademicYear}
                onChange={handleAcademicYearChange}
                label="Năm học"
              >
                <MenuItem value="2022-2023">2022-2023</MenuItem>
                <MenuItem value="2023-2024">2023-2024</MenuItem>
                <MenuItem value="2024-2025">2024-2025</MenuItem>
                <MenuItem value="2025-2026">2025-2026</MenuItem>
              </Select>
            </FormControl>
          </Box>
        </Box>
      </Box>
      
      {loading && !isParent ? (
        <Box display="flex" justifyContent="center" padding="50px">
          <CircularProgress size={60} />
          <Typography variant="h6" style={{ marginLeft: '16px' }}>
            Đang tải dữ liệu điểm số...
          </Typography>
        </Box>
      ) : (isParent && !selectedChildId) ? (
        <Box sx={{ mt: 3 }}>
          <Alert severity="info">
            Vui lòng chọn học sinh để xem bảng điểm.
          </Alert>
        </Box>
      ) : (
        <Box sx={{ mt: 3 }}>
          {activeTab === 0 && renderDashboard()}
          
          {activeTab === 1 && renderDetailedView()}
        </Box>
      )}
    </Container>
  );
};

export default StudentGradesViewPage; 