<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';

const tickets = ref([]);
const loading = ref(true);
const searchQuery = ref('');
const statusFilter = ref('all');
const priorityFilter = ref('all');
const expandedTicket = ref(null);

const statusColors = {
    open: { bg: 'bg-blue-100', text: 'text-blue-700', dot: 'bg-blue-500' },
    in_progress: { bg: 'bg-amber-100', text: 'text-amber-700', dot: 'bg-amber-500' },
    resolved: { bg: 'bg-emerald-100', text: 'text-emerald-700', dot: 'bg-emerald-500' }
};

const priorityColors = {
    high: { bg: 'bg-red-100', text: 'text-red-700', border: 'border-red-200' },
    medium: { bg: 'bg-orange-100', text: 'text-orange-700', border: 'border-orange-200' },
    low: { bg: 'bg-slate-100', text: 'text-slate-600', border: 'border-slate-200' }
};

const filteredTickets = computed(() => {
    let result = tickets.value;

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(t =>
            t.title.toLowerCase().includes(query) ||
            t.description.toLowerCase().includes(query) ||
            t.id.toString().includes(query) ||
            t.user?.name?.toLowerCase().includes(query) ||
            t.user?.email?.toLowerCase().includes(query)
        );
    }

    if (statusFilter.value !== 'all') {
        result = result.filter(t => t.status === statusFilter.value);
    }

    if (priorityFilter.value !== 'all') {
        result = result.filter(t => t.priority === priorityFilter.value);
    }

    return result;
});

const stats = computed(() => ({
    total: tickets.value.length,
    open: tickets.value.filter(t => t.status === 'open').length,
    in_progress: tickets.value.filter(t => t.status === 'in_progress').length,
    resolved: tickets.value.filter(t => t.status === 'resolved').length
}));

function formatDate(date) {
    return new Date(date).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function formatStatus(status) {
    return status.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
}

function toggleExpand(ticketId) {
    expandedTicket.value = expandedTicket.value === ticketId ? null : ticketId;
}

onMounted(async () => {
    try {
        const { data } = await axios.get('/admin/api/tickets/all');
        tickets.value = data;
    } catch (e) {
        console.error('Failed to load tickets:', e);
    } finally {
        loading.value = false;
    }
});
</script>

<template>
    <Head title="Ticket Details" />

    <AppLayout>
        <div class="space-y-6">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                    <h1 class="text-3xl font-extrabold text-slate-900">Ticket Details</h1>
                    <p class="mt-1 text-slate-500">View comprehensive details of all tickets</p>
                </div>
            </div>

            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-5">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-xl bg-slate-100 flex items-center justify-center">
                            <svg class="w-6 h-6 text-slate-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                            </svg>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-slate-900">{{ stats.total }}</p>
                            <p class="text-sm text-slate-500">Total Tickets</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-5">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center">
                            <svg class="w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-blue-600">{{ stats.open }}</p>
                            <p class="text-sm text-slate-500">Open</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-5">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-xl bg-amber-100 flex items-center justify-center">
                            <svg class="w-6 h-6 text-amber-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-amber-600">{{ stats.in_progress }}</p>
                            <p class="text-sm text-slate-500">In Progress</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-5">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-xl bg-emerald-100 flex items-center justify-center">
                            <svg class="w-6 h-6 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-emerald-600">{{ stats.resolved }}</p>
                            <p class="text-sm text-slate-500">Resolved</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6">
                <div class="flex flex-col lg:flex-row gap-4 mb-6">
                    <div class="flex-1 relative">
                        <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                        <input
                            v-model="searchQuery"
                            type="text"
                            placeholder="Search by ID, title, description, or user..."
                            class="w-full pl-12 pr-4 py-3 bg-slate-50 border-2 border-slate-200 rounded-xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 transition-all"
                        />
                    </div>
                    <div class="flex gap-3">
                        <select
                            v-model="statusFilter"
                            class="px-4 py-3 bg-slate-50 border-2 border-slate-200 rounded-xl text-slate-700 focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 transition-all"
                        >
                            <option value="all">All Status</option>
                            <option value="open">Open</option>
                            <option value="in_progress">In Progress</option>
                            <option value="resolved">Resolved</option>
                        </select>
                        <select
                            v-model="priorityFilter"
                            class="px-4 py-3 bg-slate-50 border-2 border-slate-200 rounded-xl text-slate-700 focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 transition-all"
                        >
                            <option value="all">All Priority</option>
                            <option value="high">High</option>
                            <option value="medium">Medium</option>
                            <option value="low">Low</option>
                        </select>
                    </div>
                </div>

                <div v-if="loading" class="space-y-4">
                    <div v-for="i in 5" :key="i" class="h-24 bg-slate-100 rounded-xl animate-pulse"></div>
                </div>

                <div v-else-if="filteredTickets.length === 0" class="text-center py-12">
                    <svg class="w-16 h-16 mx-auto text-slate-300 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                    <p class="text-slate-500 text-lg font-medium">No tickets found</p>
                    <p class="text-slate-400 text-sm mt-1">Try adjusting your search or filters</p>
                </div>

                <div v-else class="space-y-4">
                    <div
                        v-for="ticket in filteredTickets"
                        :key="ticket.id"
                        class="border border-slate-200 rounded-2xl overflow-hidden hover:shadow-md transition-all"
                    >
                        <div
                            @click="toggleExpand(ticket.id)"
                            class="p-5 cursor-pointer hover:bg-slate-50 transition-colors"
                        >
                            <div class="flex items-start justify-between gap-4">
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center gap-3 mb-2">
                                        <span class="text-sm font-bold text-slate-400">#{{ ticket.id }}</span>
                                        <span :class="[statusColors[ticket.status]?.bg, statusColors[ticket.status]?.text, 'px-2.5 py-1 rounded-lg text-xs font-semibold']">
                                            {{ formatStatus(ticket.status) }}
                                        </span>
                                        <span :class="[priorityColors[ticket.priority]?.bg, priorityColors[ticket.priority]?.text, 'px-2.5 py-1 rounded-lg text-xs font-semibold']">
                                            {{ ticket.priority?.toUpperCase() }}
                                        </span>
                                    </div>
                                    <h3 class="text-lg font-bold text-slate-900 truncate">{{ ticket.title }}</h3>
                                    <p class="text-sm text-slate-500 mt-1 line-clamp-2">{{ ticket.description }}</p>
                                </div>
                                <div class="flex items-center gap-3">
                                    <div class="text-right hidden sm:block">
                                        <p class="text-sm font-medium text-slate-900">{{ ticket.user?.name }}</p>
                                        <p class="text-xs text-slate-500">{{ ticket.user?.email }}</p>
                                    </div>
                                    <svg
                                        :class="['w-5 h-5 text-slate-400 transition-transform', expandedTicket === ticket.id ? 'rotate-180' : '']"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke="currentColor"
                                    >
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div v-if="expandedTicket === ticket.id" class="border-t border-slate-200 bg-slate-50 p-5">
                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                <div class="space-y-4">
                                    <div>
                                        <h4 class="text-sm font-bold text-slate-700 mb-2">Ticket Information</h4>
                                        <div class="bg-white rounded-xl p-4 space-y-3 border border-slate-200">
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Ticket ID</span>
                                                <span class="text-sm font-semibold text-slate-900">#{{ ticket.id }}</span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Category</span>
                                                <span class="text-sm font-semibold text-slate-900">{{ ticket.category || 'N/A' }}</span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Priority</span>
                                                <span :class="[priorityColors[ticket.priority]?.bg, priorityColors[ticket.priority]?.text, 'px-2 py-0.5 rounded-md text-xs font-semibold']">
                                                    {{ ticket.priority?.toUpperCase() }}
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Status</span>
                                                <span :class="[statusColors[ticket.status]?.bg, statusColors[ticket.status]?.text, 'px-2 py-0.5 rounded-md text-xs font-semibold']">
                                                    {{ formatStatus(ticket.status) }}
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Created</span>
                                                <span class="text-sm font-semibold text-slate-900">{{ formatDate(ticket.created_at) }}</span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-sm text-slate-500">Last Updated</span>
                                                <span class="text-sm font-semibold text-slate-900">{{ formatDate(ticket.updated_at) }}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <h4 class="text-sm font-bold text-slate-700 mb-2">Submitted By</h4>
                                        <div class="bg-white rounded-xl p-4 border border-slate-200">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-emerald-500 flex items-center justify-center text-white font-bold">
                                                    {{ ticket.user?.name?.charAt(0).toUpperCase() }}
                                                </div>
                                                <div>
                                                    <p class="text-sm font-semibold text-slate-900">{{ ticket.user?.name }}</p>
                                                    <p class="text-xs text-slate-500">{{ ticket.user?.email }}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <h4 class="text-sm font-bold text-slate-700 mb-2">Description</h4>
                                        <div class="bg-white rounded-xl p-4 border border-slate-200">
                                            <p class="text-sm text-slate-700 whitespace-pre-wrap">{{ ticket.description }}</p>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <h4 class="text-sm font-bold text-slate-700 mb-2">Activity History</h4>
                                    <div class="bg-white rounded-xl p-4 border border-slate-200 max-h-80 overflow-y-auto">
                                        <div v-if="ticket.logs && ticket.logs.length > 0" class="space-y-3">
                                            <div
                                                v-for="log in ticket.logs"
                                                :key="log.id"
                                                class="flex items-start gap-3 pb-3 border-b border-slate-100 last:border-0 last:pb-0"
                                            >
                                                <div :class="[
                                                    'w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0',
                                                    log.to_status === 'resolved' ? 'bg-emerald-100' :
                                                    log.to_status === 'in_progress' ? 'bg-amber-100' :
                                                    'bg-blue-100'
                                                ]">
                                                    <svg
                                                        :class="[
                                                            'w-4 h-4',
                                                            log.to_status === 'resolved' ? 'text-emerald-600' :
                                                            log.to_status === 'in_progress' ? 'text-amber-600' :
                                                            'text-blue-600'
                                                        ]"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke="currentColor"
                                                    >
                                                        <path v-if="log.to_status === 'resolved'" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                        <path v-else-if="log.to_status === 'in_progress'" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                                                        <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                                    </svg>
                                                </div>
                                                <div class="flex-1 min-w-0">
                                                    <p class="text-sm font-medium text-slate-900">
                                                        {{ !log.from_status || log.from_status === 'none' ? 'Ticket Created' : `Status: ${formatStatus(log.from_status)} → ${formatStatus(log.to_status)}` }}
                                                    </p>
                                                    <p class="text-xs text-slate-500 mt-0.5">
                                                        by {{ log.user?.name || 'System' }} • {{ formatDate(log.created_at) }}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div v-else class="text-center py-4 text-slate-400 text-sm">
                                            No activity recorded
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 pt-4 border-t border-slate-200 flex justify-end">
                                <Link
                                    :href="route('admin.tickets.show', ticket.id)"
                                    class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-500 to-emerald-500 text-white text-sm font-semibold rounded-xl hover:shadow-lg transition-all"
                                >
                                    <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                    View Full Details
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

