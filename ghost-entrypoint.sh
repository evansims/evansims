#!/bin/bash
set -e

# Auto-increment theme version to force Ghost to reload on every deployment
THEME_PATH="/var/lib/ghost/content/themes/evansims-theme"
echo "📁 Checking theme directory..."
ls -la /var/lib/ghost/content/themes/ || echo "Themes directory not found"

if [ -d "$THEME_PATH" ]; then
    echo "✅ Theme directory exists"
    echo "📋 Theme contents:"
    ls -la "$THEME_PATH" || echo "Cannot list theme contents"
    
    if [ -f "$THEME_PATH/package.json" ]; then
        echo "✅ package.json found"
    else
        echo "❌ package.json NOT found"
    fi
else
    echo "❌ Theme directory NOT found at $THEME_PATH"
fi

# Copy redirects file if it exists
if [ -f "/tmp/redirects.yaml" ]; then
    echo "📋 Copying redirects configuration..."
    mkdir -p /var/lib/ghost/content/data
    cp /tmp/redirects.yaml /var/lib/ghost/content/data/redirects.yaml
    chown node:node /var/lib/ghost/content/data/redirects.yaml
    echo "✅ Redirects configured"
fi

# Execute the original Ghost entrypoint
exec docker-entrypoint.sh "$@"