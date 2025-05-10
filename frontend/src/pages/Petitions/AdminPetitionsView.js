import React, { useState, useEffect } from "react";
import {
  Container,
  Typography,
  Box,
  CircularProgress,
  Alert,
  Snackbar,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Grid,
  Pagination,
  Card,
  CardContent,
  IconButton,
  Tooltip,
} from "@mui/material";
import DescriptionIcon from "@mui/icons-material/Description";
import AttachFileIcon from '@mui/icons-material/AttachFile';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import petitionService from "../../services/petitionService"; // Giữ lại import service

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

// Component này nhận userId (của admin) từ props
const AdminPetitionsView = ({ userId, readOnly = false }) => {
  const [loadingPetitions, setLoadingPetitions] = useState(true);
  const [loadingStats, setLoadingStats] = useState(true);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState(null);
  const [petitions, setPetitions] = useState([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [size, setSize] = useState(10);
  const [openSnackbar, setOpenSnackbar] = useState(false);
  const [openDetailsDialog, setOpenDetailsDialog] = useState(false);
  const [selectedPetition, setSelectedPetition] = useState(null);
  const [detailsError, setDetailsError] = useState(null);
  const [openStatusDialog, setOpenStatusDialog] = useState(false);
  const [selectedPetitionId, setSelectedPetitionId] = useState(null);
  const [newStatus, setNewStatus] = useState("");
  const [response, setResponse] = useState("");
  const [statusUpdateError, setStatusUpdateError] = useState(null);
  const [filters, setFilters] = useState({ Status: "" });
  const [statistics, setStatistics] = useState({ PENDING: 0, APPROVED: 0, REJECTED: 0 });

  // --- Helper Functions ---
    const formatDate = (isoString) => {
      if (!isoString) return "N/A";
      try {
        const date = new Date(isoString);
        const pad = (num) => String(num).padStart(2, "0");
        return `${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()}`;
      } catch { return "N/A"; }
    };

    const formatTime = (isoString) => {
        if (!isoString) return "N/A";
        try {
          const date = new Date(isoString);
          const pad = (num) => String(num).padStart(2, "0");
          return `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
        } catch { return "N/A"; }
      };

    const handleSnackbarClose = (event, reason) => {
      if (reason === "clickaway") return;
      setOpenSnackbar(false);
      setSuccessMessage(null);
    };

  // --- Data Fetching ---
  const fetchPetitions = async () => {
    setLoadingPetitions(true);
    setError(null); // Reset lỗi chung trước khi fetch
    try {
      console.log("Admin fetching petitions with filters:", filters, `page: ${page}, size: ${size}`);
      const response = await petitionService.getAllPetitions(
        {
          status: filters.Status || undefined, // Gửi undefined nếu rỗng
        },
        page,
        size
      );
      console.log("Admin Petitions response:", response);
      setPetitions(response.items || []);
      setTotal(response.total || 0);
    } catch (error) {
      console.error("Error fetching all petitions:", error);
      setError("Không thể tải danh sách đơn thỉnh cầu.");
      setPetitions([]);
      setTotal(0);
    } finally {
      setLoadingPetitions(false);
    }
  };

  const fetchStatistics = async () => {
    setLoadingStats(true);
    try {
      console.log("Admin fetching statistics");
      const stats = await petitionService.getPetitionStatistics();
      console.log("Statistics response:", stats);
      setStatistics(stats);
    } catch (error) {
      console.error("Error fetching statistics:", error);
      setError((prevError) => prevError || "Không thể tải thống kê đơn.");
    } finally {
      setLoadingStats(false);
    }
  };

  useEffect(() => {
    fetchPetitions();
    fetchStatistics();
  }, [page, size, filters]); // Fetch lại khi page, size hoặc filters thay đổi

  // --- Event Handlers ---
  const handlePageChange = (event, newPage) => {
    console.log("Admin changing page to:", newPage);
    setPage(newPage);
  };

  const handleFilterChange = (newFilters) => {
    setError(null); // Clear any previous error messages
    console.log("Admin updating filters:", newFilters);
    setFilters(newFilters);
    setPage(1); // Reset về trang 1 khi thay đổi bộ lọc
  };

  const handleResetFilters = () => {
    setError(null); // Clear any previous error messages
    handleFilterChange({ Status: "" });
  };

   const fetchPetitionDetails = async (petitionId) => {
     setDetailsError(null);
     setSelectedPetition(null); // Clear old data while loading
     setOpenDetailsDialog(true);
     try {
       const petition = await petitionService.getPetitionById(petitionId);
       setSelectedPetition(petition);
     } catch (err) {
       console.error("Error fetching petition details:", err);
       setDetailsError("Không thể tải chi tiết đơn thỉnh cầu.");
     }
   };

   const handleDetailsDialogClose = () => {
     setOpenDetailsDialog(false);
     setSelectedPetition(null);
     setDetailsError(null);
   };

  const handleOpenStatusDialog = (petitionId) => {
    setSelectedPetitionId(petitionId);
    setNewStatus(""); // Reset form
    setResponse("");
    setStatusUpdateError(null); // Reset lỗi dialog cũ
    setOpenStatusDialog(true);
  };

  const handleStatusDialogClose = () => {
    setOpenStatusDialog(false);
    setSelectedPetitionId(null);
    setNewStatus("");
    setResponse("");
    setStatusUpdateError(null);
  };

  const handleStatusDialogConfirm = async () => {
    if (!newStatus) {
      setStatusUpdateError("Vui lòng chọn trạng thái mới.");
      return;
    }
    setStatusUpdateError(null); // Clear error

    try {
       const updateData = {
            Status: newStatus,
            Response: response || null, // Gửi null nếu response rỗng
            AdminID: userId, // Sử dụng userId (của admin) từ props
        };
      console.log("Admin updating petition:", { petitionId: selectedPetitionId, updateData });
      await petitionService.updatePetitionStatus(selectedPetitionId, updateData);
      handleStatusDialogClose();
      setSuccessMessage("Cập nhật trạng thái thành công!");
      setOpenSnackbar(true);
      // Tải lại cả petitions và statistics
      fetchPetitions();
      fetchStatistics();
    } catch (err) {
      console.error("Error updating petition status:", err);
      const apiError = err.response?.data?.message || "Lỗi khi cập nhật trạng thái. Vui lòng thử lại.";
      setStatusUpdateError(apiError); // Hiển thị lỗi trong dialog
    }
  };

  // --- Render Logic ---
  const isLoading = loadingPetitions || loadingStats;

  return (
    <Container maxWidth="xl" sx={{ py: 4 }}> {/* Sử dụng maxWidth rộng hơn */}
      <Typography variant="h4" component="h1" gutterBottom>
        Quản lý đơn thỉnh cầu
      </Typography>

      {/* Statistics */}
      <Box mb={4}>
        <Typography variant="h6" gutterBottom>
          Thống kê đơn thỉnh cầu {isLoading && <CircularProgress size={20} sx={{ ml: 1 }} />}
        </Typography>
        <Grid container spacing={2}>
          {/* Card Đang chờ */}
          <Grid item xs={12} sm={4}>
            <Card>
              <CardContent>
                <Typography variant="h6" color="warning.main">Đang chờ</Typography>
                <Typography variant="h4">{loadingStats ? <CircularProgress size={30}/> : statistics.PENDING}</Typography>
              </CardContent>
            </Card>
          </Grid>
          {/* Card Đã duyệt */}
          <Grid item xs={12} sm={4}>
             <Card>
               <CardContent>
                 <Typography variant="h6" color="success.main">Đã duyệt</Typography>
                 <Typography variant="h4">{loadingStats ? <CircularProgress size={30}/> : statistics.APPROVED}</Typography>
               </CardContent>
             </Card>
           </Grid>
          {/* Card Từ chối */}
           <Grid item xs={12} sm={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6" color="error.main">Từ chối</Typography>
                  <Typography variant="h4">{loadingStats ? <CircularProgress size={30}/> : statistics.REJECTED}</Typography>
                </CardContent>
              </Card>
            </Grid>
        </Grid>
      </Box>

        {/* Hiển thị lỗi chung (fetch, filter validation) */}
        {error && (
             <Box mb={3}>
               <Alert severity="error" onClose={() => setError(null)}>{error}</Alert>
             </Box>
           )}


      {/* Filters */}
      <Paper sx={{ p: 2, mb: 4 }}>
        <Typography variant="h6" gutterBottom>Bộ lọc</Typography>
        <Grid container spacing={2} alignItems="center">
         <Grid item sx={{ width: '150px' }}>
            <FormControl fullWidth size="small">
              <InputLabel shrink>Trạng thái</InputLabel>
              <Select
                value={filters.Status}
                label="Trạng thái"
                onChange={(e) => handleFilterChange({ ...filters, Status: e.target.value })}
                disabled={isLoading}
                displayEmpty
                renderValue={(selected) => {
                  if (!selected) return "Tất cả";
                  if (selected === "PENDING") return "Đang chờ";
                  if (selected === "APPROVED") return "Đã duyệt";
                  if (selected === "REJECTED") return "Từ chối";
                  return selected;
                }}
              >
                <MenuItem value="">Tất cả</MenuItem>
                <MenuItem value="PENDING">Đang chờ</MenuItem>
                <MenuItem value="APPROVED">Đã duyệt</MenuItem>
                <MenuItem value="REJECTED">Từ chối</MenuItem>
              </Select>
            </FormControl>
          </Grid>
          {/* <Grid item xs={12} sm={6} md={3}>
            <Button
              variant="outlined"
              fullWidth
              onClick={handleResetFilters}
               disabled={isLoading}
               sx={{ height: '40px' }} // Match height of small TextField
            >
              Làm mới bộ lọc
            </Button>
          </Grid> */}
        </Grid>
      </Paper>

       {loadingPetitions && ( // Hiển thị loading indicator cho bảng
           <Box display="flex" justifyContent="center" my={3}><CircularProgress /></Box>
       )}

      {/* Table */}
      {!loadingPetitions && ( // Chỉ hiển thị bảng khi không loading
          <>
          <TableContainer component={Paper}>
            <Table stickyHeader sx={{ tableLayout: "fixed" }}> {/* Fixed layout để cột đều hơn */}
              <TableHead>
                <TableRow>
                  <TableCell sx={{ width: '5%', minWidth: 60 }}>ID</TableCell>
                  <TableCell sx={{ width: '15%', minWidth: 150 }}>Tiêu đề</TableCell>
                  <TableCell sx={{ width: '15%', minWidth: 180 }}>Phụ huynh</TableCell>
                  <TableCell sx={{ width: '15%', minWidth: 180 }}>Email</TableCell>
                  <TableCell sx={{ width: '10%', minWidth: 110 }}>Trạng thái</TableCell>
                  <TableCell sx={{ width: '10%', minWidth: 100 }}>Thời gian</TableCell>
                  <TableCell sx={{ width: '10%', minWidth: 110 }}>Ngày tạo</TableCell>
                  {!readOnly && (
                    <TableCell sx={{ width: '10%', minWidth: 110 }}>Thao tác</TableCell>
                  )}
                  <TableCell sx={{ width: '10%', minWidth: 90 }}>Chi tiết</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {petitions.length === 0 ? (
                     <TableRow>
                        <TableCell colSpan={readOnly ? 8 : 9} align="center">Không tìm thấy đơn thỉnh cầu nào khớp với bộ lọc.</TableCell>
                     </TableRow>
                ) : (
                    petitions.map((petition) => (
                      <TableRow hover key={petition.PetitionID}>
                        <TableCell>{petition.PetitionID}</TableCell>
                        <TableCell sx={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                          <Tooltip title={petition.Title || "N/A"} placement="top-start">
                            <span>{petition.Title || "N/A"}</span>
                          </Tooltip>
                        </TableCell>
                         <TableCell sx={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                          <Tooltip title={petition.parent ? `${petition.parent.FirstName} ${petition.parent.LastName}` : "N/A"} placement="top-start">
                            <span>{petition.parent ? `${petition.parent.FirstName} ${petition.parent.LastName}` : "N/A"}</span>
                          </Tooltip>
                        </TableCell>
                         <TableCell sx={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                            <Tooltip title={petition.parent?.Email || "N/A"} placement="top-start">
                              <span>{petition.parent?.Email || "N/A"}</span>
                           </Tooltip>
                         </TableCell>
                        <TableCell>
                          <Chip
                            label={petition.Status}
                            size="small"
                            color={
                              petition.Status === "PENDING" ? "warning"
                              : petition.Status === "APPROVED" ? "success"
                              : "error"
                            }
                          />
                        </TableCell>
                        <TableCell>{formatTime(petition.SubmittedAt)}</TableCell>
                        <TableCell>{formatDate(petition.SubmittedAt)}</TableCell>
                        {!readOnly && (
                          <TableCell>
                            {petition.Status === "PENDING" && (
                              <Button
                                variant="contained"
                                color="primary"
                                size="small"
                                onClick={() => handleOpenStatusDialog(petition.PetitionID)}
                                sx={{ whiteSpace: "nowrap" }}
                              >
                                Cập nhật
                              </Button>
                            )}
                             {/* Có thể thêm nút khác ở đây nếu cần */}
                          </TableCell>
                        )}
                         <TableCell>
                             <Tooltip title="Xem chi tiết">
                               <IconButton
                                 color="primary"
                                 size="small"
                                 onClick={() => fetchPetitionDetails(petition.PetitionID)}
                               >
                                 <DescriptionIcon />
                               </IconButton>
                             </Tooltip>
                         </TableCell>
                      </TableRow>
                    ))
                )}
              </TableBody>
            </Table>
          </TableContainer>

           {total > size && (
               <Box display="flex" justifyContent="center" mt={3}>
                 <Pagination
                   count={Math.ceil(total / size)}
                   page={page}
                   onChange={handlePageChange}
                   color="primary"
                    disabled={loadingPetitions}
                 />
               </Box>
           )}
           </>
      )}


      {/* Dialog Cập nhật trạng thái */}
      <Dialog open={openStatusDialog} onClose={handleStatusDialogClose} fullWidth maxWidth="sm">
        <DialogTitle>Cập nhật trạng thái đơn #{selectedPetitionId}</DialogTitle>
        <DialogContent>
         {/* Hiển thị lỗi trong dialog cập nhật */}
          {statusUpdateError && (
            <Alert severity="error" sx={{ mb: 2 }}>{statusUpdateError}</Alert>
          )}
          <FormControl fullWidth sx={{ mt: 1 }}>
            <InputLabel id="status-select-label">Trạng thái mới *</InputLabel>
            <Select
                labelId="status-select-label"
              value={newStatus}
              onChange={(e) => setNewStatus(e.target.value)}
              label="Trạng thái mới *"
               error={!!statusUpdateError && !newStatus}
            >
              <MenuItem value="APPROVED">Duyệt (Approved)</MenuItem>
              <MenuItem value="REJECTED">Từ chối (Rejected)</MenuItem>
            </Select>
             {!!statusUpdateError && !newStatus && <Typography color="error" variant="caption">Vui lòng chọn trạng thái</Typography>}
          </FormControl>
          <TextField
            margin="dense"
            label="Phản hồi (tùy chọn)"
            fullWidth
            multiline
            rows={4}
            value={response}
            onChange={(e) => setResponse(e.target.value)}
            sx={{ mt: 2 }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleStatusDialogClose}>Hủy</Button>
          <Button
            onClick={handleStatusDialogConfirm}
            color="primary"
            variant="contained"
            disabled={!newStatus} // Disable nút nếu chưa chọn trạng thái
          >
            Xác nhận
          </Button>
        </DialogActions>
      </Dialog>

       {/* Dialog Chi tiết đơn */}
      <Dialog open={openDetailsDialog} onClose={handleDetailsDialogClose} maxWidth="md" fullWidth>
          <DialogTitle>Chi tiết đơn thỉnh cầu #{selectedPetition?.PetitionID}</DialogTitle>
          <DialogContent>
            {detailsError ? (
              <Alert severity="error">{detailsError}</Alert>
            ) : selectedPetition ? (
               <Box sx={{ display: "flex", flexDirection: "column", gap: 2, mt: 1 }}>
                 {/* Thêm thông tin phụ huynh nếu có */}
                 <TextField label="Người gửi (Phụ huynh)" value={selectedPetition.parent ? `${selectedPetition.parent.FirstName} ${selectedPetition.parent.LastName} (${selectedPetition.parent.Email})` : "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Tiêu đề" value={selectedPetition.Title || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Nội dung" value={selectedPetition.Content || "N/A"} fullWidth multiline rows={4} InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Trạng thái" value={selectedPetition.Status || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Ngày tạo" value={formatDate(selectedPetition.SubmittedAt) || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Thời gian tạo" value={formatTime(selectedPetition.SubmittedAt) || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 <TextField label="Phản hồi (Admin)" value={selectedPetition.Response || "Chưa có phản hồi"} fullWidth multiline rows={2} InputProps={{ readOnly: true }} variant="outlined"/>
                 {/* Hiển thị file đính kèm nếu có */}
                 {selectedPetition.petition_files && selectedPetition.petition_files.length > 0 && (
                   <Box>
                     <Typography variant="subtitle2" sx={{ mb: 1 }}>File đính kèm:</Typography>
                     <List dense sx={{ pl: 1 }}>
                       {selectedPetition.petition_files.map((file, idx) => (
                         <ListItem key={idx} disablePadding>
                           <ListItemIcon sx={{ minWidth: 32 }}>
                             <AttachFileIcon color="primary" />
                           </ListItemIcon>
                           <ListItemText
                             primary={
                               <a
                                 href={`${API_URL}${file.FileUrl}`}
                                 target="_blank"
                                 rel="noopener noreferrer"
                                 style={{
                                   color: '#1976d2',
                                   textDecoration: 'underline',
                                   fontWeight: 500,
                                   cursor: 'pointer',
                                 }}
                               >
                                 {file.FileName}
                               </a>
                             }
                           />
                         </ListItem>
                       ))}
                     </List>
                   </Box>
                 )}
                 {/* Thêm thông tin người xử lý nếu có */}
                 {selectedPetition.admin && (
                    <TextField label="Người xử lý (Admin)" value={`${selectedPetition.admin.FirstName} ${selectedPetition.admin.LastName} (${selectedPetition.admin.Email})` || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 )}
                 {selectedPetition.ReviewedAt && (
                     <TextField label="Thời gian xử lý" value={`${formatTime(selectedPetition.ReviewedAt)} - ${formatDate(selectedPetition.ReviewedAt)}` || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
                 )}
               </Box>
            ) : (
             <Box display="flex" justifyContent="center" my={3}><CircularProgress /></Box>
            )}
          </DialogContent>
          <DialogActions>
            <Button onClick={handleDetailsDialogClose}>Đóng</Button>
          </DialogActions>
        </Dialog>

      {/* Snackbar Thông báo thành công */}
      <Snackbar
        open={openSnackbar}
        autoHideDuration={4000}
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: "top", horizontal: "center" }}
      >
        <Alert onClose={handleSnackbarClose} severity="success" variant="filled" sx={{ width: '100%' }}>
          {successMessage}
        </Alert>
      </Snackbar>
    </Container>
  );
};

export default AdminPetitionsView;