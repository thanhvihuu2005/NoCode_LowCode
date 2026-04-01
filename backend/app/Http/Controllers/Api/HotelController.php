<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Hotel;
use App\Models\Tour;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    /**
     * GET /api/hotels
     */
    public function index(Request $request)
    {
        try {
            $query = Hotel::where('status', 'active')
                ->orderBy('id', 'desc');

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'ilike', $search)
                      ->orWhere('location', 'ilike', $search);
                });
            }

            if ($request->filled('location') && $request->location !== '') {
                $query->where('location', $request->location);
            }

            $hotels = $query->get();

            // Map to frontend field names
            $data = $hotels->map(function ($h) {
                $priceVnd = (int) $h->price_per_night * 23000;
                $finalPrice = $priceVnd * (1 - ($h->discount ?? 0) / 100);
                return [
                    'id'            => $h->id,
                    'name'          => $h->name,
                    'location'      => $h->location,
                    'fullLocation'  => $h->full_location ?? ($h->location . ', Việt Nam'),
                    'feature'       => $h->feature ?? '',
                    'pricePerNight' => $priceVnd,          // VND
                    'finalPrice'    => (int) $finalPrice, // VND sau giảm giá
                    'discount'      => (int) ($h->discount ?? 0),
                    'badge'         => $h->badge ?? null,
                    'rating'        => (float) ($h->rating ?? 0),
                    'reviewCount'   => (string) ($h->review_count ?? '0'),
                    'img'           => $h->image_url ?? '',
                    'description'   => $h->description ?? '',
                    'availability'  => $h->availability ?? 'available',
                ];
            });

            return response()->json([
                'success' => true,
                'data'    => $data,
                'total'   => $data->count(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải dữ liệu',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/hotels/{id}
     */
    public function show($id)
    {
        try {
            $h = Hotel::where('status', 'active')->find($id);
            if (!$h) {
                return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
            }

            $priceVnd = (int) $h->price_per_night * 23000;
            $finalPrice = $priceVnd * (1 - ($h->discount ?? 0) / 100);

            return response()->json([
                'success' => true,
                'data'    => [
                    'id'            => $h->id,
                    'name'          => $h->name,
                    'location'      => $h->location,
                    'fullLocation'  => $h->full_location ?? ($h->location . ', Việt Nam'),
                    'feature'       => $h->feature ?? '',
                    'pricePerNight' => $priceVnd,
                    'finalPrice'    => (int) $finalPrice,
                    'discount'      => (int) ($h->discount ?? 0),
                    'badge'         => $h->badge ?? null,
                    'rating'        => (float) ($h->rating ?? 0),
                    'reviewCount'   => (string) ($h->review_count ?? '0'),
                    'img'           => $h->image_url ?? '',
                    'description'   => $h->description ?? '',
                    'availability'  => $h->availability ?? 'available',
                    'images'        => $this->buildGallery($h),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải dữ liệu',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    private function buildGallery($h)
    {
        $base = $h->image_url ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1200';
        return [
            ['src' => $base, 'thumb' => str_replace('w=1200', 'w=300', $base), 'title' => $h->name, 'description' => 'Ảnh chính'],
            ['src' => 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300', 'title' => 'Phòng nghỉ', 'description' => 'Phòng nghỉ sang trọng'],
            ['src' => 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300', 'title' => 'Hồ bơi', 'description' => 'Hồ bơi ngoài trời'],
            ['src' => 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=300', 'title' => 'Nhà hàng', 'description' => 'Nhà hàng cao cấp'],
            ['src' => 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=300', 'title' => 'Spa', 'description' => 'Khu vực spa thư giãn'],
            ['src' => 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=300', 'title' => 'View từ phòng', 'description' => 'Tầm nhìn tuyệt đẹp'],
        ];
    }
}
