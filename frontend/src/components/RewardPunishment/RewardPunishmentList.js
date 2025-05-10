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
  // IconButton // Not used in provided snippet
} from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
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

  const fetchData = async (idToFetch) => {
    if (!idToFetch) {
      setData([]);
      if (isViewOnlyMode) setError('Chưa có ID học sinh để xem.');
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
      
      // Nếu đang trong view-only mode (student/parent), sử dụng API view riêng
      if (isViewOnlyMode && targetType === 'student') {
        response = await rewardPunishmentService.viewStudentRewardPunishments(studentId);
      } 
      // Nếu admin/teacher đang tìm kiếm
      else if (targetType === 'student') {
        response = await rewardPunishmentService.getStudentRewardPunishments(studentId);
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
      if (errorDetail.includes("not found")) {
        setError(`Không tìm thấy ${targetType === 'student' ? 'học sinh' : 'lớp học'} với ID này`);
      } else {
        setError(`Lỗi: ${errorDetail}`);
      }
      
      setData([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const idToUse = isViewOnlyMode ? studentIdForView : internalSearchId;
    if (idToUse) {
      fetchData(idToUse);
    } else {
      setData([]); // Clear data if no ID is applicable
      if (!isViewOnlyMode) setError(''); // Clear error for admin if search is empty
    }
  // Fetch when the effective ID changes (studentIdForView, internalSearchId) or when refresh is triggered.
  // Also re-fetch if targetType changes (though less likely in this specific page flow).
  }, [studentIdForView, internalSearchId, isViewOnlyMode, refreshTrigger, targetType]);


  const handleAdminSearch = () => {
    if (!isViewOnlyMode && internalSearchId) {
      // Fetch is handled by the useEffect when internalSearchId changes
      // This button click primarily ensures internalSearchId is set if user types and clicks
      // For explicit re-fetch on button click even if ID hasn't changed, call fetchData here:
       fetchData(internalSearchId);
    }
  };

  const handleAdminKeyPress = (e) => {
    if (e.key === 'Enter' && !isViewOnlyMode) {
      handleAdminSearch();
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    // Using toLocaleString for a more standard date-time format, adjust as needed
    return date.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' });
  };

  return (
    <Box>
      {!isViewOnlyMode && (
        <Box sx={{ mb: 3, display: 'flex', alignItems: 'center' }}>
          <TextField
            label={`ID ${targetType === 'student' ? 'Học sinh' : 'Lớp học'}`}
            value={internalSearchId}
            onChange={(e) => setInternalSearchId(e.target.value)}
            onKeyPress={handleAdminKeyPress}
            type="number"
            size="small"
            sx={{ mr: 2 }}
            disabled={isViewOnlyMode}
          />
          <Button
            variant="contained"
            onClick={handleAdminSearch}
            startIcon={<SearchIcon />}
            disabled={isViewOnlyMode || !internalSearchId}
          >
            Tìm kiếm
          </Button>
        </Box>
      )}

      {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
      
      {loading ? (
        <Box sx={{ display: 'flex', justifyContent: 'center', my: 3 }}>
          <CircularProgress />
        </Box>
      ) : data.length > 0 ? (
        <TableContainer component={Paper}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>ID Khen thưởng/Kỷ luật</TableCell>
                <TableCell>Tiêu đề</TableCell>
                <TableCell>Loại</TableCell>
                <TableCell>Ngày</TableCell>
                <TableCell>Học kỳ</TableCell>
                <TableCell>Tuần</TableCell>
                <TableCell>Mô tả</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {data.map((item) => (
                // The structure of 'item' might be directly RewardPunishment data
                // or nested like item.reward_punishment depending on the API response.
                // Assuming StudentRNPRead and ClassRNPRead schemas return a flat structure
                // or you adjust accessors like item.Title, item.Type etc.
                // The existing code uses item.reward_punishment?.Title, so let's keep that pattern
                // if your schemas StudentRNPRead/ClassRNPRead have a nested 'reward_punishment' field.
                // If not, it should be item.Title, item.Type etc.
                // For this example, I'll assume the API returns a list of objects where
                // reward/punishment details are directly on the item or nested under `reward_punishment`.
                // Let's assume the API for /student/{student_id} returns List[schemas.RewardPunishment]
                // or schemas.StudentRNPRead which directly contains the fields.
                // If StudentRNPRead is { RecordID: int, reward_punishment: schemas.RewardPunishmentBase }
                // then item.reward_punishment.Title is correct.
                // If StudentRNPRead is schemas.RewardPunishment itself, then item.Title is correct.
                // Given the original code, I'll stick to item.reward_punishment?.
                 <TableRow key={item.RecordID || item.RewardPunishmentID}> {/* Use a unique key */}
                  <TableCell>{item.RecordID || item.RewardPunishmentID}</TableCell>
                  <TableCell>{item.reward_punishment?.Title || item.Title}</TableCell>
                  <TableCell>
                    {(item.reward_punishment?.Type || item.Type) === 'REWARD' ? 'Khen thưởng' : 'Kỷ luật'}
                  </TableCell>
                  <TableCell>{formatDate(item.reward_punishment?.Date || item.Date)}</TableCell>
                  <TableCell>{item.reward_punishment?.Semester || item.Semester}</TableCell>
                  <TableCell>{item.reward_punishment?.Week || item.Week}</TableCell>
                  <TableCell>{item.reward_punishment?.Description || item.Description}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      ) : effectiveId || isViewOnlyMode ? ( // If an ID was searched/provided but no data
        <Typography variant="body1" color="text.secondary" align="center" sx={{ my: 3 }}>
          Không tìm thấy dữ liệu khen thưởng/kỷ luật nào.
        </Typography>
      ) : ( // Admin view, no search ID entered yet
        <Typography variant="body1" color="text.secondary" align="center" sx={{ my: 3 }}>
          {isViewOnlyMode ? 'Đang tải hoặc không có dữ liệu.' : `Nhập ID ${targetType === 'student' ? 'học sinh' : 'lớp học'} để xem danh sách khen thưởng/kỷ luật.`}
        </Typography>
      )}
    </Box>
  );
};

export default RewardPunishmentList;