<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\User;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    /**
     * GET /api/admin/bookings
     */
    public function index(Request $request)
    {
        try {
            $query = Booking::with('user')->orderBy('id', 'desc');

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('code', 'ilike', $search)
                      ->orWhere('service_name', 'ilike', $search);
                });
            }

            if ($request->filled('status') && $request->status !== '') {
                $query->where('status', $request->status);
            }

            if ($request->filled('service_type') && $request->service_type !== '') {
                $query->where('service_type', $request->service_type);
            }

            $bookings = $query->get();

            // Attach user_name to each booking
            $bookings = $bookings->map(function ($booking) {
                $booking->user_name = $booking->user ? $booking->user->name : 'Khách vãng lai';
                $booking->user_email = $booking->user ? $booking->user->email : '';
                return $booking;
            });

            return response()->json([
                'success' => true,
                'data' => $bookings,
                'total' => $bookings->count(),
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
     * GET /api/admin/bookings/{id}
     */
    public function show($id)
    {
        $booking = Booking::with('user')->find($id);
        if (!$booking) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }
        $booking->user_name = $booking->user ? $booking->user->name : 'Khách vãng lai';
        return response()->json(['success' => true, 'data' => $booking]);
    }

    /**
     * PUT /api/admin/bookings/{id}/status
     */
    public function updateStatus(Request $request, $id)
    {
        $booking = Booking::find($id);
        if (!$booking) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        $request->validate([
            'status' => 'required|string|in:Pending,Confirmed,Completed,Cancelled',
        ]);

        try {
            $booking->update(['status' => $request->status]);

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật trạng thái thành công',
                'data' => $booking->fresh(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
