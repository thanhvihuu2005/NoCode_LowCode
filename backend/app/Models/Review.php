<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    use HasFactory;
    protected $table = 'reviews';
    public $timestamps = false;

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    protected $fillable = [
        'code', 'user_id', 'service_type', 'service_id',
        'service_name', 'rating', 'comment', 'status', 'created_at',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];
}
