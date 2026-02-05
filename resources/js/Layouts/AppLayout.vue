<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';

const page = usePage();
const user = computed(() => page.props.auth?.user);
const isAdmin = computed(() => user.value?.is_admin === true || user.value?.is_admin === 1);
const flash = computed(() => page.props.flash);

const sidebarOpen = ref(false);
const dropdownOpen = ref(false);
const sessionTime = ref('');
const currentDate = ref('');
const showFlash = ref(false);

const userNavigation = [
    { name: 'Dashboard', href: 'dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6', badge: null },
    { name: 'My Tickets', href: 'tickets.index', icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4', badge: null },
    { name: 'Create Ticket', href: 'tickets.create', icon: 'M12 4v16m8-8H4', badge: 'NEW' },
    { name: 'History', href: 'tickets.history', icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z', badge: null },
];

const adminNavigation = [
    { name: 'Dashboard', href: 'admin.dashboard', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', badge: null },
    { name: 'Ticket Queue', href: 'admin.tickets.queue', icon: 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10', badge: null },
    { name: 'Ticket Details', href: 'admin.tickets.details', icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01', badge: null },
    { name: 'Ticket History Log', href: 'admin.tickets.logs', icon: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z', badge: null },
];

function updateSessionTime() {
    const now = new Date();
    sessionTime.value = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
    currentDate.value = now.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
}

watch(flash, (newFlash) => {
    if (newFlash?.error || newFlash?.warning || newFlash?.success) {
        showFlash.value = true;
        setTimeout(() => showFlash.value = false, 5000);
    }
}, { immediate: true });

onMounted(() => {
    updateSessionTime();
    setInterval(updateSessionTime, 60000);
});

function logout() {
    router.post(route('logout'));
}
</script>

<template>
    <div class="min-h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100">
        <div v-if="sidebarOpen" class="fixed inset-0 z-40 lg:hidden" @click="sidebarOpen = false">
            <div class="fixed inset-0 bg-slate-900/80 backdrop-blur-sm"></div>
        </div>

        <aside :class="['fixed inset-y-0 left-0 z-50 w-72 transform transition-transform duration-300 ease-in-out lg:translate-x-0', sidebarOpen ? 'translate-x-0' : '-translate-x-full']" :style="{ background: isAdmin ? 'linear-gradient(to bottom, #1e40af, #047857, #059669)' : 'linear-gradient(to bottom, #0891b2, #0284c7, #0369a1)' }">
            <div class="flex flex-col h-full">
                <div class="flex items-center justify-between h-20 px-6 border-b border-white/10">
                    <Link href="/" class="flex items-center space-x-3 group">
                        <div :class="['w-12 h-12 rounded-2xl flex items-center justify-center shadow-2xl transform transition-transform group-hover:scale-110', isAdmin ? 'bg-gradient-to-br from-blue-400 to-emerald-400 shadow-blue-500/50' : 'bg-gradient-to-br from-cyan-400 to-sky-500 shadow-cyan-500/50']">
                            <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                            </svg>
                        </div>
                        <div>
                            <span class="text-2xl font-bold text-white tracking-tight">ServiQ</span>
                            <p v-if="isAdmin" class="text-xs text-emerald-300 font-medium">Admin Panel</p>
                        </div>
                    </Link>
                    <button @click="sidebarOpen = false" class="lg:hidden text-white/70 hover:text-white transition-colors">
                        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <div class="flex-1 overflow-y-auto py-8 px-4">
                    <nav v-if="!isAdmin" class="space-y-2">
                        <Link v-for="item in userNavigation" :key="item.name" :href="route(item.href)" :class="['group flex items-center px-4 py-3.5 text-sm font-semibold rounded-2xl transition-all duration-200', route().current(item.href) ? 'bg-gradient-to-r from-cyan-500 to-sky-600 text-white shadow-lg shadow-cyan-500/30 scale-105' : 'text-slate-300 hover:text-white hover:bg-white/10']">
                            <svg class="w-5 h-5 mr-3 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="item.icon" />
                            </svg>
                            <span>{{ item.name }}</span>
                        </Link>
                    </nav>

                    <nav v-if="isAdmin" class="space-y-2">
                        <Link v-for="item in adminNavigation" :key="item.name" :href="route(item.href)" :class="['group flex items-center px-4 py-3.5 text-sm font-semibold rounded-2xl transition-all duration-200', route().current(item.href) ? 'bg-gradient-to-r from-blue-400 to-emerald-400 text-white shadow-lg shadow-blue-400/30 scale-105' : 'text-emerald-100 hover:text-white hover:bg-white/10']">
                            <svg class="w-5 h-5 mr-3 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="item.icon" />
                            </svg>
                            <span>{{ item.name }}</span>
                        </Link>
                    </nav>
                </div>

                <div class="p-4 border-t border-white/10">
                    <div :class="['p-4 rounded-2xl backdrop-blur-sm', isAdmin ? 'bg-emerald-700/30' : 'bg-sky-900/30']">
                        <div class="flex items-center space-x-3">
                            <div :class="['w-12 h-12 rounded-full flex items-center justify-center text-white font-bold text-lg shadow-lg', isAdmin ? 'bg-gradient-to-br from-blue-400 to-emerald-500' : 'bg-gradient-to-br from-cyan-400 to-sky-500']">
                                {{ user?.name?.charAt(0).toUpperCase() }}
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-semibold text-white truncate">{{ user?.name }}</p>
                                <p :class="['text-xs truncate', isAdmin ? 'text-emerald-200' : 'text-cyan-200']">{{ user?.email }}</p>
                            </div>
                        </div>
                        <div v-if="isAdmin" class="mt-3 px-3 py-1.5 bg-emerald-400/20 rounded-lg border border-emerald-400/30">
                            <p class="text-xs font-bold text-emerald-200 text-center">ADMINISTRATOR</p>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <div class="lg:pl-80">
            <header class="sticky top-0 z-30">
                <div class="absolute inset-0 bg-white/80 backdrop-blur-xl border-b border-slate-200/60"></div>
                <div class="relative flex items-center justify-between h-20 px-4 sm:px-6 lg:px-8">
                    <div class="flex items-center gap-4">
                        <button @click="sidebarOpen = true" class="lg:hidden p-2.5 rounded-xl bg-slate-100 text-slate-600 hover:text-slate-900 hover:bg-slate-200 transition-all active:scale-95">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
                            </svg>
                        </button>
                        <div class="hidden lg:flex items-center">
                            <div class="flex items-center gap-3 px-4 py-2 rounded-2xl bg-gradient-to-r from-slate-50 to-white border border-slate-200/80 shadow-sm">
                                <div class="flex items-center gap-2">
                                    <svg class="w-4 h-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    <span class="text-sm font-semibold text-slate-600">{{ currentDate }}</span>
                                </div>
                                <div class="w-px h-4 bg-slate-200"></div>
                                <div class="flex items-center gap-2">
                                    <svg class="w-4 h-4 text-cyan-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span class="text-sm font-bold text-slate-800">{{ sessionTime }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center gap-2 sm:gap-3">
                        <div class="hidden md:flex items-center gap-2 px-3 py-2 rounded-xl bg-gradient-to-r from-emerald-50 to-teal-50 border border-emerald-100">
                            <span class="relative flex h-2.5 w-2.5">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                                <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
                            </span>
                            <span class="text-xs font-bold text-emerald-700 uppercase tracking-wide">Online</span>
                        </div>
                        <div class="relative">
                            <button @click="dropdownOpen = !dropdownOpen" class="flex items-center gap-3 p-1.5 pr-3 rounded-2xl hover:bg-slate-100 transition-all group">
                                <div :class="['relative w-10 h-10 rounded-xl flex items-center justify-center text-white font-bold shadow-lg ring-2 ring-white', isAdmin ? 'bg-gradient-to-br from-blue-400 to-emerald-400' : 'bg-gradient-to-br from-cyan-400 to-sky-600']">
                                    <span class="absolute -top-0.5 -right-0.5 w-3 h-3 bg-emerald-500 rounded-full border-2 border-white"></span>
                                    {{ user?.name?.charAt(0).toUpperCase() }}
                                </div>
                                <div class="hidden sm:block text-left">
                                    <p class="text-sm font-bold text-slate-800 group-hover:text-slate-900">{{ user?.name?.split(' ')[0] }}</p>
                                    <p :class="['text-xs font-medium', isAdmin ? 'text-emerald-500' : 'text-cyan-600']">{{ isAdmin ? 'Admin' : 'User' }}</p>
                                </div>
                                <svg class="w-4 h-4 text-slate-400 group-hover:text-slate-600 transition-transform" :class="{ 'rotate-180': dropdownOpen }" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </button>
                            <Transition enter-active-class="transition ease-out duration-200" enter-from-class="opacity-0 scale-95 -translate-y-2" enter-to-class="opacity-100 scale-100 translate-y-0" leave-active-class="transition ease-in duration-150" leave-from-class="opacity-100 scale-100 translate-y-0" leave-to-class="opacity-0 scale-95 -translate-y-2">
                                <div v-if="dropdownOpen" class="absolute right-0 mt-3 w-72 bg-white rounded-2xl shadow-2xl shadow-slate-200/50 border border-slate-100 overflow-hidden z-50">
                                    <div class="p-4 bg-gradient-to-br from-slate-50 to-white border-b border-slate-100">
                                        <div class="flex items-center gap-3">
                                            <div :class="['w-12 h-12 rounded-xl flex items-center justify-center text-white font-bold text-lg shadow-lg', isAdmin ? 'bg-gradient-to-br from-blue-500 to-emerald-400' : 'bg-gradient-to-br from-cyan-400 to-sky-600']">
                                                {{ user?.name?.charAt(0).toUpperCase() }}
                                            </div>
                                            <div class="flex-1 min-w-0">
                                                <p class="text-sm font-bold text-slate-900 truncate">{{ user?.name }}</p>
                                                <p class="text-xs text-slate-500 truncate">{{ user?.email }}</p>
                                            </div>
                                        </div>
                                        <div v-if="isAdmin" class="mt-3 flex items-center gap-2 px-3 py-1.5 bg-gradient-to-r from-blue-500 to-emerald-400 rounded-lg">
                                            <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                            </svg>
                                            <span class="text-xs font-bold text-white">Administrator Access</span>
                                        </div>
                                    </div>
                                    <div class="p-2">
                                        <Link :href="route('profile.edit')" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-slate-700 hover:bg-slate-50 transition-colors group">
                                            <div class="w-9 h-9 rounded-lg bg-slate-100 flex items-center justify-center group-hover:bg-cyan-100 transition-colors">
                                                <svg class="w-5 h-5 text-slate-500 group-hover:text-cyan-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                                </svg>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold">Profile Settings</p>
                                                <p class="text-xs text-slate-500">Manage your account</p>
                                            </div>
                                        </Link>
                                    </div>
                                    <div class="p-2 border-t border-slate-100">
                                        <button @click="logout" class="flex items-center gap-3 w-full px-3 py-2.5 rounded-xl text-red-600 hover:bg-red-50 transition-colors group">
                                            <div class="w-9 h-9 rounded-lg bg-red-50 flex items-center justify-center group-hover:bg-red-100 transition-colors">
                                                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                                </svg>
                                            </div>
                                            <div class="text-left">
                                                <p class="text-sm font-semibold">Sign Out</p>
                                                <p class="text-xs text-red-400">End your session</p>
                                            </div>
                                        </button>
                                    </div>
                                </div>
                            </Transition>
                        </div>
                    </div>
                </div>
            </header>

            <main class="p-6 sm:p-8 lg:p-10">
                <div v-if="showFlash && (flash?.error || flash?.warning)" class="mb-6 p-4 rounded-xl bg-red-50 border border-red-200">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 text-red-500 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                        <p class="text-sm font-medium text-red-800">{{ flash?.error || flash?.warning }}</p>
                    </div>
                </div>
                <div v-if="showFlash && flash?.success" class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200">
                    <div class="flex items-center">
                        <svg class="w-5 h-5 text-emerald-500 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <p class="text-sm font-medium text-emerald-800">{{ flash?.success }}</p>
                    </div>
                </div>
                <slot />
            </main>
        </div>
    </div>
</template>

