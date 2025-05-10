import React, { createContext, useContext, useState, useEffect } from "react";
import axios from "axios";
import authService from "../services/authService";

const BGHTeacherContext = createContext();

export const useBGHTeacher = () => useContext(BGHTeacherContext);

export const BGHTeacherProvider = ({ children }) => {
  const [isBGHTeacher, setIsBGHTeacher] = useState(false);
  const [checked, setChecked] = useState(false);
  const currentUser = authService.getCurrentUser();

  useEffect(() => {
    const checkBGH = async () => {
      const token = authService.getToken();
      if (!token) {
        setIsBGHTeacher(false);
        setChecked(true);
        return;
      }
      try {
        if (currentUser?.role === "teacher") {
          const res = await axios.get(
            (process.env.REACT_APP_API_URL || "http://localhost:8000") + "/users/is-bgh-teacher",
            { headers: { Authorization: `Bearer ${token}` } }
          );
          setIsBGHTeacher(res.data.is_bgh_teacher === true);
        } else {
          setIsBGHTeacher(false);
        }
      } catch {
        setIsBGHTeacher(false);
      }
      setChecked(true);
    };
    checkBGH();
  }, [currentUser]);

  return (
    <BGHTeacherContext.Provider value={{ isBGHTeacher, checked }}>
      {children}
    </BGHTeacherContext.Provider>
  );
}; 