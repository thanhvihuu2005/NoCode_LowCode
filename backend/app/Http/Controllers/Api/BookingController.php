<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class BookingController extends Controller
{
    /**
     * POST /api/client/bookings
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'service_type' => 'required|string|in:tour,hotel',
                'service_id'   => 'required|integer',
                'service_name' => 'required|string',
                'guests'       => 'required|integer|min:1',
                'total_price'  => 'required|numeric',
                'check_in_date'  => 'nullable|date',
                'check_out_date' => 'nullable|date',
                'discount_code'  => 'nullable|string',
                'note'           => 'nullable|string',
            ]);

            $user = auth()->user();
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Người dùng chưa đăng nhập',
                ], 401);
            }

            // Generate a unique booking code
            $code = 'BK-' . strtoupper(Str::random(8));

            $bookingData = [
                'code'           => $code,
                'user_id'        => $user->id,
                'service_type'   => $request->service_type,
                'service_id'     => $request->service_id,
                'service_name'   => $request->service_name,
                'guests'         => $request->guests,
                'total_price'    => $request->total_price,
                'check_in_date'  => $request->check_in_date,
                'check_out_date' => $request->check_out_date,
                'discount_code'  => $request->discount_code,
                'note'           => $request->note,
                'status'         => 'Pending',
            ];

            $booking = Booking::create($bookingData);

            return response()->json([
                'success' => true,
                'message' => 'Đặt dịch vụ thành công!',
                'data'    => $booking,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi lưu đơn hàng',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/client/bookings
     */
    public function index()
    {
        try {
            $user = auth()->user();
            $bookings = Booking::where('user_id', $user->id)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data'    => $bookings,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải danh sách đơn hàng',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * GET /api/client/bookings/{id}
     */
    public function show($id)
    {
        try {
            $user = auth()->user();
            $booking = Booking::where('user_id', $user->id)->find($id);

            if (!$booking) {
                return response()->json([
                    'success' => false,
                    'message' => 'Không tìm thấy đơn hàng',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => $booking,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải chi tiết đơn hàng',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }
}
