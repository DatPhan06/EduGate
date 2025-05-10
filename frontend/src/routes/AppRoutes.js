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
import UserManagementPage from '../pages/Admin/UserManagementPage';
import EventSchedulePage from '../pages/EventSchedule/EventSchedulePage';
import RewardsDisciplinePage from '../pages/RewardsDiscipline/RewardsDisciplinePage';
import DailyLogPage from '../pages/DailyLog/DailyLogPage';
import AcademicResultsPage from '../pages/AcademicResults/AcademicResultsPage';
import ReportsPage from '../pages/Reports/ReportsPage';
import PrincipalDashboardPage from '../pages/Principal/PrincipalDashboardPage';
import ClassManagementPage from '../pages/Admin/ClassManagementPage';
import ConversationMonitorPage from '../pages/Admin/ConversationMonitorPage';
import DepartmentManagementPage from '../pages/Admin/DepartmentManagementPage';
import TimetableManagementPage from '../pages/Admin/TimetableManagementPage';
import GradeManagementPage from '../pages/Admin/GradeManagementPage';
import TimetableViewComponent from '../components/Timetable/TimetableViewComponent';
import ClassEventsPage from '../pages/ClassEventsPage';
import TeacherClassEventsPage from '../pages/Teacher/TeacherClassEventsPage';
import StudentClassEventsPage from '../pages/Student/StudentClassEventsPage';


// Teacher Pages
import HomeroomClassPage from '../pages/Teacher/HomeroomClassPage';
import HomeroomStudentsPage from '../pages/Teacher/HomeroomStudentsPage';
import StudentGradesPage from '../pages/Teacher/StudentGradesPage';
import TeachingSubjectsPage from '../pages/Teacher/TeachingSubjectsPage';
import ClassSubjectStudentsPage from '../pages/Teacher/ClassSubjectStudentsPage';
import SubjectStudentGradesPage from '../pages/Teacher/SubjectStudentGradesPage';
import HomeroomClassGradesPage from '../pages/Teacher/HomeroomClassGradesPage';
import TeacherRewardsDisciplinePage from '../pages/Teacher/TeacherRewardsDisciplinePage';

// Student Pages
import StudentGradesViewPage from '../pages/Student/StudentGradesViewPage';

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
                <Route path="event-schedule" element={
                                        <ProtectedRoute roles={[ 'teacher', 'parent', 'student']}>
                        <EventSchedulePage />
                    </ProtectedRoute>
                } />
                <Route path="petitions" element={
                    <ProtectedRoute roles={['parent']}>
                        <Petitions />
                    </ProtectedRoute>
                } />
                <Route path="petitions-management" element={
                    <ProtectedRoute roles={[ 'admin']}>
                        <Petitions />
                    </ProtectedRoute>
                } />
                <Route path="rewards-discipline" element={
                    <ProtectedRoute roles={['admin', 'parent', 'student']}>
                        <RewardsDisciplinePage />
                    </ProtectedRoute>
                } />
                <Route path="daily-log" element={
                    <ProtectedRoute roles={[ 'teacher', 'parent', 'student']}>
                        <DailyLogPage />
                    </ProtectedRoute>
                } />
                <Route path="academic-results" element={
                    <ProtectedRoute roles={[ 'teacher', 'parent', 'student']}>
                        <AcademicResultsPage />
                    </ProtectedRoute>
                } />

                {/* Teacher Homeroom Routes */}
                <Route
                    path="teacher/homeroom"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <HomeroomClassPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/homeroom/:classId/students"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <HomeroomStudentsPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/homeroom/:classId/grades"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <HomeroomClassGradesPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/homeroom/:classId/student/:studentId/grades"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <StudentGradesPage />
                        </ProtectedRoute>
                    }
                />

                {/* Teacher Subject Grade Management Routes */}
                <Route
                    path="teacher/subjects"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <TeachingSubjectsPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/subjects/:classSubjectId/students"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <ClassSubjectStudentsPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/subjects/:classSubjectId/student/:studentId/grades"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <SubjectStudentGradesPage />
                        </ProtectedRoute>
                    }
                />
                
                {/* Teacher Rewards and Discipline Management */}
                <Route
                    path="teacher/rewards-discipline"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <TeacherRewardsDisciplinePage />
                        </ProtectedRoute>
                    }
                />

                {/* Class Events Routes */}
                <Route
                    path="class-events/:classId"
                    element={
                        <ProtectedRoute roles={['admin', 'teacher', 'student', 'parent']}>
                            <ClassEventsPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="teacher/class-events"
                    element={
                        <ProtectedRoute roles={['teacher']}>
                            <TeacherClassEventsPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="student/class-events"
                    element={
                        <ProtectedRoute roles={['student']}>
                            <StudentClassEventsPage />
                        </ProtectedRoute>
                    }
                />

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
                    path="department-management"
                    element={
                        <ProtectedRoute roles={['admin']}>
                            <DepartmentManagementPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="timetable-view"
                    element={
                        <ProtectedRoute roles={['admin', 'teacher', 'student', 'parent']}>
                            <TimetableViewComponent />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="timetable-management"
                    element={
                        <ProtectedRoute roles={['admin', 'teacher', 'student', 'parent']}>
                            <TimetableManagementPage />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="grade-management"
                    element={
                        <ProtectedRoute roles={['admin']}>
                            <GradeManagementPage />
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
                
                {/* Student Routes */}
                <Route
                    path="student/grades"
                    element={
                        <ProtectedRoute roles={['student', 'parent']}>
                            <StudentGradesViewPage />
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