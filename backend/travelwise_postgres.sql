-- ============================================================
-- TravelWise Database Schema - PostgreSQL
-- Hệ thống đặt tour và khách sạn
-- Created: 2026-03-28
-- ============================================================

-- Tạo database (chạy lệnh này với quyền superuser nếu cần)
-- CREATE DATABASE travelwise ENCODING 'UTF8';
-- \c travelwise

-- Extension hỗ trợ UUID (tuỳ chọn)
-- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- XÓA BẢNG CŨ NẾU TỒN TẠI (drop theo thứ tự FK)
-- ============================================================
DROP TABLE IF EXISTS automation_logs        CASCADE;
DROP TABLE IF EXISTS recommendation_rules   CASCADE;
DROP TABLE IF EXISTS notifications          CASCADE;
DROP TABLE IF EXISTS wishlists              CASCADE;
DROP TABLE IF EXISTS booking_addons         CASCADE;
DROP TABLE IF EXISTS addons                 CASCADE;
DROP TABLE IF EXISTS reviews                CASCADE;
DROP TABLE IF EXISTS promo_codes            CASCADE;
DROP TABLE IF EXISTS bookings               CASCADE;
DROP TABLE IF EXISTS hotels                 CASCADE;
DROP TABLE IF EXISTS tours                  CASCADE;
DROP TABLE IF EXISTS destinations           CASCADE;
DROP TABLE IF EXISTS users                  CASCADE;

-- ============================================================
-- ENUM TYPES
-- ============================================================
CREATE TYPE user_role        AS ENUM ('client', 'admin');
CREATE TYPE user_status      AS ENUM ('active', 'blocked');
CREATE TYPE dest_status      AS ENUM ('active', 'inactive');
CREATE TYPE item_status      AS ENUM ('active', 'inactive');
CREATE TYPE availability_t   AS ENUM ('available', 'selling-fast', 'sold-out');
CREATE TYPE booking_status   AS ENUM ('Pending', 'Confirmed', 'Completed', 'Cancelled');
CREATE TYPE service_type     AS ENUM ('tour', 'hotel');
CREATE TYPE review_status    AS ENUM ('published', 'hidden');
CREATE TYPE promo_status     AS ENUM ('active', 'expired', 'disabled');
CREATE TYPE rule_type        AS ENUM ('cross-sell', 'upsell');
CREATE TYPE log_status       AS ENUM ('success', 'failure');
CREATE TYPE notif_type       AS ENUM ('booking', 'promo', 'system');

-- ============================================================
-- HÀM TỰ ĐỘNG CẬP NHẬT updated_at
-- ============================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 1. BẢNG USERS
-- ============================================================
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    phone       VARCHAR(20),
    avatar_url  VARCHAR(500),
    role        user_role    DEFAULT 'client',
    status      user_status  DEFAULT 'active',
    created_at  TIMESTAMP    DEFAULT NOW(),
    updated_at  TIMESTAMP    DEFAULT NOW()
);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 2. BẢNG DESTINATIONS
-- ============================================================
CREATE TABLE destinations (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    name        VARCHAR(100) NOT NULL,
    keyword     VARCHAR(100),
    image_url   VARCHAR(500),
    description TEXT,
    status      dest_status DEFAULT 'active',
    created_at  TIMESTAMP   DEFAULT NOW()
);

-- ============================================================
-- 3. BẢNG TOURS
-- ============================================================
CREATE TABLE tours (
    id               SERIAL PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    image_url        VARCHAR(500),
    image_alt        VARCHAR(200),
    destination_id   INT REFERENCES destinations(id) ON DELETE SET NULL,
    location         VARCHAR(100),
    full_location    VARCHAR(200),
    duration         VARCHAR(50),
    includes         VARCHAR(500),
    description      TEXT,
    price_per_person NUMERIC(10, 2) NOT NULL DEFAULT 0,
    discount         INT           DEFAULT 0,
    badge            VARCHAR(50),
    rating           NUMERIC(3, 1) DEFAULT 0,
    review_count     INT           DEFAULT 0,
    status           item_status   DEFAULT 'active',
    created_at       TIMESTAMP     DEFAULT NOW(),
    updated_at       TIMESTAMP     DEFAULT NOW()
);

CREATE TRIGGER trg_tours_updated_at
    BEFORE UPDATE ON tours
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 4. BẢNG HOTELS
-- ============================================================
CREATE TABLE hotels (
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(200) NOT NULL,
    image_url        VARCHAR(500),
    image_alt        VARCHAR(200),
    destination_id   INT REFERENCES destinations(id) ON DELETE SET NULL,
    location         VARCHAR(100),
    full_location    VARCHAR(200),
    feature          VARCHAR(100),
    description      TEXT,
    price_per_night  NUMERIC(10, 2) NOT NULL DEFAULT 0,
    discount         INT            DEFAULT 0,
    badge            VARCHAR(50),
    availability     availability_t DEFAULT 'available',
    rating           NUMERIC(3, 1)  DEFAULT 0,
    review_count     INT            DEFAULT 0,
    status           item_status    DEFAULT 'active',
    created_at       TIMESTAMP      DEFAULT NOW(),
    updated_at       TIMESTAMP      DEFAULT NOW()
);

CREATE TRIGGER trg_hotels_updated_at
    BEFORE UPDATE ON hotels
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 5. BẢNG BOOKINGS
-- ============================================================
CREATE TABLE bookings (
    id              SERIAL PRIMARY KEY,
    code            VARCHAR(20) UNIQUE,
    user_id         INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_type    service_type   NOT NULL,
    service_id      INT            NOT NULL,
    service_name    VARCHAR(200),
    check_in_date   DATE,
    check_out_date  DATE,
    guests          INT            DEFAULT 1,
    total_price     NUMERIC(10, 2) NOT NULL DEFAULT 0,
    discount_code   VARCHAR(50),
    status          booking_status DEFAULT 'Pending',
    note            TEXT,
    created_at      TIMESTAMP      DEFAULT NOW(),
    updated_at      TIMESTAMP      DEFAULT NOW()
);

CREATE TRIGGER trg_bookings_updated_at
    BEFORE UPDATE ON bookings
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 6. BẢNG ADD-ONS
-- ============================================================
CREATE TABLE addons (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    name        VARCHAR(200)   NOT NULL,
    description TEXT,
    price       NUMERIC(10, 2) NOT NULL DEFAULT 0,
    status      item_status    DEFAULT 'active'
);

-- ============================================================
-- 7. BẢNG BOOKING_ADDONS
-- ============================================================
CREATE TABLE booking_addons (
    id          SERIAL PRIMARY KEY,
    booking_id  INT NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    addon_id    INT NOT NULL REFERENCES addons(id)   ON DELETE CASCADE,
    quantity    INT            DEFAULT 1,
    price       NUMERIC(10, 2)
);

-- ============================================================
-- 8. BẢNG REVIEWS
-- ============================================================
CREATE TABLE reviews (
    id           SERIAL PRIMARY KEY,
    code         VARCHAR(20) UNIQUE,
    user_id      INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_type service_type  NOT NULL,
    service_id   INT           NOT NULL,
    service_name VARCHAR(200),
    rating       SMALLINT      NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment      TEXT,
    status       review_status DEFAULT 'published',
    created_at   TIMESTAMP     DEFAULT NOW()
);

-- ============================================================
-- 9. BẢNG WISHLISTS
-- ============================================================
CREATE TABLE wishlists (
    id           SERIAL PRIMARY KEY,
    user_id      INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_type service_type NOT NULL,
    service_id   INT          NOT NULL,
    created_at   TIMESTAMP    DEFAULT NOW(),
    UNIQUE (user_id, service_type, service_id)
);

-- ============================================================
-- 10. BẢNG PROMO_CODES
-- ============================================================
CREATE TABLE promo_codes (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    promo_code  VARCHAR(50)    NOT NULL UNIQUE,
    type        VARCHAR(50),
    value_num   NUMERIC(10, 2) NOT NULL DEFAULT 0,
    is_percent  BOOLEAN        DEFAULT TRUE,
    use_limit   INT            DEFAULT 0,
    used_count  INT            DEFAULT 0,
    expiry_date DATE,
    status      promo_status   DEFAULT 'active',
    created_at  TIMESTAMP      DEFAULT NOW()
);

-- ============================================================
-- 11. BẢNG RECOMMENDATION_RULES
-- ============================================================
CREATE TABLE recommendation_rules (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    trigger_kw  VARCHAR(200) NOT NULL,
    suggestion  VARCHAR(500) NOT NULL,
    type        rule_type    DEFAULT 'cross-sell',
    is_active   BOOLEAN      DEFAULT TRUE,
    created_at  TIMESTAMP    DEFAULT NOW()
);

-- ============================================================
-- 12. BẢNG AUTOMATION_LOGS
-- ============================================================
CREATE TABLE automation_logs (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) UNIQUE,
    event       VARCHAR(500) NOT NULL,
    status      log_status   DEFAULT 'success',
    payload     JSONB,
    created_at  TIMESTAMP    DEFAULT NOW()
);

-- ============================================================
-- 13. BẢNG NOTIFICATIONS
-- ============================================================
CREATE TABLE notifications (
    id          SERIAL PRIMARY KEY,
    user_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(200),
    message     TEXT,
    type        notif_type DEFAULT 'system',
    is_read     BOOLEAN    DEFAULT FALSE,
    created_at  TIMESTAMP  DEFAULT NOW()
);

-- ============================================================
-- INDEX tăng tốc truy vấn
-- ============================================================
CREATE INDEX idx_tours_destination    ON tours(destination_id);
CREATE INDEX idx_hotels_destination   ON hotels(destination_id);
CREATE INDEX idx_bookings_user        ON bookings(user_id);
CREATE INDEX idx_bookings_service     ON bookings(service_type, service_id);
CREATE INDEX idx_reviews_service      ON reviews(service_type, service_id);
CREATE INDEX idx_wishlists_user       ON wishlists(user_id);
CREATE INDEX idx_notifications_user   ON notifications(user_id, is_read);
CREATE INDEX idx_automation_logs_time ON automation_logs(created_at DESC);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Users (password = hash của 'password123')
INSERT INTO users (code, name, email, password, role, status, created_at) VALUES
('USR-001', 'Nguyễn Văn A',  'vana@gmail.com',      md5('password123'), 'client', 'active',  '2024-01-12'),
('USR-002', 'Trần Thị B',    'thib@gmail.com',      md5('password123'), 'client', 'active',  '2024-02-15'),
('USR-003', 'Lê Văn C',      'vanc@gmail.com',      md5('password123'), 'client', 'blocked', '2024-02-20'),
('USR-004', 'Phạm Minh D',   'minhd@gmail.com',     md5('password123'), 'client', 'active',  '2024-03-05'),
('ADM-001', 'Admin',         'admin@travelwise.vn', md5('admin2024'),   'admin',  'active',  '2024-01-01');

-- Destinations
INSERT INTO destinations (code, name, keyword, image_url, description, status) VALUES
('dest-1',  'Vũng Tàu',        'Vũng Tàu',        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=800', 'Thành phố biển nổi tiếng gần TP. Hồ Chí Minh.', 'active'),
('dest-2',  'Đà Lạt',          'Đà Lạt',          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=800', 'Thành phố ngàn hoa với khí hậu mát mẻ, thơ mộng.', 'active'),
('dest-3',  'Sapa',            'Sapa',            'https://images.unsplash.com/photo-1627894005416-541a7f367b65?q=80&w=800', 'Vùng núi phía Bắc với ruộng bậc thang ngoạn mục.', 'active'),
('dest-4',  'Hội An',          'Hội An',          'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800', 'Phố cổ di sản thế giới với đèn lồng lung linh.', 'active'),
('dest-5',  'Phú Quốc',        'Phú Quốc',        'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=800', 'Đảo ngọc thiên nhiên với bãi biển trắng mịn.', 'active'),
('dest-6',  'Hà Nội',          'Hà Nội',          'https://images.unsplash.com/photo-1523592121529-f6dde35f079e?q=80&w=800', 'Thủ đô nghìn năm văn hiến với Hồ Gươm.', 'active'),
('dest-7',  'TP. Hồ Chí Minh', 'TP. Hồ Chí Minh', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=800', 'Thành phố năng động nhất Việt Nam.', 'active'),
('dest-8',  'Đà Nẵng',         'Đà Nẵng',         'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800', 'Thành phố đáng sống bên bờ biển Mỹ Khê.', 'active'),
('dest-9',  'Ý',               'Ý',               NULL, 'Đất nước hình chiếc ủng với lịch sử và văn hóa lâu đời.', 'active'),
('dest-10', 'Thụy Sĩ',         'Thụy Sĩ',         NULL, 'Đất nước của dãy Alps và đồng hồ nổi tiếng.', 'active'),
('dest-11', 'Nhật Bản',        'Nhật Bản',        NULL, 'Xứ sở hoa anh đào với nền văn hóa độc đáo.', 'active'),
('dest-12', 'Maldives',        'Maldives',        NULL, 'Thiên đường biển đảo nhiệt đới.', 'active');

-- Tours
INSERT INTO tours (title, image_url, image_alt, location, full_location, duration, includes, description, price_per_person, discount, badge, rating, review_count, status) VALUES
('Khám phá bờ biển Amalfi',        'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=1200', 'Amalfi Coast',   'Ý',        'Bờ biển Amalfi, Ý',         '8 NGÀY',  'Hotels, Meals, Guide',             'Trải nghiệm vẻ đẹp ngoạn mục của phong cảnh thiên nhiên tại Ý.',             1899.00, 15, 'BEST SELLER', 9.2, 1284, 'active'),
('Cuộc phiêu lưu dãy Alps Thụy Sĩ','https://images.unsplash.com/photo-1531310197839-ccf54634509e?q=80&w=1200', 'Swiss Alps',     'Thụy Sĩ',  'Dãy Alps, Thụy Sĩ',         '6 NGÀY',  'Trains, Chalets, Skiing',          'Khám phá những đỉnh núi tuyết phủ trắng xóa của dãy Alps.',                 2450.00,  0, 'FEATURED',   9.8,  840, 'active'),
('Hành trình di sản Kyoto',        'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=800',  'Kyoto Temple',   'Nhật Bản', 'Kyoto, Nhật Bản',            '10 NGÀY', 'Ryokans, Tea Ceremony, Transport', 'Đắm mình vào không gian cổ kính của cố đô Kyoto.',                           1550.00,  0, NULL,         9.5, 2100, 'active'),
('Sapa Misty Mountains',           'https://images.unsplash.com/photo-1504457047772-27fad17af0ec?q=80&w=1200', 'Sapa Mountains', 'Việt Nam', 'Sapa, Lào Cai, Việt Nam',   '3 NGÀY',  'Trekking, Home Stay, Guide',       'Chinh phục đỉnh Fansipan và khám phá vẻ đẹp hoang sơ của Sapa.',             150.00,  0, 'POPULAR',    8.9, 1500, 'active'),
('Kỳ nghỉ lãng mạn tại Maldives', 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1200', 'Maldives',       'Maldives', 'Đảo san hô, Maldives',      '7 NGÀY',  'Water Villa, Flights',             'Tận hưởng kỳ nghỉ sang trọng trên những hòn đảo thiên đường Maldives.',      3200.00,  0, 'LUXURY',     9.9,  450, 'active');

-- Hotels
INSERT INTO hotels (name, image_url, image_alt, location, full_location, feature, description, price_per_night, discount, badge, availability, rating, review_count, status) VALUES
('An Home - Phòng đơn Vũng Tàu',   'https://cf.bstatic.com/xdata/images/hotel/max1024x768/438865324.jpg',   'An Home',      'Vũng Tàu', 'Vũng Tàu, Việt Nam',           'Gần biển',  'An Home cung cấp không gian nghỉ ngơi ấm cúng tại trung tâm thành phố biển.',   15.00,  0, 'TOP RATED',  'available',    9.1,  428, 'active'),
('The Song Vũng Tàu Xinh',         'https://cf.bstatic.com/xdata/images/hotel/max1280x900/414436894.jpg',   'The Song',     'Vũng Tàu', 'Vũng Tàu, Việt Nam',           'View biển', 'Căn hộ cao cấp tại The Sóng với đầy đủ tiện nghi và tầm nhìn hướng biển.',      18.00, 20, 'BEST SELLER','available',    9.1,  312, 'active'),
('Căn hộ The Sóng - Mai Villa',    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/415510619.jpg',   'Mai Villa',    'Vũng Tàu', 'Vũng Tàu, Việt Nam',           'Sang trọng','Trải nghiệm không gian sống thượng lưu tại Mai Villa.',                         22.00,  0, 'LUXURY',     'selling-fast', 8.8, 1200, 'active'),
('THE SÓNG - TRINH''S HOUSE',      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/414436894.jpg',   'Trinh House',  'Vũng Tàu', 'Vũng Tàu, Việt Nam',           'Ấm cúng',  'Trinh House mang đến cảm giác thân thuộc như chính ngôi nhà của bạn.',          19.00,  0, NULL,         'available',    8.2,   56, 'active'),
('Dalat Palace Heritage Hotel',    'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800','Dalat Palace', 'Đà Lạt',   'Đà Lạt, Lâm Đồng, Việt Nam',  'Di sản',   'Khách sạn di sản hàng đầu tại Đà Lạt với kiến trúc Pháp cổ điển.',             100.00,  0, NULL,         'available',    9.5, 1200, 'active'),
('Terracotta Hotel & Resort Dalat','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=800','Terracotta',  'Đà Lạt',   'Hồ Tuyền Lâm, Đà Lạt',        'Resort',   'Khu nghỉ dưỡng nép mình bên hồ Tuyền Lâm mộng mơ.',                            80.00,  0, NULL,         'available',    8.9, 3400, 'active');

-- Bookings
INSERT INTO bookings (code, user_id, service_type, service_id, service_name, check_in_date, total_price, status) VALUES
('BK-1001', 1, 'tour',  1, 'Khám phá bờ biển Amalfi',      '2024-03-20', 1899.00, 'Pending'),
('BK-1002', 2, 'tour',  4, 'Sapa Misty Mountains',          '2024-03-22',  150.00, 'Confirmed'),
('BK-1003', 1, 'hotel', 1, 'An Home - Phòng đơn Vũng Tàu', '2024-03-25',   85.00, 'Completed'),
('BK-1004', 4, 'tour',  2, 'Cuộc phiêu lưu dãy Alps',      '2024-04-01', 2450.00, 'Cancelled');

-- Add-ons
INSERT INTO addons (code, name, description, price) VALUES
('ADD-01', 'Bảo hiểm du lịch toàn diện', 'Bảo vệ bạn trước mọi rủi ro về sức khỏe và hành lý.', 15.00),
('ADD-02', 'Xe đưa đón sân bay',          'Đón tận nơi, đúng giờ bằng xe đời mới.',              25.00),
('ADD-03', 'SIM du lịch 4G tốc độ cao',  'Luôn kết nối mọi lúc mọi nơi.',                       10.00);

-- Reviews
INSERT INTO reviews (code, user_id, service_type, service_id, service_name, rating, comment, status) VALUES
('REV-001', 1, 'hotel', 1, 'An Home - Phòng đơn Vũng Tàu', 5, 'Dịch vụ tuyệt vời, phòng sạch sẽ!',             'published'),
('REV-002', 2, 'tour',  1, 'Khám phá bờ biển Amalfi',       4, 'Chuyến đi rất thú vị nhưng thời gian hơi gấp.', 'published'),
('REV-003', 3, 'tour',  4, 'Sapa Misty Mountains',           1, 'Quá tệ, tôi sẽ không quay lại!',                'hidden');

-- Promo Codes
INSERT INTO promo_codes (code, promo_code, type, value_num, is_percent, use_limit, used_count, expiry_date, status) VALUES
('PROMO-001', 'WINTER2024', 'Dịch vụ', 10,     TRUE,  500, 123, '2024-12-31', 'active'),
('PROMO-002', 'WELCOMENEW', 'Tất cả',  100000, FALSE,   0,  87, NULL,         'active'),
('PROMO-003', 'SUMMERVIBE', 'Tour',    15,     TRUE,  200, 200, '2024-08-30', 'expired');

-- Recommendation Rules
INSERT INTO recommendation_rules (code, trigger_kw, suggestion, type, is_active) VALUES
('RULE-001', 'Sapa',    'Tour Trekking Fansipan',              'cross-sell', TRUE),
('RULE-002', 'Hội An',  'Vé show Ký Ức Hội An',               'cross-sell', TRUE),
('RULE-003', 'Luxury',  'Dịch vụ đưa đón VIP bằng Limousine', 'upsell',     FALSE);

-- Automation Logs
INSERT INTO automation_logs (code, event, status) VALUES
('LOG-001', 'Email xác nhận BK-1002', 'success'),
('LOG-002', 'Gợi ý tour mới USR-004', 'success'),
('LOG-003', 'Lỗi gửi email USR-003',  'failure');

-- ============================================================
-- KIỂM TRA DỮ LIỆU
-- ============================================================
-- SELECT * FROM users;
-- SELECT * FROM destinations;
-- SELECT * FROM tours;
-- SELECT * FROM hotels;
-- SELECT * FROM bookings;
