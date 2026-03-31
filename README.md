# ✈️ TravelWise - Hệ thống Quản lý Kênh Đặt phòng & Tour Du Lịch

Một ứng dụng được chia thành hai phần riêng biệt: Frontend (dành cho client/admin giao diện web) và Backend (hệ thống API Laravel xử lý logic và cơ sở dữ liệu).

## 📁 Cấu trúc dự án

- `/fe`: Toàn bộ mã nguồn Frontend sử dụng HTML, Tailwind CSS, và Vanilla JavaScript.
- `/be`: Hệ thống API Backend viết bằng **Laravel (PHP)** kết nối với cơ sở dữ liệu **PostgreSQL**.

---

## 💻 1. Hướng Cài đặt và Chạy BE (Backend - Laravel)

### Yêu cầu hệ thống:

- PHP >= 8.2 (Bật các extensions cơ bản: pdo_pgsql, pgsql, bz2, curl, mbstring, openssl).
- PostgreSQL (dùng user/password quản lý DB).
- Composer.

### Các bước chạy:

1. Mở terminal tại thư mục `be`: `cd be`
2. Cài đặt các thư viện gói cho Laravel: `composer install`
3. Cấu hình file môi trường:
   - Copy file `.env.example` thành `.env`
   - Chỉnh sửa kết nối DB trong `.env`: `DB_CONNECTION=pgsql`, `DB_HOST=127.0.0.1`, `DB_PORT=5432`, `DB_DATABASE=travelwise`, `DB_USERNAME=postgres`, `DB_PASSWORD=your_password`
4. Tạo JWT Secret Key: `php artisan jwt:secret`
5. Tạo application key: `php artisan key:generate`
6. Chạy migrate để tạo bảng: `php artisan migrate` (và `php artisan db:seed` nếu có seed data).
7. Khởi động server BE: `php artisan serve` (Server BE sẽ mặc định chạy trên cổng `http://localhost:8000`).

---

## 🎨 2. Hướng Cài đặt và Chạy FE (Frontend - HTML/JS)

### Kiến trúc FE:

- `/fe/client`: Giao diện đặt tour, hotel dành cho khách hàng chung.
- `/fe/admin`: Giao diện hệ thống quản lý dữ liệu (Dashboard) cho admin.
- `/fe/design-system`: Chứa hướng dẫn UI style, components chung.
- `/fe/js`: Mã nguồn logic tương tác API và Component (`api.js` đóng vai trò giao tiếp).

### Các bước chạy:

1. Dự án FE sử dụng Tailwind CDN nên có thể mở trực tiếp các file HTML bằng trình duyệt.
2. Tuy nhiên, do FE dùng RESTful API và có hệ CORS, khuyến cáo bạn sử dụng máy chủ nội bộ.
   👉 **Cách đơn giản nhất:** Dùng tiện ích mở rộng **Live Server** trong VS Code để mở thư mục `/fe`. (Chuột phải file `fe/client/index.html` chọn Open with Live Server – chạy qua `http://127.0.0.1:5500`).
3. Đảm bảo Backend hệ thống phân quyền của Laravel đã chạy ở nền (`http://localhost:8000`).

---

## 🤝 3. Quy trình tương tác API / Luồng Authentication

- Các file bên FE khi cần tải hay đẩy dữ liệu, chúng sẽ gọi hàm thông qua `fe/js/api.js`.
- File này sẽ tiến hành fetch request định dạng `application/json` qua lại thông qua domain `http://localhost:8000/api`.
- Sau khi User/Admin tiến hành SignIn, BE trả về 1 Token. Token này sẽ được cất giữ ở Frontend qua localStorage mang tên `tw_token`.
- Các phiên request sau đều đi qua Middleware bảo vệ bên BE (`auth:api`) và bắt buộc header truyền vào phải có định dạng `Authorization: Bearer <tw_token>`.
