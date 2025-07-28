#!/bin/bash
set -e

echo "🔍 ActivityPub Migration Status"
echo "=============================="

# Check if required environment variables are set
if [ -z "$DATABASE_USER" ] || [ -z "$DATABASE_PASSWORD" ]; then
    echo "❌ Error: DATABASE_USER and DATABASE_PASSWORD must be set"
    exit 1
fi

echo ""
echo "📊 Checking schema_migrations table..."

# Check if the schema_migrations table exists
TABLE_EXISTS=$(mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub -e "SHOW TABLES LIKE 'schema_migrations';" 2>/dev/null | grep -c schema_migrations || echo "0")

if [ "$TABLE_EXISTS" = "0" ]; then
    echo "❌ No migrations have been run yet (schema_migrations table doesn't exist)"
    echo ""
    echo "💡 Run 'run-activitypub-migrations' to apply migrations"
    exit 0
fi

# Show migration history
echo ""
echo "📋 Applied migrations:"
mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub -e "
SELECT 
    version as 'Migration Version',
    CASE 
        WHEN dirty = 1 THEN '⚠️  DIRTY (failed)' 
        ELSE '✅ Clean' 
    END as 'Status'
FROM schema_migrations 
ORDER BY version DESC;
"

# Show current version using migrate tool if available
if command -v migrate &> /dev/null; then
    echo ""
    echo "🏷️  Current version (from migrate tool):"
    
    # Create temporary directory to check against GitHub
    TEMP_DIR="/tmp/activitypub-check"
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Clone migrations
    git init >/dev/null 2>&1
    git remote add origin https://github.com/TryGhost/ActivityPub.git >/dev/null 2>&1
    git config core.sparseCheckout true >/dev/null 2>&1
    echo "migrate/migrations/*" > .git/info/sparse-checkout
    git pull --depth=1 origin main >/dev/null 2>&1
    
    if [ -d "migrate/migrations" ]; then
        cd migrate/migrations
        DATABASE_URL="mysql://${DATABASE_USER}:${DATABASE_PASSWORD}@tcp(db:3306)/activitypub"
        
        CURRENT_VERSION=$(migrate -path . -database "$DATABASE_URL" version 2>/dev/null || echo "unknown")
        echo "   Version: $CURRENT_VERSION"
        
        # Count total available migrations
        TOTAL_MIGRATIONS=$(ls -1 *.up.sql 2>/dev/null | wc -l)
        CURRENT_NUM=$(echo $CURRENT_VERSION | grep -oE '[0-9]+' || echo "0")
        
        # Check for pending migrations
        PENDING_COUNT=0
        if [ "$CURRENT_NUM" != "0" ]; then
            for migration in $(ls -1 *.up.sql | sort -n); do
                VERSION=$(echo $migration | grep -oE '^[0-9]+')
                if [ "$VERSION" -gt "$CURRENT_NUM" ]; then
                    ((PENDING_COUNT++))
                fi
            done
        else
            PENDING_COUNT=$TOTAL_MIGRATIONS
        fi
        
        echo "   Total migrations available: $TOTAL_MIGRATIONS"
        echo "   Pending migrations: $PENDING_COUNT"
        
        if [ $PENDING_COUNT -gt 0 ]; then
            echo ""
            echo "⚠️  You have $PENDING_COUNT pending migration(s)!"
            echo "💡 Run 'run-activitypub-migrations' to apply them"
        else
            echo ""
            echo "✅ All migrations are up to date!"
        fi
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
fi

# Show table structure
echo ""
echo "📊 ActivityPub tables:"
mysql -h db -u $DATABASE_USER -p$DATABASE_PASSWORD activitypub -e "SHOW TABLES;"