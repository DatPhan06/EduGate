import React, { useState, useEffect } from "react";
import { Container, Typography, Box, CircularProgress, Alert } from "@mui/material";
import authService from "../../services/authService";
import ParentPetitionsView from "./ParentPetitionsView"; // Import component con
import AdminPetitionsView from "./AdminPetitionsView";   // Import component con

const Petitions = () => {
  const [userRole, setUserRole] = useState(null);
  const [userId, setUserId] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUserInfo = async () => {
      setLoading(true); // Bắt đầu loading khi fetch user info
      setError(null);   // Reset lỗi cũ
      try {
        const user = await authService.getCurrentUser();
        console.log("Raw User Response:", JSON.stringify(user, null, 2));
        if (!user) {
          // Nếu không có user, coi như chưa đăng nhập
          setUserRole(null);
          setUserId(null);
        } else if (!user.role || !user.UserID) {
          throw new Error("Thiếu role hoặc UserID trong dữ liệu người dùng");
        } else {
          setUserRole(user.role);
          setUserId(user.UserID);
          console.log(
            "State Updated - userRole:",
            user.role,
            "userId:",
            user.UserID
          );
        }
      } catch (err) {
        console.error("Error fetching user info:", err);
        setError("Không thể tải thông tin người dùng. Vui lòng thử lại.");
        setUserRole(null); // Reset role nếu có lỗi
        setUserId(null);
      } finally {
        setLoading(false); // Kết thúc loading
      }
    };

    fetchUserInfo();
  }, []); // Chỉ chạy 1 lần khi component mount

  // --- Render Loading State ---
  if (loading) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="80vh"
      >
        <CircularProgress />
      </Box>
    );
  }

  // --- Render Error State (Lỗi fetch user info) ---
  if (error) {
    return (
      <Container maxWidth="lg" sx={{ py: 4 }}>
         <Typography variant="h4" component="h1" gutterBottom>
           Trang quản lý đơn thỉnh cầu
         </Typography>
        <Alert severity="error">{error}</Alert>
      </Container>
    );
  }

  // --- Render based on user role ---
  if (userRole === "parent" && userId) {
    // Truyền userId xuống cho component con
    return <ParentPetitionsView userId={userId} />;
  }

  if (userRole === "admin" && userId) {
    // Truyền userId xuống cho component con
    return <AdminPetitionsView userId={userId} />;
  }

  // --- Render for unauthorized roles (teacher, student) ---
  if (userRole === "teacher" || userRole === "student") {
    return (
      <Container maxWidth="lg" sx={{ py: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Trang quản lý đơn thỉnh cầu
        </Typography>
        <Typography variant="body1">
          Bạn không có quyền truy cập chức năng này.
        </Typography>
      </Container>
    );
  }

  // --- Render Default (Not logged in) ---
  return (
    <Container maxWidth="lg" sx={{ py: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        Trang quản lý đơn thỉnh cầu
      </Typography>
      <Typography variant="body1">
        Vui lòng đăng nhập để sử dụng chức năng này.
      </Typography>
    </Container>
  );
};

export default Petitions;