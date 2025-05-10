import React, { useState, useEffect } from 'react';
import {
    Box,
    TextField,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    Button,
    Typography,
    Alert,
    Tabs,
    Tab,
    FormHelperText,
    Grid,
    Divider
} from '@mui/material';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeRaw from 'rehype-raw';
import './MarkdownStyles.css';

const EVENT_TYPES = [
    { value: 'ANNOUNCEMENT', label: 'Thông báo chung' },
    { value: 'HOMEWORK', label: 'Bài tập về nhà' },
    { value: 'EXAM', label: 'Lịch kiểm tra' },
    { value: 'EVENT', label: 'Sự kiện lớp' },
    { value: 'PARENT_MEETING', label: 'Họp phụ huynh' },
    { value: 'OTHER', label: 'Khác' }
];

const ClassEventEditor = ({
    classId,
    initialData = null,
    onSubmit,
    isLoading = false,
    error = ''
}) => {
    // Default empty form
    const defaultForm = {
        ClassID: classId,
        Title: '',
        Content: '',
        Type: 'ANNOUNCEMENT',
        EventDate: null
    };

    // Form state
    const [formData, setFormData] = useState(initialData || defaultForm);
    const [validation, setValidation] = useState({
        Title: '',
        Content: '',
        Type: ''
    });
    const [tabIndex, setTabIndex] = useState(0);

    // Markdown examples for help tab
    const markdownExample = `# Tiêu đề lớn
## Tiêu đề nhỏ hơn
### Tiêu đề cấp 3

Đây là **văn bản in đậm** và *văn bản in nghiêng*.

> Đây là một trích dẫn quan trọng.

- Điểm đầu tiên
- Điểm thứ hai
- Điểm thứ ba

1. Mục đầu tiên
2. Mục thứ hai
3. Mục thứ ba

[Đây là một liên kết](https://example.com)

![Alt text cho hình ảnh](https://example.com/image.jpg)

\`\`\`
// Đây là một khối mã
const hello = 'world';
console.log(hello);
\`\`\`

| Cột 1 | Cột 2 | Cột 3 |
|-------|-------|-------|
| A1    | B1    | C1    |
| A2    | B2    | C2    |
`;

    // Initialize form with initial data if provided
    useEffect(() => {
        if (initialData) {
            setFormData({
                ...initialData,
                // Convert string date to Date object
                EventDate: initialData.EventDate ? new Date(initialData.EventDate) : null
            });
        } else {
            setFormData(defaultForm);
        }
    }, [initialData]);

    // Handle form input changes
    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value
        });

        // Clear validation error when field is modified
        if (validation[name]) {
            setValidation({
                ...validation,
                [name]: ''
            });
        }
    };

    // Handle date change
    const handleDateChange = (newDate) => {
        setFormData({
            ...formData,
            EventDate: newDate
        });
    };

    // Handle tab change between editor and preview
    const handleTabChange = (event, newValue) => {
        setTabIndex(newValue);
    };

    // Validate form before submission
    const validateForm = () => {
        const newErrors = {};
        let isValid = true;

        if (!formData.Title.trim()) {
            newErrors.Title = 'Vui lòng nhập tiêu đề';
            isValid = false;
        }

        if (!formData.Content.trim()) {
            newErrors.Content = 'Vui lòng nhập nội dung';
            isValid = false;
        }

        if (!formData.Type) {
            newErrors.Type = 'Vui lòng chọn loại thông báo';
            isValid = false;
        }

        setValidation(newErrors);
        return isValid;
    };

    // Handle form submission
    const handleSubmit = (e) => {
        e.preventDefault();

        if (validateForm()) {
            // Convert EventDate to ISO string if it exists
            const submitData = {
                ...formData,
                EventDate: formData.EventDate ? formData.EventDate.toISOString() : null
            };

            onSubmit(submitData);
        }
    };

    return (
        <Box component="form" onSubmit={handleSubmit} sx={{ mt: 2 }}>
            {/* Display any API errors */}
            {error && (
                <Alert severity="error" sx={{ mb: 3 }}>
                    {error}
                </Alert>
            )}

            <Grid container spacing={3}>
                <Grid item xs={12}>
                    <TextField
                        name="Title"
                        label="Tiêu đề thông báo"
                        fullWidth
                        value={formData.Title}
                        onChange={handleInputChange}
                        error={!!validation.Title}
                        helperText={validation.Title}
                        disabled={isLoading}
                        required
                    />
                </Grid>

                <Grid item xs={12} sm={6}>
                    <FormControl fullWidth error={!!validation.Type}>
                        <InputLabel>Loại thông báo</InputLabel>
                        <Select
                            name="Type"
                            value={formData.Type}
                            label="Loại thông báo"
                            onChange={handleInputChange}
                            disabled={isLoading}
                            required
                        >
                            {EVENT_TYPES.map((type) => (
                                <MenuItem key={type.value} value={type.value}>
                                    {type.label}
                                </MenuItem>
                            ))}
                        </Select>
                        {validation.Type && <FormHelperText>{validation.Type}</FormHelperText>}
                    </FormControl>
                </Grid>

                <Grid item xs={12} sm={6}>
                    <LocalizationProvider dateAdapter={AdapterDateFns}>
                        <DateTimePicker
                            label="Ngày sự kiện (nếu có)"
                            value={formData.EventDate}
                            onChange={handleDateChange}
                            slotProps={{
                                textField: {
                                    fullWidth: true,
                                    disabled: isLoading
                                }
                            }}
                        />
                    </LocalizationProvider>
                </Grid>

                <Grid item xs={12}>
                    <Typography variant="subtitle1" gutterBottom>
                        Nội dung thông báo
                    </Typography>

                    <Tabs 
                        value={tabIndex} 
                        onChange={handleTabChange}
                        sx={{ mb: 2 }}
                    >
                        <Tab label="Soạn thảo" />
                        <Tab label="Xem trước" />
                        <Tab label="Trợ giúp" />
                    </Tabs>

                    {/* Editor Tab */}
                    {tabIndex === 0 && (
                        <TextField
                            name="Content"
                            multiline
                            rows={10}
                            fullWidth
                            value={formData.Content}
                            onChange={handleInputChange}
                            placeholder="Nhập nội dung thông báo ở đây. Hỗ trợ định dạng Markdown."
                            error={!!validation.Content}
                            helperText={validation.Content || 'Hỗ trợ định dạng Markdown. Chuyển sang tab Xem trước để kiểm tra trước khi gửi.'}
                            disabled={isLoading}
                            required
                        />
                    )}

                    {/* Preview Tab */}
                    {tabIndex === 1 && (
                        <Box 
                            className="markdown-preview" 
                            sx={{ 
                                border: '1px solid #ddd',
                                borderRadius: 1,
                                p: 2,
                                minHeight: '240px',
                                bgcolor: '#fff'
                            }}
                        >
                            {formData.Content ? (
                                <ReactMarkdown 
                                    remarkPlugins={[remarkGfm]} 
                                    rehypePlugins={[rehypeRaw]}
                                >
                                    {formData.Content}
                                </ReactMarkdown>
                            ) : (
                                <Typography color="text.secondary" sx={{ fontStyle: 'italic' }}>
                                    Nội dung xem trước sẽ hiển thị ở đây...
                                </Typography>
                            )}
                        </Box>
                    )}

                    {/* Help Tab */}
                    {tabIndex === 2 && (
                        <Box sx={{ p: 2, border: '1px solid #ddd', borderRadius: 1 }}>
                            <Typography variant="h6" gutterBottom>
                                Hướng dẫn sử dụng Markdown
                            </Typography>
                            <Typography variant="body2" paragraph>
                                Markdown là một cú pháp đơn giản để định dạng văn bản. Dưới đây là một số ví dụ cơ bản:
                            </Typography>
                            
                            <Grid container spacing={2}>
                                <Grid item xs={12} md={6}>
                                    <Typography variant="subtitle2">Mã Markdown:</Typography>
                                    <Box 
                                        component="pre" 
                                        sx={{ 
                                            bgcolor: '#f5f5f5', 
                                            p: 2, 
                                            borderRadius: 1,
                                            overflow: 'auto',
                                            fontSize: '0.875rem'
                                        }}
                                    >
                                        {markdownExample}
                                    </Box>
                                </Grid>
                                <Grid item xs={12} md={6}>
                                    <Typography variant="subtitle2">Kết quả hiển thị:</Typography>
                                    <Box 
                                        className="markdown-preview" 
                                        sx={{ 
                                            border: '1px solid #ddd', 
                                            p: 2, 
                                            borderRadius: 1,
                                            overflow: 'auto',
                                            maxHeight: '400px'
                                        }}
                                    >
                                        <ReactMarkdown 
                                            remarkPlugins={[remarkGfm]} 
                                            rehypePlugins={[rehypeRaw]}
                                        >
                                            {markdownExample}
                                        </ReactMarkdown>
                                    </Box>
                                </Grid>
                            </Grid>
                        </Box>
                    )}
                </Grid>

                <Grid item xs={12}>
                    <Divider sx={{ mt: 2, mb: 3 }} />
                    <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                        <Button
                            type="submit"
                            variant="contained"
                            color="primary"
                            disabled={isLoading}
                            sx={{ minWidth: 120 }}
                        >
                            {isLoading ? 'Đang xử lý...' : initialData ? 'Cập nhật' : 'Tạo thông báo'}
                        </Button>
                    </Box>
                </Grid>
            </Grid>
        </Box>
    );
};

export default ClassEventEditor;