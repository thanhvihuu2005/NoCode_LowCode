<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Destination;
use App\Models\Tour;
use App\Models\Hotel;
use App\Models\Booking;
use App\Models\Review;
use App\Models\PromoCode;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ── Users ─────────────────────────────────────────────────
        $admin = User::create([
            'code' => 'ADM-001',
            'name' => 'Admin TravelWise',
            'email' => 'admin@travelwise.vn',
            'password' => Hash::make('admin123'),
            'phone' => '0901234567',
            'role' => 'admin',
            'status' => 'active',
        ]);

        $user1 = User::create([
            'code' => 'USR-001',
            'name' => 'Nguyễn Văn A',
            'email' => 'vana@gmail.com',
            'password' => Hash::make('password123'),
            'phone' => '0901111111',
            'role' => 'client',
            'status' => 'active',
        ]);

        $user2 = User::create([
            'code' => 'USR-002',
            'name' => 'Trần Thị B',
            'email' => 'thib@gmail.com',
            'password' => Hash::make('password123'),
            'phone' => '0902222222',
            'role' => 'client',
            'status' => 'active',
        ]);

        $user3 = User::create([
            'code' => 'USR-003',
            'name' => 'Lê Văn C',
            'email' => 'vanc@gmail.com',
            'password' => Hash::make('password123'),
            'phone' => '0903333333',
            'role' => 'client',
            'status' => 'blocked',
        ]);

        $user4 = User::create([
            'code' => 'USR-004',
            'name' => 'Phạm Minh D',
            'email' => 'minhd@gmail.com',
            'password' => Hash::make('password123'),
            'phone' => '0904444444',
            'role' => 'client',
            'status' => 'active',
        ]);

        // ── Destinations ─────────────────────────────────────────
        $dest1 = Destination::create([
            'code' => 'dest-1',
            'name' => 'Vũng Tàu',
            'keyword' => 'Vũng Tàu',
            'image_url' => 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=800',
            'description' => 'Thành phố biển nổi tiếng gần TP. Hồ Chí Minh.',
            'status' => 'active',
        ]);

        $dest2 = Destination::create([
            'code' => 'dest-2',
            'name' => 'Đà Lạt',
            'keyword' => 'Đà Lạt',
            'image_url' => 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=800',
            'description' => 'Thành phố ngàn hoa với khí hậu mát mẻ, thơ mộng.',
            'status' => 'active',
        ]);

        $dest3 = Destination::create([
            'code' => 'dest-3',
            'name' => 'Sapa',
            'keyword' => 'Sapa',
            'image_url' => 'https://images.unsplash.com/photo-1627894005416-541a7f367b65?q=80&w=800',
            'description' => 'Vùng núi phía Bắc với ruộng bậc thang ngoạn mục.',
            'status' => 'active',
        ]);

        $dest4 = Destination::create([
            'code' => 'dest-4',
            'name' => 'Hội An',
            'keyword' => 'Hội An',
            'image_url' => 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800',
            'description' => 'Phố cổ di sản thế giới với đèn lồng lung linh.',
            'status' => 'active',
        ]);

        $dest5 = Destination::create([
            'code' => 'dest-5',
            'name' => 'Phú Quốc',
            'keyword' => 'Phú Quốc',
            'image_url' => 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=800',
            'description' => 'Đảo ngọc thiên nhiên với bãi biển trắng mịn.',
            'status' => 'active',
        ]);

        $dest6 = Destination::create([
            'code' => 'dest-6',
            'name' => 'Hà Nội',
            'keyword' => 'Hà Nội',
            'image_url' => 'https://images.unsplash.com/photo-1523592121529-f6dde35f079e?q=80&w=800',
            'description' => 'Thủ đô nghìn năm văn hiến với Hồ Gươm.',
            'status' => 'active',
        ]);

        $dest7 = Destination::create([
            'code' => 'dest-7',
            'name' => 'TP. Hồ Chí Minh',
            'keyword' => 'TP. Hồ Chí Minh',
            'image_url' => 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=800',
            'description' => 'Thành phố năng động nhất Việt Nam.',
            'status' => 'active',
        ]);

        $dest8 = Destination::create([
            'code' => 'dest-8',
            'name' => 'Đà Nẵng',
            'keyword' => 'Đà Nẵng',
            'image_url' => 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800',
            'description' => 'Thành phố đáng sống bên bờ biển Mỹ Khê.',
            'status' => 'active',
        ]);

        // ── Tours ───────────────────────────────────────────────
        $tour1 = Tour::create([
            'title' => 'Khám phá bờ biển Amalfi',
            'image_url' => 'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=1200',
            'image_alt' => 'Amalfi Coast',
            'location' => 'Ý',
            'full_location' => 'Bờ biển Amalfi, Ý',
            'duration' => '8 NGÀY',
            'includes' => 'Hotels, Meals, Guide',
            'description' => 'Trải nghiệm vẻ đẹp ngoạn mục của phong cảnh thiên nhiên tại Ý.',
            'price_per_person' => 1899.00,
            'discount' => 15,
            'badge' => 'BEST SELLER',
            'rating' => 9.2,
            'review_count' => 1284,
            'status' => 'active',
            'destination_id' => null,
        ]);

        $tour2 = Tour::create([
            'title' => 'Cuộc phiêu lưu dãy Alps Thụy Sĩ',
            'image_url' => 'https://images.unsplash.com/photo-1531310197839-ccf54634509e?q=80&w=1200',
            'image_alt' => 'Swiss Alps',
            'location' => 'Thụy Sĩ',
            'full_location' => 'Dãy Alps, Thụy Sĩ',
            'duration' => '6 NGÀY',
            'includes' => 'Trains, Chalets, Skiing',
            'description' => 'Khám phá những đỉnh núi tuyết phủ trắng xóa của dãy Alps.',
            'price_per_person' => 2450.00,
            'discount' => 0,
            'badge' => 'FEATURED',
            'rating' => 9.8,
            'review_count' => 840,
            'status' => 'active',
            'destination_id' => null,
        ]);

        $tour3 = Tour::create([
            'title' => 'Hành trình di sản Kyoto',
            'image_url' => 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=800',
            'image_alt' => 'Kyoto Temple',
            'location' => 'Nhật Bản',
            'full_location' => 'Kyoto, Nhật Bản',
            'duration' => '10 NGÀY',
            'includes' => 'Ryokans, Tea Ceremony, Transport',
            'description' => 'Đắm mình vào không gian cổ kính của cố đô Kyoto.',
            'price_per_person' => 1550.00,
            'discount' => 0,
            'badge' => null,
            'rating' => 9.5,
            'review_count' => 2100,
            'status' => 'active',
            'destination_id' => null,
        ]);

        $tour4 = Tour::create([
            'title' => 'Sapa Misty Mountains',
            'image_url' => 'https://images.unsplash.com/photo-1504457047772-27fad17af0ec?q=80&w=1200',
            'image_alt' => 'Sapa Mountains',
            'location' => 'Việt Nam',
            'full_location' => 'Sapa, Lào Cai, Việt Nam',
            'duration' => '3 NGÀY',
            'includes' => 'Trekking, Home Stay, Guide',
            'description' => 'Chinh phục đỉnh Fansipan và khám phá vẻ đẹp hoang sơ của Sapa.',
            'price_per_person' => 150.00,
            'discount' => 0,
            'badge' => 'POPULAR',
            'rating' => 8.9,
            'review_count' => 1500,
            'status' => 'active',
            'destination_id' => $dest3->id,
        ]);

        $tour5 = Tour::create([
            'title' => 'Kỳ nghỉ lãng mạn tại Maldives',
            'image_url' => 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1200',
            'image_alt' => 'Maldives',
            'location' => 'Maldives',
            'full_location' => 'Đảo san hô, Maldives',
            'duration' => '7 NGÀY',
            'includes' => 'Water Villa, Flights',
            'description' => 'Tận hưởng kỳ nghỉ sang trọng trên những hòn đảo thiên đường Maldives.',
            'price_per_person' => 3200.00,
            'discount' => 0,
            'badge' => 'LUXURY',
            'rating' => 9.9,
            'review_count' => 450,
            'status' => 'active',
            'destination_id' => null,
        ]);

        // ── Hotels ─────────────────────────────────────────────
        Hotel::create([
            'name' => 'An Home - Phòng đơn Vũng Tàu',
            'image_url' => 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/438865324.jpg',
            'image_alt' => 'An Home',
            'location' => 'Vũng Tàu',
            'full_location' => 'Vũng Tàu, Việt Nam',
            'feature' => 'Gần biển',
            'description' => 'An Home cung cấp không gian nghỉ ngơi ấm cúng tại trung tâm thành phố biển.',
            'price_per_night' => 15.00,
            'discount' => 0,
            'badge' => 'TOP RATED',
            'availability' => 'available',
            'rating' => 9.1,
            'review_count' => 428,
            'status' => 'active',
            'destination_id' => $dest1->id,
        ]);

        Hotel::create([
            'name' => 'The Song Vũng Tàu Xinh',
            'image_url' => 'https://cf.bstatic.com/xdata/images/hotel/max1280x900/414436894.jpg',
            'image_alt' => 'The Song',
            'location' => 'Vũng Tàu',
            'full_location' => 'Vũng Tàu, Việt Nam',
            'feature' => 'View biển',
            'description' => 'Căn hộ cao cấp tại The Sóng với đầy đủ tiện nghi và tầm nhìn hướng biển tuyệt đẹp.',
            'price_per_night' => 18.00,
            'discount' => 20,
            'badge' => 'BEST SELLER',
            'availability' => 'available',
            'rating' => 9.1,
            'review_count' => 312,
            'status' => 'active',
            'destination_id' => $dest1->id,
        ]);

        Hotel::create([
            'name' => "Căn hộ The Sóng - Mai Villa",
            'image_url' => 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/415510619.jpg',
            'image_alt' => 'Mai Villa',
            'location' => 'Vũng Tàu',
            'full_location' => 'Vũng Tàu, Việt Nam',
            'feature' => 'Sang trọng',
            'description' => 'Trải nghiệm không gian sống thượng lưu tại Mai Villa với thiết kế hiện đại.',
            'price_per_night' => 22.00,
            'discount' => 0,
            'badge' => 'LUXURY',
            'availability' => 'selling-fast',
            'rating' => 8.8,
            'review_count' => 1200,
            'status' => 'active',
            'destination_id' => $dest1->id,
        ]);

        Hotel::create([
            'name' => 'Dalat Palace Heritage Hotel',
            'image_url' => 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800',
            'image_alt' => 'Dalat Palace',
            'location' => 'Đà Lạt',
            'full_location' => 'Đà Lạt, Lâm Đồng, Việt Nam',
            'feature' => 'Di sản',
            'description' => 'Khách sạn di sản hàng đầu tại Đà Lạt với kiến trúc Pháp cổ điển.',
            'price_per_night' => 100.00,
            'discount' => 0,
            'badge' => 'LUXURY',
            'availability' => 'available',
            'rating' => 9.5,
            'review_count' => 1200,
            'status' => 'active',
            'destination_id' => $dest2->id,
        ]);

        Hotel::create([
            'name' => "Terracotta Hotel & Resort Dalat",
            'image_url' => 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=800',
            'image_alt' => 'Terracotta',
            'location' => 'Đà Lạt',
            'full_location' => 'Hồ Tuyền Lâm, Đà Lạt',
            'feature' => 'Resort',
            'description' => 'Khu nghỉ dưỡng nép mình bên hồ Tuyền Lâm mộng mơ.',
            'price_per_night' => 80.00,
            'discount' => 0,
            'badge' => null,
            'availability' => 'available',
            'rating' => 8.9,
            'review_count' => 3400,
            'status' => 'active',
            'destination_id' => $dest2->id,
        ]);

        Hotel::create([
            'name' => "THE SÓNG - TRINH'S HOUSE",
            'image_url' => 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/414436894.jpg',
            'image_alt' => 'Trinh House',
            'location' => 'Vũng Tàu',
            'full_location' => 'Vũng Tàu, Việt Nam',
            'feature' => 'Ấm cúng',
            'description' => 'Trinh House mang đến cảm giác thân thuộc như chính ngôi nhà của bạn.',
            'price_per_night' => 19.00,
            'discount' => 0,
            'badge' => null,
            'availability' => 'available',
            'rating' => 8.2,
            'review_count' => 56,
            'status' => 'active',
            'destination_id' => $dest1->id,
        ]);

        // ── Bookings ───────────────────────────────────────────
        Booking::create([
            'code' => 'BK-1001',
            'user_id' => $user1->id,
            'service_type' => 'tour',
            'service_id' => $tour1->id,
            'service_name' => 'Khám phá bờ biển Amalfi',
            'check_in_date' => now()->addDays(20),
            'total_price' => 1899.00,
            'status' => 'Pending',
        ]);

        Booking::create([
            'code' => 'BK-1002',
            'user_id' => $user2->id,
            'service_type' => 'tour',
            'service_id' => $tour4->id,
            'service_name' => 'Sapa Misty Mountains',
            'check_in_date' => now()->addDays(22),
            'total_price' => 150.00,
            'status' => 'Confirmed',
        ]);

        Booking::create([
            'code' => 'BK-1003',
            'user_id' => $user1->id,
            'service_type' => 'hotel',
            'service_id' => 1,
            'service_name' => 'An Home - Phòng đơn Vũng Tàu',
            'check_in_date' => now()->addDays(25),
            'total_price' => 85.00,
            'status' => 'Completed',
        ]);

        Booking::create([
            'code' => 'BK-1004',
            'user_id' => $user4->id,
            'service_type' => 'tour',
            'service_id' => $tour2->id,
            'service_name' => 'Cuộc phiêu lưu dãy Alps',
            'check_in_date' => now()->addDays(5),
            'total_price' => 2450.00,
            'status' => 'Cancelled',
        ]);

        // ── Reviews ────────────────────────────────────────────
        Review::create([
            'code' => 'REV-001',
            'user_id' => $user1->id,
            'service_type' => 'hotel',
            'service_id' => 1,
            'service_name' => 'An Home - Phòng đơn Vũng Tàu',
            'rating' => 5,
            'comment' => 'Dịch vụ tuyệt vời, phòng sạch sẽ!',
            'status' => 'published',
            'created_at' => now()->subDays(5),
        ]);

        Review::create([
            'code' => 'REV-002',
            'user_id' => $user2->id,
            'service_type' => 'tour',
            'service_id' => $tour1->id,
            'service_name' => 'Khám phá bờ biển Amalfi',
            'rating' => 4,
            'comment' => 'Chuyến đi rất thú vị nhưng thời gian hơi gấp.',
            'status' => 'published',
            'created_at' => now()->subDays(3),
        ]);

        Review::create([
            'code' => 'REV-003',
            'user_id' => $user3->id,
            'service_type' => 'tour',
            'service_id' => $tour4->id,
            'service_name' => 'Sapa Misty Mountains',
            'rating' => 1,
            'comment' => 'Quá tệ, tôi sẽ không quay lại!',
            'status' => 'hidden',
            'created_at' => now()->subDays(2),
        ]);

        // ── Promo Codes ───────────────────────────────────────
        PromoCode::create([
            'code' => 'PROMO-001',
            'promo_code' => 'WINTER2024',
            'type' => 'Dịch vụ',
            'value_num' => 10,
            'is_percent' => true,
            'use_limit' => 500,
            'used_count' => 123,
            'expiry_date' => now()->addMonths(3),
            'status' => 'active',
        ]);

        PromoCode::create([
            'code' => 'PROMO-002',
            'promo_code' => 'WELCOMENEW',
            'type' => 'Tất cả',
            'value_num' => 100000,
            'is_percent' => false,
            'use_limit' => 0,
            'used_count' => 87,
            'expiry_date' => null,
            'status' => 'active',
        ]);

        PromoCode::create([
            'code' => 'PROMO-003',
            'promo_code' => 'SUMMERVIBE',
            'type' => 'Tour',
            'value_num' => 15,
            'is_percent' => true,
            'use_limit' => 200,
            'used_count' => 200,
            'expiry_date' => now()->subDays(10),
            'status' => 'expired',
        ]);
    }
}
