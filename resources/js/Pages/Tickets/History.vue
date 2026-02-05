<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';
import axios from 'axios';

const tickets = ref([]);
const logs = ref([]);
const loading = ref(true);
const activeTab = ref('tickets');
const currentTime = ref(Date.now());
let timeInterval = null;

const statusColors = {
    open: { bg: 'bg-blue-100', text: 'text-blue-700', dot: 'bg-blue-500' },
    in_progress: { bg: 'bg-amber-100', text: 'text-amber-700', dot: 'bg-amber-500' },
    resolved: { bg: 'bg-emerald-100', text: 'text-emerald-700', dot: 'bg-emerald-500' }
};

onMounted(async () => {
    try {
        const { data } = await axios.get('/api/tickets');
        tickets.value = data;

        const allLogs = [];
        for (const ticket of data) {
            if (ticket.logs && ticket.logs.length > 0) {
                ticket.logs.forEach(log => {
                    allLogs.push({
                        ...log,
                        ticket_title: ticket.title,
                        ticket_id: ticket.id
                    });
                });
            }
        }
        logs.value = allLogs.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
    } catch (e) {
        console.error(e);
    } finally {
        loading.value = false;
    }

    timeInterval = setInterval(() => {
        currentTime.value = Date.now();
    }, 30000);
});

onUnmounted(() => {
    if (timeInterval) {
        clearInterval(timeInterval);
    }
});

function formatDate(date) {
    return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

function getTimeAgo(date) {
    const now = currentTime.value;
    const past = new Date(date).getTime();
    const diffMs = now - past;
    const diffSeconds = Math.floor(diffMs / 1000);
    const diffMinutes = Math.floor(diffSeconds / 60);
    const diffHours = Math.floor(diffMinutes / 60);
    const diffDays = Math.floor(diffHours / 24);
    const diffWeeks = Math.floor(diffDays / 7);
    const diffMonths = Math.floor(diffDays / 30);

    if (diffSeconds < 60) return 'Just now';
    if (diffMinutes === 1) return '1 minute ago';
    if (diffMinutes < 60) return `${diffMinutes} minutes ago`;
    if (diffHours === 1) return '1 hour ago';
    if (diffHours < 24) return `${diffHours} hours ago`;
    if (diffDays === 1) return '1 day ago';
    if (diffDays < 7) return `${diffDays} days ago`;
    if (diffWeeks === 1) return '1 week ago';
    if (diffWeeks < 4) return `${diffWeeks} weeks ago`;
    if (diffMonths === 1) return '1 month ago';
    return `${diffMonths} months ago`;
}

function getActionText(log) {
    if (!log.from_status || log.from_status === 'none') {
        return 'Ticket Created';
    }
    if (log.to_status === 'resolved') {
        return 'Resolved';
    }
    if (log.to_status === 'in_progress') {
        return 'Started Progress';
    }
    return 'Status Changed';
}

function getActionColor(log) {
    if (!log.from_status || log.from_status === 'none') {
        return 'bg-blue-100 text-blue-700';
    }
    if (log.to_status === 'resolved') {
        return 'bg-emerald-100 text-emerald-700';
    }
    if (log.to_status === 'in_progress') {
        return 'bg-amber-100 text-amber-700';
    }
    return 'bg-slate-100 text-slate-700';
}
</script>

<template>
    <Head title="Ticket History" />

    <AppLayout>
        <div class="space-y-8">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                        <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-3xl font-extrabold text-slate-900">History</h1>
                        <p class="text-slate-500">Track all your ticket activity and changes</p>
                    </div>
                </div>
            </div>

            <div class="flex gap-2 p-1.5 bg-slate-100 rounded-2xl w-fit">
                <button
                    @click="activeTab = 'tickets'"
                    :class="[activeTab === 'tickets' ? 'bg-white shadow-sm text-slate-900' : 'text-slate-600 hover:text-slate-900', 'px-5 py-2.5 text-sm font-semibold rounded-xl transition-all']"
                >
                    All Tickets
                </button>
                <button
                    @click="activeTab = 'activity'"
                    :class="[activeTab === 'activity' ? 'bg-white shadow-sm text-slate-900' : 'text-slate-600 hover:text-slate-900', 'px-5 py-2.5 text-sm font-semibold rounded-xl transition-all']"
                >
                    Activity Log
                </button>
            </div>

            <div v-if="activeTab === 'tickets'" class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="px-8 py-6 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-purple-100 flex items-center justify-center">
                            <svg class="w-5 h-5 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                        </div>
                        <div>
                            <h2 class="text-lg font-bold text-slate-900">All Tickets</h2>
                            <p class="text-sm text-slate-500">{{ tickets.length }} total tickets</p>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <div v-if="loading" class="space-y-4">
                        <div v-for="i in 4" :key="i" class="h-20 bg-gradient-to-r from-slate-100 to-slate-50 rounded-2xl animate-pulse"></div>
                    </div>

                    <div v-else-if="tickets.length === 0" class="text-center py-16">
                        <div class="w-20 h-20 mx-auto rounded-full bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center mb-4">
                            <svg class="w-10 h-10 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                        </div>
                        <p class="text-slate-500 font-medium">No ticket history available</p>
                        <Link :href="route('tickets.create')" class="inline-flex items-center mt-4 px-4 py-2 bg-indigo-600 text-white text-sm font-semibold rounded-xl hover:bg-indigo-700 transition-colors">
                            Create your first ticket
                        </Link>
                    </div>

                    <div v-else class="space-y-3">
                        <Link v-for="ticket in tickets" :key="ticket.id" :href="route('tickets.show', ticket.id)" class="group flex items-center gap-4 p-5 rounded-2xl border-2 border-slate-100 hover:border-indigo-200 hover:bg-gradient-to-r hover:from-indigo-50/50 hover:to-purple-50/50 transition-all">
                            <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center text-slate-500 font-bold text-sm group-hover:from-indigo-100 group-hover:to-purple-100 group-hover:text-indigo-600 transition-colors">
                                #{{ ticket.user_ticket_number }}
                            </div>
                            <div class="flex-1 min-w-0">
                                <h3 class="text-sm font-bold text-slate-900 truncate group-hover:text-indigo-700 transition-colors">{{ ticket.title }}</h3>
                                <div class="flex items-center gap-3 mt-1">
                                    <span class="text-xs text-slate-400 font-medium">{{ formatDate(ticket.created_at) }}</span>
                                    <span v-if="ticket.category" class="text-xs text-purple-600 font-medium">{{ ticket.category }}</span>
                                </div>
                            </div>
                            <div class="flex items-center gap-3">
                                <div class="flex items-center gap-2">
                                    <span :class="[statusColors[ticket.status]?.dot, 'w-2 h-2 rounded-full']"></span>
                                    <span :class="[statusColors[ticket.status]?.bg, statusColors[ticket.status]?.text, 'px-3 py-1.5 text-xs font-bold rounded-xl capitalize']">
                                        {{ ticket.status?.replace('_', ' ') }}
                                    </span>
                                </div>
                                <svg class="w-5 h-5 text-slate-300 group-hover:text-indigo-500 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                                </svg>
                            </div>
                        </Link>
                    </div>
                </div>
            </div>

            <div v-if="activeTab === 'activity'" class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="px-8 py-6 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center">
                            <svg class="w-5 h-5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div>
                            <h2 class="text-lg font-bold text-slate-900">Activity Log</h2>
                            <p class="text-sm text-slate-500">Recent changes to your tickets</p>
                        </div>
                    </div>
                </div>
                <div class="p-6">
                    <div v-if="loading" class="space-y-4">
                        <div v-for="i in 4" :key="i" class="h-16 bg-gradient-to-r from-slate-100 to-slate-50 rounded-2xl animate-pulse"></div>
                    </div>

                    <div v-else-if="logs.length === 0" class="text-center py-16">
                        <div class="w-20 h-20 mx-auto rounded-full bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center mb-4">
                            <svg class="w-10 h-10 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <p class="text-slate-500 font-medium">No activity yet</p>
                    </div>

                    <div v-else class="space-y-4">
                        <div v-for="log in logs" :key="log.id" class="flex items-start gap-4 p-4 rounded-2xl bg-slate-50 hover:bg-slate-100 transition-colors">
                            <div :class="[getActionColor(log), 'w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0']">
                                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
                                </svg>
                            </div>
                            <div class="flex-1 min-w-0">
                                <div class="flex items-center gap-2">
                                    <span :class="[getActionColor(log), 'px-2 py-0.5 text-xs font-bold rounded-lg']">{{ getActionText(log) }}</span>
                                    <span class="text-xs text-slate-400">{{ getTimeAgo(log.created_at) }}</span>
                                </div>
                                <Link :href="route('tickets.show', log.ticket_id)" class="text-sm font-semibold text-slate-800 hover:text-indigo-600 mt-1 block truncate">
                                    #{{ log.ticket_id }} - {{ log.ticket_title }}
                                </Link>
                                <p v-if="log.from_status && log.from_status !== 'none'" class="text-xs text-slate-500 mt-1">
                                    {{ log.from_status }} → {{ log.to_status }}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>


