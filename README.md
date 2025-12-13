# ManeFlow - Hair Growth Journey App

ManeFlow is an innovative web application designed to empower users on their hair growth journey. The app provides personalized recommendations for products, growth methods, and things to avoid based on each user's unique hair characteristics.

## Features

- **User Authentication**: Secure registration and login system with double authentication
- **Online Data Fetching**: Automatically fetches latest hair products and methods from online sources (Amazon, Ulta, Sephora)
- **Hair Profile Creation**: Comprehensive form to input hair characteristics including:
  - Hair type (using standard hair typing system)
  - Hair density, porosity, and scalp type
  - Current and goal length
  - Treatment history
  - Hair concerns
- **Personalized Recommendations**: 
  - Product recommendations based on hair type compatibility
  - Growth methods tailored to your hair type
  - Pitfalls to avoid specific to your hair characteristics

- **Modern UI**: Beautiful, responsive design with smooth animations
- **AJAX Support**: Dynamic content loading and form interactions

## Requirements

- XAMPP (or similar local server with PHP and MySQL)
- PHP 7.4 or higher
- MySQL/MariaDB
- Web browser

## Installation

1. **Database Setup**:
   - Open phpMyAdmin in your browser (usually `http://localhost/phpmyadmin`)
   - Import the `maneflow.sql` file to create the database and all tables
   - The database will be created with all necessary tables and relationships

2. **Populate Initial Data**:
   - After importing the database, run the setup script to populate hair types and concerns
   - Navigate to: `http://localhost/ManeFlow/setup.php`
   - This will automatically insert all hair types (1A-4C) and common hair concerns
   - **Important**: You must run this setup script before using the application!

2. **File Placement**:
   - Place all files in your XAMPP `htdocs` directory:
     ```
     C:\xampp\htdocs\ManeFlow\
     ```

3. **Environment Configuration (Optional but Recommended)**:
   - Create a `.env` file in the project root directory if you want to customize database settings (see below).
   - See `ENV_SETUP.md` for detailed instructions

4. **Database Configuration**:
   - Open `config/db.php` (or set in `.env` file)
   - Verify the database credentials match your XAMPP setup:
     ```php
     define('DB_HOST', '127.0.0.1');
     define('DB_USER', 'root');
     define('DB_PASS', '');  // Default XAMPP password is empty
     define('DB_NAME', 'maneflow');
     ```
   - If your MySQL password is different, update `DB_PASS`

4. **Start XAMPP**:
   - Start Apache and MySQL from the XAMPP Control Panel

5. **Access the Application**:
   - Open your browser and navigate to: `http://localhost/ManeFlow/`

## Project Structure

```
ManeFlow/
├── config/
│   └── db.php                 # Database configuration
├── includes/
│   ├── header.php            # Site header/navigation
│   └── footer.php            # Site footer
├── api/
│   ├── generate_recommendations.php  # Recommendation generation logic
│   ├── get_hair_types.php    # AJAX endpoint for hair types
│   └── get_recommendations.php       # AJAX endpoint for recommendations
├── css/
│   └── style.css             # Main stylesheet
├── js/
│   └── main.js               # JavaScript functionality
├── index.php                 # Homepage
├── login.php                 # Login page
├── register.php              # Registration page
├── logout.php                # Logout handler
├── dashboard.php             # User dashboard
├── profile.php               # Hair profile creation/editing
├── recommendations.php       # Personalized recommendations display
├── maneflow.sql              # Database schema
└── README.md                 # This file
```

## Usage

1. **Registration**: 
   - Click "Sign Up" on the homepage
   - Fill in your details and create an account

2. **Create Hair Profile**:
   - After logging in, go to "My Profile"
   - Fill in your hair characteristics:
     - Select your hair type (e.g., 4C, 3B, 2A, etc.)
     - Choose density, porosity, and scalp type
     - Enter current and goal length
     - Select any hair concerns
   - Click "Save Profile & Generate Recommendations"

3. **View Recommendations**:
   - Go to "Recommendations" from the navigation
   - View personalized:
     - Product recommendations with ratings and links
     - Growth methods with instructions
     - Things to avoid with explanations

4. **Update Profile**:
   - Return to "My Profile" anytime to update your information
   - Recommendations will be regenerated automatically

## Database Tables

The application uses the following main tables:

- `users` - User accounts
- `user_hair_profiles` - User hair characteristics
- `hair_types` - Hair type definitions
- `products` - Hair care products
- `growth_methods` - Hair growth techniques
- `hair_pitfalls` - Things to avoid
- `user_recommendations` - Generated recommendations
- `product_hair_type_compatibility` - Product compatibility scores
- `method_hair_type_compatibility` - Method effectiveness scores
- `pitfall_hair_type_applicability` - Pitfall risk levels

## Customization

### Adding Hair Types
Insert records into the `hair_types` table:
```sql
INSERT INTO hair_types (type_code, type_name, category, description) 
VALUES ('4C', 'Type 4C', 'coily', 'Description...');
```

### Adding Products
Insert products into the `products` table and link them to hair types in `product_hair_type_compatibility`:
```sql
INSERT INTO products (product_name, brand, category, description) 
VALUES ('Product Name', 'Brand', 'shampoo', 'Description...');
```

### Adding Growth Methods
Insert methods into the `growth_methods` table and link them to hair types in `method_hair_type_compatibility`.

## Technologies Used

- **Backend**: PHP 7.4+
- **Database**: MySQL/MariaDB
- **Frontend**: HTML5, CSS3, JavaScript
- **AJAX**: XMLHttpRequest for dynamic content
- **Web Scraping**: cURL for fetching online hair care data
- **Icons**: Font Awesome 6.4.0

## Online Data Fetching

The application includes an intelligent algorithm that fetches hair care information from online sources:

- **Product Sources**: Amazon, Ulta, Sephora
- **Method Sources**: Hair care blogs and educational websites
- **Automatic Integration**: Fetched products are automatically added to the database and linked to hair types
- **Smart Matching**: Products are matched to hair types based on search terms and ratings

### How to Use Online Fetching:

1. Go to the **Recommendations** page
2. Click **"Fetch Latest Products & Methods Online"** button
3. The system will fetch and integrate new data from online sources
4. Recommendations will be updated automatically with the latest products

### Important Notes:

- **Rate Limiting**: The system includes delays between requests to respect website policies
- **Legal Compliance**: Always respect robots.txt and terms of service of websites
- **API Alternatives**: For production use, consider using official APIs (Amazon Product Advertising API, etc.)
- **Error Handling**: The system gracefully handles failures and continues with available data

## Security Features

- Password hashing using PHP's `password_hash()`
- Prepared statements to prevent SQL injection
- Session management for authentication
- Input validation and sanitization

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Edge (latest)
- Safari (latest)

## Troubleshooting

**Database Connection Error**:
- Verify MySQL is running in XAMPP
- Check database credentials in `config/db.php`
- Ensure the `maneflow` database exists

**Recommendations Not Showing**:
- Make sure you've completed your hair profile
- Verify that compatibility data exists in the database
- Check that hair types are linked to products/methods/pitfalls

**Styling Issues**:
- Clear browser cache
- Verify `css/style.css` is loading correctly
- Check browser console for errors

## Future Enhancements

Potential features to add:
- Progress tracking with photos
- Hair care routine builder
- Educational content library
- Product reviews and ratings
- Community features

## License

This project is created for educational purposes.

## Support

For issues or questions, please check:
- Database connection settings
- File permissions
- PHP error logs in XAMPP

---

**Enjoy your hair growth journey with ManeFlow!** 🌟

