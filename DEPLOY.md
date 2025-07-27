# Deployment on Dokploy

## Required Environment Variables

Configure these in Dokploy's environment variables UI:

### Database Configuration
- `DATABASE_PASSWORD` - Password for Ghost database user (required)
- `MYSQL_ROOT_PASSWORD` - MySQL root password (required)

### Optional Configuration

#### Ghost Settings
- `GHOST_URL` - Your blog URL (default: `https://evansims.com`)
- `NODE_ENV` - Environment mode (default: `production`)

#### Database Settings (if using external database)
- `DATABASE_CLIENT` - Database type (default: `mysql`)
- `DATABASE_HOST` - Database hostname (default: `db`)
- `DATABASE_USER` - Database username (default: `ghost`)
- `DATABASE_NAME` - Database name (default: `ghost`)

#### Email Configuration
To enable email functionality, configure these variables:
- `MAIL_USER` - SMTP username
- `MAIL_PASSWORD` - SMTP password
- `MAIL_HOST` - SMTP server hostname
- `MAIL_PORT` - SMTP port (default: `587`)
- `MAIL_TRANSPORT` - Mail transport method (default: `SMTP`)

## Deployment Steps

1. Create a new project in Dokploy
2. Connect this repository
3. Set the required environment variables listed above
4. Deploy using the `docker-compose.yml` file
5. Ghost will be available on port 2368

## First-Time Setup

After deployment, visit `https://evansims.com/ghost` to complete the Ghost setup wizard and create your admin account.

## Data Persistence

The following data is persisted across deployments:
- Ghost content (themes, images, posts): `ghost_content` volume
- MySQL database: `ghost_mysql` volume