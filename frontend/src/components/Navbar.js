import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBell, faUser } from "@fortawesome/free-solid-svg-icons";
import styles from "./Navbar.module.css";
import authService from "../services/authService";

/**
 * Thành phần Navbar hiển thị thanh điều hướng của trang web.
 * Bao gồm các mục chính như Đặt Vé, Thông Tin Hành Trình, Khám Phá, QAirline và Tài Khoản.
 *
 * @component
 * @returns {JSX.Element} Thành phần Navbar.
 */
/**
 * Navbar component that renders the navigation bar with various menu items and user account options.
 * It also handles fetching notifications and user data, and displays notifications in a modal.
 *
 * @component
 * @returns {JSX.Element} The rendered Navbar component.
 *
 * @example
 * return (
 *   <Navbar />
 * )
 *
 * @function
 * @name Navbar
 *
 * @description
 * The Navbar component manages the state for menu and notification toggles, fetches user data and notifications,
 * and displays them in a dropdown and modal. It also provides navigation links for different sections of the application.
 *
 * @property {boolean} isMenuOpen - State to track if the menu is open.
 * @property {function} setIsMenuOpen - Function to set the state of isMenuOpen.
 * @property {boolean} isNotificationOpen - State to track if the notification dropdown is open.
 * @property {function} setIsNotificationOpen - Function to set the state of isNotificationOpen.
 * @property {Array} notifications - State to store the list of notifications.
 * @property {function} setNotifications - Function to set the state of notifications.
 * @property {Object|null} currentUser - State to store the current user data.
 * @property {function} setCurrentUser - Function to set the state of currentUser.
 * @property {Object|null} selectedNotification - State to store the selected notification for the modal.
 * @property {function} setSelectedNotification - Function to set the state of selectedNotification.
 * @property {boolean} isModalOpen - State to track if the notification modal is open.
 * @property {function} setIsModalOpen - Function to set the state of isModalOpen.
 * @property {string|null} token - The authentication token retrieved from localStorage.
 * @property {boolean} isLoggedIn - Boolean indicating if the user is logged in.
 *
 * @method fetchNotifications
 * @description Fetches notifications from the server and updates the notifications state.
 *
 * @method fetchUserAndNotifications
 * @description Fetches the current user data and their notifications if the user is logged in.
 *
 * @method toggleNotification
 * @description Toggles the state of the notification dropdown.
 *
 * @method toggleMenu
 * @description Toggles the state of the menu.
 *
 * @method handleNotificationClick
 * @description Handles the click event on a notification item, sets the selected notification, and opens the modal.
 *
 * @method handleCloseModal
 * @description Handles the event to close the notification modal.
 */
const Navbar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isNotificationOpen, setIsNotificationOpen] = useState(false);
  const [isAccountOpen, setIsAccountOpen] = useState(false);
  const navigate = useNavigate();
  const isLoggedIn = !!authService.getCurrentUser();

  const handleLogout = () => {
    authService.logout();
    navigate("/login");
  };

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const toggleNotification = () => {
    setIsNotificationOpen(!isNotificationOpen);
  };

  const toggleAccount = () => {
    setIsAccountOpen(!isAccountOpen);
  };

  return (
    <nav className={styles.nav}>
      <div className={styles.navContainer}>
        <div className={styles.navLeft}>
          <Link to="/" className={styles.logo}>
            <img src="/images/logo.png" alt="EduGate Logo" />
          </Link>
        </div>

        <div className={styles.navCenter}>
          <Link to="/" className={styles.navLink}>Trang chủ</Link>
          <Link to="/courses" className={styles.navLink}>Khóa học</Link>
          <Link to="/teachers" className={styles.navLink}>Giáo viên</Link>
          <Link to="/about" className={styles.navLink}>Giới thiệu</Link>
          <Link to="/contact" className={styles.navLink}>Liên hệ</Link>
        </div>

        <div className={styles.navRight}>
          {isLoggedIn ? (
            <>
              <div className={styles.notificationContainer}>
                <button className={styles.notificationButton} onClick={toggleNotification}>
                  <FontAwesomeIcon icon={faBell} />
                </button>
                {isNotificationOpen && (
                  <div className={styles.notificationDropdown}>
                    <div className={styles.notificationHeader}>
                      <h3>Thông báo</h3>
                    </div>
                    <div className={styles.notificationContent}>
                      <p>Không có thông báo mới</p>
                    </div>
                  </div>
                )}
              </div>

              <div className={styles.accountContainer}>
                <button className={styles.accountButton} onClick={toggleAccount}>
                  <FontAwesomeIcon icon={faUser} />
                </button>
                {isAccountOpen && (
                  <div className={styles.accountDropdown}>
                    <Link to="/profile" className={styles.dropdownItem}>Hồ sơ</Link>
                    <Link to="/settings" className={styles.dropdownItem}>Cài đặt</Link>
                    <button onClick={handleLogout} className={styles.dropdownItem}>Đăng xuất</button>
                  </div>
                )}
              </div>
            </>
          ) : (
            <div className={styles.authButtons}>
              <Link to="/login" className={styles.loginButton}>Đăng nhập</Link>
              <Link to="/register" className={styles.registerButton}>Đăng ký</Link>
            </div>
          )}
        </div>

        <button className={styles.menuButton} onClick={toggleMenu}>
          <span className={styles.menuIcon}></span>
        </button>
      </div>

      {/* Mobile Menu */}
      {isMenuOpen && (
        <div className={styles.mobileMenu}>
          <Link to="/" className={styles.mobileLink}>Trang chủ</Link>
          <Link to="/courses" className={styles.mobileLink}>Khóa học</Link>
          <Link to="/teachers" className={styles.mobileLink}>Giáo viên</Link>
          <Link to="/about" className={styles.mobileLink}>Giới thiệu</Link>
          <Link to="/contact" className={styles.mobileLink}>Liên hệ</Link>
          {!isLoggedIn && (
            <>
              <Link to="/login" className={styles.mobileLink}>Đăng nhập</Link>
              <Link to="/register" className={styles.mobileLink}>Đăng ký</Link>
            </>
          )}
        </div>
      )}
    </nav>
  );
};

export default Navbar;
