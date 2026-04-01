<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PromoCode;
use Illuminate\Http\Request;

class PromoCodeController extends Controller
{
    /**
     * GET /api/admin/promo-codes
     */
    public function index(Request $request)
    {
        try {
            $query = PromoCode::query();

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('code', 'ilike', $search)
                      ->orWhere('promo_code', 'ilike', $search);
                });
            }

            if ($request->filled('status') && $request->status !== '') {
                $query->where('status', $request->status);
            }

            $promos = $query->orderBy('id', 'desc')->get();

            // Add formatted value
            $promos = $promos->map(function ($promo) {
                if ($promo->is_percent) {
                    $promo->value_display = $promo->value_num . '%';
                } else {
                    $promo->value_display = number_format($promo->value_num, 0, ',', '.') . '₫';
                }
                return $promo;
            });

            return response()->json([
                'success' => true,
                'data' => $promos,
                'total' => $promos->count(),
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
     * POST /api/admin/promo-codes
     */
    public function store(Request $request)
    {
        $request->validate([
            'promo_code' => 'required|string|max:50|unique:promo_codes,promo_code',
            'value_num' => 'required|numeric|min:0',
        ]);

        try {
            $count = PromoCode::count() + 1;
            $promo = PromoCode::create([
                'code' => 'PROMO-' . str_pad($count, 3, '0', STR_PAD_LEFT),
                'promo_code' => $request->promo_code,
                'type' => $request->type ?? 'Tất cả',
                'value_num' => $request->value_num,
                'is_percent' => $request->is_percent ?? true,
                'use_limit' => $request->use_limit ?? 0,
                'used_count' => 0,
                'expiry_date' => $request->expiry_date,
                'status' => $request->status ?? 'active',
            ]);

            if ($promo->is_percent) {
                $promo->value_display = $promo->value_num . '%';
            } else {
                $promo->value_display = number_format($promo->value_num, 0, ',', '.') . '₫';
            }

            return response()->json([
                'success' => true,
                'message' => 'Thêm mã giảm giá thành công',
                'data' => $promo,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi thêm dữ liệu',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PUT /api/admin/promo-codes/{id}
     */
    public function update(Request $request, $id)
    {
        $promo = PromoCode::find($id);
        if (!$promo) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $promo->update([
                'promo_code' => $request->promo_code ?? $promo->promo_code,
                'type' => $request->type ?? $promo->type,
                'value_num' => $request->value_num ?? $promo->value_num,
                'is_percent' => $request->is_percent ?? $promo->is_percent,
                'use_limit' => $request->use_limit ?? $promo->use_limit,
                'expiry_date' => $request->expiry_date ?? $promo->expiry_date,
                'status' => $request->status ?? $promo->status,
            ]);

            if ($promo->is_percent) {
                $promo->value_display = $promo->value_num . '%';
            } else {
                $promo->value_display = number_format($promo->value_num, 0, ',', '.') . '₫';
            }

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật thành công',
                'data' => $promo->fresh(),
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
     * DELETE /api/admin/promo-codes/{id}
     */
    public function destroy($id)
    {
        $promo = PromoCode::find($id);
        if (!$promo) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $promo->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa mã giảm giá',
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
