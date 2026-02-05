<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link, usePage } from '@inertiajs/vue3';
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';

const page = usePage();
const user = computed(() => page.props.auth?.user);
const tickets = ref([]);
const loading = ref(true);
const stats = ref({ total: 0, open: 0, in_progress: 0, resolved: 0 });

const statusConfig = {
    open: { color: 'bg-gradient-to-r from-blue-500 to-cyan-500 text-white', bg: 'bg-blue-50', text: 'text-blue-600', icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' },
    in_progress: { color: 'bg-gradient-to-r from-amber-500 to-orange-500 text-white', bg: 'bg-amber-50', text: 'text-amber-600', icon: 'M13 10V3L4 14h7v7l9-11h-7z' },
    resolved: { color: 'bg-gradient-to-r from-emerald-500 to-teal-500 text-white', bg: 'bg-emerald-50', text: 'text-emerald-600', icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' }
};

onMounted(async () => {
    try {
        const { data } = await axios.get('/api/tickets');
        tickets.value = data.slice(0, 5);
        stats.value.total = data.length;
        stats.value.open = data.filter(t => t.status === 'open').length;
        stats.value.in_progress = data.filter(t => t.status === 'in_progress').length;
        stats.value.resolved = data.filter(t => t.status === 'resolved').length;
    } catch (e) {
        console.error(e);
    } finally {
        loading.value = false;
    }
});

function getTimeAgo(date) {
    const now = new Date();
    const past = new Date(date);
    const diffMs = now - past;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);

    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    return `${diffDays}d ago`;
}

function getGreeting() {
    const hour = new Date().getHours();
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
}
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout>
        <div class="space-y-8">
            <div class="relative overflow-hidden bg-gradient-to-br from-indigo-500 via-purple-500 to-indigo-600 rounded-3xl p-8 shadow-xl shadow-indigo-500/20">
                <div class="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl transform translate-x-16 -translate-y-16"></div>
                <div class="absolute bottom-0 left-0 w-48 h-48 bg-white/10 rounded-full blur-3xl transform -translate-x-12 translate-y-12"></div>
                <div class="relative flex flex-col md:flex-row md:items-center md:justify-between gap-6">
                    <div>
                        <p class="text-indigo-200 font-medium mb-1">{{ getGreeting() }}</p>
                        <h1 class="text-3xl md:text-4xl font-extrabold text-white mb-2">Welcome back, {{ user?.name?.split(' ')[0] }}!</h1>
                        <p class="text-indigo-200 text-lg">Here's what's happening with your tickets today.</p>
                    </div>
                    <Link :href="route('tickets.create')" class="inline-flex items-center px-6 py-3.5 bg-white text-indigo-600 text-sm font-bold rounded-2xl shadow-lg hover:shadow-xl hover:scale-105 transition-all">
                        <svg class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4" />
                        </svg>
                        New Ticket
                    </Link>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6">
                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-all hover:scale-[1.02]">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                            </svg>
                        </div>
                        <span class="text-xs font-bold text-indigo-600 bg-indigo-50 px-2.5 py-1 rounded-lg">TOTAL</span>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">Total Tickets</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.total }}</p>
                    <div class="mt-3 flex items-center gap-2 text-sm">
                        <span class="text-slate-400">All your support requests</span>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-all hover:scale-[1.02]">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center shadow-lg shadow-blue-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <span class="text-xs font-bold text-blue-600 bg-blue-50 px-2.5 py-1 rounded-lg">OPEN</span>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">Open</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.open }}</p>
                    <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                        <div class="h-full bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full transition-all duration-500" :style="{ width: stats.total ? (stats.open / stats.total * 100) + '%' : '0%' }"></div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-all hover:scale-[1.02]">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center shadow-lg shadow-amber-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                        </div>
                        <span class="text-xs font-bold text-amber-600 bg-amber-50 px-2.5 py-1 rounded-lg">ACTIVE</span>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">In Progress</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.in_progress }}</p>
                    <div class="mt-3 h-2 bg-slate-100 rounded-full overflow-hidden">
                        <div class="h-full bg-gradient-to-r from-amber-500 to-orange-500 rounded-full transition-all duration-500" :style="{ width: stats.total ? (stats.in_progress / stats.total * 100) + '%' : '0%' }"></div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-all hover:scale-[1.02]">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-emerald-500 to-teal-500 flex items-center justify-center shadow-lg shadow-emerald-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <span class="text-xs font-bold text-emerald-600 bg-emerald-50 px-2.5 py-1 rounded-lg">DONE</span>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">Resolved</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.resolved }}</p>
                    <div class="mt-3 flex items-center gap-2">
                        <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                        </svg>
                        <span class="text-sm font-medium text-emerald-600">Completed</span>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
                <div class="xl:col-span-2 bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                    <div class="px-8 py-6 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-indigo-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                                </svg>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900">Recent Tickets</h2>
                                <p class="text-sm text-slate-500">Your latest support requests</p>
                            </div>
                        </div>
                        <Link :href="route('tickets.index')" class="inline-flex items-center text-sm font-bold text-indigo-600 hover:text-indigo-700 bg-indigo-50 px-4 py-2 rounded-xl hover:bg-indigo-100 transition-colors">
                            View All
                            <svg class="w-4 h-4 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </Link>
                    </div>
                    <div class="p-6">
                        <div v-if="loading" class="space-y-4">
                            <div v-for="i in 4" :key="i" class="h-20 bg-gradient-to-r from-slate-100 to-slate-50 rounded-2xl animate-pulse"></div>
                        </div>
                        <div v-else-if="tickets.length === 0" class="text-center py-16">
                            <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-indigo-100 to-purple-100 flex items-center justify-center mb-6">
                                <svg class="w-12 h-12 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                                </svg>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 mb-2">No tickets yet</h3>
                            <p class="text-slate-500 mb-6">Create your first ticket to get started</p>
                            <Link :href="route('tickets.create')" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white text-sm font-bold rounded-xl shadow-lg shadow-indigo-500/30 hover:shadow-xl hover:scale-105 transition-all">
                                <svg class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                </svg>
                                Create Ticket
                            </Link>
                        </div>
                        <div v-else class="space-y-3">
                            <Link v-for="ticket in tickets" :key="ticket.id" :href="route('tickets.show', ticket.id)" class="group flex items-center gap-4 p-5 rounded-2xl border-2 border-slate-100 hover:border-indigo-200 hover:bg-gradient-to-r hover:from-indigo-50/50 hover:to-purple-50/50 transition-all">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center text-slate-500 font-bold text-sm group-hover:from-indigo-100 group-hover:to-purple-100 group-hover:text-indigo-600 transition-colors">
                                    #{{ ticket.id }}
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h3 class="text-sm font-bold text-slate-900 truncate group-hover:text-indigo-700 transition-colors">{{ ticket.title }}</h3>
                                    <p class="text-xs text-slate-400 font-medium mt-1">{{ getTimeAgo(ticket.created_at) }}</p>
                                </div>
                                <span :class="[statusConfig[ticket.status]?.color || 'bg-slate-500 text-white', 'px-3 py-1.5 text-xs font-bold rounded-xl shadow-sm capitalize']">
                                    {{ ticket.status?.replace('_', ' ') }}
                                </span>
                                <svg class="w-5 h-5 text-slate-300 group-hover:text-indigo-500 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                                </svg>
                            </Link>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                    <div class="px-6 py-5 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-purple-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                                </svg>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900">Quick Actions</h2>
                                <p class="text-sm text-slate-500">Common tasks</p>
                            </div>
                        </div>
                    </div>
                    <div class="p-6 space-y-4">
                        <Link :href="route('tickets.create')" class="group flex items-center p-5 rounded-2xl bg-gradient-to-br from-indigo-500 to-purple-600 text-white shadow-lg shadow-indigo-500/30 hover:shadow-xl hover:scale-[1.02] transition-all">
                            <div class="w-12 h-12 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center mr-4">
                                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="font-bold">New Ticket</p>
                                <p class="text-sm text-indigo-200">Create a support request</p>
                            </div>
                            <svg class="w-5 h-5 text-white/50 group-hover:text-white group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </Link>

                        <Link :href="route('tickets.index')" class="group flex items-center p-5 rounded-2xl border-2 border-slate-100 hover:border-purple-200 hover:bg-purple-50/50 transition-all">
                            <div class="w-12 h-12 rounded-xl bg-purple-100 flex items-center justify-center mr-4 group-hover:bg-purple-200 transition-colors">
                                <svg class="w-6 h-6 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="font-bold text-slate-900">My Tickets</p>
                                <p class="text-sm text-slate-500">View all your tickets</p>
                            </div>
                            <svg class="w-5 h-5 text-slate-300 group-hover:text-purple-500 group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </Link>

                        <Link :href="route('tickets.history')" class="group flex items-center p-5 rounded-2xl border-2 border-slate-100 hover:border-blue-200 hover:bg-blue-50/50 transition-all">
                            <div class="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center mr-4 group-hover:bg-blue-200 transition-colors">
                                <svg class="w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="font-bold text-slate-900">History</p>
                                <p class="text-sm text-slate-500">Track ticket changes</p>
                            </div>
                            <svg class="w-5 h-5 text-slate-300 group-hover:text-blue-500 group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </Link>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
