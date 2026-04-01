<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Hotel extends Model
{
    use HasFactory;
    protected $table = 'hotels';
    public $timestamps = true;

    public function destination()
    {
        return $this->belongsTo(Destination::class);
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class, 'service_id')
            ->where('service_type', 'hotel');
    }

    protected $fillable = [
        'name', 'image_url', 'image_alt', 'destination_id',
        'location', 'full_location', 'feature', 'description',
        'price_per_night', 'discount', 'badge', 'availability',
        'rating', 'review_count', 'status',
    ];
}
