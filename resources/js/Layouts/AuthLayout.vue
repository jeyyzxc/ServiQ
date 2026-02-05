<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    title: String,
    subtitle: String,
    isAdmin: {
        type: Boolean,
        default: false
    }
});

const gradientColors = computed(() => {
    return props.isAdmin
        ? 'from-amber-900 via-orange-900 to-amber-900'
        : 'from-slate-900 via-indigo-900 to-slate-900';
});
</script>

<template>
    <div class="min-h-screen flex">
        <div :class="['hidden lg:flex lg:w-1/2 relative bg-gradient-to-br', gradientColors]">
            <div class="absolute inset-0 overflow-hidden">
                <div class="absolute -top-40 -right-40 w-80 h-80 rounded-full bg-white/5 blur-3xl"></div>
                <div class="absolute top-1/2 -left-20 w-60 h-60 rounded-full bg-white/5 blur-3xl"></div>
                <div class="absolute -bottom-20 right-1/4 w-72 h-72 rounded-full bg-white/5 blur-3xl"></div>
            </div>

            <div class="absolute top-8 left-8 z-20">
                <Link href="/" class="flex items-center gap-3 group">
                    <div :class="['w-14 h-14 rounded-2xl flex items-center justify-center shadow-2xl transform transition-all duration-300 group-hover:scale-110 group-hover:rotate-3', isAdmin ? 'bg-gradient-to-br from-amber-400 to-orange-600 shadow-amber-500/30' : 'bg-gradient-to-br from-indigo-400 to-purple-600 shadow-indigo-500/30']">
                        <svg class="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                        </svg>
                    </div>
                    <div>
                        <span class="text-2xl font-extrabold text-white tracking-tight">ServiQ</span>
                        <p v-if="isAdmin" class="text-xs text-amber-300 font-semibold">Admin Portal</p>
                    </div>
                </Link>
            </div>

            <div class="relative z-10 flex flex-col justify-center px-12 lg:px-16 w-full">
                <div class="max-w-lg">
                    <div v-if="isAdmin" class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-500/20 border border-amber-500/30 mb-6">
                        <svg class="w-4 h-4 text-amber-400" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                        </svg>
                        <span class="text-sm font-bold text-amber-300">Restricted Access</span>
                    </div>

                    <h1 class="text-4xl lg:text-5xl font-extrabold text-white leading-tight mb-6">
                        <template v-if="isAdmin">
                            Admin <span class="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 to-orange-400">Control Center</span>
                        </template>
                        <template v-else>
                            Streamline Your <span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-purple-400">Support Queue</span>
                        </template>
                    </h1>
                    <p class="text-lg text-slate-300 mb-12">
                        <template v-if="isAdmin">
                            Manage tickets, monitor activity, and maintain control over your support system.
                        </template>
                        <template v-else>
                            A modern ticketing system with priority-based queue management. Track, manage, and resolve issues efficiently.
                        </template>
                    </p>

                    <div class="space-y-5">
                        <div class="flex items-center gap-4 p-4 rounded-2xl bg-white/5 backdrop-blur-sm border border-white/10 hover:bg-white/10 transition-all">
                            <div :class="['w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0', isAdmin ? 'bg-amber-500/20' : 'bg-indigo-500/20']">
                                <svg :class="['w-6 h-6', isAdmin ? 'text-amber-400' : 'text-indigo-400']" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-white font-bold mb-0.5">Enterprise Security</h3>
                                <p class="text-slate-400 text-sm">256-bit SSL encryption & secure sessions</p>
                            </div>
                        </div>

                        <div class="flex items-center gap-4 p-4 rounded-2xl bg-white/5 backdrop-blur-sm border border-white/10 hover:bg-white/10 transition-all">
                            <div class="w-12 h-12 rounded-xl bg-purple-500/20 flex items-center justify-center flex-shrink-0">
                                <svg class="w-6 h-6 text-purple-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-white font-bold mb-0.5">Real-time Updates</h3>
                                <p class="text-slate-400 text-sm">Instant notifications on all changes</p>
                            </div>
                        </div>

                        <div class="flex items-center gap-4 p-4 rounded-2xl bg-white/5 backdrop-blur-sm border border-white/10 hover:bg-white/10 transition-all">
                            <div class="w-12 h-12 rounded-xl bg-emerald-500/20 flex items-center justify-center flex-shrink-0">
                                <svg class="w-6 h-6 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-white font-bold mb-0.5">Smart Priority Queue</h3>
                                <p class="text-slate-400 text-sm">AI-powered ticket prioritization</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="absolute bottom-8 left-8 right-8 z-20 flex items-center justify-between">
                <p class="text-slate-500 text-sm">© 2026 ServiQ. All rights reserved.</p>
                <div class="flex items-center gap-1">
                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                    <span class="text-sm text-slate-400">System Online</span>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:px-12 xl:px-20 bg-gradient-to-br from-slate-50 via-white to-slate-50">
            <div class="lg:hidden mb-8">
                <Link href="/" class="inline-flex items-center gap-3">
                    <div :class="['w-12 h-12 rounded-xl flex items-center justify-center shadow-lg', isAdmin ? 'bg-gradient-to-br from-amber-500 to-orange-600' : 'bg-gradient-to-br from-indigo-500 to-purple-600']">
                        <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                        </svg>
                    </div>
                    <span class="text-xl font-extrabold text-slate-900">ServiQ</span>
                </Link>
            </div>

            <div class="mx-auto w-full max-w-md">
                <div class="mb-8">
                    <h2 class="text-3xl font-extrabold text-slate-900 mb-2">{{ title }}</h2>
                    <p class="text-slate-500">{{ subtitle }}</p>
                </div>

                <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 p-8">
                    <slot />
                </div>

                <div class="mt-8 flex items-center justify-center gap-6 text-sm text-slate-400">
                    <a href="#" class="hover:text-slate-600 transition-colors">Privacy</a>
                    <span class="w-1 h-1 rounded-full bg-slate-300"></span>
                    <a href="#" class="hover:text-slate-600 transition-colors">Terms</a>
                    <span class="w-1 h-1 rounded-full bg-slate-300"></span>
                    <a href="#" class="hover:text-slate-600 transition-colors">Support</a>
                </div>
            </div>
        </div>
    </div>
</template>
