import React, { createContext, useState, useEffect, useContext } from 'react';
import axios from 'axios';

const AuthContext = createContext();

export function useAuth() {
  return useContext(AuthContext);
}

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Kiểm tra nếu người dùng đã đăng nhập
    const token = localStorage.getItem('token');
    if (token) {
      // Giả lập có người dùng đăng nhập sẵn để tránh lỗi
      const mockUser = {
        UserID: 1,
        FirstName: 'Admin',
        LastName: 'User',
        Email: 'admin@example.com',
        role: 'ADMIN',
        Status: 'ACTIVE'
      };
      setUser(mockUser);
    }
    setLoading(false);
  }, []);

  const value = {
    user,
    setUser,
    loading
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

export default AuthContext;