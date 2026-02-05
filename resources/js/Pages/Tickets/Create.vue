<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { reactive, ref, computed } from 'vue';
import axios from 'axios';

const loading = ref(false);
const errors = ref({});
const successMessage = ref('');
const errorMessage = ref('');

const form = reactive({
    title: '',
    description: '',
    category: ''
});

const categories = [
    { value: 'general', label: 'General Inquiry', icon: 'M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z', color: 'indigo' },
    { value: 'technical', label: 'Technical Support', icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z', color: 'blue' },
    { value: 'billing', label: 'Billing', icon: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z', color: 'emerald' },
    { value: 'feature', label: 'Feature Request', icon: 'M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z', color: 'amber' },
    { value: 'bug', label: 'Bug Report', icon: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z', color: 'red' },
    { value: 'other', label: 'Other', icon: 'M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z', color: 'slate' }
];

const getCategoryColor = (color, selected) => {
    const colors = {
        indigo: selected ? 'border-indigo-500 bg-indigo-50 ring-2 ring-indigo-500' : 'border-slate-200 hover:border-indigo-300 hover:bg-indigo-50/50',
        blue: selected ? 'border-blue-500 bg-blue-50 ring-2 ring-blue-500' : 'border-slate-200 hover:border-blue-300 hover:bg-blue-50/50',
        emerald: selected ? 'border-emerald-500 bg-emerald-50 ring-2 ring-emerald-500' : 'border-slate-200 hover:border-emerald-300 hover:bg-emerald-50/50',
        amber: selected ? 'border-amber-500 bg-amber-50 ring-2 ring-amber-500' : 'border-slate-200 hover:border-amber-300 hover:bg-amber-50/50',
        red: selected ? 'border-red-500 bg-red-50 ring-2 ring-red-500' : 'border-slate-200 hover:border-red-300 hover:bg-red-50/50',
        slate: selected ? 'border-slate-500 bg-slate-50 ring-2 ring-slate-500' : 'border-slate-200 hover:border-slate-300 hover:bg-slate-50/50',
    };
    return colors[color] || colors.slate;
};

const getIconColor = (color, selected) => {
    const colors = {
        indigo: selected ? 'text-indigo-600' : 'text-slate-400 group-hover:text-indigo-500',
        blue: selected ? 'text-blue-600' : 'text-slate-400 group-hover:text-blue-500',
        emerald: selected ? 'text-emerald-600' : 'text-slate-400 group-hover:text-emerald-500',
        amber: selected ? 'text-amber-600' : 'text-slate-400 group-hover:text-amber-500',
        red: selected ? 'text-red-600' : 'text-slate-400 group-hover:text-red-500',
        slate: selected ? 'text-slate-600' : 'text-slate-400 group-hover:text-slate-500',
    };
    return colors[color] || colors.slate;
};

const characterCount = computed(() => form.description.length);
const maxCharacters = 2000;

async function submit() {
    loading.value = true;
    errors.value = {};
    errorMessage.value = '';
    successMessage.value = '';

    try {
        await axios.post('/api/tickets', form);
        successMessage.value = 'Ticket created successfully! Redirecting...';
        setTimeout(() => {
            router.visit(route('tickets.index'));
        }, 1500);
    } catch (e) {
        if (e.response?.data?.errors) {
            errors.value = e.response.data.errors;
        } else if (e.response?.data?.error) {
            errorMessage.value = e.response.data.error;
        } else {
            errorMessage.value = 'Failed to create ticket. Please try again.';
        }
    } finally {
        loading.value = false;
    }
}
</script>

<template>
    <Head title="Create Ticket" />

    <AppLayout>
        <div class="max-w-4xl mx-auto">
            <div class="mb-8">
                <Link :href="route('tickets.index')" class="inline-flex items-center gap-2 text-sm font-medium text-slate-500 hover:text-indigo-600 transition-colors mb-6 group">
                    <svg class="w-5 h-5 transform group-hover:-translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                    </svg>
                    Back to My Tickets
                </Link>

                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                        <svg class="w-7 h-7 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-3xl font-extrabold text-slate-900">Create New Ticket</h1>
                        <p class="text-slate-500 mt-1">Submit a support request and we'll respond as soon as possible</p>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                        <div class="px-8 py-6 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-indigo-100 flex items-center justify-center">
                                    <svg class="w-5 h-5 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                    </svg>
                                </div>
                                <div>
                                    <h2 class="text-lg font-bold text-slate-900">Ticket Details</h2>
                                    <p class="text-sm text-slate-500">Fill in the information below</p>
                                </div>
                            </div>
                        </div>

                        <form @submit.prevent="submit" class="p-8 space-y-8">
                            <div v-if="successMessage" class="p-5 bg-gradient-to-r from-emerald-50 to-teal-50 border border-emerald-200 rounded-2xl">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-xl bg-emerald-500 flex items-center justify-center shadow-lg">
                                        <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="font-bold text-emerald-800">{{ successMessage }}</p>
                                        <p class="text-sm text-emerald-600 mt-1">You will be redirected shortly...</p>
                                    </div>
                                </div>
                            </div>

                            <div v-if="errorMessage" class="p-5 bg-gradient-to-r from-red-50 to-rose-50 border border-red-200 rounded-2xl">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-xl bg-red-500 flex items-center justify-center shadow-lg">
                                        <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                    </svg>
                                    </div>
                                    <div>
                                        <p class="font-bold text-red-800">{{ errorMessage }}</p>
                                        <p class="text-sm text-red-600 mt-1">Please check your input and try again</p>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <label for="title" class="block text-sm font-bold text-slate-700 mb-3">
                                    Subject <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <input
                                        id="title"
                                        v-model="form.title"
                                        type="text"
                                        required
                                        class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all"
                                        :class="{ 'border-red-300 focus:border-red-500 focus:ring-red-500/10': errors.title }"
                                        placeholder="Brief summary of your issue or request"
                                    />
                                </div>
                                <p v-if="errors.title" class="mt-2 text-sm text-red-600 flex items-center gap-1">
                                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                                    </svg>
                                    {{ errors.title[0] }}
                                </p>
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-slate-700 mb-3">Category</label>
                                <div class="grid grid-cols-2 sm:grid-cols-3 gap-3">
                                    <button
                                        v-for="cat in categories"
                                        :key="cat.value"
                                        type="button"
                                        @click="form.category = cat.value"
                                        :class=" [
                                            getCategoryColor(cat.color, form.category === cat.value),
                                            'group flex flex-col items-center p-4 rounded-2xl border-2 transition-all duration-200'
                                        ]"
                                    >
                                        <div :class="['w-10 h-10 rounded-xl flex items-center justify-center mb-2 transition-colors', form.category === cat.value ? `bg-${cat.color}-100` : 'bg-slate-100 group-hover:bg-slate-200']">
                                            <svg :class="[getIconColor(cat.color, form.category === cat.value), 'w-5 h-5 transition-colors']" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="cat.icon" />
                                            </svg>
                                        </div>
                                        <span :class="['text-sm font-semibold transition-colors', form.category === cat.value ? `text-${cat.color}-700` : 'text-slate-600']">{{ cat.label }}</span>
                                    </button>
                                </div>
                            </div>

                            <div>
                                <div class="flex items-center justify-between mb-3">
                                    <label for="description" class="block text-sm font-bold text-slate-700">
                                        Description <span class="text-red-500">*</span>
                                    </label>
                                    <span :class="['text-xs font-medium', characterCount > maxCharacters ? 'text-red-500' : 'text-slate-400']">
                                        {{ characterCount }} / {{ maxCharacters }}
                                    </span>
                                </div>
                                <textarea
                                    id="description"
                                    v-model="form.description"
                                    rows="8"
                                    required
                                    :maxlength="maxCharacters"
                                    class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 transition-all resize-none"
                                    :class="{ 'border-red-300 focus:border-red-500 focus:ring-red-500/10': errors.description }"
                                    placeholder="Please provide as much detail as possible about your issue or request. Include any relevant information that might help us assist you faster..."
                                ></textarea>
                                <p v-if="errors.description" class="mt-2 text-sm text-red-600 flex items-center gap-1">
                                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                                    </svg>
                                    {{ errors.description[0] }}
                                </p>
                            </div>

                            <div class="flex items-center justify-between pt-6 border-t border-slate-100">
                                <Link :href="route('tickets.index')" class="px-6 py-3 text-sm font-semibold text-slate-600 hover:text-slate-800 hover:bg-slate-100 rounded-xl transition-all">
                                    Cancel
                                </Link>
                                <button
                                    type="submit"
                                    :disabled="loading || !form.title || !form.description"
                                    class="inline-flex items-center px-8 py-3.5 bg-gradient-to-r from-indigo-600 to-purple-600 text-white text-sm font-bold rounded-2xl hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-4 focus:ring-indigo-500/30 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg shadow-indigo-500/30 hover:shadow-xl hover:scale-[1.02] active:scale-[0.98]"
                                >
                                    <svg v-if="loading" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    <svg v-else class="w-5 h-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                                    </svg>
                                    {{ loading ? 'Submitting...' : 'Submit Ticket' }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="space-y-6">
                    <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 p-6">
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                            <h3 class="font-bold text-slate-900">What happens next?</h3>
                        </div>
                        <div class="space-y-4">
                            <div class="flex items-start gap-3">
                                <div class="w-6 h-6 rounded-full bg-indigo-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                                    <span class="text-xs font-bold text-indigo-600">1</span>
                                </div>
                                <p class="text-sm text-slate-600">Your ticket will be added to our support queue</p>
                            </div>
                            <div class="flex items-start gap-3">
                                <div class="w-6 h-6 rounded-full bg-indigo-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                                    <span class="text-xs font-bold text-indigo-600">2</span>
                                </div>
                                <p class="text-sm text-slate-600">Our team will review and prioritize your request</p>
                            </div>
                            <div class="flex items-start gap-3">
                                <div class="w-6 h-6 rounded-full bg-indigo-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                                    <span class="text-xs font-bold text-indigo-600">3</span>
                                </div>
                                <p class="text-sm text-slate-600">You'll receive updates as your ticket progresses</p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-amber-50 to-orange-50 rounded-3xl border border-amber-200 p-6">
                        <div class="flex items-center gap-3 mb-4">
                            <div class="w-10 h-10 rounded-xl bg-amber-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-amber-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                                </svg>
                            </div>
                            <h3 class="font-bold text-amber-900">Tips for faster resolution</h3>
                        </div>
                        <ul class="space-y-2">
                            <li class="flex items-start gap-2 text-sm text-amber-800">
                                <svg class="w-4 h-4 text-amber-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                                Be specific about the issue
                            </li>
                            <li class="flex items-start gap-2 text-sm text-amber-800">
                                <svg class="w-4 h-4 text-amber-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                                Include steps to reproduce
                            </li>
                            <li class="flex items-start gap-2 text-sm text-amber-800">
                                <svg class="w-4 h-4 text-amber-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                                Choose the right category
                            </li>
                        </ul>
                    </div>

                    <div class="bg-gradient-to-br from-emerald-50 to-teal-50 rounded-3xl border border-emerald-200 p-6">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-emerald-900">Secure Submission</h3>
                                <p class="text-sm text-emerald-700 mt-1">Your data is encrypted and secure</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>


