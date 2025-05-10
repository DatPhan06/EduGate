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
  Pagination,
  IconButton,
} from "@mui/material";
import DescriptionIcon from "@mui/icons-material/Description";
import petitionService from "../../services/petitionService"; // Giữ lại import service

// Component này nhận userId từ props
const ParentPetitionsView = ({ userId }) => {
  const [loading, setLoading] = useState(true); // Loading riêng cho fetch petitions
  const [error, setError] = useState(null);     // Error riêng cho fetch/create petitions
  const [successMessage, setSuccessMessage] = useState(null); // Thông báo thành công
  const [petitions, setPetitions] = useState([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [size, setSize] = useState(10);
  const [openSnackbar, setOpenSnackbar] = useState(false);
  const [openDetailsDialog, setOpenDetailsDialog] = useState(false);
  const [selectedPetition, setSelectedPetition] = useState(null);
  const [detailsError, setDetailsError] = useState(null);
  const [openDialog, setOpenDialog] = useState(false); // Dialog tạo đơn
  const [newPetition, setNewPetition] = useState({ Title: "", Content: "" });

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
    setSuccessMessage(null); // Reset message khi đóng snackbar
  };

  // --- Data Fetching ---
  const fetchPetitions = async () => {
    if (!userId) return; // Không fetch nếu chưa có userId
    setLoading(true);
    setError(null);
    try {
      console.log(`Parent fetching petitions for userId: ${userId}, page: ${page}, size: ${size}`);
      const response = await petitionService.getParentPetitions(userId, page, size);
      console.log("Parent Petitions response:", response);
      setPetitions(response.items || []);
      setTotal(response.total || 0);
    } catch (error) {
      console.error("Error fetching parent petitions:", error);
      setError("Không thể tải danh sách đơn thỉnh cầu của bạn.");
      setPetitions([]); // Reset data nếu lỗi
      setTotal(0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPetitions();
  }, [userId, page, size]); // Fetch lại khi userId, page hoặc size thay đổi

  // --- Event Handlers ---
  const handlePageChange = (event, newPage) => {
    console.log("Parent changing page to:", newPage);
    setPage(newPage);
  };

  const handleOpenCreateDialog = () => {
    setNewPetition({ Title: "", Content: "" }); // Reset form
    setError(null); // Xóa lỗi cũ (nếu có từ lần trước)
    setOpenDialog(true);
  };

  const handleCloseCreateDialog = () => {
    setOpenDialog(false);
  };

  const handleCreatePetition = async () => {
    if (!newPetition.Title || !newPetition.Content) {
        setError("Vui lòng nhập Tiêu đề và Nội dung.");
        return;
    }
    setError(null); // Xóa lỗi hiển thị
    try {
      console.log("Parent creating petition:", newPetition);
      await petitionService.createPetition({
        ...newPetition,
        ParentID: userId, // Sử dụng userId từ props
      });
      handleCloseCreateDialog();
      setSuccessMessage("Tạo đơn thỉnh cầu thành công!");
      setOpenSnackbar(true);
      setPage(1); // Quay về trang 1 để xem đơn mới nhất
      fetchPetitions(); // Tải lại danh sách
    } catch (error) {
      console.error("Error creating petition:", error);
      // Hiển thị lỗi cụ thể hơn nếu có từ API, nếu không thì báo lỗi chung
      const apiError = error.response?.data?.message || "Không thể tạo đơn thỉnh cầu. Vui lòng thử lại.";
      setError(apiError);
       // Không đóng dialog khi lỗi để người dùng sửa
    }
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

  // --- Render Logic ---
  if (loading && !petitions.length) { // Chỉ hiển thị loading toàn trang khi chưa có dữ liệu
      return (
        <Box display="flex" justifyContent="center" alignItems="center" minHeight="60vh">
          <CircularProgress />
        </Box>
      );
  }

  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={4}>
        <Typography variant="h4" component="h1">
          Đơn thỉnh cầu của tôi
        </Typography>
        <Button
          variant="contained"
          color="primary"
          onClick={handleOpenCreateDialog}
        >
          Tạo đơn mới
        </Button>
      </Box>

      {/* Hiển thị lỗi fetch hoặc lỗi tạo đơn */}
      {error && !openDialog && ( // Chỉ hiển thị lỗi chung khi dialog tạo đơn đóng
        <Box mb={3}>
          <Alert severity="error" onClose={() => setError(null)}>{error}</Alert>
        </Box>
      )}

       {loading && petitions.length > 0 && ( // Hiển thị loading nhỏ khi đang tải trang mới
            <Box display="flex" justifyContent="center" my={2}><CircularProgress size={24} /></Box>
        )}


      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Tiêu đề</TableCell>
              <TableCell>Nội dung</TableCell>
              <TableCell>Trạng thái</TableCell>
              <TableCell>Thời gian</TableCell>
              <TableCell>Ngày tạo</TableCell>
              <TableCell>Chi tiết</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {petitions.length === 0 && !loading ? (
                <TableRow>
                    <TableCell colSpan={6} align="center">Không có đơn thỉnh cầu nào.</TableCell>
                </TableRow>
            ) : (
                petitions.map((petition) => (
                  <TableRow key={petition.PetitionID}>
                    <TableCell sx={{ maxWidth: 200, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {petition.Title}
                    </TableCell>
                    <TableCell sx={{ maxWidth: 300, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                      {petition.Content}
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={petition.Status}
                        color={
                          petition.Status === "PENDING" ? "warning"
                          : petition.Status === "APPROVED" ? "success"
                          : "error"
                        }
                        size="small"
                      />
                    </TableCell>
                    <TableCell sx={{ minWidth: 100 }}>{formatTime(petition.SubmittedAt)}</TableCell>
                    <TableCell sx={{ minWidth: 120 }}>{formatDate(petition.SubmittedAt)}</TableCell>
                    <TableCell>
                      <IconButton
                        color="primary"
                        size="small"
                        onClick={() => fetchPetitionDetails(petition.PetitionID)}
                        title="Xem chi tiết"
                      >
                        <DescriptionIcon />
                      </IconButton>
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
                 disabled={loading} // Disable pagination khi đang tải
               />
             </Box>
        )}


      {/* Dialog Tạo đơn mới */}
      <Dialog open={openDialog} onClose={handleCloseCreateDialog} fullWidth maxWidth="sm">
        <DialogTitle>Tạo đơn thỉnh cầu mới</DialogTitle>
        <DialogContent>
         {/* Hiển thị lỗi trong dialog */}
          {error && openDialog && (
            <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>
          )}
          <TextField
            autoFocus
            margin="dense"
            label="Tiêu đề"
            fullWidth
            required
            value={newPetition.Title}
            onChange={(e) => setNewPetition({ ...newPetition, Title: e.target.value })}
            error={!!error && !newPetition.Title} // Highlight lỗi nếu cần
            helperText={!!error && !newPetition.Title ? "Tiêu đề là bắt buộc" : ""}
          />
          <TextField
            margin="dense"
            label="Nội dung"
            fullWidth
            required
            multiline
            rows={4}
            value={newPetition.Content}
            onChange={(e) => setNewPetition({ ...newPetition, Content: e.target.value })}
            error={!!error && !newPetition.Content} // Highlight lỗi nếu cần
             helperText={!!error && !newPetition.Content ? "Nội dung là bắt buộc" : ""}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseCreateDialog}>Hủy</Button>
          <Button onClick={handleCreatePetition} color="primary" variant="contained">
            Tạo đơn
          </Button>
        </DialogActions>
      </Dialog>

      {/* Dialog Chi tiết đơn */}
      <Dialog open={openDetailsDialog} onClose={handleDetailsDialogClose} maxWidth="md" fullWidth>
        <DialogTitle>Chi tiết đơn thỉnh cầu</DialogTitle>
        <DialogContent>
          {detailsError ? (
            <Alert severity="error">{detailsError}</Alert>
          ) : selectedPetition ? (
            <Box sx={{ display: "flex", flexDirection: "column", gap: 2, mt: 1 }}>
              <TextField label="Tiêu đề" value={selectedPetition.Title || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined" />
              <TextField label="Nội dung" value={selectedPetition.Content || "N/A"} fullWidth multiline rows={4} InputProps={{ readOnly: true }} variant="outlined"/>
              <TextField label="Trạng thái" value={selectedPetition.Status || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
              <TextField label="Ngày tạo" value={formatDate(selectedPetition.SubmittedAt) || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
              <TextField label="Thời gian tạo" value={formatTime(selectedPetition.SubmittedAt) || "N/A"} fullWidth InputProps={{ readOnly: true }} variant="outlined"/>
              <TextField label="Phản hồi (Admin)" value={selectedPetition.Response || "Chưa có phản hồi"} fullWidth multiline rows={2} InputProps={{ readOnly: true }} variant="outlined"/>
            </Box>
          ) : (
            <Box display="flex" justifyContent="center" my={3}><CircularProgress /></Box> // Loading indicator for details
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDetailsDialogClose}>Đóng</Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar Thông báo thành công */}
      <Snackbar
        open={openSnackbar}
        autoHideDuration={4000} // Tăng thời gian hiển thị
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: "top", horizontal: "center" }}
      >
        <Alert
          onClose={handleSnackbarClose}
          severity="success"
          variant="filled" // Làm nổi bật hơn
          sx={{ width: '100%' }}
        >
          {successMessage}
        </Alert>
      </Snackbar>
    </Container>
  );
};

export default ParentPetitionsView;