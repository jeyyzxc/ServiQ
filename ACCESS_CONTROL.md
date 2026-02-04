# ServiQ - User & Admin Panel Separation

## Access Control Implementation

### Complete Separation Between User and Admin Panels

The system now enforces **strict separation** between user and admin panels with the following security measures:

---

## 1. Frontend Separation

### User Login Page
- **No admin login link visible** - Users cannot access admin login from the user panel
- Clean, focused user experience without admin references
- Located at: `/login`

### Admin Login
- Accessed via: `/admin/login` or `/login?admin=1`
- Completely separate entry point
- Only accessible through direct URL (not linked from user panel)

### Navigation
- **User Panel**: Only shows user menu items (Dashboard, My Tickets, Create Ticket, History)
- **Admin Panel**: Only shows admin menu items (Admin Dashboard, Ticket Queue, Activity Logs)
- Navigation dynamically renders based on `is_admin` status

---

## 2. Backend Middleware Protection

### AdminMiddleware
**File**: `app/Http/Middleware/AdminMiddleware.php`

- Protects all admin routes (`/admin/*`)
- Checks if user is authenticated AND has admin privileges
- **Non-admin users**: Redirected to user dashboard with error message
- **Unauthenticated users**: Redirected to login

### UserOnlyMiddleware
**File**: `app/Http/Middleware/UserOnlyMiddleware.php`

- Protects user-specific routes (`/tickets/*`, `/dashboard`)
- **Admin users**: Redirected to admin dashboard
- **Ensures admins use admin panel** for ticket management
- Allows shared routes (profile, logout) for both

---

## 3. Route Structure

### User Routes (Protected by `user.only` middleware)
```
/dashboard
/tickets
/tickets/create
/tickets/history
/tickets/{id}
/api/tickets
```

### Admin Routes (Protected by `admin` middleware)
```
/admin/dashboard
/admin/tickets/queue
/admin/tickets/logs
/admin/tickets/{id}/show
/admin/api/tickets/*
```

### Shared Routes
```
/profile (accessible to both)
/logout (accessible to both)
```

---

## 4. Access Control Rules

### Regular Users
✅ Can access:
- User dashboard
- My tickets
- Create tickets
- Ticket history
- Profile settings

❌ Cannot access:
- Admin dashboard
- Ticket queue management
- Admin ticket processing
- Activity logs
- Priority management
- Admin API endpoints

### Admin Users
✅ Can access:
- Admin dashboard
- Ticket queue
- Process any ticket
- Activity logs
- Change priority/status
- Profile settings

❌ Cannot access:
- User ticket pages (redirected to admin panel)
- User dashboard (redirected to admin dashboard)

---

## 5. Security Features

### Session Management
- Session timer displayed in header
- "Secure Session" indicator shows encrypted connection
- Automatic session timeout (Laravel default: 2 hours)

### Authentication Flow
1. **User Login** → `/login` → User Dashboard
2. **Admin Login** → `/admin/login` or `/login?admin=1` → Admin Dashboard
3. **Unauthorized Access** → Redirect to appropriate dashboard with message

### URL Protection
- Direct URL access to restricted routes is blocked
- Middleware validates permissions before rendering pages
- API endpoints also protected by same middleware

---

## 6. Testing Access Control

### Test as User
**Credentials**: `user@serviq.com` / `password`

Try accessing:
- ❌ `http://127.0.0.1:8000/admin/dashboard` → Redirects to user dashboard
- ❌ `http://127.0.0.1:8000/admin/tickets/queue` → Access denied
- ✅ `http://127.0.0.1:8000/tickets` → Works fine
- ✅ `http://127.0.0.1:8000/tickets/create` → Works fine

### Test as Admin
**Credentials**: `admin@serviq.com` / `password`

Try accessing:
- ✅ `http://127.0.0.1:8000/admin/dashboard` → Works fine
- ✅ `http://127.0.0.1:8000/admin/tickets/queue` → Works fine
- ❌ `http://127.0.0.1:8000/tickets` → Redirects to admin dashboard
- ❌ `http://127.0.0.1:8000/dashboard` → Redirects to admin dashboard

---

## 7. Implementation Files

### Modified Files
1. `resources/js/Pages/Auth/Login.vue` - Removed admin link from user login
2. `resources/js/Pages/Welcome.vue` - Removed admin link from landing page
3. `resources/js/Layouts/AppLayout.vue` - Conditional navigation rendering
4. `app/Http/Middleware/AdminMiddleware.php` - Enhanced admin protection
5. `app/Http/Middleware/UserOnlyMiddleware.php` - NEW: User-only route protection
6. `bootstrap/app.php` - Registered new middleware
7. `routes/web.php` - Applied middleware to routes, added `/admin/login`

---

## 8. Error Messages

### User Trying Admin Access
```
"Access denied. Admin privileges required."
```
Redirected to: `/dashboard`

### Admin Trying User Access
```
"Admins should use the admin panel."
```
Redirected to: `/admin/dashboard`

---

## 9. Database Schema

### Users Table
```sql
is_admin BOOLEAN DEFAULT 0
```

- `0` = Regular User
- `1` = Administrator

### Default Accounts
- **Admin**: admin@serviq.com
- **User**: user@serviq.com
- **Password**: password (both)

---

## Summary

✅ **Complete separation** between user and admin panels  
✅ **No cross-access** - Users cannot see/access admin features  
✅ **No admin links** in user panel  
✅ **Backend enforcement** via middleware  
✅ **Frontend protection** via conditional rendering  
✅ **Secure authentication** flow for both panels  
✅ **Session security** indicators  
✅ **Clean UX** - Each role sees only relevant features
