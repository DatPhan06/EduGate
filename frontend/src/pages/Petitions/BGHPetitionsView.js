import React from "react";
import AdminPetitionsView from "./AdminPetitionsView";

// BGHPetitionsView chỉ cho phép xem, không cho chỉnh sửa
const BGHPetitionsView = ({ userId }) => {
  // Truyền prop readOnly để AdminPetitionsView ẩn/disable các chức năng chỉnh sửa
  return <AdminPetitionsView userId={userId} readOnly={true} />;
};

export default BGHPetitionsView; 