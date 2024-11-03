<?php
session_start(); // Bắt đầu phiên làm việc

// Kiểm tra xem có dữ liệu POST không
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu JSON từ yêu cầu
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['section'])) {
        // Cập nhật giá trị của session
        $_SESSION['section_admin'] = $data['section'];
        echo json_encode(['message' => 'Section updated successfully']);
    } else {
        echo json_encode(['message' => 'No section provided']);
    }
} else {
    echo json_encode(['message' => 'Invalid request method']);
}
?>
