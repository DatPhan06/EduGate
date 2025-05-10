import React, { useState, useEffect, useCallback } from 'react';
import {
    Container,
    Typography,
    Box,
    CircularProgress,
    Alert,
    Paper,
    Grid,
    Pagination
} from '@mui/material';
import ClassEventCard from '../../components/ClassEvents/ClassEventCard';
import classPostService from '../../services/classPostService';
import authService from '../../services/authService';

const StudentAnnouncementsPage = () => {
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [posts, setPosts] = useState([]);
    const [studentClassId, setStudentClassId] = useState(null);
    const [studentName, setStudentName] = useState('');
    const [className, setClassName] = useState(''); // To store class name

    const [page, setPage] = useState(1);
    const [totalPages, setTotalPages] = useState(0);
    const postsPerPage = 10; // Or get from API if dynamic

    const fetchStudentAndClassInfo = useCallback(async () => {
        try {
            const currentUser = authService.getCurrentUser();
            if (currentUser && currentUser.role === 'student' && currentUser.UserID && currentUser.ClassID) {
                setStudentClassId(currentUser.ClassID);
                setStudentName(`${currentUser.FirstName} ${currentUser.LastName}`);
                // TODO: Fetch class name based on ClassID if not directly available
                // For now, we'll leave className blank or use a placeholder
                // If your User object for student includes className, you can set it here.
                // e.g., setClassName(currentUser.ClassName || 'Lớp của bạn'); 
            } else {
                setError('Không thể xác định thông tin học sinh hoặc lớp học.');
                setLoading(false);
                return false;
            }
            return true;
        } catch (err) {
            console.error("Error fetching student info:", err);
            setError('Lỗi tải thông tin học sinh.');
            setLoading(false);
            return false;
        }
    }, []);

    const fetchClassPosts = useCallback(async (classId, currentPage) => {
        if (!classId) return;
        setLoading(true);
        try {
            const data = await classPostService.getClassPostsByClass(classId, currentPage, postsPerPage);
            if (data && data.items) {
                setPosts(data.items);
                setTotalPages(data.totalPages);
            } else {
                setPosts([]);
                setTotalPages(0);
            }
            setError('');
        } catch (err) {
            console.error("Error fetching class posts:", err);
            setError('Không thể tải thông báo của lớp. Vui lòng thử lại.');
            setPosts([]);
        } finally {
            setLoading(false);
        }
    }, [postsPerPage]);

    useEffect(() => {
        const initLoad = async () => {
            const studentInfoLoaded = await fetchStudentAndClassInfo();
            if (studentInfoLoaded && studentClassId) {
                fetchClassPosts(studentClassId, page);
            } else if (studentInfoLoaded && !studentClassId) {
                // This case might happen if ClassID is not immediately available on currentUser
                // and needs to be fetched separately. For now, we assume it's there.
                setError('Không tìm thấy thông tin lớp của học sinh.');
                setLoading(false);
            }
        };
        initLoad();
    }, [fetchStudentAndClassInfo, fetchClassPosts, studentClassId, page]);
    
    const handlePageChange = (event, value) => {
        setPage(value);
    };

    if (loading && posts.length === 0) {
        return (
            <Container maxWidth="md" sx={{ py: 4, textAlign: 'center' }}>
                <CircularProgress />
                <Typography sx={{ mt: 2 }}>Đang tải thông báo...</Typography>
            </Container>
        );
    }

    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Paper elevation={2} sx={{ p: 3, mb: 3 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Thông báo lớp {className}
                </Typography>
                <Typography variant="subtitle1" color="text.secondary">
                    Xin chào {studentName}, đây là các thông báo và sự kiện của lớp bạn.
                </Typography>
            </Paper>

            {error && (
                <Alert severity="error" sx={{ mb: 2 }}>
                    {error}
                </Alert>
            )}

            {!loading && posts.length === 0 && !error && (
                <Alert severity="info">Hiện tại chưa có thông báo nào cho lớp của bạn.</Alert>
            )}

            <Grid container spacing={3}>
                {posts.map((post) => (
                    <Grid item xs={12} key={post.PostID}>
                        <ClassEventCard post={post} canEdit={false} />
                    </Grid>
                ))}
            </Grid>
            
            {totalPages > 1 && (
                <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
                    <Pagination 
                        count={totalPages} 
                        page={page} 
                        onChange={handlePageChange} 
                        color="primary" 
                    />
                </Box>
            )}
        </Container>
    );
};

export default StudentAnnouncementsPage;
