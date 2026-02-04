# Fix for 500 Error on /api/tickets

## Problem
The `/api/tickets` endpoint was returning a 500 Internal Server Error when accessed.

## Root Cause
The `user.only` middleware was applied to API routes, which was causing issues:
1. API requests expect JSON responses, not redirects
2. Admins were being blocked from API endpoints they might legitimately need access to
3. The middleware was redirecting API calls instead of returning proper JSON error responses

## Solution Applied

### 1. Updated UserOnlyMiddleware
**File**: `app/Http/Middleware/UserOnlyMiddleware.php`

**Changes**:
- Added check for API requests using `$request->is('api/*')` and `$request->expectsJson()`
- API requests now return JSON error responses instead of redirects
- Admins are allowed to access API endpoints without restriction
- Only page routes (non-API) enforce the admin→user dashboard restriction

```php
// Before: Always redirected
if ($request->user()->isAdmin()) {
    return redirect()->route('admin.dashboard');
}

// After: Smart handling
if ($request->user()->isAdmin() && !$request->is('api/*')) {
    if ($request->expectsJson()) {
        return response()->json(['error' => '...'], 403);
    }
    return redirect()->route('admin.dashboard');
}
```

### 2. Restructured Routes
**File**: `routes/web.php`

**Changes**:
- Separated page routes from API routes
- Page routes (`/tickets`, `/tickets/create`, etc.) → `user.only` middleware
- API routes (`/api/tickets`) → Only `auth` middleware (no user.only restriction)

```php
// User pages (blocked for admins)
Route::middleware(['auth', 'user.only'])->group(function () {
    Route::get('/tickets', ...);
    Route::get('/tickets/create', ...);
    // ...
});

// API endpoints (accessible to authenticated users regardless of role)
Route::middleware('auth')->group(function () {
    Route::post('/api/tickets', [TicketController::class, 'store']);
    Route::get('/api/tickets', [TicketController::class, 'index']);
    Route::get('/api/tickets/{ticket}', [TicketController::class, 'show']);
});
```

## Why This Works

### Access Control Matrix

| Route Type | Regular User | Admin User |
|------------|--------------|------------|
| `/dashboard` | ✅ Allowed | ❌ Redirected to admin dashboard |
| `/tickets` (page) | ✅ Allowed | ❌ Redirected to admin dashboard |
| `/api/tickets` (API) | ✅ Allowed | ✅ Allowed (returns their tickets) |
| `/admin/dashboard` | ❌ Denied | ✅ Allowed |
| `/admin/api/*` | ❌ Denied | ✅ Allowed |

### Why Admins Need API Access
1. Admin dashboard calls `/api/tickets/queue` to fetch ticket data
2. Admin pages use AJAX to update tickets in real-time
3. Blocking API access would break admin functionality

### How Regular Users Are Protected
1. `TicketController::index()` filters tickets by `user_id`
2. Users can only see their own tickets
3. Admin-specific API endpoints are protected by `admin` middleware
4. Regular users cannot access `/admin/api/*` routes

## Testing the Fix

### Test as Regular User
1. Login as `user@serviq.com`
2. Go to `/tickets` → Should work ✅
3. Console should show: `/api/tickets` returns 200 ✅
4. User sees only their own tickets ✅

### Test as Admin
1. Login as `admin@serviq.com`
2. Go to `/admin/dashboard` → Should work ✅
3. Console should show: `/admin/api/tickets/queue` returns 200 ✅
4. Try to access `/tickets` → Redirected to admin dashboard ✅
5. API endpoints work for fetching admin data ✅

## Security Maintained

✅ **Page-level separation**: Admins cannot access user pages
✅ **Data-level security**: Users can only see their own tickets
✅ **Role-based API**: Admin endpoints blocked for regular users
✅ **Proper error handling**: JSON for APIs, redirects for pages

## Files Modified
1. `app/Http/Middleware/UserOnlyMiddleware.php`
2. `routes/web.php`

## Commands to Apply Fix
```bash
php artisan optimize:clear
php artisan route:clear
php artisan config:clear
php artisan view:clear
```

Then refresh the browser (Ctrl+F5) to clear cache.

## Expected Behavior After Fix

### In Browser DevTools Console
**Before**: ❌ `GET /api/tickets` → 500 Internal Server Error

**After**: ✅ `GET /api/tickets` → 200 OK (returns JSON array of tickets)

### No Functionality Lost
- User panel still completely separated ✅
- Admin cannot access user pages ✅  
- User cannot access admin pages ✅
- Both can use their respective API endpoints ✅
- Security boundaries maintained ✅
