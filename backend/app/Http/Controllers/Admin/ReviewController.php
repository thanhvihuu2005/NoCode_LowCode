<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    /**
     * GET /api/admin/reviews
     */
    public function index(Request $request)
    {
        try {
            $query = Review::with('user')->orderBy('id', 'desc');

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('service_name', 'ilike', $search)
                      ->orWhere('comment', 'ilike', $search);
                });
            }

            if ($request->filled('status') && $request->status !== '') {
                $query->where('status', $request->status);
            }

            $reviews = $query->get();
            $reviews = $reviews->map(function ($review) {
                $review->user_name = $review->user ? $review->user->name : 'Người dùng đã xóa';
                return $review;
            });

            return response()->json([
                'success' => true,
                'data' => $reviews,
                'total' => $reviews->count(),
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
     * PATCH /api/admin/reviews/{id}/toggle-status
     */
    public function toggleStatus($id)
    {
        $review = Review::find($id);
        if (!$review) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $review->status = $review->status === 'published' ? 'hidden' : 'published';
            $review->save();

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật trạng thái thành công',
                'data' => $review,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/admin/reviews/{id}
     */
    public function destroy($id)
    {
        $review = Review::find($id);
        if (!$review) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $review->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa đánh giá',
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
