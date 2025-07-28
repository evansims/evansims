#!/bin/bash
set -e

echo "🚀 ActivityPub Migration Tool"
echo "============================"

# Check if required environment variables are set
if [ -z "$DATABASE_USER" ] || [ -z "$DATABASE_PASSWORD" ]; then
    echo "❌ Error: DATABASE_USER and DATABASE_PASSWORD must be set"
    exit 1
fi

# Create temporary directory for migrations
MIGRATION_DIR="/tmp/activitypub-migrations"
rm -rf "$MIGRATION_DIR"
mkdir -p "$MIGRATION_DIR"

echo "📥 Downloading migrations from GitHub..."
cd "$MIGRATION_DIR"

# Clone only the migrate/migrations directory from the repository
git init
git remote add origin https://github.com/TryGhost/ActivityPub.git
git config core.sparseCheckout true
echo "migrate/migrations/*" > .git/info/sparse-checkout
git pull --depth=1 origin main

# Check if migrations were downloaded
if [ ! -d "migrate/migrations" ]; then
    echo "❌ Failed to download migrations"
    exit 1
fi

echo "✅ Migrations downloaded successfully"
echo ""
echo "📋 Found migrations:"
ls -la migrate/migrations/

# Install golang-migrate if not already installed
if ! command -v migrate &> /dev/null; then
    echo "📦 Installing golang-migrate..."
    curl -L https://github.com/golang-migrate/migrate/releases/download/v4.17.0/migrate.linux-amd64.tar.gz | tar xvz
    mv migrate /usr/local/bin/
    chmod +x /usr/local/bin/migrate
fi

# Run migrations
echo ""
echo "🔄 Checking migration status..."
cd migrate/migrations

# Construct the database URL
DATABASE_URL="mysql://${DATABASE_USER}:${DATABASE_PASSWORD}@tcp(db:3306)/activitypub"

# Check current migration version
echo "📊 Current migration version:"
migrate -path . -database "$DATABASE_URL" version 2>/dev/null || echo "No migrations applied yet"

# Count available migrations
TOTAL_MIGRATIONS=$(ls -1 *.up.sql 2>/dev/null | wc -l)
echo "📁 Available migrations: $TOTAL_MIGRATIONS"

# Show pending migrations
echo ""
echo "🔍 Checking for pending migrations..."
CURRENT_VERSION=$(migrate -path . -database "$DATABASE_URL" version 2>&1 | grep -oE '[0-9]+' || echo "0")

if [ "$CURRENT_VERSION" = "0" ] || [ -z "$CURRENT_VERSION" ]; then
    echo "No migrations have been applied yet. All $TOTAL_MIGRATIONS migrations are pending."
else
    # List migrations that haven't been applied
    PENDING_COUNT=0
    for migration in $(ls -1 *.up.sql | sort -n); do
        VERSION=$(echo $migration | grep -oE '^[0-9]+')
        if [ "$VERSION" -gt "$CURRENT_VERSION" ]; then
            echo "  - Pending: $migration"
            ((PENDING_COUNT++))
        fi
    done
    
    if [ $PENDING_COUNT -eq 0 ]; then
        echo "✅ All migrations are already applied! Nothing to do."
        exit 0
    else
        echo "📋 Found $PENDING_COUNT pending migration(s)"
    fi
fi

# Ask for confirmation
echo ""
read -p "Do you want to apply the pending migrations? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Migration cancelled"
    exit 1
fi

# Run the migrations
echo ""
echo "🚀 Applying migrations..."
migrate -path . -database "$DATABASE_URL" up

if [ $? -eq 0 ]; then
    echo "✅ Migrations completed successfully!"
    
    # Show new migration version
    echo ""
    echo "📊 New migration version:"
    migrate -path . -database "$DATABASE_URL" version
    
    # Show the schema_migrations table
    echo ""
    echo "📋 Migration history (from schema_migrations table):"
    mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub -e "SELECT version, dirty FROM schema_migrations ORDER BY version DESC LIMIT 5;"
else
    echo "❌ Migration failed"
    
    # Check if database is in dirty state
    echo ""
    echo "🔍 Checking migration state..."
    mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub -e "SELECT version, dirty FROM schema_migrations;" 2>/dev/null || echo "Could not check migration state"
    
    echo ""
    echo "💡 If the database is in a 'dirty' state (dirty=1), you may need to:"
    echo "   1. Fix the issue that caused the migration to fail"
    echo "   2. Run: migrate -path . -database \"$DATABASE_URL\" force VERSION"
    echo "      (where VERSION is the last successful migration number)"
    exit 1
fi

# Cleanup
rm -rf "$MIGRATION_DIR"

echo ""
echo "🎉 Done! The ActivityPub database schema is now up to date."