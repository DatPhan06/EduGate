import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import authService from '../services/authService';

// Layout Components
import MainLayout from '../layouts/MainLayout';

import Home from '../pages/Home/Home';
import Messages from '../pages/Messages/Messages';
import Petitions from '../pages/Petitions/Petitions'; 
import Register from '../pages/Auth/Register';
import Unauthorized from '../pages/Errors/Unauthorized';
import NotFound from '../pages/Errors/NotFound';
import UserProfile from '../pages/Users/UserProfile'; 
import Login from '../pages/Auth/Login';
import UserManagementPage from '../pages/UserManagement/UserManagementPage';
import EventSchedulePage from '../pages/EventSchedule/EventSchedulePage';
import RewardsDisciplinePage from '../pages/RewardsDiscipline/RewardsDisciplinePage';
import DailyLogPage from '../pages/DailyLog/DailyLogPage';
import AcademicResultsPage from '../pages/AcademicResults/AcademicResultsPage';
import ReportsPage from '../pages/Reports/ReportsPage';
import PrincipalDashboardPage from '../pages/Principal/PrincipalDashboardPage';
import ClassManagementPage from '../pages/ClassManagement/ClassManagementPage';
import ConversationMonitorPage from '../pages/Admin/ConversationMonitorPage';

// Protected Route Component
const ProtectedRoute = ({ children, roles = [] }) => {
    const currentUser = authService.getCurrentUser();
    
    if (!currentUser) {
        return <Navigate to="/login" replace />;
    }

    // Giả sử currentUser.role là một string. Nếu là mảng, cần điều chỉnh logic.
    // Hoặc nếu role trong token là một object hoặc một trường khác (ví dụ: currentUser.rolesArray)
    const userRole = currentUser.role; // Ví dụ: "admin", "teacher", "student", "parent", "principal"

    if (roles.length > 0 && !roles.includes(userRole)) {
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

            {/* Protected Routes using MainLayout */}
            <Route
                path="/"
                element={
                    <ProtectedRoute>
                        <MainLayout />
                    </ProtectedRoute>
                }
            >
                <Route index element={<Home />} />
                <Route path="home" element={<Home />} />
                <Route path="profile" element={<UserProfile />} />
                
                <Route path="messaging" element={
                    <ProtectedRoute roles={[ 'teacher', 'parent', 'student']}>
                        <Messages />
                    </ProtectedRoute>
                } />
                <Route path="event-schedule" element={<EventSchedulePage />} />
                <Route path="petitions" element={<Petitions />} />
                <Route path="rewards-discipline" element={<RewardsDisciplinePage />} />
                <Route path="daily-log" element={<DailyLogPage />} />
                <Route path="academic-results" element={<AcademicResultsPage />} />
                <Route path="reports-statistics" element={<ReportsPage />} />

                <Route
                    path="user-management"
                    element={
                        <ProtectedRoute roles={['admin']}>
                            <UserManagementPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="class-management"
                    element={
                        <ProtectedRoute roles={['admin']}>
                            <ClassManagementPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="principal-dashboard"
                    element={
                        <ProtectedRoute roles={['principal', 'bgh']}>
                            <PrincipalDashboardPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="conversation-monitor"
                    element={
                        <ProtectedRoute roles={['admin']}>
                            <ConversationMonitorPage />
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