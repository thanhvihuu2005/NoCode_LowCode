<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('automation_logs', function (Blueprint $table) {
            $table->id();
            $table->string('event');          // VD: "booking-tour", "booking-hotel", "booking-confirm"
            $table->json('payload')->nullable();  // Dữ liệu gửi từ n8n
            $table->string('status', 20);     // "success" | "failure"
            $table->string('source', 50)->default('n8n');  // "n8n" | "manual"
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('automation_logs');
    }
};
