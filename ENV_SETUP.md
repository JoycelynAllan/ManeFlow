# Environment Setup Guide

## Configuration

To use the application, you need to set up your environment variables.

### Security Notes
- The `.env` file is already included in `.gitignore`
- Keep your API key secure and don't share it publicly
- For production, consider using environment variables set at the server level

### Optional: Database Configuration via .env

You can also configure database settings in `.env`:

```
DB_HOST=127.0.0.1
DB_USER=root
DB_PASS=your_password
DB_NAME=maneflow
```

Note: Database configuration can also be set directly in `config/db.php` if preferred.

