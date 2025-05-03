import React, { useState, useEffect } from 'react';
import { 
    Box, 
    Typography, 
    Grid, 
    Paper, 
    Chip,
    Divider,
    List,
    ListItem,
    ListItemText
} from '@mui/material';
import { format } from 'date-fns';
import { api } from '../../services/api';

const RewardPunishmentDetails = ({ record }) => {
    const [studentRecipients, setStudentRecipients] = useState([]);
    const [classRecipients, setClassRecipients] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchDetails = async () => {
            try {
                setLoading(true);
                // Nếu có API để lấy thông tin người/lớp nhận
                const [studentResponse, classResponse] = await Promise.all([
                    api.get(`/reward-punishment/${record.RecordID}/students`),
                    api.get(`/reward-punishment/${record.RecordID}/classes`)
                ]);
                
                setStudentRecipients(studentResponse.data);
                setClassRecipients(classResponse.data);
            } catch (error) {
                console.error('Error fetching details:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchDetails();
    }, [record]);

    return (
        <Box sx={{ py: 2 }}>
            <Grid container spacing={3}>
                <Grid item xs={12}>
                    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <Typography variant="h5" gutterBottom>
                            {record.Title}
                        </Typography>
                        <Chip 
                            label={record.Type === 'reward' ? 'Khen thưởng' : 'Kỷ luật'} 
                            color={record.Type === 'reward' ? 'success' : 'error'}
                        />
                    </Box>
                    <Divider sx={{ my: 1 }} />
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <Typography variant="subtitle2">Ngày</Typography>
                    <Typography>{format(new Date(record.Date), 'dd/MM/yyyy')}</Typography>
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <Typography variant="subtitle2">Học kỳ</Typography>
                    <Typography>{record.Semester}</Typography>
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <Typography variant="subtitle2">Tuần</Typography>
                    <Typography>{record.Week}</Typography>
                </Grid>
                
                <Grid item xs={12}>
                    <Typography variant="subtitle2">Mô tả</Typography>
                    <Paper sx={{ p: 2, bgcolor: '#f5f5f5' }}>
                        <Typography style={{ whiteSpace: 'pre-line' }}>{record.Description}</Typography>
                    </Paper>
                </Grid>
                
                {loading ? (
                    <Grid item xs={12}>
                        <Typography>Đang tải dữ liệu người nhận...</Typography>
                    </Grid>
                ) : (
                    <>
                        {studentRecipients.length > 0 && (
                            <Grid item xs={12} md={6}>
                                <Typography variant="subtitle2">Học sinh</Typography>
                                <Paper sx={{ p: 1, maxHeight: 200, overflow: 'auto' }}>
                                    <List dense>
                                        {studentRecipients.map(student => (
                                            <ListItem key={student.StudentID}>
                                                <ListItemText 
                                                    primary={student.StudentName} 
                                                    secondary={student.StudentID} 
                                                />
                                            </ListItem>
                                        ))}
                                    </List>
                                </Paper>
                            </Grid>
                        )}
                        
                        {classRecipients.length > 0 && (
                            <Grid item xs={12} md={6}>
                                <Typography variant="subtitle2">Lớp học</Typography>
                                <Paper sx={{ p: 1, maxHeight: 200, overflow: 'auto' }}>
                                    <List dense>
                                        {classRecipients.map(classInfo => (
                                            <ListItem key={classInfo.ClassID}>
                                                <ListItemText 
                                                    primary={classInfo.ClassName} 
                                                    secondary={classInfo.ClassID} 
                                                />
                                            </ListItem>
                                        ))}
                                    </List>
                                </Paper>
                            </Grid>
                        )}
                    </>
                )}
            </Grid>
        </Box>
    );
};

export default RewardPunishmentDetails;