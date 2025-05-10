import React, { useState, useEffect } from 'react';
import {
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Box,
  Typography,
  CircularProgress,
  Alert,
  Button,
  Card,
  CardContent,
  InputAdornment,
  Chip,
  IconButton,
  Tooltip,
  Grid
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import RefreshIcon from '@mui/icons-material/Refresh';
import rewardPunishmentService from '../../services/rewardPunishmentService';

const RewardPunishmentList = ({ targetType, refreshTrigger, studentIdForView }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  // internalSearchId is for admin's manual search
  const [internalSearchId, setInternalSearchId] = useState(''); 
  
  const isViewOnlyMode = !!studentIdForView;
  // The ID displayed in the search box or used for fetching
  const effectiveId = isViewOnlyMode ? String(studentIdForView || '') : internalSearchId;

  // Hàm lấy tất cả khen thưởng kỷ luật
  const fetchAllData = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await rewardPunishmentService.getAllRewardPunishments();
      console.log("All rewards/punishments API response:", response);
      setData(response.data || []);
    } catch (err) {
      console.error("Error fetching all reward/punishment data:", err);
      const errorDetail = err.response?.data?.detail || err.message || 'Không thể tải dữ liệu';
      setError(`Lỗi: ${errorDetail}`);
      setData([]);
    } finally {
      setLoading(false);
    }
  };
  
  // Hàm lấy khen thưởng kỷ luật theo ID
  const fetchSpecificData = async (idToFetch) => {
    if (!idToFetch) {
      // If no ID is provided, show all data instead of clearing
      fetchAllData();
      return;
    }
    
    setLoading(true);
    setError('');
    try {
      let response;
      const studentId = parseInt(idToFetch, 10);
      
      if (isNaN(studentId)) {
        throw new Error("ID học sinh phải là số");
      }
      
      console.log(`Fetching data for ${targetType} with ID: ${studentId}`);
      
      // Sử dụng chung một endpoint cho tất cả vai trò - backend sẽ xử lý phân quyền
      if (targetType === 'student') {
        response = await rewardPunishmentService.getStudentRewardPunishments(studentId);
        // Process the nested data structure from the student endpoints
        if (response.data && Array.isArray(response.data)) {
          // Check if data has reward_punishment nested object structure
          if (response.data.length > 0 && response.data[0].reward_punishment) {
            // Unwrap the nested reward_punishment data
            const processedData = response.data.map(item => ({
              // Keep the original ID fields
              RecordID: item.RecordID,
              StudentRNPID: item.StudentRNPID,
              StudentID: item.StudentID,
              // Extract fields from nested reward_punishment object
              ...item.reward_punishment
            }));
            console.log("Processed unwrapped data:", processedData);
            setData(processedData);
            return; // Exit early since we've already set the data
          }
        }
      } else if (targetType === 'class') {
        response = await rewardPunishmentService.getClassRewardPunishments(studentId);
      } else {
        throw new Error("Invalid target type for fetching rewards/punishments.");
      }
      
      console.log("API response:", response);
      setData(response.data || []);
    } catch (err) {
      console.error("Error fetching reward/punishment data:", err);
      const errorDetail = err.response?.data?.detail || err.message || 'Không thể tải dữ liệu';
      console.error("Error detail:", errorDetail);
      
      // Cải thiện thông báo lỗi hiển thị cho người dùng
      if (errorDetail.includes("not found") || errorDetail.includes("404")) {
        setError(`Không tìm thấy ${targetType === 'student' ? 'học sinh' : 'lớp học'} với ID này`);
      } else if (errorDetail.includes("permission") || errorDetail.includes("403")) {
        setError(`Bạn không có quyền xem thông tin ${targetType === 'student' ? 'học sinh' : 'lớp học'} này`);
      } else {
        setError(`Lỗi: ${errorDetail}`);
      }
      
      setData([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // Nếu đang ở view-only mode (student hoặc parent), luôn fetch theo studentId
    if (isViewOnlyMode && studentIdForView) {
      fetchSpecificData(studentIdForView);
    } 
    // Otherwise, always load all data by default
    else {
      fetchAllData();
    }
  }, [studentIdForView, isViewOnlyMode, refreshTrigger, targetType]);

  const handleSearch = () => {
    if (!isViewOnlyMode && internalSearchId) {
      fetchSpecificData(internalSearchId);
    } else if (!isViewOnlyMode && !internalSearchId) {
      // If search field is cleared, show all data
      fetchAllData();
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !isViewOnlyMode) {
      handleSearch();
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    // Using toLocaleString for a more standard date-time format, adjust as needed
    return date.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' });
  };

  // Function to get the type display text
  const getTypeDisplayText = (typeValue) => {
    // Check all possible variations of type values for 'reward'
    const typeStr = String(typeValue || '').toLowerCase();
    return typeStr === 'reward' ? 'Khen thưởng' : 'Kỷ luật';
  };

  const getTypeIcon = (typeValue) => {
    const typeStr = String(typeValue || '').toLowerCase();
    return typeStr === 'reward' ? <RewardIcon /> : <PunishmentIcon />;
  }

  const getTypeColor = (typeValue) => {
    const typeStr = String(typeValue || '').toLowerCase();
    return typeStr === 'reward' ? 'success' : 'error'; 
  }

  return (
    <Box sx={{ width: '100%' }}>
      {!isViewOnlyMode && (
        <Paper sx={{ 
          mb: 3,
          p: 2, 
          display: 'flex',
          alignItems: 'center',
          flexWrap: 'wrap',
          gap: 2,
          borderBottom: '1px solid #e0e0e0',
        }}>
          <Grid container spacing={2} alignItems="center">
            <Grid item xs={12} md={5}>
              <TextField
                label={`ID ${targetType === 'student' ? 'Học sinh' : 'Lớp học'} (không bắt buộc)`}
                value={internalSearchId}
                onChange={(e) => setInternalSearchId(e.target.value)}
                onKeyPress={handleKeyPress}
                type="number"
                size="small"
                fullWidth
                disabled={isViewOnlyMode}
                placeholder="Để trống để xem tất cả"
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <SearchIcon />
                    </InputAdornment>
                  ),
                }}
              />
            </Grid>
            <Grid item xs={6} md={2}>
              <Button
                variant="contained"
                fullWidth
                onClick={handleSearch}
                disabled={isViewOnlyMode}
              >
                Tìm kiếm
              </Button>
            </Grid>
            <Grid item xs={6} md={1}>
              <Tooltip title="Làm mới dữ liệu">
                <IconButton 
                  color="primary" 
                  onClick={fetchAllData}
                >
                  <RefreshIcon />
                </IconButton>
              </Tooltip>
            </Grid>
            <Grid item xs={12} md={4} textAlign="right">
              <Typography variant="subtitle2" color="text.secondary">
                Tổng số bản ghi: <strong>{data.length}</strong>
              </Typography>
            </Grid>
          </Grid>
        </Paper>
      )}

      {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
      
      {loading ? (
        <Box sx={{ display: 'flex', justifyContent: 'center', my: 3 }}>
          <CircularProgress />
        </Box>
      ) : data.length > 0 ? (
        <TableContainer component={Paper} sx={{ mt: 2, overflowX: 'auto' }}>
          <Table sx={{ minWidth: 900 }}>
            <TableHead>
              <TableRow sx={{ backgroundColor: '#f5f5f5' }}>
                <TableCell align="center" width="5%">ID</TableCell>
                <TableCell width="20%">Tiêu đề</TableCell>
                <TableCell align="center" width="10%">Loại</TableCell>
                <TableCell width="15%">Ngày</TableCell>
                <TableCell width="10%">Học kỳ</TableCell>
                <TableCell align="center" width="5%">Tuần</TableCell>
                <TableCell width="25%">Mô tả</TableCell>
                <TableCell align="center" width="10%">Học sinh ID</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {data.map((item) => (
                <TableRow 
                  key={item.RecordID || item.RewardPunishmentID || item.id}
                  sx={{ '&:nth-of-type(odd)': { backgroundColor: '#fafafa' } }}
                >
                  <TableCell align="center">{item.RecordID || item.RewardPunishmentID || item.id}</TableCell>
                  <TableCell>{item.Title || item.title || ''}</TableCell>
                  <TableCell align="center">
                    <Chip
                      label={getTypeDisplayText(item.Type || item.type)}
                      color={(item.Type || item.type || '').toLowerCase() === 'reward' ? 'success' : 'error'}
                      size="small"
                      variant="outlined"
                    />
                  </TableCell>
                  <TableCell>{formatDate(item.Date || item.date)}</TableCell>
                  <TableCell>{item.Semester || item.semester || ''}</TableCell>
                  <TableCell align="center">{item.Week || item.week || ''}</TableCell>
                  <TableCell>{item.Description || item.description || ''}</TableCell>
                  <TableCell align="center">{item.StudentID || item.student_id || ''}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      ) : (
        <Typography variant="body1" color="text.secondary" align="center" sx={{ my: 3 }}>
          {isViewOnlyMode ? 'Không có dữ liệu khen thưởng/kỷ luật.' : effectiveId ? 'Không tìm thấy dữ liệu khen thưởng/kỷ luật.' : 'Không có dữ liệu khen thưởng/kỷ luật nào trong hệ thống.'}
        </Typography>
      )}
    </Box>
  );
};

export default RewardPunishmentList;