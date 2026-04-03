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

---

## 🤖 4. Hướng dẫn thiết lập n8n Automation (Tự động hóa)

Hệ thống sử dụng **n8n** để tự động hóa các quy trình gửi email chăm sóc khách hàng (Cross-sell, Upsell, Retention).

### Các bước thiết lập:

1. **Khởi động n8n:**
   - Cài đặt n8n (nếu chưa có): `npm install n8n -g`
   - Chạy n8n bằng lệnh: `n8n start`
   - Truy cập giao diện quản lý tại: `http://localhost:5678`

2. **Import các Workflow mẫu:**
   - Trong giao diện n8n, chọn biểu tượng menu -> **Import from File**. Lần lượt import 3 file JSON có sẵn ở thư mục gốc dự án:
     - `n8n-wf1-cross-sell-hotel.json`: Gợi ý khách sạn sau khi khách đặt Tour.
     - `n8n-wf2-upsell-vip.json`: Gửi email mời nâng cấp lên gói dịch vụ VIP.
     - `n8n-wf3-retention-tour.json`: Gợi ý các chuyến đi mới cho khách hàng cũ.

3. **Cấu hình kết nối API & Authentication:**
   - Mở từng Workflow đã import, click vào các node **HTTP Request** (như *Get Bookings*, *Get Hotels*, *Get Tours*).
   - **URL:** Đảm bảo đường dẫn là `http://127.0.0.1:8000/api/...` (Sử dụng `127.0.0.1` thay vì `localhost` để tránh lỗi IPv6 trên một số máy).
   - **Authentication:** Tại tab *Parameters* -> *Headers*, tìm dòng `Authorization`. Hãy thay thế đoạn token cũ bằng Token Admin hiện tại của bạn:
     - 💡 *Mẹo:* Đăng nhập vào trang Admin -> Nhấn F12 -> Application -> LocalStorage -> Copy giá trị của `tw_token`. Sau đó dán vào n8n theo định dạng: `Bearer <token_vừa_copy>`.

4. **Kích hoạt hệ thống (Publish):**
   - Sau khi cấu hình xong, nhấn nút **Publish** ở góc trên bên phải màn hình n8n cho cả 3 workflow. Lúc này các chấm trạng thái sẽ chuyển sang màu xanh lá cây (**Active**).

5. **Vận hành và Kiểm tra:**
   - **Trên trang Admin:** Vào mục **Hệ thống > Tự động hóa**. Bấm nút **Test Trigger** để giả lập một lệnh gọi từ Laravel sang n8n.
   - **Tự động thực tế:** Khi bạn thay đổi trạng thái một đơn đặt chỗ trong trang **Quản lý Đặt chỗ**:
     - Chuyển đơn Tour sang **Confirmed** -> Kích hoạt gửi email gợi ý khách sạn.
     - Chuyển đơn Hotel sang **Confirmed** -> Kích hoạt gửi email mời nâng cấp VIP.
     - Chuyển đơn bất kỳ sang **Completed** -> Kích hoạt gửi email chăm sóc khách cũ.

