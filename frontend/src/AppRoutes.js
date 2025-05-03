import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from '../contexts/AuthContext';
import Login from './pages/Users/Login';
import Register from './pages/Users/Register';
import authService from './services/authService';
import Home from './pages/Home';

const PrivateRoute = ({ children }) => {
    const user = authService.getCurrentUser();
    return user ? children : <Navigate to="/login" />;
};

const AppRoutes = () => {
    return (
        <AuthProvider>
            <Routes>
                <Route path="/login" element={<Login />} />
                <Route path="/register" element={<Register />} />
                <Route
                    path="/"
                    element={
                        <PrivateRoute>
                            <Home />
                        </PrivateRoute>
                    }
                />
            </Routes>
        </AuthProvider>
    );
};

export default AppRoutes;
