import React, { useState, useEffect } from 'react';
import { 
    Box, 
    TextField, 
    MenuItem, 
    Grid, 
    Button,
    FormControl,
    InputLabel,
    Select,
    Typography,
    Autocomplete,
    Chip
} from '@mui/material';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider, DatePicker } from '@mui/x-date-pickers';
import { vi } from 'date-fns/locale';
import { api } from '../../services/api';

const RewardPunishmentForm = ({ onSubmit, type }) => {
    const [formData, setFormData] = useState({
        Title: '',
        Type: type,
        Description: '',
        Date: new Date(),
        Semester: '',
        Week: '',
        StudentIDs: [],
        ClassIDs: []
    });
    const [students, setStudents] = useState([]);
    const [classes, setClasses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [errors, setErrors] = useState({});

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                const [studentsResponse, classesResponse] = await Promise.all([
                    api.get('/students/'),
                    api.get('/classes/')
                ]);
                setStudents(studentsResponse.data);
                setClasses(classesResponse.data);
            } catch (error) {
                console.error('Error fetching data:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value
        });
    };

    const handleDateChange = (date) => {
        setFormData({
            ...formData,
            Date: date
        });
    };

    const handleStudentsChange = (event, values) => {
        setFormData({
            ...formData,
            StudentIDs: values.map(student => student.StudentID)
        });
    };

    const handleClassesChange = (event, values) => {
        setFormData({
            ...formData,
            ClassIDs: values.map(cls => cls.ClassID)
        });
    };

    const validate = () => {
        const newErrors = {};
        if (!formData.Title.trim()) newErrors.Title = 'Tiêu đề không được để trống';
        if (!formData.Description.trim()) newErrors.Description = 'Mô tả không được để trống';
        if (!formData.Semester.trim()) newErrors.Semester = 'Học kỳ không được để trống';
        if (!formData.Week) newErrors.Week = 'Tuần không được để trống';
        if (formData.StudentIDs.length === 0 && formData.ClassIDs.length === 0) {
            newErrors.Recipients = 'Phải chọn ít nhất một học sinh hoặc lớp học';
        }
        
        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        
        if (!validate()) return;
        
        try {
            // Tạo khen thưởng/kỷ luật mới
            const recordData = {
                Title: formData.Title,
                Type: formData.Type,
                Description: formData.Description,
                Date: formData.Date.toISOString(),
                Semester: formData.Semester,
                Week: parseInt(formData.Week)
            };
            
            const response = await api.post('/reward-punishment/', recordData);
            const recordId = response.data.RecordID;
            
            // Gán cho học sinh
            await Promise.all(formData.StudentIDs.map(studentId => 
                api.post('/reward-punishment/assign-student/', {
                    StudentID: studentId,
                    RecordID: recordId
                })
            ));
            
            // Gán cho lớp học
            await Promise.all(formData.ClassIDs.map(classId => 
                api.post('/reward-punishment/assign-class/', {
                    ClassID: classId,
                    RecordID: recordId
                })
            ));
            
            onSubmit(formData);
        } catch (error) {
            console.error('Error submitting form:', error);
        }
    };

    if (loading) {
        return <Typography>Đang tải dữ liệu...</Typography>;
    }

    return (
        <Box component="form" onSubmit={handleSubmit} sx={{ mt: 2 }}>
            <Grid container spacing={3}>
                <Grid item xs={12}>
                    <TextField
                        fullWidth
                        label="Tiêu đề"
                        name="Title"
                        value={formData.Title}
                        onChange={handleChange}
                        error={!!errors.Title}
                        helperText={errors.Title}
                    />
                </Grid>
                
                <Grid item xs={12}>
                    <TextField
                        fullWidth
                        label="Mô tả"
                        name="Description"
                        multiline
                        rows={4}
                        value={formData.Description}
                        onChange={handleChange}
                        error={!!errors.Description}
                        helperText={errors.Description}
                    />
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={vi}>
                        <DatePicker
                            label="Ngày"
                            value={formData.Date}
                            onChange={handleDateChange}
                            renderInput={(params) => <TextField {...params} fullWidth />}
                        />
                    </LocalizationProvider>
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <TextField
                        fullWidth
                        label="Học kỳ"
                        name="Semester"
                        value={formData.Semester}
                        onChange={handleChange}
                        error={!!errors.Semester}
                        helperText={errors.Semester}
                    />
                </Grid>
                
                <Grid item xs={12} md={4}>
                    <TextField
                        fullWidth
                        label="Tuần"
                        name="Week"
                        type="number"
                        value={formData.Week}
                        onChange={handleChange}
                        error={!!errors.Week}
                        helperText={errors.Week}
                    />
                </Grid>
                
                <Grid item xs={12} md={6}>
                    <Autocomplete
                        multiple
                        options={students}
                        getOptionLabel={(option) => `${option.StudentName} (${option.StudentID})`}
                        onChange={handleStudentsChange}
                        renderInput={(params) => (
                            <TextField
                                {...params}
                                label="Chọn học sinh"
                                error={!!errors.Recipients}
                            />
                        )}
                        renderTags={(value, getTagProps) =>
                            value.map((option, index) => (
                                <Chip
                                    label={`${option.StudentName}`}
                                    {...getTagProps({ index })}
                                />
                            ))
                        }
                    />
                </Grid>
                
                <Grid item xs={12} md={6}>
                    <Autocomplete
                        multiple
                        options={classes}
                        getOptionLabel={(option) => `${option.ClassName} (${option.ClassID})`}
                        onChange={handleClassesChange}
                        renderInput={(params) => (
                            <TextField
                                {...params}
                                label="Chọn lớp học"
                                error={!!errors.Recipients}
                            />
                        )}
                        renderTags={(value, getTagProps) =>
                            value.map((option, index) => (
                                <Chip
                                    label={`${option.ClassName}`}
                                    {...getTagProps({ index })}
                                />
                            ))
                        }
                    />
                </Grid>
                
                {errors.Recipients && (
                    <Grid item xs={12}>
                        <Typography color="error">{errors.Recipients}</Typography>
                    </Grid>
                )}
                
                <Grid item xs={12}>
                    <Button type="submit" variant="contained" fullWidth>
                        Lưu
                    </Button>
                </Grid>
            </Grid>
        </Box>
    );
};

export default RewardPunishmentForm;