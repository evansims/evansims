# ActivityPub Database Setup

## Using the Admin Service (Recommended)

First, access the admin container:

```bash
docker compose exec admin bash
```

Then, from inside the admin container, you can use these convenient aliases:

```bash
# Connect to MySQL as root
mysql-root

# Or run a command directly
mysql-root -e "CREATE DATABASE IF NOT EXISTS activitypub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;"

# Connect to the Ghost database
mysql-ghost

# Connect to the ActivityPub database (after creating it)
mysql-activitypub

# Show all databases
mysql-root -e "SHOW DATABASES;"
```

## Alternative Methods

If you prefer not to use the admin service, you can run these commands from your host:

## Option 1: Using docker exec (recommended)

Replace `YOUR_ROOT_PASSWORD` with your actual MySQL root password:

```bash
docker exec evansimscom-ghost-zshuav-db-1 mysql -uroot -pYOUR_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS activitypub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;"
```

## Option 2: Using docker compose run

This creates a temporary container to run the command:

```bash
docker compose run --rm db mysql -h db -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS activitypub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;"
```

## After creating the database

Restart the ActivityPub service to use the new database:

```bash
docker compose restart activitypub
```

## Checking if it worked

You can verify the database was created:

```bash
docker exec evansimscom-ghost-zshuav-db-1 mysql -uroot -pYOUR_ROOT_PASSWORD -e "SHOW DATABASES;"
```

You should see both `ghost` and `activitypub` databases listed.

## Note about migrations

The ActivityPub service may need to run its own migrations to create tables. If you still see errors about missing tables after creating the database, the ActivityPub edge image might not include automatic migration capabilities. Since this is a beta service, you may need to wait for updates or check the TryGhost/ActivityPub repository for migration instructions.

## For New Deployments

If you're setting up a fresh deployment, the `mysql-init/01-create-activitypub-db.sql` script will automatically create the ActivityPub database when MySQL first starts. No manual steps needed!