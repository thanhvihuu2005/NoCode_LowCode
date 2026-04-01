<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Admin\DestinationController;
use App\Http\Controllers\Admin\TourController;
use App\Http\Controllers\Admin\HotelController;
use App\Http\Controllers\Admin\BookingController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\ReviewController;
use App\Http\Controllers\Admin\PromoCodeController;
use App\Http\Controllers\Admin\RecommendationController;
use App\Http\Controllers\Admin\AutomationController;

use App\Http\Controllers\Api\HotelController as PublicHotelController;
use App\Http\Controllers\Api\TourController as PublicTourController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Health check (public)
Route::get('/health', function () {
    return response()->json([
        'status'    => 'ok',
        'message'   => 'TravelWise API is running',
        'timestamp' => now()->toDateTimeString()
    ]);
});

// ── Public: Hotels & Tours (no auth required) ─────────────────
Route::get('/hotels', [PublicHotelController::class, 'index']);
Route::get('/hotels/{id}', [PublicHotelController::class, 'show']);
Route::get('/tours',  [PublicTourController::class, 'index']);
Route::get('/tours/{id}',  [PublicTourController::class, 'show']);

// Public Auth routes
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);
});

// Protected routes (require JWT token)
Route::middleware('auth:api')->group(function () {

    // Auth utilities
    Route::prefix('auth')->group(function () {
        Route::get('/me',       [AuthController::class, 'me']);
        Route::post('/logout',  [AuthController::class, 'logout']);
        Route::post('/refresh', [AuthController::class, 'refresh']);
    });

    // ── Admin: Destinations ──────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/destinations',                      [DestinationController::class, 'index']);
        Route::post('/destinations',                     [DestinationController::class, 'store']);
        Route::get('/destinations/{id}',                 [DestinationController::class, 'show']);
        Route::put('/destinations/{id}',                 [DestinationController::class, 'update']);
        Route::delete('/destinations/{id}',             [DestinationController::class, 'destroy']);
        Route::patch('/destinations/{id}/toggle-status',[DestinationController::class, 'toggleStatus']);
    });

    // ── Admin: Tours ─────────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/tours',    [TourController::class, 'index']);
        Route::post('/tours',    [TourController::class, 'store']);
        Route::get('/tours/{id}',[TourController::class, 'show']);
        Route::put('/tours/{id}',[TourController::class, 'update']);
        Route::delete('/tours/{id}',[TourController::class, 'destroy']);
    });

    // ── Admin: Hotels ────────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/hotels',    [HotelController::class, 'index']);
        Route::post('/hotels',    [HotelController::class, 'store']);
        Route::get('/hotels/{id}',[HotelController::class, 'show']);
        Route::put('/hotels/{id}',[HotelController::class, 'update']);
        Route::delete('/hotels/{id}',[HotelController::class, 'destroy']);
    });

    // ── Admin: Bookings ───────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/bookings',               [BookingController::class, 'index']);
        Route::get('/bookings/{id}',          [BookingController::class, 'show']);
        Route::put('/bookings/{id}/status',   [BookingController::class, 'updateStatus']);
    });

    // ── Admin: Users ──────────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/users',                      [UserController::class, 'index']);
        Route::patch('/users/{id}/toggle-status', [UserController::class, 'toggleStatus']);
    });

    // ── Admin: Reviews ────────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/reviews',                       [ReviewController::class, 'index']);
        Route::patch('/reviews/{id}/toggle-status',   [ReviewController::class, 'toggleStatus']);
        Route::delete('/reviews/{id}',               [ReviewController::class, 'destroy']);
    });

    // ── Admin: Promo Codes ────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/promo-codes',    [PromoCodeController::class, 'index']);
        Route::post('/promo-codes',    [PromoCodeController::class, 'store']);
        Route::put('/promo-codes/{id}',[PromoCodeController::class, 'update']);
        Route::delete('/promo-codes/{id}',[PromoCodeController::class, 'destroy']);
    });

    // ── Admin: Automation ────────────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/automation/workflows', [AutomationController::class, 'workflows']);
        Route::get('/automation/logs',      [AutomationController::class, 'logs']);
        Route::post('/automation/logs',     [AutomationController::class, 'storeLog']);
    });

    // ── Webhook (public — n8n gọi vào đây) ──────────────────
    Route::post('/automation/webhook/{type}', [AutomationController::class, 'handleWebhook']);

    // ── Admin: Recommendations ──────────────────────────────
    Route::prefix('admin')->group(function () {
        Route::get('/recommendations',              [RecommendationController::class, 'index']);
        Route::post('/recommendations',             [RecommendationController::class, 'store']);
        Route::put('/recommendations/{id}',         [RecommendationController::class, 'update']);
        Route::patch('/recommendations/{id}/toggle',[RecommendationController::class, 'toggle']);
        Route::delete('/recommendations/{id}',     [RecommendationController::class, 'destroy']);
    });
});
