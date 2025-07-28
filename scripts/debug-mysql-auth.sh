#!/bin/bash
set -e

echo "🔍 MySQL Authentication Debug"
echo "============================"

if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$DATABASE_PASSWORD" ]; then
    echo "❌ Error: MYSQL_ROOT_PASSWORD and DATABASE_PASSWORD must be set"
    exit 1
fi

echo ""
echo "1️⃣ Checking ghost user authentication plugin..."
mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "SELECT user, host, plugin FROM mysql.user WHERE user='ghost';" 2>/dev/null

echo ""
echo "2️⃣ Testing ghost user connection to ghost database..."
if mysql -h db -u ghost -p$DATABASE_PASSWORD ghost -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✅ Can connect to ghost database"
else
    echo "❌ Cannot connect to ghost database"
fi

echo ""
echo "3️⃣ Testing ghost user connection to activitypub database..."
if mysql -h db -u ghost -p$DATABASE_PASSWORD activitypub -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✅ Can connect to activitypub database"
else
    echo "❌ Cannot connect to activitypub database"
fi

echo ""
echo "4️⃣ Attempting to fix authentication..."
echo "   Setting ghost user to use mysql_native_password..."

# Update the ghost user to use mysql_native_password
mysql -h db -u root -p$MYSQL_ROOT_PASSWORD <<EOF 2>/dev/null
ALTER USER 'ghost'@'%' IDENTIFIED WITH mysql_native_password BY '$DATABASE_PASSWORD';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Authentication updated"
else
    echo "❌ Failed to update authentication"
fi

echo ""
echo "5️⃣ Re-granting permissions..."
mysql -h db -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON activitypub.* TO 'ghost'@'%'; FLUSH PRIVILEGES;" 2>/dev/null

echo ""
echo "6️⃣ Final test..."
if mysql -h db -u ghost -p$DATABASE_PASSWORD activitypub -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✅ Ghost user can now connect to activitypub database!"
    echo ""
    echo "🎉 Authentication fixed! You can now run migrations."
else
    echo "❌ Still cannot connect"
    echo ""
    echo "🔍 Current environment variables:"
    echo "   DATABASE_USER=$DATABASE_USER"
    echo "   DATABASE_PASSWORD=[hidden, length=${#DATABASE_PASSWORD}]"
    echo ""
    echo "💡 Please verify:"
    echo "   1. The DATABASE_PASSWORD in your environment matches the password set for ghost user"
    echo "   2. Try connecting manually: mysql -h db -u ghost -p"
fi