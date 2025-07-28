#!/bin/bash
set -e

# Theme configuration
THEME_NAME="evansims-theme"
THEME_SOURCE="/tmp/theme-built"
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

# Install pre-built theme
if [ -d "$THEME_SOURCE" ]; then
    echo "📦 Installing pre-built theme from $THEME_SOURCE"
    
    # Remove old theme if exists
    if [ -d "$THEME_DEST" ]; then
        echo "   Removing old theme..."
        rm -rf "$THEME_DEST"
    fi
    
    # Copy built theme to destination
    echo "   Installing theme to $THEME_DEST..."
    cp -r "$THEME_SOURCE" "$THEME_DEST"
    
    # Set proper ownership
    echo "   Setting ownership..."
    chown -R node:node "$THEME_DEST"
    
    # Verify installation
    if [ -f "$THEME_DEST/package.json" ]; then
        # Increment version to force Ghost to reload
        VERSION=$(date +%s)
        sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"1.0.$VERSION\"/" "$THEME_DEST/package.json"
        echo "✅ Theme installed successfully (version 1.0.$VERSION)"
        
        # List theme contents
        echo "   Theme structure:"
        find "$THEME_DEST" -type f -name "*.hbs" | head -10
        
        # Check for built assets
        if [ -d "$THEME_DEST/assets/built" ]; then
            echo "   Built assets found:"
            ls -la "$THEME_DEST/assets/built" | head -5
        else
            echo "   ⚠️  No built assets found - theme may not have a build process"
        fi
    else
        echo "❌ Theme installation failed - package.json not found"
        exit 1
    fi
else
    echo "❌ No pre-built theme found at $THEME_SOURCE"
    echo "   This should not happen - check the Dockerfile build process"
    exit 1
fi

# Copy redirects file if it exists
if [ -f "/tmp/redirects.yaml" ]; then
    echo "📋 Copying redirects configuration..."
    mkdir -p /var/lib/ghost/content/data
    cp /tmp/redirects.yaml /var/lib/ghost/content/data/redirects.yaml
    chown node:node /var/lib/ghost/content/data/redirects.yaml
    echo "✅ Redirects configured"
fi

# Create themes ready marker
touch /var/lib/ghost/content/themes/.ready

echo "🎯 Starting Ghost..."
echo ""

# Execute the original Ghost entrypoint
exec docker-entrypoint.sh "$@"