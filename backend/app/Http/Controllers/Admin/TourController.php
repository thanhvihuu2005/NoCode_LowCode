<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Tour;
use App\Models\Destination;
use Illuminate\Http\Request;

class TourController extends Controller
{
    /**
     * GET /api/admin/tours
     */
    public function index(Request $request)
    {
        try {
            $query = Tour::with('destination')->orderBy('id', 'desc');

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('title', 'ilike', $search)
                        ->orWhere('location', 'ilike', $search);
                });
            }

            if ($request->filled('location') && $request->location !== '') {
                $query->where('location', $request->location);
            }

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            $tours = $query->get();

            return response()->json([
                'success' => true,
                'data' => $tours,
                'total' => $tours->count(),
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
     * GET /api/admin/tours/{id}
     */
    public function show($id)
    {
        $tour = Tour::with('destination')->find($id);
        if (!$tour) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }
        return response()->json(['success' => true, 'data' => $tour]);
    }

    /**
     * POST /api/admin/tours
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'price_per_person' => 'required|numeric|min:0',
            'location' => 'required|string|max:100',
        ]);

        try {
            $destId = $request->destination_id;
            if (empty($destId) || !is_numeric($destId)) {
                $destId = null;
            }

            $tour = Tour::create([
                'title' => $request->title,
                'image_url' => $request->image_url ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200',
                'image_alt' => $request->title,
                'location' => $request->location,
                'full_location' => $request->full_location ?? $request->location,
                'duration' => $request->duration ?? '',
                'includes' => $request->includes ?? '',
                'description' => $request->description ?? '',
                'price_per_person' => floatval($request->price_per_person),
                'discount' => intval($request->discount ?? 0),
                'badge' => $request->badge ?? null,
                'rating' => floatval($request->rating ?? 0),
                'review_count' => intval($request->review_count ?? 0),
                'status' => $request->status ?? 'active',
                'destination_id' => $destId,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Thêm tour thành công',
                'data' => $tour,
            ], 201);
        } catch (\Exception $e) {
            \Log::error('Admin Tour Store Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi thêm dữ liệu: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PUT /api/admin/tours/{id}
     */
    public function update(Request $request, $id)
    {
        $tour = Tour::find($id);
        if (!$tour) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $destId = $request->has('destination_id') ? $request->destination_id : $tour->destination_id;
            if ($request->has('destination_id') && (empty($destId) || !is_numeric($destId))) {
                $destId = null;
            }

            $tour->update([
                'title' => $request->title ?? $tour->title,
                'image_url' => $request->image_url ?? $tour->image_url,
                'image_alt' => $request->title ?? $tour->title,
                'location' => $request->location ?? $tour->location,
                'full_location' => $request->full_location ?? $tour->full_location,
                'duration' => $request->duration ?? $tour->duration,
                'includes' => $request->includes ?? $tour->includes,
                'description' => $request->description ?? $tour->description,
                'price_per_person' => $request->has('price_per_person') ? floatval($request->price_per_person) : $tour->price_per_person,
                'discount' => $request->has('discount') ? intval($request->discount) : $tour->discount,
                'badge' => $request->has('badge') ? $request->badge : $tour->badge,
                'rating' => $request->has('rating') ? floatval($request->rating) : $tour->rating,
                'review_count' => $request->has('review_count') ? intval($request->review_count) : $tour->review_count,
                'status' => $request->status ?? $tour->status,
                'destination_id' => $destId,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật thành công',
                'data' => $tour->fresh(),
            ]);
        } catch (\Exception $e) {
            \Log::error('Admin Tour Update Error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/admin/tours/{id}
     */
    public function destroy($id)
    {
        $tour = Tour::find($id);
        if (!$tour) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $tour->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa tour',
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
