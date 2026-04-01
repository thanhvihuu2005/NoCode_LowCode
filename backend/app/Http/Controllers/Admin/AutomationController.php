<?php

namespace App\Http\Controllers\Admin;

use App\Models\AutomationLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

class AutomationController extends Controller
{
    public static function routes()
    {
        Route::prefix('automation')->group(function () {
            Route::get('/workflows',   [self::class, 'workflows']);
            Route::get('/logs',         [self::class, 'logs']);
            Route::post('/logs',        [self::class, 'storeLog']);
        });
    }

    /**
     * Danh sách workflows (n8n gọi webhook → ghi vào DB)
     * URL: POST /api/automation/webhook/booking-tour
     */
    public static function handleWebhook(Request $request, string $type)
    {
        $payload = $request->all();

        AutomationLog::create([
            'event'   => $type,
            'payload' => json_encode($payload),
            'status'  => 'success',
        ]);

        return response()->json(['ok' => true, 'log_id' => $type]);
    }

    public function workflows()
    {
        $workflows = [
            ['id' => 1, 'name' => 'Cross-sell: Gợi ý khách sạn sau đặt tour', 'trigger' => 'POST /automation/webhook/booking-tour', 'status' => true, 'runs' => 48, 'last' => '10 phút trước'],
            ['id' => 2, 'name' => 'Upsell: Email nâng cấp phòng', 'trigger' => 'POST /automation/webhook/booking-hotel', 'status' => true, 'runs' => 23, 'last' => '2 giờ trước'],
            ['id' => 3, 'name' => 'Email xác nhận đặt chỗ', 'trigger' => 'POST /automation/webhook/booking-confirm', 'status' => true, 'runs' => 124, 'last' => '5 phút trước'],
        ];

        return response()->json(['success' => true, 'data' => $workflows]);
    }

    public function logs()
    {
        $logs = AutomationLog::orderBy('created_at', 'desc')->limit(50)->get();

        return response()->json([
            'success' => true,
            'data' => $logs->map(fn($l) => [
                'id'        => 'LOG-' . str_pad($l->id, 3, '0', STR_PAD_LEFT),
                'event'     => $l->event,
                'payload'   => $l->payload,
                'timestamp' => $l->created_at->format('d/m/Y H:i'),
                'status'    => $l->status,
            ])
        ]);
    }

    public function storeLog(Request $request)
    {
        AutomationLog::create([
            'event'   => $request->event ?? 'manual-trigger',
            'payload' => json_encode($request->all()),
            'status'  => $request->status ?? 'success',
        ]);

        return response()->json(['success' => true]);
    }
}
