<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useToast } from 'vue-toastification';

const toast = useToast();
const logs = ref([]);
const loading = ref(true);

async function load() {
    try {
        const { data } = await axios.get('/admin/api/tickets/queue');
        const allLogs = [];
        for (const ticket of data) {
            const ticketData = await axios.get(`/admin/api/tickets/${ticket.id}`);
            if (ticketData.data.logs) {
                ticketData.data.logs.forEach(log => {
                    allLogs.push({ ...log, ticket: ticketData.data });
                });
            }
        }
        logs.value = allLogs.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
    } catch (e) {
        toast.error('Failed to load logs');
    } finally {
        loading.value = false;
    }
}

function formatDate(date) {
    return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' });
}

onMounted(load);
</script>

<template>
    <Head title="Activity Logs" />

    <AppLayout>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8">
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Activity Logs</h1>
                <p class="mt-1 text-slate-500">Track all ticket status changes and actions</p>
            </div>
            <a :href="route('api.admin.tickets.export')" class="mt-4 sm:mt-0 inline-flex items-center px-4 py-2.5 bg-white border border-slate-200 text-slate-700 text-sm font-semibold rounded-xl hover:bg-slate-50 transition-all shadow-sm">
                <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                Export CSV
            </a>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
            <div v-if="loading" class="p-6 space-y-4">
                <div v-for="i in 5" :key="i" class="h-16 bg-slate-100 rounded-xl animate-pulse"></div>
            </div>

            <div v-else-if="logs.length === 0" class="p-12 text-center">
                <div class="w-16 h-16 mx-auto rounded-full bg-slate-100 flex items-center justify-center mb-4">
                    <svg class="w-8 h-8 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                </div>
                <h3 class="text-lg font-semibold text-slate-900 mb-2">No activity logs</h3>
                <p class="text-slate-500">Activity will appear here when tickets are updated.</p>
            </div>

            <div v-else>
                <table class="w-full">
                    <thead class="bg-slate-50 border-b border-slate-100">
                        <tr>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Ticket</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Action</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider hidden sm:table-cell">By</th>
                            <th class="px-6 py-4 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Date</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <tr v-for="log in logs" :key="log.id" class="hover:bg-slate-50 transition-colors">
                            <td class="px-6 py-4">
                                <Link :href="route('admin.tickets.show', log.ticket?.id)" class="text-sm font-semibold text-indigo-600 hover:text-indigo-700">
                                    #{{ log.ticket?.id }} - {{ log.ticket?.title }}
                                </Link>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-2">
                                    <span class="px-2 py-1 bg-blue-100 text-blue-700 text-xs font-semibold rounded-md">Status</span>
                                    <span class="text-sm text-slate-600">
                                        {{ log.from_status || 'none' }} → {{ log.to_status }}
                                    </span>
                                </div>
                            </td>
                            <td class="px-6 py-4 hidden sm:table-cell">
                                <span class="text-sm text-slate-600">{{ log.user?.name || 'System' }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="text-sm text-slate-500">{{ formatDate(log.created_at) }}</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </AppLayout>
</template>
