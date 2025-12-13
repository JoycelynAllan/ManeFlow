# Parent-Child Account Feature

## Overview
This feature allows parents (users 13+) to create and manage child accounts for children under 13. Parents can monitor their children's hair care profiles and progress.

## Database Migration Required

Before using this feature, you must run the database migration:

```sql
-- Run this SQL in your MySQL database
ALTER TABLE `users` 
ADD COLUMN `parent_user_id` INT(11) NULL DEFAULT NULL AFTER `hormonal_status`,
ADD KEY `idx_parent_user` (`parent_user_id`),
ADD CONSTRAINT `fk_user_parent` FOREIGN KEY (`parent_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
```

Or run the migration file:
```bash
mysql -u your_username -p your_database < migrations/add_parent_child_support.sql
```

## Features

### 1. Age Restriction
- Users must be at least 13 years old to register directly
- Children under 13 cannot create their own accounts
- Server-side and client-side validation enforce this restriction

### 2. Parent Dashboard - "My Children"
- Accessible from the navigation menu
- Parents can:
  - Add new child accounts
  - View all their children
  - See which children have profiles created
  - Access each child's profile
  - Delete child accounts

### 3. Child Profile Management
- Parents can view and edit their children's hair profiles
- Child profiles work exactly like adult profiles but with age-appropriate recommendations
- Parents see a "Back to My Children" button when viewing a child's profile

## How It Works

1. **Parent Registration**: Parent creates account (must be 13+)
2. **Add Child**: Parent goes to "My Children" page and adds child information
3. **Child Account Creation**: System automatically creates a child account with:
   - Unique email (format: parent_email.childname_timestamp@maneflow.child)
   - Secure random password
   - Link to parent account via `parent_user_id`
4. **Profile Management**: Parent can create/edit child's hair profile
5. **Monitoring**: Parent can view child's recommendations, routines, and progress

## Files Modified/Created

- `register.php` - Added 13+ age restriction
- `children.php` - New page for managing children
- `profile.php` - Updated to support viewing/editing child profiles
- `includes/header.php` - Added "My Children" navigation link
- `migrations/add_parent_child_support.sql` - Database migration

## Security Features

- Parent-child relationship verified on every operation
- Children cannot access parent accounts
- Parents can only manage their own children
- Child accounts automatically deleted if parent account is deleted (CASCADE)

## Usage

1. Run the database migration
2. Register as a parent (must be 13+)
3. Navigate to "My Children" from the menu
4. Click "Add Child" and fill in child's information
5. Click "Create Profile" or "View Profile" for the child
6. Manage the child's hair care profile as needed

