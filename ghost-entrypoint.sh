#!/bin/bash
set -e

# Auto-increment theme version to force Ghost to reload on every deployment
THEME_PATH="/var/lib/ghost/content/themes/evansims-theme"
if [ -f "$THEME_PATH/package.json" ]; then
    echo "🔄 Auto-incrementing theme version..."
    
    # Get current timestamp to ensure unique version
    TIMESTAMP=$(date +%s)
    
    # Update package.json with timestamp-based version
    sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"1.0.$TIMESTAMP\"/" "$THEME_PATH/package.json"
    
    echo "✅ Theme version updated to 1.0.$TIMESTAMP"
fi

# Execute the original Ghost entrypoint
exec docker-entrypoint.sh "$@"