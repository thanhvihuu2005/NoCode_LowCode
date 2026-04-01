<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingAddon extends Model
{
    use HasFactory;
    protected $table = 'booking_addons';
    public $timestamps = false;

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    protected $fillable = ['booking_id', 'addon_id', 'quantity', 'price'];
}
