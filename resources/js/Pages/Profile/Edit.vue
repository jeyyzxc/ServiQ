<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Head, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
    mustVerifyEmail: Boolean,
    status: String,
});

const page = usePage();
const user = computed(() => page.props.auth?.user);

const activeTab = ref('profile');

const profileForm = useForm({
    name: user.value?.name || '',
    email: user.value?.email || '',
});

const passwordForm = useForm({
    current_password: '',
    password: '',
    password_confirmation: '',
});

const deleteForm = useForm({
    password: '',
});

const showDeleteModal = ref(false);
const showPassword = ref(false);
const showNewPassword = ref(false);
const showConfirmPassword = ref(false);

const updateProfile = () => {
    profileForm.patch(route('profile.update'), {
        preserveScroll: true,
    });
};

const updatePassword = () => {
    passwordForm.put(route('password.update'), {
        preserveScroll: true,
        onSuccess: () => {
            passwordForm.reset();
        },
    });
};

const deleteAccount = () => {
    deleteForm.delete(route('profile.destroy'), {
        preserveScroll: true,
    });
};
</script>

<template>
    <Head title="Profile Settings" />

    <AppLayout>
        <div class="max-w-4xl mx-auto">
            <div class="mb-8">
                <div class="flex items-center gap-4">
                    <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-400 to-sky-600 flex items-center justify-center text-white text-2xl font-bold shadow-lg shadow-cyan-500/30">
                        {{ user?.name?.charAt(0).toUpperCase() }}
                    </div>
                    <div>
                        <h1 class="text-3xl font-extrabold text-slate-900">Profile Settings</h1>
                        <p class="text-slate-500 mt-1">Manage your account information and security</p>
                    </div>
                </div>
            </div>

            <div class="flex gap-2 p-1.5 bg-cyan-100 rounded-2xl w-fit mb-8">
                <button
                    @click="activeTab = 'profile'"
                    :class="[activeTab === 'profile' ? 'bg-white shadow-sm text-slate-900' : 'text-slate-600 hover:text-slate-900', 'px-5 py-2.5 text-sm font-semibold rounded-xl transition-all']"
                >
                    Profile Info
                </button>
                <button
                    @click="activeTab = 'password'"
                    :class="[activeTab === 'password' ? 'bg-white shadow-sm text-slate-900' : 'text-slate-600 hover:text-slate-900', 'px-5 py-2.5 text-sm font-semibold rounded-xl transition-all']"
                >
                    Password
                </button>
            </div>

            <div v-if="activeTab === 'profile'" class="space-y-6">
                <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                    <div class="px-8 py-6 border-b border-cyan-100 bg-gradient-to-r from-cyan-50 to-white">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-cyan-100 flex items-center justify-center">
                                <svg class="w-5 h-5 text-cyan-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                </svg>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900">Profile Information</h2>
                                <p class="text-sm text-slate-500">Update your account's profile information and email address</p>
                            </div>
                        </div>
                    </div>
                    <form @submit.prevent="updateProfile" class="p-8 space-y-6">
                        <div>
                            <label for="name" class="block text-sm font-bold text-slate-700 mb-2">Full Name</label>
                            <input
                                id="name"
                                type="text"
                                v-model="profileForm.name"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-cyan-500 focus:ring-4 focus:ring-cyan-500/10 transition-all"
                                :class="{ 'border-red-300': profileForm.errors.name }"
                            />
                            <p v-if="profileForm.errors.name" class="mt-2 text-sm text-red-600">{{ profileForm.errors.name }}</p>
                        </div>
                        <div>
                            <label for="email" class="block text-sm font-bold text-slate-700 mb-2">Email Address</label>
                            <input
                                id="email"
                                type="email"
                                v-model="profileForm.email"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-cyan-500 focus:ring-4 focus:ring-cyan-500/10 transition-all"
                                :class="{ 'border-red-300': profileForm.errors.email }"
                            />
                            <p v-if="profileForm.errors.email" class="mt-2 text-sm text-red-600">{{ profileForm.errors.email }}</p>
                        </div>
                        <div class="flex items-center justify-between pt-4 border-t border-slate-100">
                            <p v-if="profileForm.recentlySuccessful" class="text-sm font-medium text-emerald-600 flex items-center gap-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                </svg>
                                Saved successfully
                            </p>
                            <div v-else></div>
                            <button
                                type="submit"
                                :disabled="profileForm.processing"
                                class="px-6 py-3 bg-gradient-to-r from-cyan-500 to-sky-600 text-white text-sm font-bold rounded-xl shadow-lg shadow-cyan-500/30 hover:shadow-xl hover:scale-[1.02] transition-all disabled:opacity-50"
                            >
                                {{ profileForm.processing ? 'Saving...' : 'Save Changes' }}
                            </button>
                        </div>
                    </form>
                </div>

                <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-red-200 overflow-hidden">
                    <div class="p-6 flex items-center justify-between">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-red-100 flex items-center justify-center">
                                <svg class="w-6 h-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-base font-bold text-slate-900">Delete Account</h3>
                                <p class="text-sm text-slate-500">Permanently remove your account and all data</p>
                            </div>
                        </div>
                        <button
                            @click="showDeleteModal = true"
                            class="px-5 py-2.5 bg-red-600 text-white text-sm font-bold rounded-xl hover:bg-red-700 transition-colors"
                        >
                            Delete Account
                        </button>
                    </div>
                </div>
            </div>

            <div v-if="activeTab === 'password'" class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                <div class="px-8 py-6 border-b border-sky-100 bg-gradient-to-r from-sky-50 to-white">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-sky-100 flex items-center justify-center">
                            <svg class="w-5 h-5 text-sky-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </div>
                        <div>
                            <h2 class="text-lg font-bold text-slate-900">Update Password</h2>
                            <p class="text-sm text-slate-500">Ensure your account uses a strong, unique password</p>
                        </div>
                    </div>
                </div>
                <form @submit.prevent="updatePassword" class="p-8 space-y-6">
                    <div>
                        <label for="current_password" class="block text-sm font-bold text-slate-700 mb-2">Current Password</label>
                        <div class="relative">
                            <input
                                id="current_password"
                                :type="showPassword ? 'text' : 'password'"
                                v-model="passwordForm.current_password"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-cyan-500 focus:ring-4 focus:ring-cyan-500/10 transition-all pr-12"
                                :class="{ 'border-red-300': passwordForm.errors.current_password }"
                            />
                            <button type="button" @click="showPassword = !showPassword" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                                <svg v-if="!showPassword" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                </svg>
                                <svg v-else class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                </svg>
                            </button>
                        </div>
                        <p v-if="passwordForm.errors.current_password" class="mt-2 text-sm text-red-600">{{ passwordForm.errors.current_password }}</p>
                    </div>
                    <div>
                        <label for="password" class="block text-sm font-bold text-slate-700 mb-2">New Password</label>
                        <div class="relative">
                            <input
                                id="password"
                                :type="showNewPassword ? 'text' : 'password'"
                                v-model="passwordForm.password"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-cyan-500 focus:ring-4 focus:ring-cyan-500/10 transition-all pr-12"
                                :class="{ 'border-red-300': passwordForm.errors.password }"
                            />
                            <button type="button" @click="showNewPassword = !showNewPassword" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                                <svg v-if="!showNewPassword" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                </svg>
                                <svg v-else class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                </svg>
                            </button>
                        </div>
                        <p v-if="passwordForm.errors.password" class="mt-2 text-sm text-red-600">{{ passwordForm.errors.password }}</p>
                    </div>
                    <div>
                        <label for="password_confirmation" class="block text-sm font-bold text-slate-700 mb-2">Confirm New Password</label>
                        <div class="relative">
                            <input
                                id="password_confirmation"
                                :type="showConfirmPassword ? 'text' : 'password'"
                                v-model="passwordForm.password_confirmation"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-cyan-500 focus:ring-4 focus:ring-cyan-500/10 transition-all pr-12"
                                :class="{ 'border-red-300': passwordForm.errors.password_confirmation }"
                            />
                            <button type="button" @click="showConfirmPassword = !showConfirmPassword" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                                <svg v-if="!showConfirmPassword" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                </svg>
                                <svg v-else class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                                </svg>
                            </button>
                        </div>
                        <p v-if="passwordForm.errors.password_confirmation" class="mt-2 text-sm text-red-600">{{ passwordForm.errors.password_confirmation }}</p>
                    </div>
                    <div class="flex items-center justify-between pt-4 border-t border-slate-100">
                        <p v-if="passwordForm.recentlySuccessful" class="text-sm font-medium text-emerald-600 flex items-center gap-2">
                            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                            </svg>
                            Password updated
                        </p>
                        <div v-else></div>
                        <button
                            type="submit"
                            :disabled="passwordForm.processing"
                            class="px-6 py-3 bg-gradient-to-r from-sky-500 to-cyan-600 text-white text-sm font-bold rounded-xl shadow-lg shadow-sky-500/30 hover:shadow-xl hover:scale-[1.02] transition-all disabled:opacity-50"
                        >
                            {{ passwordForm.processing ? 'Updating...' : 'Update Password' }}
                        </button>
                    </div>
                </form>
            </div>

            <div v-if="showDeleteModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/80 backdrop-blur-sm">
                <div class="bg-white rounded-3xl shadow-2xl max-w-md w-full overflow-hidden">
                    <div class="p-6 bg-gradient-to-r from-red-500 to-rose-600">
                        <div class="flex items-center gap-4">
                            <div class="w-14 h-14 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center">
                                <svg class="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-extrabold text-white">Delete Account</h3>
                                <p class="text-sm text-red-100">This action cannot be undone</p>
                            </div>
                        </div>
                    </div>
                    <div class="p-6">
                        <p class="text-sm text-slate-600 mb-6">Once your account is deleted, all of your data will be permanently removed. Please enter your password to confirm deletion.</p>
                        <form @submit.prevent="deleteAccount">
                            <input
                                type="password"
                                v-model="deleteForm.password"
                                placeholder="Enter your password to confirm"
                                class="w-full px-5 py-4 bg-slate-50 border-2 border-slate-200 rounded-2xl text-slate-900 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-red-500 focus:ring-4 focus:ring-red-500/10 transition-all mb-4"
                                :class="{ 'border-red-300': deleteForm.errors.password }"
                            />
                            <p v-if="deleteForm.errors.password" class="text-sm text-red-600 mb-4">{{ deleteForm.errors.password }}</p>
                            <div class="flex gap-3">
                                <button
                                    type="button"
                                    @click="showDeleteModal = false; deleteForm.reset();"
                                    class="flex-1 px-5 py-3.5 bg-slate-100 text-slate-700 text-sm font-bold rounded-xl hover:bg-slate-200 transition-colors"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    :disabled="deleteForm.processing"
                                    class="flex-1 px-5 py-3.5 bg-red-600 text-white text-sm font-bold rounded-xl hover:bg-red-700 transition-colors disabled:opacity-50"
                                >
                                    {{ deleteForm.processing ? 'Deleting...' : 'Yes, Delete My Account' }}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
