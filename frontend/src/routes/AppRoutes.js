import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import authService from '../services/authService';

// Layout Components
import MainLayout from '../layouts/MainLayout';

// Page Components
import Home from '../pages/Home/Home';
import Messages from '../pages/Messages/Messages';
import Events from '../pages/Events/Events';
import Petitions from '../pages/Petitions/Petitions';
import Rewards from '../pages/Rewards/Rewards';
import AcademicResults from '../pages/AcademicResults/AcademicResults';
import UserList from '../pages/Users/UserList';
import Login from '../pages/Users/Login';
import Register from '../pages/Users/Register';
import Unauthorized from '../pages/Errors/Unauthorized';
import NotFound from '../pages/Errors/NotFound';
import UserProfile from '../pages/Users/UserProfile';

// Protected Route Component
const ProtectedRoute = ({ children, roles = [] }) => {
    const currentUser = authService.getCurrentUser();
    
    if (!currentUser) {
        return <Navigate to="/login" replace />;
    }

    if (roles.length > 0 && !roles.includes(currentUser.role)) {
        return <Navigate to="/unauthorized" replace />;
    }

    return children;
};

const AppRoutes = () => {
    return (
        <Routes>
            {/* Public Routes */}
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/unauthorized" element={<Unauthorized />} />

            {/* Protected Routes */}
            <Route
                path="/"
                element={
                    <ProtectedRoute>
                        <MainLayout />
                    </ProtectedRoute>
                }
            >
                {/* Default route */}
                <Route index element={<Home />} />

                {/* Module Routes */}
                <Route path="messages" element={<Messages />} />
                <Route path="events" element={<Events />} />
                <Route path="petitions" element={<Petitions />} />
                <Route path="rewards" element={<Rewards />} />
                <Route path="academic-results" element={<AcademicResults />} />
                <Route path="users/me" element={<UserProfile />} />

                {/* Admin Routes */}
                <Route
                    path="users"
                    element={
                        <ProtectedRoute roles={['ADMIN']}>
                            <UserList />
                        </ProtectedRoute>
                    }
                />
            </Route>

            {/* 404 Route */}
            <Route path="*" element={<NotFound />} />
        </Routes>
    );
};

export default AppRoutes; 