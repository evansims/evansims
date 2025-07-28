# ActivityPub Setup Guide

## Prerequisites

1. Ensure the admin container is built with the latest Dockerfile:
   ```bash
   docker compose build admin
   docker compose up -d admin
   ```

2. Have your MySQL root password ready

## Step 1: Create the ActivityPub Database

### Using the Admin Container

1. Access the admin container:
   ```bash
   docker compose exec admin bash
   ```

2. Create the database and ensure ghost user has access:
   ```bash
   # Create the database
   mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS activitypub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
   
   # Ensure ghost user can access it (MySQL 8.0 syntax)
   mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;"
   ```

### Alternative: Using the Setup Script

From your host machine:
```bash
MYSQL_ROOT_PASSWORD=yourpassword ./scripts/setup-activitypub-db.sh
```

## Step 2: Run ActivityPub Migrations

The ActivityPub service requires database migrations to create its tables.

### From the Admin Container (Recommended)

1. If not already in the admin container:
   ```bash
   docker compose exec admin bash
   ```

2. Run the migrations:
   ```bash
   run-activitypub-migrations
   ```

This command will:
- Download the latest migrations from GitHub
- Apply them to the activitypub database
- Display the current migration version

### What the Migration Script Does

1. Downloads migrations from https://github.com/TryGhost/ActivityPub/tree/main/migrate/migrations
2. Uses `golang-migrate` to apply the migrations
3. Creates tables like `sites`, `key_value`, etc. that ActivityPub needs

## Step 3: Restart the ActivityPub Service

After running migrations:
```bash
docker compose restart activitypub
```

## Verifying the Setup

1. Check the ActivityPub logs:
   ```bash
   docker compose logs activitypub
   ```

2. You should no longer see database errors

3. Test the ActivityPub endpoint:
   ```bash
   curl http://localhost:8080/.ghost/activitypub/v1/site
   ```

## Troubleshooting

### "Access denied" errors
- Ensure you created the database with the correct permissions
- The ghost user needs full access to the activitypub database

### "Table doesn't exist" errors
- Run the migrations as described in Step 2
- Check that migrations completed successfully

### Migration failures
- Ensure the admin container has internet access to download from GitHub
- Check that the DATABASE_USER and DATABASE_PASSWORD environment variables are set

## Admin Container Commands

When in the admin container, you have these helpful aliases:

- `mysql-root` - Connect to MySQL as root
- `mysql-ghost` - Connect to the Ghost database
- `mysql-activitypub` - Connect to the ActivityPub database
- `run-activitypub-migrations` - Run the ActivityPub migrations
- `check-migration-status` - Check which migrations have been applied

## How Migration Tracking Works

The `golang-migrate` tool automatically tracks migrations using a `schema_migrations` table:

1. **schema_migrations table**: Stores the current migration version and state
   - `version`: The number of the last successfully applied migration
   - `dirty`: Whether a migration failed mid-execution (0 = clean, 1 = dirty)

2. **Migration files**: Named with incrementing numbers (e.g., `001_create_sites.up.sql`)

3. **Automatic tracking**: 
   - Only new migrations are applied
   - Previously run migrations are skipped
   - Failed migrations are marked as "dirty"

### Checking Migration Status

To see which migrations have been applied:

```bash
docker compose exec admin bash
check-migration-status
```

This will show:
- Current migration version
- List of applied migrations
- Number of pending migrations
- All ActivityPub tables

## Notes

- ActivityPub is in beta, so expect potential issues
- The edge image may not include automatic migrations
- Always backup your database before running migrations