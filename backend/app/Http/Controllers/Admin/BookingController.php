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

            // --- N8N AUTOMATION TRIGGER ---
            try {
                // Lấy email khách hàng (nếu không có thì mặc định gửi về mail test của bạn)
                $userEmail = $booking->user ? $booking->user->email : 'dangthanhvu0103@gmail.com';
                $webhookPath = null;

                if ($request->status === 'Confirmed') {
                    // Mới chốt đơn (Confirmed) 
                    if ($booking->service_type === 'tour') $webhookPath = 'booking-tour'; // Luồng 1
                    if ($booking->service_type === 'hotel') $webhookPath = 'upsell-vip';   // Luồng 2
                } elseif ($request->status === 'Completed') {
                    // Khách đi xong rồi (Completed) -> Chăm sóc khách cũ
                    $webhookPath = 'retention-tour'; // Luồng 3
                }

                // Nếu có khớp với điều kiện nào thì tự động bắn súng sang N8N
                if ($webhookPath) {
                    \Illuminate\Support\Facades\Http::post('http://127.0.0.1:5678/webhook/' . $webhookPath, [
                        'customer_email' => $userEmail,
                        'booking_id' => $booking->id,
                        'service_id' => $booking->service_id,
                        'service_type' => $booking->service_type
                    ]);
                }
            } catch (\Exception $e) {
                // Bỏ qua lỗi nếu n8n sập, không làm hỏng tính năng website
            }
            // ------------------------------

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
