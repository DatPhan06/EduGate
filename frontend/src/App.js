import React from "react";
import { BrowserRouter as Router } from "react-router-dom";
import AppRoutes from "./routes/AppRoutes";
import { BGHTeacherProvider } from './contexts/BGHTeacherContext';

import "./styles/global.css";
import "./styles/variables.css";

const App = () => {
  return (
    <BGHTeacherProvider>
      <Router>
        <AppRoutes />
      </Router>
    </BGHTeacherProvider>
  );
};

export default App;
