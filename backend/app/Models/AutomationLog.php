<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AutomationLog extends Model
{
    protected $table = 'automation_logs';

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
