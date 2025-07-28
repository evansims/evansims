#!/bin/bash
set -e

# Theme configuration
THEME_NAME="evansims-theme"
THEME_SOURCE="/tmp/theme-source"
THEME_DEST="/var/lib/ghost/content/themes/$THEME_NAME"

echo "🚀 Ghost Custom Entrypoint"
echo "========================="

# Wait for Ghost directory structure to be ready
echo "⏳ Waiting for Ghost content directory..."
timeout=30
while [ ! -d "/var/lib/ghost/content/themes" ] && [ $timeout -gt 0 ]; do
    echo "   Waiting... ($timeout seconds remaining)"
    sleep 2
    timeout=$((timeout - 2))
done

if [ ! -d "/var/lib/ghost/content/themes" ]; then
    echo "❌ Ghost content directory not ready after timeout"
    exit 1
fi

# Copy theme files
if [ -d "$THEME_SOURCE" ]; then
    echo "📦 Installing theme from $THEME_SOURCE to $THEME_DEST"
    
    # Remove old theme if exists
    if [ -d "$THEME_DEST" ]; then
        echo "   Removing old theme..."
        rm -rf "$THEME_DEST"
    fi
    
    # Copy new theme
    echo "   Copying theme files..."
    cp -r "$THEME_SOURCE" "$THEME_DEST"
    
    # Set proper ownership
    echo "   Setting ownership..."
    chown -R node:node "$THEME_DEST"
    
    # Verify installation
    if [ -f "$THEME_DEST/package.json" ]; then
        echo "✅ Theme installed successfully"
        echo "   Theme contents:"
        ls -la "$THEME_DEST"
        
        # Increment version to force Ghost to reload
        VERSION=$(date +%s)
        sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"1.0.$VERSION\"/" "$THEME_DEST/package.json"
        echo "   Updated theme version to 1.0.$VERSION"
    else
        echo "❌ Theme installation failed - package.json not found"
        exit 1
    fi
else
    echo "⚠️  No theme source found at $THEME_SOURCE"
fi

# Create themes ready marker
touch /var/lib/ghost/content/themes/.ready

echo "🎯 Starting Ghost..."
echo ""

# Execute the original Ghost entrypoint
exec docker-entrypoint.sh "$@"