<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Ticket extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'title', 'description', 'category', 'priority', 'status', 'user_ticket_number'
    ];

    protected $attributes = [
        'status' => 'open',
        'priority' => 'low',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function logs()
    {
        return $this->hasMany(TicketLog::class);
    }

    public function scopeOrdered($query)
    {
        return $query->orderByRaw("CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 ELSE 4 END ASC")
                     ->orderBy('created_at', 'asc');
    }

    public static function getNextUserTicketNumber($userId)
    {
        return DB::transaction(function () use ($userId) {
            $maxNumber = static::where('user_id', $userId)
                ->lockForUpdate()
                ->max('user_ticket_number');

            return ($maxNumber ?? 0) + 1;
        });
    }
}

