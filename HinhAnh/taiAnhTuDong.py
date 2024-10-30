import os
import requests

# Đường dẫn đến file txt chứa địa điểm du lịch
file_path = r"C:/xampp/htdocs/Travelforum/HinhAnh/diaDiemDuLich.txt"

# Hàm tải hình ảnh từ URL và lưu vào thư mục
def download_image(url, save_path):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Kiểm tra lỗi HTTP
        with open(save_path, 'wb') as file:
            file.write(response.content)
        print(f"Đã tải hình: {save_path}")
    except Exception as e:
        print(f"Không thể tải hình từ {url}. Lỗi: {e}")

# Đọc file và tải hình ảnh
with open(file_path, 'r', encoding='utf-8') as file:
    lines = file.readlines()

current_province = ""
for line in lines:
    line = line.strip()
    if line:  # Bỏ qua dòng trống
        if line[0].isdigit():  # Dòng mới bắt đầu với số, có nghĩa là tên tỉnh
            current_province = line.split('.')[1].strip()  # Lấy tên tỉnh
        elif line.startswith('-'):  # Dòng địa điểm
            parts = line.split(' ')
            image_url = parts[-1] if parts[-1].startswith('http') else None
            place_name = ' '.join(parts[:-1]).strip().lstrip('- ') if image_url else line.strip().lstrip('- ')
            
            if image_url:
                print(f"Tải hình từ URL: {image_url}")  # In ra URL
                # Tạo thư mục cho tỉnh nếu chưa tồn tại
                province_folder = os.path.join(r"C:/xampp/htdocs/Travelforum/HinhAnh", current_province)
                if not os.path.exists(province_folder):
                    os.makedirs(province_folder)
                # Tạo đường dẫn cho file hình ảnh
                image_filename = f"{place_name}.jpg".replace('/', '_').replace(' ', '_')  # Đặt tên cho file hình ảnh
                image_path = os.path.join(province_folder, image_filename)
                # Tải hình ảnh
                download_image(image_url.strip(), image_path)  # Dùng strip để loại bỏ khoảng trắng
            else:
                print(f"Không có URL cho địa điểm: {line}")

# In ra thư mục đã tải hình
print(f"Các hình đã được tải vào thư mục: {os.path.join(r'C:/xampp/htdocs/Travelforum/HinhAnh', current_province)}")
