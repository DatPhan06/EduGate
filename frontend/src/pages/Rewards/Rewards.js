import React, { useState, useEffect } from 'react';
import { 
    Box, 
    Typography, 
    Paper, 
    Tabs, 
    Tab, 
    Button, 
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField,
    MenuItem,
    Grid,
    List,
    ListItem,
    ListItemText,
    ListItemSecondaryAction,
    IconButton,
    Divider,
    Chip 
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import VisibilityIcon from '@mui/icons-material/Visibility';
import { format } from 'date-fns';
import { useAuth } from '../../contexts/AuthContext';
import { api } from '../../services/api';
import RewardPunishmentForm from './RewardPunishmentForm';
import RewardPunishmentDetails from './RewardPunishmentDetails';

const Rewards = () => {
    const [tabValue, setTabValue] = useState(0);
    const [records, setRecords] = useState([]);
    const [selectedRecord, setSelectedRecord] = useState(null);
    const [openForm, setOpenForm] = useState(false);
    const [openDetails, setOpenDetails] = useState(false);
    const [loading, setLoading] = useState(true);
    const { user } = useAuth();
    
    const isAdminOrTeacher = user && (user.role === 'ADMIN' || user.role === 'TEACHER');

    useEffect(() => {
        fetchRecords();
    }, [tabValue]);

    const fetchRecords = async () => {
        try {
            setLoading(true);
            const type = tabValue === 0 ? 'reward' : 'punishment';
            const response = await api.get(`/reward-punishment/?type_filter=${type}`);
            setRecords(response.data);
        } catch (error) {
            console.error('Error fetching records:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleTabChange = (event, newValue) => {
        setTabValue(newValue);
    };

    const handleOpenForm = () => {
        setOpenForm(true);
    };

    const handleCloseForm = () => {
        setOpenForm(false);
    };

    const handleFormSubmit = async (formData) => {
        try {
            await api.post('/reward-punishment/', formData);
            handleCloseForm();
            fetchRecords();
        } catch (error) {
            console.error('Error creating record:', error);
        }
    };

    const handleViewDetails = (record) => {
        setSelectedRecord(record);
        setOpenDetails(true);
    };

    const handleCloseDetails = () => {
        setOpenDetails(false);
    };

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h4" gutterBottom>
                    Quản lý Khen thưởng / Kỷ luật
                </Typography>
                {isAdminOrTeacher && (
                    <Button 
                        variant="contained" 
                        startIcon={<AddIcon />}
                        onClick={handleOpenForm}
                    >
                        Thêm mới
                    </Button>
                )}
            </Box>

            <Paper sx={{ mb: 3 }}>
                <Tabs
                    value={tabValue}
                    onChange={handleTabChange}
                    indicatorColor="primary"
                    textColor="primary"
                    centered
                >
                    <Tab label="Khen thưởng" />
                    <Tab label="Kỷ luật" />
                </Tabs>
            </Paper>

            <Paper sx={{ p: 2 }}>
                {loading ? (
                    <Typography>Đang tải dữ liệu...</Typography>
                ) : records.length === 0 ? (
                    <Typography>Không có dữ liệu</Typography>
                ) : (
                    <List>
                        {records.map((record) => (
                            <React.Fragment key={record.RecordID}>
                                <ListItem>
                                    <ListItemText
                                        primary={record.Title}
                                        secondary={
                                            <>
                                                <Typography component="span" variant="body2" color="text.primary">
                                                    {format(new Date(record.Date), 'dd/MM/yyyy')}
                                                </Typography>
                                                {" — "}{record.Description.substring(0, 100)}
                                                {record.Description.length > 100 ? "..." : ""}
                                            </>
                                        }
                                    />
                                    <ListItemSecondaryAction>
                                        <Chip 
                                            label={`HK: ${record.Semester}, Tuần: ${record.Week}`}
                                            size="small"
                                            sx={{ mr: 1 }}
                                        />
                                        <IconButton edge="end" onClick={() => handleViewDetails(record)}>
                                            <VisibilityIcon />
                                        </IconButton>
                                    </ListItemSecondaryAction>
                                </ListItem>
                                <Divider />
                            </React.Fragment>
                        ))}
                    </List>
                )}
            </Paper>

            {/* Form Dialog */}
            <Dialog open={openForm} onClose={handleCloseForm} maxWidth="md" fullWidth>
                <DialogTitle>
                    {tabValue === 0 ? 'Thêm khen thưởng mới' : 'Thêm kỷ luật mới'}
                </DialogTitle>
                <DialogContent>
                    <RewardPunishmentForm 
                        onSubmit={handleFormSubmit} 
                        type={tabValue === 0 ? 'reward' : 'punishment'} 
                    />
                </DialogContent>
            </Dialog>

            {/* Details Dialog */}
            {selectedRecord && (
                <Dialog open={openDetails} onClose={handleCloseDetails} maxWidth="md" fullWidth>
                    <DialogTitle>Chi tiết {selectedRecord.Type === 'reward' ? 'khen thưởng' : 'kỷ luật'}</DialogTitle>
                    <DialogContent>
                        <RewardPunishmentDetails record={selectedRecord} />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={handleCloseDetails}>Đóng</Button>
                    </DialogActions>
                </Dialog>
            )}
        </Box>
    );
};

export default Rewards;