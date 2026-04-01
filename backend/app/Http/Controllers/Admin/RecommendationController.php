<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\RecommendationRule;
use Illuminate\Http\Request;

class RecommendationController extends Controller
{
    /**
     * GET /api/admin/recommendations
     */
    public function index(Request $request)
    {
        try {
            $query = RecommendationRule::query();

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('trigger_kw', 'ilike', $search)
                      ->orWhere('suggestion', 'ilike', $search)
                      ->orWhere('code', 'ilike', $search);
                });
            }

            if ($request->filled('type') && $request->type !== '') {
                $query->where('type', $request->type);
            }

            $rules = $query->orderBy('id', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $rules,
                'total' => $rules->count(),
                'stats' => [
                    'active' => $rules->where('is_active', true)->count(),
                    'total' => $rules->count(),
                ],
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
     * POST /api/admin/recommendations
     */
    public function store(Request $request)
    {
        $request->validate([
            'trigger_kw' => 'required|string|max:255',
            'suggestion' => 'required|string|max:500',
            'type' => 'required|string|in:cross-sell,upsell',
        ]);

        try {
            $count = RecommendationRule::count() + 1;
            $rule = RecommendationRule::create([
                'code' => 'RULE-' . str_pad($count, 3, '0', STR_PAD_LEFT),
                'trigger_kw' => $request->trigger_kw,
                'suggestion' => $request->suggestion,
                'type' => $request->type,
                'is_active' => true,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Thêm rule gợi ý thành công',
                'data' => $rule,
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
     * PUT /api/admin/recommendations/{id}
     */
    public function update(Request $request, $id)
    {
        $rule = RecommendationRule::find($id);
        if (!$rule) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy rule'], 404);
        }

        $request->validate([
            'trigger_kw' => 'sometimes|string|max:255',
            'suggestion' => 'sometimes|string|max:500',
            'type' => 'sometimes|string|in:cross-sell,upsell',
        ]);

        try {
            $rule->update([
                'trigger_kw' => $request->trigger_kw ?? $rule->trigger_kw,
                'suggestion' => $request->suggestion ?? $rule->suggestion,
                'type' => $request->type ?? $rule->type,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật thành công',
                'data' => $rule->fresh(),
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
     * PATCH /api/admin/recommendations/{id}/toggle
     */
    public function toggle($id)
    {
        $rule = RecommendationRule::find($id);
        if (!$rule) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy rule'], 404);
        }

        try {
            $rule->update(['is_active' => !$rule->is_active]);
            return response()->json([
                'success' => true,
                'message' => $rule->is_active ? 'Đã bật rule' : 'Đã tắt rule',
                'data' => $rule->fresh(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật trạng thái',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/admin/recommendations/{id}
     */
    public function destroy($id)
    {
        $rule = RecommendationRule::find($id);
        if (!$rule) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy rule'], 404);
        }

        try {
            $rule->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa rule gợi ý',
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
