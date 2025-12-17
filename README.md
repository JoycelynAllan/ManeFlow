# ManeFlow - Comprehensive Hair Care Management System

ManeFlow is a comprehensive web application designed to empower users on their hair growth journey. The app provides personalized recommendations, intelligent diagnosis, growth forecasting, custom routines, style suggestions, and educational content - all tailored to each user's unique hair characteristics and needs.

## Features

### 🔐 User Authentication & Account Management
- Secure registration and login system with password hashing
- Password reset functionality
- **Parent-Child Account System**: Parents can create and manage accounts for children under 13
- Profile management with personal information and preferences

### 👨‍👩‍👧‍👦 Parent-Child Account Management
- Create child accounts (under 13 years old) linked to parent account
- Manage multiple children's hair profiles from one parent account
- Age-appropriate recommendations and content for children
- Separate tracking for each child's progress and routines
- Access all features (diagnosis, forecast, routines, etc.) for each child

### 💇 Hair Profile Creation
Comprehensive profile system including:
- Hair type (1A-4C using standard hair typing system)
- Hair density, porosity, and scalp type
- Current and goal length
- Treatment history
- Hair concerns and goals
- Age-specific considerations

### 💡 Personalized Recommendations
- **Product Recommendations**: Curated products based on hair type compatibility with ratings and purchase links
- **Growth Methods**: Tailored techniques and methods for your specific hair type
- **Things to Avoid**: Pitfalls and practices to avoid based on your hair characteristics
- **Online Data Fetching**: Automatically fetches latest products from Amazon, Ulta, and Sephora
- **Enhanced Recommendations**: AI-powered suggestions based on profile analysis

### 🩺 Hair Problem Diagnosis
- Interactive symptom selection interface
- Age-specific hair concerns (child, teen, adult, senior)
- Intelligent diagnosis engine that identifies possible causes
- Recommended solutions and treatments
- Past diagnosis history tracking
- Severity assessment and likelihood scoring

### 📈 Growth Forecasting & Progress Tracking
- Track hair growth progress over time with measurements
- Visual charts showing growth history (powered by Chart.js)
- Predictive forecasting based on historical data
- Goal tracking with progress visualization
- Estimated time to reach hair length goals
- Confidence levels for predictions

### 📅 Personalized Hair Care Routines
- Auto-generated routines based on hair profile:
  - Morning routines
  - Night routines
  - Wash day routines
- Step-by-step instructions for each routine
- Routine completion tracking
- Update alerts when routines need refreshing
- Detailed routine views with product recommendations

### 💅 Hairstyle Recommendations
- Age-appropriate style suggestions
- Styles categorized by occasion and difficulty
- Maintenance requirements for each style
- Hair type compatibility ratings
- Visual style galleries

### 📚 Educational Content
- Age-appropriate hair care education
- Articles, videos, and tutorials
- Hair care tips and best practices
- Ingredient information
- Technique guides

### 🔔 Notification System
- Real-time notifications for important updates
- Unread notification badge in header
- Notification management (mark as read)
- Activity tracking and alerts

### 🌐 Progressive Web App (PWA)
- Offline functionality with service worker
- Installable on mobile devices
- Responsive design for all screen sizes
- Fast loading with caching

## Requirements

- **Server**: XAMPP (or similar with PHP and MySQL)
- **PHP**: 7.4 or higher
- **Database**: MySQL/MariaDB
- **Browser**: Modern browser (Chrome, Firefox, Edge, Safari)

## Installation

ManeFlow can be set up in two environments: **Local Development** (using XAMPP) or **Server Deployment**.

---

## Option A: Local Development Setup (XAMPP)

### 1. Database Setup
- Open phpMyAdmin: `http://localhost/phpmyadmin`
- Import the `maneflow.sql` file to create the database and all tables
- The database will be created with all necessary tables and relationships

### 2. File Placement
Place all files in your XAMPP `htdocs` directory:
```
C:\xampp\htdocs\ManeFlow-1\
```

### 3. Database Configuration
Open `config/db.php` and verify credentials:
```php
define('DB_HOST', '127.0.0.1');
define('DB_USER', 'root');
define('DB_PASS', '');  // Default XAMPP password is empty
define('DB_NAME', 'maneflow');
```

### 4. Start XAMPP
- Start Apache and MySQL from the XAMPP Control Panel

### 5. Populate Initial Data
- Navigate to: `http://localhost/ManeFlow-1/setup.php`
- This will automatically insert:
  - All hair types (1A-4C)
  - Common hair concerns
  - Age-specific concerns
  - Initial products and methods
- **Important**: You must run this setup script before using the application!

### 6. Access the Application
- Open your browser and navigate to: `http://localhost/ManeFlow-1/`

---

## Option B: Server Deployment

### 1. Database Setup
- Open phpMyAdmin: `http://169.239.251.102:341/phpmyadmin/`
- Import the `webtech_2025A_joycelyn_allan.sql` file to create the database and all tables
- The database will be created with all necessary tables and relationships

### 2. File Placement
Upload all files to your server directory:
```
~/public_html/ManeFlow/
```

### 3. Database Configuration
Open `config/db.php` and update with your server credentials:
```php
define('DB_HOST', 'your_server_host');
define('DB_USER', 'your_database_user');
define('DB_PASS', 'your_database_password');
define('DB_NAME', 'webtech_2025A_joycelyn_allan');
```

### 4. Populate Initial Data
- Navigate to: `http://169.239.251.102:341/~joycelyn.allan/ManeFlow/setup.php`
- This will automatically insert:
  - All hair types (1A-4C)
  - Common hair concerns
  - Age-specific concerns
  - Initial products and methods
- **Important**: You must run this setup script before using the application!

### 5. Access the Application
- Open your browser and navigate to: `http://169.239.251.102:341/~joycelyn.allan/ManeFlow/index.php`

---

## Additional Configuration (Both Environments)

### Environment Variables (Optional)
- Create a `.env` file in the project root for custom database settings
- This allows you to keep sensitive credentials out of version control

## Project Structure

```
ManeFlow-1/
├── config/
│   ├── db.php                          # Database configuration
│   └── .env                            # Environment variables (optional)
├── includes/
│   ├── header.php                      # Site header/navigation
│   └── footer.php                      # Site footer
├── api/
│   ├── generate_recommendations.php    # Generate personalized recommendations
│   ├── enhanced_recommendations.php    # AI-enhanced recommendations
│   ├── fetch_hair_data.php            # Fetch products from online sources
│   ├── diagnose.php                   # Hair problem diagnosis
│   ├── generate_forecast.php          # Growth prediction algorithm
│   ├── add_progress.php               # Add growth progress entries
│   ├── generate_routines.php          # Generate custom routines
│   ├── get_notifications.php          # Fetch user notifications
│   ├── mark_notification_read.php     # Mark notifications as read
│   └── offline_data.php               # PWA offline data
├── css/
│   └── style.css                      # Main stylesheet
├── js/
│   └── main.js                        # JavaScript functionality
├── index.php                          # Homepage
├── login.php                          # Login page
├── register.php                       # Registration page
├── reset_password.php                 # Password reset
├── logout.php                         # Logout handler
├── dashboard.php                      # User dashboard
├── profile.php                        # Hair profile creation/editing
├── children.php                       # Parent-child account management
├── recommendations.php                # Personalized recommendations
├── diagnosis.php                      # Hair problem diagnosis
├── forecast.php                       # Growth forecasting
├── routines.php                       # Hair care routines
├── routine_detail.php                 # Detailed routine view
├── styles.php                         # Hairstyle recommendations
├── education.php                      # Educational content
├── notifications.php                  # Notification center
├── manifest.json                      # PWA manifest
├── sw.js                             # Service worker
└── README.md                         # This file
```

## Usage Guide

### Getting Started

1. **Registration**: 
   - Click "Sign Up" on the homepage
   - Fill in your details (name, email, password, date of birth, gender)
   - Create your account

2. **Create Hair Profile**:
   - After logging in, go to "My Profile"
   - Fill in your hair characteristics:
     - Select your hair type (e.g., 4C, 3B, 2A, etc.)
     - Choose density, porosity, and scalp type
     - Enter current and goal length
     - Select any hair concerns
   - Click "Save Profile"

### Core Features

3. **Get Recommendations**:
   - Go to "Recommendations" from the navigation
   - View personalized product, method, and pitfall recommendations
   - Click "Fetch Latest Products & Methods" to get updated online data
   - Filter and browse recommendations by category

4. **Diagnose Hair Problems**:
   - Go to "Diagnosis"
   - Select your current hair concerns/symptoms
   - Get intelligent analysis of possible causes
   - Receive recommended solutions and treatments
   - View past diagnoses

5. **Track Growth Progress**:
   - Go to "Growth Forecast"
   - Add progress entries with current hair length
   - View growth history chart
   - Generate forecasts to predict future growth
   - Track progress toward your length goals

6. **Use Custom Routines**:
   - Go to "My Routines"
   - Click "Generate/Update My Routines"
   - View morning, night, and wash day routines
   - Follow step-by-step instructions
   - Track routine completions

7. **Explore Hairstyles**:
   - Go to "Hairstyles"
   - Browse age-appropriate style recommendations
   - Filter by occasion and difficulty
   - View maintenance requirements

8. **Learn & Educate**:
   - Go to "Education"
   - Access age-appropriate educational content
   - Read articles, watch videos, and learn techniques

### Parent Features

9. **Manage Children's Accounts**:
   - Go to "My Children"
   - Add child accounts (under 13 years old)
   - Create hair profiles for each child
   - Access all features for each child:
     - Recommendations
     - Diagnosis
     - Growth tracking
     - Routines
     - Styles
     - Education

## Database Schema

### Main Tables

- `users` - User accounts and authentication
- `user_hair_profiles` - Detailed hair characteristics
- `hair_types` - Hair type definitions (1A-4C)
- `hair_concerns` - Common hair concerns
- `age_specific_concerns` - Age-appropriate concerns

### Recommendation System

- `products` - Hair care products
- `growth_methods` - Hair growth techniques
- `hair_pitfalls` - Things to avoid
- `user_recommendations` - Generated recommendations
- `product_hair_type_compatibility` - Product compatibility scores
- `method_hair_type_compatibility` - Method effectiveness scores
- `pitfall_hair_type_applicability` - Pitfall risk levels

### Diagnosis System

- `hair_symptoms` - Symptom definitions
- `symptom_cause_relationships` - Symptom-to-cause mappings
- `hair_problem_causes` - Possible causes
- `cause_solution_relationships` - Cause-to-solution mappings
- `hair_problem_solutions` - Treatment solutions
- `user_diagnoses` - Diagnosis history

### Progress & Forecasting

- `hair_growth_progress` - Growth measurements
- `growth_forecasts` - Predicted growth data

### Routines & Styles

- `hair_care_routines` - Custom routines
- `routine_steps` - Routine step details
- `routine_completion_log` - Completion tracking
- `hairstyles` - Style recommendations
- `style_hair_type_suitability` - Style compatibility

### Education & Notifications

- `educational_content` - Educational resources
- `content_age_appropriateness` - Age-appropriate content
- `user_notifications` - User notifications

### Parent-Child System

- `parent_child_activity_log` - Activity tracking

## Technologies Used

- **Backend**: PHP 7.4+
- **Database**: MySQL/MariaDB
- **Frontend**: HTML5, CSS3, JavaScript
- **Charts**: Chart.js for data visualization
- **AJAX**: XMLHttpRequest for dynamic content
- **Web Scraping**: cURL for fetching online product data
- **Icons**: Font Awesome 6.4.0
- **PWA**: Service Worker, Web App Manifest

## Online Data Fetching

The application includes an intelligent web scraping system:

- **Product Sources**: Amazon, Ulta, Sephora
- **Automatic Integration**: Products are added to database with compatibility scores
- **Smart Matching**: Products matched to hair types based on descriptions
- **Rate Limiting**: Respects website policies with delays between requests
- **Error Handling**: Graceful failure handling

### Usage:
1. Go to "Recommendations" page
2. Click "Fetch Latest Products & Methods"
3. System fetches and integrates new data
4. Recommendations update automatically

## Security Features

- **Password Security**: bcrypt hashing with `password_hash()`
- **SQL Injection Protection**: Prepared statements throughout
- **Session Management**: Secure session handling
- **Input Validation**: Server-side validation and sanitization
- **XSS Protection**: HTML escaping with `htmlspecialchars()`
- **CSRF Protection**: Form token validation

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Edge (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Troubleshooting

### Database Connection Error
- Verify MySQL is running in XAMPP
- Check database credentials in `config/db.php`
- Ensure the `maneflow` database exists

### Parent-Child Feature Not Working
- Run the migration: `run_migration.php?key=migrate2024`
- This adds required columns for parent-child functionality

### Recommendations Not Showing
- Complete your hair profile first
- Verify compatibility data exists in database
- Check that hair types are linked to products/methods

### Charts Not Displaying
- Ensure Chart.js CDN is accessible
- Check browser console for JavaScript errors
- Verify progress data exists

### Styling Issues
- Clear browser cache
- Verify `css/style.css` is loading correctly
- Check browser console for errors

## Future Enhancements

- Community features and forums
- Product reviews and ratings from users
- Photo upload for progress tracking
- Mobile app (iOS/Android)
- Social sharing features
- Professional stylist consultations
- Subscription-based premium features

## License

This project is created for educational purposes.

## Support

For issues or questions:
- Check database connection settings
- Review PHP error logs in XAMPP
- Verify file permissions
- Ensure all required tables exist

---

**Enjoy your personalized hair growth journey with ManeFlow!** 
