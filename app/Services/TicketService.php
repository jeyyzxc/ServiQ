<?php

namespace App\Services;

use App\Events\TicketStatusChanged;
use App\Models\Ticket;
use App\Models\TicketLog;
use Illuminate\Support\Facades\DB;

class TicketService
{
    private const STATUSES = ['open', 'in_progress', 'resolved'];

    public function changeStatus(Ticket $ticket, string $toStatus, $actor = null): Ticket
    {
        $from = $ticket->status;

        if ($from === $toStatus) {
            return $ticket;
        }

        $fromIndex = array_search($from, self::STATUSES);
        $toIndex = array_search($toStatus, self::STATUSES);

        if ($fromIndex === false || $toIndex === false || $toIndex <= $fromIndex) {
            throw new \InvalidArgumentException("Invalid status transition from {$from} to {$toStatus}");
        }

        return DB::transaction(function () use ($ticket, $from, $toStatus, $actor, $fromIndex, $toIndex) {
            for ($i = $fromIndex + 1; $i <= $toIndex; $i++) {
                $previousStatus = self::STATUSES[$i - 1];
                $currentStatus = self::STATUSES[$i];

                $ticket->status = $currentStatus;
                $ticket->save();

                TicketLog::create([
                    'ticket_id' => $ticket->id,
                    'user_id' => $actor ? $actor->id : null,
                    'from_status' => $previousStatus,
                    'to_status' => $currentStatus,
                ]);

                event(new TicketStatusChanged($ticket, $previousStatus, $currentStatus, $actor));
            }

            return $ticket->fresh();
        });
    }

    public function markAsViewed(Ticket $ticket, $actor = null): Ticket
    {
        if ($ticket->status !== 'open') {
            return $ticket;
        }

        $hasViewedLog = TicketLog::where('ticket_id', $ticket->id)
            ->where('to_status', 'viewed')
            ->exists();

        if ($hasViewedLog) {
            return $ticket;
        }

        return DB::transaction(function () use ($ticket, $actor) {
            TicketLog::create([
                'ticket_id' => $ticket->id,
                'user_id' => $actor ? $actor->id : null,
                'from_status' => 'open',
                'to_status' => 'viewed',
            ]);

            return $ticket->fresh();
        });
    }
}
