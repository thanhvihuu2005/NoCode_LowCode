<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Hotel;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    /**
     * GET /api/admin/hotels
     */
    public function index(Request $request)
    {
        try {
            $query = Hotel::orderBy('id', 'desc');

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

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            $hotels = $query->get();

            return response()->json([
                'success' => true,
                'data' => $hotels,
                'total' => $hotels->count(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải dữ liệu',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/admin/hotels/{id}
     */
    public function show($id)
    {
        $hotel = Hotel::find($id);
        if (!$hotel) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }
        return response()->json(['success' => true, 'data' => $hotel]);
    }

    /**
     * POST /api/admin/hotels
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'price_per_night' => 'required|numeric|min:0',
            'location' => 'required|string|max:100',
        ]);

        try {
            $destId = $request->destination_id;
            if (empty($destId) || !is_numeric($destId)) {
                $destId = null;
            }

            $hotel = Hotel::create([
                'name' => $request->name,
                'image_url' => $request->image_url ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800',
                'image_alt' => $request->name,
                'location' => $request->location,
                'full_location' => $request->full_location ?? $request->location . ', Việt Nam',
                'feature' => $request->feature ?? '',
                'description' => $request->description ?? '',
                'price_per_night' => floatval($request->price_per_night),
                'discount' => intval($request->discount ?? 0),
                'badge' => $request->badge ?? null,
                'availability' => $request->availability ?? 'available',
                'rating' => floatval($request->rating ?? 0),
                'review_count' => intval($request->review_count ?? 0),
                'status' => $request->status ?? 'active',
                'destination_id' => $destId,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Thêm khách sạn thành công',
                'data' => $hotel,
            ], 201);
        } catch (\Exception $e) {
            \Log::error('Admin Hotel Store Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi thêm dữ liệu: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PUT /api/admin/hotels/{id}
     */
    public function update(Request $request, $id)
    {
        $hotel = Hotel::find($id);
        if (!$hotel) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $destId = $request->has('destination_id') ? $request->destination_id : $hotel->destination_id;
            if ($request->has('destination_id') && (empty($destId) || !is_numeric($destId))) {
                $destId = null;
            }

            $hotel->update([
                'name' => $request->name ?? $hotel->name,
                'image_url' => $request->image_url ?? $hotel->image_url,
                'image_alt' => $request->name ?? $hotel->name,
                'location' => $request->location ?? $hotel->location,
                'full_location' => $request->full_location ?? $hotel->full_location,
                'feature' => $request->feature ?? $hotel->feature,
                'description' => $request->description ?? $hotel->description,
                'price_per_night' => $request->has('price_per_night') ? floatval($request->price_per_night) : $hotel->price_per_night,
                'discount' => $request->has('discount') ? intval($request->discount) : $hotel->discount,
                'badge' => $request->has('badge') ? $request->badge : $hotel->badge,
                'availability' => $request->has('availability') ? $request->availability : $hotel->availability,
                'rating' => $request->has('rating') ? floatval($request->rating) : $hotel->rating,
                'review_count' => $request->has('review_count') ? intval($request->review_count) : $hotel->review_count,
                'status' => $request->status ?? $hotel->status,
                'destination_id' => $destId,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật thành công',
                'data' => $hotel->fresh(),
            ]);
        } catch (\Exception $e) {
            \Log::error('Admin Hotel Update Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/admin/hotels/{id}
     */
    public function destroy($id)
    {
        $hotel = Hotel::find($id);
        if (!$hotel) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $hotel->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa khách sạn',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi xóa',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
