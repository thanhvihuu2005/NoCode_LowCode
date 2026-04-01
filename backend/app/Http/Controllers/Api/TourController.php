<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tour;
use Illuminate\Http\Request;

class TourController extends Controller
{
    /**
     * GET /api/tours
     */
    public function index(Request $request)
    {
        try {
            $query = Tour::where('status', 'active')
                ->with('destination')
                ->orderBy('id', 'desc');

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

            $tours = $query->get();

            $data = $tours->map(function ($t) {
                $priceVnd = (int) $t->price_per_person * 23000;
                $finalPrice = $priceVnd * (1 - ($t->discount ?? 0) / 100);
                return [
                    'id'            => $t->id,
                    'name'          => $t->title,
                    'location'      => $t->location,
                    'fullLocation'  => $t->full_location ?? ($t->location ?? ''),
                    'feature'       => $t->feature ?? '',
                    'duration'     => $t->duration ?? '',
                    'includes'      => $t->includes ?? '',
                    'pricePerPerson' => $priceVnd,
                    'finalPrice'    => (int) $finalPrice,
                    'discount'      => (int) ($t->discount ?? 0),
                    'badge'         => $t->badge ?? null,
                    'rating'        => (float) ($t->rating ?? 0),
                    'reviewCount'   => (string) ($t->review_count ?? '0'),
                    'img'           => $t->image_url ?? '',
                    'description'   => $t->description ?? '',
                    'destination'   => $t->destination ? [
                        'id'   => $t->destination->id,
                        'name' => $t->destination->name,
                    ] : null,
                ];
            });

            return response()->json([
                'success' => true,
                'data'    => $data,
                'total'   => $data->count(),
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
     * GET /api/tours/{id}
     */
    public function show($id)
    {
        try {
            $t = Tour::where('status', 'active')
                ->with('destination')
                ->find($id);
            if (!$t) {
                return response()->json(['success' => false, 'message' => 'Không tìm thấy'], 404);
            }

            $priceVnd = (int) $t->price_per_person * 23000;
            $finalPrice = $priceVnd * (1 - ($t->discount ?? 0) / 100);

            return response()->json([
                'success' => true,
                'data'    => [
                    'id'            => $t->id,
                    'name'          => $t->title,
                    'location'      => $t->location,
                    'fullLocation'  => $t->full_location ?? ($t->location ?? ''),
                    'feature'       => $t->feature ?? '',
                    'duration'     => $t->duration ?? '',
                    'includes'      => $t->includes ?? '',
                    'pricePerPerson' => $priceVnd,
                    'finalPrice'    => (int) $finalPrice,
                    'discount'      => (int) ($t->discount ?? 0),
                    'badge'         => $t->badge ?? null,
                    'rating'        => (float) ($t->rating ?? 0),
                    'reviewCount'   => (string) ($t->review_count ?? '0'),
                    'img'           => $t->image_url ?? '',
                    'description'   => $t->description ?? '',
                    'destination'   => $t->destination ? [
                        'id'   => $t->destination->id,
                        'name' => $t->destination->name,
                    ] : null,
                    'images'        => $this->buildGallery($t),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Lỗi khi tải dữ liệu',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    private function buildGallery($t)
    {
        $base = $t->image_url ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200';
        return [
            ['src' => $base, 'thumb' => str_replace('w=1200', 'w=300', $base), 'title' => $t->title, 'description' => 'Ảnh chính'],
            ['src' => 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=300', 'title' => 'Cảnh quan', 'description' => 'Khám phá vẻ đẹp thiên nhiên'],
            ['src' => 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300', 'title' => 'Núi non', 'description' => 'Cảnh quan núi non hùng vĩ'],
            ['src' => 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=300', 'title' => 'Du lịch', 'description' => 'Trải nghiệm du lịch tuyệt vời'],
            ['src' => 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=300', 'title' => 'Thiên nhiên', 'description' => 'Thiên nhiên hoang sơ'],
            ['src' => 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1200', 'thumb' => 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=300', 'title' => 'Phong cảnh', 'description' => 'Phong cảnh tuyệt đẹp'],
        ];
    }
}
