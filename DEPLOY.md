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
5. Your site will be available on port 2368

## Mastodon Federation Support

This configuration includes Ghost redirects for Mastodon federation endpoints from evansims.com to mastodon.evansims.com. The following paths are automatically redirected:

- `/.well-known/host-meta` - WebFinger discovery
- `/.well-known/webfinger` - Account lookups
- `/@evan` - Profile redirect
- `/users/evan` - ActivityPub actor

This allows users to find your Mastodon account using @evan@evansims.com instead of @evan@mastodon.evansims.com.

**Note**: Dokploy should be configured to route traffic from port 80/443 to this container's port 2368.

## First-Time Setup

After deployment, visit `https://evansims.com/ghost` to complete the Ghost setup wizard and create your admin account.

## Data Persistence

The following data is persisted across deployments:
- Ghost content (themes, images, posts): `ghost_content` volume
- MySQL database: `ghost_mysql` volume

## Custom Theme

This repository includes a custom Ghost theme in the `ghost-theme` directory. The theme is automatically mounted into the Ghost container at `/var/lib/ghost/content/themes/evansims-theme`.

### Theme Development

1. Edit theme files in the `ghost-theme` directory
2. The theme uses Gulp for building CSS assets:
   ```bash
   cd ghost-theme
   npm install
   npm run build  # or: npx gulp
   ```
3. Changes will be reflected immediately in Ghost after a page refresh
4. To activate the theme, go to Ghost Admin → Settings → Design → Change theme → Advanced → Upload theme → Select "evansims-theme"

### Theme Structure
- `default.hbs` - Base template for all pages
- `index.hbs` - Homepage template
- `post.hbs` - Individual post template
- `assets/css/screen.css` - Main stylesheet
- `package.json` - Theme metadata and configuration

### Automatic Theme Updates

The Ghost container automatically updates the theme version on every deployment using a custom entrypoint script. This ensures Ghost always loads the latest theme changes without manual intervention.

When you deploy through Dokploy:
1. Push your theme changes to GitHub
2. Deploy in Dokploy
3. The theme version is automatically updated with a timestamp
4. Ghost detects the version change and reloads the theme

No manual cache clearing or version incrementing required!