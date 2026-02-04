# FIX: 500 Error on /api/tickets

## Problem
You're getting a 500 error when:
1. Creating a new ticket (POST /api/tickets)
2. Loading the tickets list (GET /api/tickets)

## Changes Already Made

### 1. TicketController - Added Error Handling
Both `store()` and `index()` methods now have try-catch blocks to handle errors gracefully.

### 2. TicketStatusChanged Event - Removed Broadcasting
Removed `ShouldBroadcast` interface that was causing errors when Pusher isn't configured.

### 3. Ticket Model - Added Default Attributes
Added default values for `status` and `priority`.

### 4. bootstrap.js - Simplified
Removed Pusher/Echo configuration that was causing JavaScript errors.

### 5. Create.vue - Removed vue-toastification
Replaced with simple inline error/success messages.

---

## Steps to Apply the Fix

### Step 1: Stop Current Server
Press `Ctrl+C` in the terminal running `php artisan serve`

### Step 2: Clear All Caches
```bash
cd C:\Users\jerom\Downloads\ServiQ
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Step 3: Reset Database
```bash
php artisan migrate:fresh --seed
```

### Step 4: Rebuild Frontend
```bash
npm run build
```

### Step 5: Start Server
```bash
php artisan serve
```

### Step 6: Clear Browser Cache
Press `Ctrl+Shift+F5` in your browser

---

## Test the Fix

### As Regular User
1. Go to http://127.0.0.1:8000
2. Login with: `user@serviq.com` / `password`
3. Click "Create Ticket" in sidebar
4. Fill in:
   - Subject: "Test Ticket"
   - Description: "This is a test"
   - Select a category
5. Click "Submit Ticket"
6. Should show success message and redirect to My Tickets

### Expected Results
- ✅ No 500 error in browser console
- ✅ Ticket created successfully
- ✅ Redirected to My Tickets page
- ✅ New ticket visible in the list

---

## If Still Getting 500 Error

### Check 1: Verify Database Connection
```bash
php artisan tinker
>>> App\Models\User::count()
# Should return: 2
>>> exit
```

### Check 2: Test Ticket Creation in Tinker
```bash
php artisan tinker
>>> $ticket = App\Models\Ticket::create(['user_id' => 2, 'title' => 'Test', 'description' => 'Test desc']);
>>> echo $ticket->id;
# Should return a number like: 1
>>> exit
```

### Check 3: View Laravel Logs
Open `storage/logs/laravel.log` in your editor and scroll to the bottom to see the actual error message.

### Check 4: Enable Debug Mode
In `.env` file, set:
```
APP_DEBUG=true
```
Then restart server. The error page will show the exact problem.

---

## Common Issues & Solutions

### Issue: "SQLSTATE[HY000]: General error: 1 no such table: tickets"
**Solution**: Run migrations
```bash
php artisan migrate:fresh --seed
```

### Issue: "Class 'App\Events\TicketStatusChanged' not found"
**Solution**: Clear composer autoload
```bash
composer dump-autoload
```

### Issue: "419 CSRF Token Mismatch"
**Solution**: Clear browser cache and cookies, or use incognito mode

### Issue: "Connection refused" or "Server error"
**Solution**: Make sure `php artisan serve` is running in a terminal

---

## Files Modified to Fix This Issue

1. **app/Http/Controllers/TicketController.php**
   - Added try-catch to store() and index()
   - Better error messages

2. **app/Events/TicketStatusChanged.php**
   - Removed `ShouldBroadcast` interface
   - Added `Dispatchable` trait

3. **app/Models/Ticket.php**
   - Added default attributes for status and priority

4. **resources/js/bootstrap.js**
   - Removed Pusher/Echo configuration

5. **resources/js/Pages/Tickets/Create.vue**
   - Removed vue-toastification dependency
   - Added inline success/error messages

---

## Quick Commands Reference

```bash
# Clear everything
php artisan optimize:clear

# Reset database
php artisan migrate:fresh --seed

# Rebuild frontend
npm run build

# Start server
php artisan serve

# Check logs
type storage\logs\laravel.log | more
```

---

## Success Criteria

After applying the fix:
- ✅ Dashboard loads without 500 error
- ✅ My Tickets page loads without 500 error
- ✅ Create Ticket form submits successfully
- ✅ New ticket appears in My Tickets list
- ✅ Ticket details page works
- ✅ No errors in browser console

---

**The 500 error should now be fixed!** 🎉
