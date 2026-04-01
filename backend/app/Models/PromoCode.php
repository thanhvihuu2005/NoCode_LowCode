<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PromoCode extends Model
{
    use HasFactory;
    protected $table = 'promo_codes';
    public $timestamps = false;

    protected $fillable = [
        'code', 'promo_code', 'type', 'value_num',
        'is_percent', 'use_limit', 'used_count', 'expiry_date', 'status',
    ];

    protected $casts = [
        'is_percent' => 'boolean',
        'value_num' => 'float',
        'use_limit' => 'integer',
        'used_count' => 'integer',
        'expiry_date' => 'date',
    ];
}
