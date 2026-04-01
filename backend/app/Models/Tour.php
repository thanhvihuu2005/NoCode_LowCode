<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tour extends Model
{
    use HasFactory;
    protected $table = 'tours';
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
            ->where('service_type', 'tour');
    }

    protected $fillable = [
        'title', 'image_url', 'image_alt', 'destination_id',
        'location', 'full_location', 'duration', 'includes',
        'description', 'price_per_person', 'discount', 'badge',
        'rating', 'review_count', 'status',
    ];
}
