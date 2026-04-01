<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    use HasFactory;
    protected $table = 'bookings';
    public $timestamps = true;

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function addons()
    {
        return $this->hasMany(BookingAddon::class);
    }

    protected $fillable = [
        'code', 'user_id', 'service_type', 'service_id',
        'service_name', 'check_in_date', 'check_out_date',
        'guests', 'total_price', 'discount_code', 'status', 'note',
    ];
}
