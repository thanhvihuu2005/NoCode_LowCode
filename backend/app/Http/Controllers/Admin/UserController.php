<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Booking;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * GET /api/admin/users
     */
    public function index(Request $request)
    {
        try {
            $query = User::query();

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'ilike', $search)
                      ->orWhere('email', 'ilike', $search);
                });
            }

            if ($request->filled('status') && $request->status !== '') {
                $query->where('status', $request->status);
            }

            $users = $query->orderBy('id', 'desc')->get();

            // Attach booking count to each user
            $users = $users->map(function ($user) {
                $user->booking_count = Booking::where('user_id', $user->id)->count();
                return $user;
            });

            return response()->json([
                'success' => true,
                'data' => $users,
                'total' => $users->count(),
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
     * PATCH /api/admin/users/{id}/toggle-status
     */
    public function toggleStatus($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy người dùng'], 404);
        }

        // Prevent admin from blocking themselves
        $currentUser = auth()->user();
        if ($currentUser && $currentUser->id == $id) {
            return response()->json([
                'success' => false,
                'message' => 'Bạn không thể khóa chính mình',
            ], 400);
        }

        try {
            $user->status = $user->status === 'active' ? 'blocked' : 'active';
            $user->save();

            return response()->json([
                'success' => true,
                'message' => $user->status === 'active' ? 'Đã mở khóa tài khoản' : 'Đã khóa tài khoản',
                'data' => $user,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật trạng thái',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
