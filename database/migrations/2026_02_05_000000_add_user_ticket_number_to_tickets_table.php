<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tickets', function (Blueprint $table) {
            $table->unsignedInteger('user_ticket_number')->nullable()->after('user_id');
            $table->index(['user_id', 'user_ticket_number']);
        });

        $users = DB::table('tickets')->select('user_id')->distinct()->get();

        foreach ($users as $user) {
            $tickets = DB::table('tickets')
                ->where('user_id', $user->user_id)
                ->orderBy('created_at', 'asc')
                ->orderBy('id', 'asc')
                ->get();

            $number = 1;
            foreach ($tickets as $ticket) {
                DB::table('tickets')
                    ->where('id', $ticket->id)
                    ->update(['user_ticket_number' => $number]);
                $number++;
            }
        }
    }

    public function down(): void
    {
        Schema::table('tickets', function (Blueprint $table) {
            $table->dropIndex(['user_id', 'user_ticket_number']);
            $table->dropColumn('user_ticket_number');
        });
    }
};
