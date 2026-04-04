<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Destination;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class DestinationController extends Controller
{
    /**
     * GET /api/admin/destinations
     */
    public function index(Request $request)
    {
        try {
            $query = Destination::query();

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            if ($request->filled('search')) {
                $search = '%' . $request->search . '%';
                $query->where(function ($q) use ($search) {
                    $q->where('name', 'ilike', $search)
                        ->orWhere('keyword', 'ilike', $search);
                });
            }

            $destinations = $query->orderBy('id', 'desc')->get();

            return response()->json([
                'success' => true,
                'data'    => $destinations,
                'total'   => $destinations->count(),
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
     * GET /api/admin/destinations/{id}
     */
    public function show($id)
    {
        $destination = Destination::find($id);
        if (!$destination) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }
        return response()->json(['success' => true, 'data' => $destination]);
    }

    /**
     * POST /api/admin/destinations
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:destinations,name',
        ]);

        try {
            $count = Destination::count() + 1;
            $destination = Destination::create([
                'code'        => 'dest-' . str_pad($count, 3, '0', STR_PAD_LEFT),
                'name'        => $request->name,
                'keyword'     => $request->keyword ?? $request->name,
                'image_url'   => $request->image_url,
                'description' => $request->description,
                'status'      => $request->status ?? 'active',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Thêm điểm đến thành công',
                'data'    => $destination,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi thêm dữ liệu',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PUT /api/admin/destinations/{id}
     */
    public function update(Request $request, $id)
    {
        $destination = Destination::find($id);
        if (!$destination) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255|unique:destinations,name,' . $id,
        ]);

        try {
            $destination->update([
                'name'        => $request->name,
                'keyword'     => $request->keyword ?? $request->name,
                'image_url'   => $request->image_url,
                'description' => $request->description,
                'status'      => $request->status ?? $destination->status,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Cập nhật thành công',
                'data'    => $destination->fresh(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi cập nhật',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * DELETE /api/admin/destinations/{id}
     */
    public function destroy($id)
    {
        $destination = Destination::find($id);
        if (!$destination) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        try {
            $destination->delete();
            return response()->json([
                'success' => true,
                'message' => 'Đã xóa điểm đến',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi xóa',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * PATCH /api/admin/destinations/{id}/toggle-status
     */
    public function toggleStatus($id)
    {
        $destination = Destination::find($id);
        if (!$destination) {
            return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
        }

        $destination->status = $destination->status === 'active' ? 'inactive' : 'active';
        $destination->save();

        return response()->json([
            'success' => true,
            'message' => 'Đã cập nhật trạng thái',
            'data'    => $destination,
        ]);
    }
}
