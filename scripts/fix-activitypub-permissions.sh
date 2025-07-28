#!/bin/bash
set -e

echo "🔧 Fixing ActivityPub Database Permissions"
echo "========================================"

# Check if required environment variables are set
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "❌ Error: MYSQL_ROOT_PASSWORD must be set"
    exit 1
fi

if [ -z "$DATABASE_PASSWORD" ]; then
    echo "❌ Error: DATABASE_PASSWORD must be set"
    exit 1
fi

echo ""
echo "📊 Checking current state..."

# First, ensure the activitypub database exists
mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS activitypub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null && echo "✅ ActivityPub database exists" || echo "❌ Failed to create database"

echo ""
echo "🔐 Granting permissions to ghost user..."

# Grant permissions (MySQL 8.0 compatible syntax)
mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;" 2>/dev/null && echo "✅ Permissions granted" || echo "❌ Failed to grant permissions"

echo ""
echo "🔍 Verifying ghost user can connect..."

# Test connection as ghost user
if mysql -h db -u ghost -p$DATABASE_PASSWORD -e "USE activitypub; SELECT 1;" >/dev/null 2>&1; then
    echo "✅ Ghost user can successfully connect to activitypub database!"
    
    echo ""
    echo "📋 Current grants for ghost user:"
    mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW GRANTS FOR 'ghost'@'%';" | grep -E "(activitypub|GRANT)"
else
    echo "❌ Ghost user cannot connect to activitypub database"
    echo ""
    echo "Attempting alternative fix..."
    
    # Try to explicitly set authentication plugin
    mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "ALTER USER 'ghost'@'%' IDENTIFIED WITH mysql_native_password BY '$DATABASE_PASSWORD'; FLUSH PRIVILEGES;" 2>/dev/null && echo "✅ Updated ghost user authentication" || echo "❌ Failed to update authentication"
    
    # Grant permissions again
    mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;" 2>/dev/null
    
    # Test again
    if mysql -h db -u ghost -p$DATABASE_PASSWORD -e "USE activitypub; SELECT 1;" >/dev/null 2>&1; then
        echo "✅ Ghost user can now connect after authentication fix!"
    else
        echo "❌ Still unable to connect. Please check your DATABASE_PASSWORD matches the one used when creating the ghost user."
    fi
fi

echo ""
echo "🎯 Next steps:"
echo "   1. If successful, run: run-activitypub-migrations"
echo "   2. If failed, check that DATABASE_PASSWORD environment variable matches your Ghost configuration"