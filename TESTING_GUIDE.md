# ServiQ - Access Control Test Guide

## How to Test the Complete Separation

### Prerequisites
- Server running: `php artisan serve`
- Frontend built: `npm run build`
- Test accounts created (from database seeder)

---

## Test Scenario 1: User Panel Isolation

### Step 1: Login as Regular User
1. Go to `http://127.0.0.1:8000`
2. Click "User Sign In"
3. **Notice**: No "Admin Login" link visible anywhere
4. Login with: `user@serviq.com` / `password`

### Step 2: Verify User Can Access User Features
✅ Should work:
- Dashboard: `http://127.0.0.1:8000/dashboard`
- My Tickets: `http://127.0.0.1:8000/tickets`
- Create Ticket: `http://127.0.0.1:8000/tickets/create`
- Ticket History: `http://127.0.0.1:8000/tickets/history`

### Step 3: Verify User CANNOT Access Admin Features
❌ Should redirect to user dashboard:
- Admin Dashboard: `http://127.0.0.1:8000/admin/dashboard`
- Ticket Queue: `http://127.0.0.1:8000/admin/tickets/queue`
- Activity Logs: `http://127.0.0.1:8000/admin/tickets/logs`

**Expected Behavior**: 
- Redirected to `/dashboard`
- Message shown: "Access denied. Admin privileges required."

### Step 4: Check Navigation
- Sidebar should show ONLY:
  - Dashboard
  - My Tickets
  - Create Ticket
  - History
- **No admin menu items visible**

---

## Test Scenario 2: Admin Panel Isolation

### Step 1: Logout and Login as Admin
1. Click profile dropdown → Sign Out
2. Go to `http://127.0.0.1:8000/admin/login` (direct URL)
   OR `http://127.0.0.1:8000/login?admin=1`
3. Login with: `admin@serviq.com` / `password`

### Step 2: Verify Admin Can Access Admin Features
✅ Should work:
- Admin Dashboard: `http://127.0.0.1:8000/admin/dashboard`
- Ticket Queue: `http://127.0.0.1:8000/admin/tickets/queue`
- Activity Logs: `http://127.0.0.1:8000/admin/tickets/logs`
- Process Ticket: `http://127.0.0.1:8000/admin/tickets/1/show`

### Step 3: Verify Admin CANNOT Access User Panel
❌ Should redirect to admin dashboard:
- User Dashboard: `http://127.0.0.1:8000/dashboard`
- User Tickets: `http://127.0.0.1:8000/tickets`
- Create Ticket: `http://127.0.0.1:8000/tickets/create`

**Expected Behavior**:
- Redirected to `/admin/dashboard`
- Message shown: "Admins should use the admin panel."

### Step 4: Check Navigation
- Sidebar should show ONLY:
  - Admin Dashboard
  - Ticket Queue
  - Activity Logs
- **No user menu items visible**
- Profile badge shows "Admin"

---

## Test Scenario 3: API Endpoint Protection

### Using Browser DevTools or Postman

#### As Regular User
✅ Should work:
```
GET /api/tickets (list user's tickets)
POST /api/tickets (create ticket)
GET /api/tickets/1 (view own ticket)
```

❌ Should fail (403 or redirect):
```
GET /admin/api/tickets/queue
POST /admin/api/tickets/1/status
POST /admin/api/tickets/1/priority
```

#### As Admin
✅ Should work:
```
GET /admin/api/tickets/queue
GET /admin/api/tickets/1
POST /admin/api/tickets/1/status
POST /admin/api/tickets/1/priority
```

---

## Test Scenario 4: Session Security

### Check Security Indicators
1. Login as any user
2. Look at the header (top-right)
3. Verify you see:
   - ✅ Green "Secure Session" badge
   - ✅ Session timer showing current time
   - ✅ User profile with avatar

### Test Session Timeout
1. Login and wait for session to expire (default: 2 hours)
2. Try to navigate to any protected route
3. **Expected**: Redirected to login page

---

## Test Scenario 5: Direct URL Access

### Test as Unauthenticated User
Try accessing without logging in:
```
http://127.0.0.1:8000/dashboard
http://127.0.0.1:8000/tickets
http://127.0.0.1:8000/admin/dashboard
```

**Expected**: All redirect to `/login`

---

## Test Scenario 6: Welcome Page

### Verify Landing Page
1. Logout completely
2. Go to `http://127.0.0.1:8000`
3. **Check**:
   - ✅ "Get Started Free" button visible
   - ✅ "User Sign In" button visible
   - ❌ NO "Admin Login" link visible anywhere

---

## Test Scenario 7: Login Page

### User Login Page
1. Go to `http://127.0.0.1:8000/login`
2. **Check**:
   - ✅ User login form visible
   - ✅ "Create an account" link visible
   - ❌ NO "Admin Login" link visible

### Admin Login Page
1. Go to `http://127.0.0.1:8000/login?admin=1`
2. **Check**:
   - ✅ Admin login form with admin icon
   - ✅ "Admin Access" title
   - ✅ Admin-specific styling (amber colors)
   - ✅ "Restricted access area" notice

---

## Expected Results Summary

### ✅ Pass Criteria

**User Panel:**
- No admin features visible
- No admin menu items
- No admin login links
- Cannot access admin URLs (redirected)
- Can access all user features

**Admin Panel:**
- No user panel features visible  
- Only admin menu items shown
- Cannot access user URLs (redirected)
- Can access all admin features
- "Admin" badge visible in profile

**Security:**
- Session indicator present
- Middleware blocks unauthorized access
- API endpoints protected
- Direct URL access blocked

---

## Troubleshooting

### If You See Admin Links in User Panel
1. Check: `resources/js/Pages/Welcome.vue` - Line 87-97 should have no admin link
2. Check: `resources/js/Pages/Auth/Login.vue` - Line 152-165 should have no admin link
3. Run: `npm run build`
4. Clear browser cache (Ctrl + Shift + Delete)

### If Middleware Not Working
1. Run: `php artisan route:clear`
2. Run: `php artisan cache:clear`
3. Check: `bootstrap/app.php` - Middleware registered?
4. Restart server: `php artisan serve`

### If Navigation Shows Wrong Items
1. Check: `resources/js/Layouts/AppLayout.vue` - Lines 62-125
2. Verify: `$page.props.auth.user.is_admin` is correct
3. Run: `npm run build`
4. Hard refresh: Ctrl + F5

---

## Success Checklist

- [ ] User cannot see admin features
- [ ] Admin cannot access user pages
- [ ] No admin links in user login
- [ ] No admin links on welcome page
- [ ] Navigation shows correct menu for each role
- [ ] Direct URL access is blocked
- [ ] API endpoints are protected
- [ ] Session security indicator visible
- [ ] Error messages display correctly
- [ ] Redirects work properly

---

## Support

If all tests pass, the system has **complete separation** between user and admin panels with proper security enforcement! 🎉
