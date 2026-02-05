<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';
import axios from 'axios';
import Chart from 'chart.js/auto';

const loading = ref(true);
const stats = ref({ total: 0, open: 0, in_progress: 0, resolved_today: 0 });
const recentTickets = ref([]);

const priorityColors = {
    high: 'bg-gradient-to-r from-red-500 to-rose-500 text-white',
    medium: 'bg-gradient-to-r from-amber-500 to-orange-500 text-white',
    low: 'bg-gradient-to-r from-slate-400 to-slate-500 text-white'
};


onMounted(async () => {
    try {
        const { data } = await axios.get('/admin/api/dashboard/stats');
        stats.value.total = data.total;
        stats.value.open = data.open;
        stats.value.in_progress = data.in_progress;
        stats.value.resolved_today = data.resolved_today;
        recentTickets.value = data.recent_tickets;

        const ctx = document.getElementById('statusChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Open', 'In Progress'],
                    datasets: [{
                        data: [stats.value.open, stats.value.in_progress],
                        backgroundColor: ['#3B82F6', '#F59E0B'],
                        borderWidth: 0,
                        borderRadius: 8,
                        spacing: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: { size: 12, weight: '600' }
                            }
                        }
                    }
                }
            });
        }
    } catch (e) {
        console.error('Failed to load dashboard data');
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
</script>

<template>
    <Head title="Admin Dashboard" />

    <AppLayout>
        <div class="space-y-8">
            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center shadow-lg shadow-amber-500/30">
                            <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                        </div>
                        <div>
                            <h1 class="text-3xl font-extrabold text-slate-900">Admin Dashboard</h1>
                            <p class="text-slate-500 font-medium">Real-time overview of your ticketing system</p>
                        </div>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.tickets.queue')" class="inline-flex items-center px-5 py-2.5 bg-gradient-to-r from-amber-500 to-orange-600 text-white text-sm font-bold rounded-xl shadow-lg shadow-amber-500/30 hover:shadow-xl hover:scale-105 transition-all">
                        <svg class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                        </svg>
                        View Queue
                    </Link>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
                <div class="relative overflow-hidden bg-gradient-to-br from-indigo-500 via-purple-500 to-indigo-600 rounded-3xl p-6 shadow-xl shadow-indigo-500/20">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full blur-2xl transform translate-x-8 -translate-y-8"></div>
                    <div class="relative">
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-sm flex items-center justify-center">
                                <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                                </svg>
                            </div>
                            <span class="px-3 py-1 bg-white/20 backdrop-blur-sm text-white text-xs font-bold rounded-full">QUEUE</span>
                        </div>
                        <p class="text-white/80 text-sm font-semibold mb-1">Total in Queue</p>
                        <p class="text-5xl font-black text-white">{{ stats.total }}</p>
                        <p class="text-white/60 text-sm mt-2">Active tickets awaiting action</p>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center shadow-lg shadow-blue-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="flex flex-col items-end">
                            <span class="text-xs font-bold text-blue-600 bg-blue-50 px-2 py-1 rounded-lg">OPEN</span>
                        </div>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">Open Tickets</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.open }}</p>
                    <div class="mt-4 h-2 bg-slate-100 rounded-full overflow-hidden">
                        <div class="h-full bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full transition-all duration-500" :style="{ width: stats.total ? (stats.open / stats.total * 100) + '%' : '0%' }"></div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center shadow-lg shadow-amber-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                        </div>
                        <div class="flex flex-col items-end">
                            <span class="text-xs font-bold text-amber-600 bg-amber-50 px-2 py-1 rounded-lg">ACTIVE</span>
                        </div>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">In Progress</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.in_progress }}</p>
                    <div class="mt-4 h-2 bg-slate-100 rounded-full overflow-hidden">
                        <div class="h-full bg-gradient-to-r from-amber-500 to-orange-500 rounded-full transition-all duration-500" :style="{ width: stats.total ? (stats.in_progress / stats.total * 100) + '%' : '0%' }"></div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl p-6 shadow-xl shadow-slate-200/50 border border-slate-100 hover:shadow-2xl transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-emerald-500 to-teal-500 flex items-center justify-center shadow-lg shadow-emerald-500/30">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <div class="flex flex-col items-end">
                            <span class="text-xs font-bold text-emerald-600 bg-emerald-50 px-2 py-1 rounded-lg">TODAY</span>
                        </div>
                    </div>
                    <p class="text-slate-500 text-sm font-semibold mb-1">Resolved Today</p>
                    <p class="text-4xl font-black text-slate-900">{{ stats.resolved_today }}</p>
                    <div class="mt-4 flex items-center gap-2">
                        <svg class="w-4 h-4 text-emerald-500" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                        </svg>
                        <span class="text-sm font-medium text-emerald-600">Completed tickets</span>
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
                                <p class="text-sm text-slate-500">Latest submitted tickets</p>
                            </div>
                        </div>
                        <Link :href="route('admin.tickets.queue')" class="inline-flex items-center text-sm font-bold text-indigo-600 hover:text-indigo-700 bg-indigo-50 px-4 py-2 rounded-xl hover:bg-indigo-100 transition-colors">
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
                        <div v-else-if="recentTickets.length === 0" class="text-center py-16">
                            <div class="w-20 h-20 mx-auto rounded-full bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center mb-4">
                                <svg class="w-10 h-10 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                                </svg>
                            </div>
                            <p class="text-slate-500 font-medium">No tickets in queue</p>
                            <p class="text-sm text-slate-400 mt-1">All caught up!</p>
                        </div>
                        <div v-else class="space-y-3">
                            <Link v-for="ticket in recentTickets" :key="ticket.id" :href="route('admin.tickets.show', ticket.id)" class="group flex items-center gap-4 p-5 rounded-2xl border-2 border-slate-100 hover:border-indigo-200 hover:bg-gradient-to-r hover:from-indigo-50/50 hover:to-purple-50/50 transition-all">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center text-slate-500 font-bold text-sm group-hover:from-indigo-100 group-hover:to-purple-100 group-hover:text-indigo-600 transition-colors">
                                    #{{ ticket.id }}
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h3 class="text-sm font-bold text-slate-900 truncate group-hover:text-indigo-700 transition-colors">{{ ticket.title }}</h3>
                                    <div class="flex items-center gap-3 mt-1">
                                        <span class="text-xs text-slate-400 font-medium">{{ getTimeAgo(ticket.created_at) }}</span>
                                        <span class="w-1 h-1 rounded-full bg-slate-300"></span>
                                        <span class="text-xs text-slate-500">{{ ticket.user?.name || 'Unknown' }}</span>
                                    </div>
                                </div>
                                <span :class="[priorityColors[ticket.priority], 'px-3 py-1.5 text-xs font-bold rounded-xl shadow-sm uppercase tracking-wide']">
                                    {{ ticket.priority }}
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
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z" />
                                </svg>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900">Status Overview</h2>
                                <p class="text-sm text-slate-500">Ticket distribution</p>
                            </div>
                        </div>
                    </div>
                    <div class="p-6">
                        <div class="h-56">
                            <canvas id="statusChart"></canvas>
                        </div>
                        <div class="mt-6 space-y-3">
                            <div class="flex items-center justify-between p-3 rounded-xl bg-blue-50">
                                <div class="flex items-center gap-3">
                                    <div class="w-3 h-3 rounded-full bg-blue-500"></div>
                                    <span class="text-sm font-semibold text-slate-700">Open</span>
                                </div>
                                <span class="text-sm font-bold text-blue-600">{{ stats.open }}</span>
                            </div>
                            <div class="flex items-center justify-between p-3 rounded-xl bg-amber-50">
                                <div class="flex items-center gap-3">
                                    <div class="w-3 h-3 rounded-full bg-amber-500"></div>
                                    <span class="text-sm font-semibold text-slate-700">In Progress</span>
                                </div>
                                <span class="text-sm font-bold text-amber-600">{{ stats.in_progress }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <Link :href="route('admin.tickets.queue')" class="group relative overflow-hidden flex items-center p-6 rounded-3xl bg-gradient-to-br from-indigo-500 via-purple-500 to-indigo-600 text-white shadow-xl shadow-indigo-500/30 hover:shadow-2xl hover:scale-[1.02] transition-all">
                    <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full blur-2xl transform translate-x-8 -translate-y-8"></div>
                    <div class="relative w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-sm flex items-center justify-center mr-5">
                        <svg class="w-7 h-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                        </svg>
                    </div>
                    <div class="relative">
                        <p class="text-lg font-bold">Ticket Queue</p>
                        <p class="text-sm text-indigo-200">Process pending tickets</p>
                    </div>
                    <svg class="ml-auto w-6 h-6 text-white/50 group-hover:text-white group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                </Link>

                <Link :href="route('admin.tickets.logs')" class="group flex items-center p-6 rounded-3xl bg-white border-2 border-slate-100 shadow-xl shadow-slate-200/30 hover:border-indigo-200 hover:shadow-2xl hover:scale-[1.02] transition-all">
                    <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center mr-5 group-hover:from-indigo-100 group-hover:to-purple-100 transition-colors">
                        <svg class="w-7 h-7 text-slate-500 group-hover:text-indigo-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                    </div>
                    <div>
                        <p class="text-lg font-bold text-slate-900">Activity Logs</p>
                        <p class="text-sm text-slate-500">View system history</p>
                    </div>
                    <svg class="ml-auto w-6 h-6 text-slate-300 group-hover:text-indigo-500 group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                </Link>

                <a :href="route('api.admin.tickets.export')" class="group flex items-center p-6 rounded-3xl bg-white border-2 border-slate-100 shadow-xl shadow-slate-200/30 hover:border-emerald-200 hover:shadow-2xl hover:scale-[1.02] transition-all">
                    <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-slate-100 to-slate-50 flex items-center justify-center mr-5 group-hover:from-emerald-100 group-hover:to-teal-100 transition-colors">
                        <svg class="w-7 h-7 text-slate-500 group-hover:text-emerald-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                    </div>
                    <div>
                        <p class="text-lg font-bold text-slate-900">Export Data</p>
                        <p class="text-sm text-slate-500">Download CSV report</p>
                    </div>
                    <svg class="ml-auto w-6 h-6 text-slate-300 group-hover:text-emerald-500 group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                </a>
            </div>
        </div>
    </AppLayout>
</template>
