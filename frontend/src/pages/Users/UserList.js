import React, { useState, useEffect } from 'react';
import {
    Box,
    Button,
    Paper,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    TextField,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    IconButton,
    Typography
} from '@mui/material';
import { Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material';
import userService from '../../services/userService';
import UserForm from './UserForm';

const UserList = () => {
    const [users, setUsers] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [roleFilter, setRoleFilter] = useState('');
    const [statusFilter, setStatusFilter] = useState('');
    const [openForm, setOpenForm] = useState(false);
    const [selectedUser, setSelectedUser] = useState(null);

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        try {
            const response = await userService.getAllUsers();
            setUsers(response.data);
        } catch (error) {
            console.error('Error fetching users:', error);
            // TODO: Add error handling/notification
        }
    };

    const handleSearch = (e) => {
        setSearchTerm(e.target.value);
    };

    const handleRoleFilter = (e) => {
        setRoleFilter(e.target.value);
    };

    const handleStatusFilter = (e) => {
        setStatusFilter(e.target.value);
    };

    const handleEdit = (user) => {
        setSelectedUser(user);
        setOpenForm(true);
    };

    const handleDelete = async (userId) => {
        if (window.confirm('Are you sure you want to delete this user?')) {
            try {
                await userService.deleteUser(userId);
                fetchUsers();
            } catch (error) {
                console.error('Error deleting user:', error);
                // TODO: Add error handling/notification
            }
        }
    };

    const handleAddUser = () => {
        setSelectedUser(null);
        setOpenForm(true);
    };

    const handleFormClose = () => {
        setOpenForm(false);
        setSelectedUser(null);
    };

    const handleFormSuccess = () => {
        fetchUsers();
    };

    const filteredUsers = users.filter(user => {
        const matchesSearch = 
            user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
            user.firstName.toLowerCase().includes(searchTerm.toLowerCase()) ||
            user.lastName.toLowerCase().includes(searchTerm.toLowerCase());
        
        const matchesRole = !roleFilter || user.role === roleFilter;
        const matchesStatus = !statusFilter || user.status === statusFilter;

        return matchesSearch && matchesRole && matchesStatus;
    });

    return (
        <Box sx={{ p: 3 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
                <Typography variant="h4">User Management</Typography>
                <Button variant="contained" color="primary" onClick={handleAddUser}>
                    Add New User
                </Button>
            </Box>

            <Box sx={{ display: 'flex', gap: 2, mb: 3 }}>
                <TextField
                    label="Search"
                    variant="outlined"
                    value={searchTerm}
                    onChange={handleSearch}
                    sx={{ flex: 1 }}
                />
                <FormControl sx={{ minWidth: 120 }}>
                    <InputLabel>Role</InputLabel>
                    <Select
                        value={roleFilter}
                        onChange={handleRoleFilter}
                        label="Role"
                    >
                        <MenuItem value="">All Roles</MenuItem>
                        <MenuItem value="ADMIN">Admin</MenuItem>
                        <MenuItem value="TEACHER">Teacher</MenuItem>
                        <MenuItem value="STUDENT">Student</MenuItem>
                    </Select>
                </FormControl>
                <FormControl sx={{ minWidth: 120 }}>
                    <InputLabel>Status</InputLabel>
                    <Select
                        value={statusFilter}
                        onChange={handleStatusFilter}
                        label="Status"
                    >
                        <MenuItem value="">All Statuses</MenuItem>
                        <MenuItem value="ACTIVE">Active</MenuItem>
                        <MenuItem value="INACTIVE">Inactive</MenuItem>
                    </Select>
                </FormControl>
            </Box>

            <TableContainer component={Paper}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Name</TableCell>
                            <TableCell>Email</TableCell>
                            <TableCell>Role</TableCell>
                            <TableCell>Gender</TableCell>
                            <TableCell>Status</TableCell>
                            <TableCell>Actions</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {filteredUsers.map((user) => (
                            <TableRow key={user.id}>
                                <TableCell>{`${user.firstName} ${user.lastName}`}</TableCell>
                                <TableCell>{user.email}</TableCell>
                                <TableCell>{user.role}</TableCell>
                                <TableCell>{user.gender}</TableCell>
                                <TableCell>{user.status}</TableCell>
                                <TableCell>
                                    <IconButton onClick={() => handleEdit(user)} color="primary">
                                        <EditIcon />
                                    </IconButton>
                                    <IconButton onClick={() => handleDelete(user.id)} color="error">
                                        <DeleteIcon />
                                    </IconButton>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>

            <UserForm
                open={openForm}
                handleClose={handleFormClose}
                user={selectedUser}
                onSuccess={handleFormSuccess}
            />
        </Box>
    );
};

export default UserList; 