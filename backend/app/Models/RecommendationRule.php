<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RecommendationRule extends Model
{
    use HasFactory;
    protected $table = 'recommendation_rules';
    protected $fillable = [
        'code', 'trigger_kw', 'suggestion', 'type', 'is_active',
    ];
    protected $casts = [
        'is_active' => 'boolean',
    ];
}
