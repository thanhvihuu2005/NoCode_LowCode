<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AutomationLog extends Model
{
    protected $table = 'automation_logs';
    
    // Tắt tự động thêm updated_at để tránh lỗi cột không tồn tại
    const UPDATED_AT = null;

    protected $fillable = [
        'event',
        'payload',
        'status',
        'source',
    ];

    protected $casts = [
        'payload' => 'array',
    ];
}
