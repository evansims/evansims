#!/bin/bash
set -e

echo "🎨 Ghost Theme Activation Script"
echo "==============================="

# Configuration
GHOST_ADMIN_URL="${GHOST_URL:-https://evansims.com}/ghost/api/admin"
THEME_NAME="evansims-theme"

# Check for required environment variables
if [ -z "$GHOST_ADMIN_KEY" ]; then
    echo "❌ Error: GHOST_ADMIN_KEY environment variable not set"
    echo ""
    echo "To generate an admin key:"
    echo "1. Go to your Ghost admin panel"
    echo "2. Navigate to Settings → Integrations"
    echo "3. Create a new custom integration"
    echo "4. Copy the Admin API Key"
    echo "5. Set it as GHOST_ADMIN_KEY in Dokploy"
    exit 1
fi

echo ""
echo "🔍 Checking current theme..."

# Get current theme
CURRENT_THEME=$(curl -s -H "Authorization: Ghost ${GHOST_ADMIN_KEY}" \
    "${GHOST_ADMIN_URL}/themes/" | jq -r '.themes[] | select(.active==true) | .name')

echo "   Current theme: ${CURRENT_THEME:-none}"

if [ "$CURRENT_THEME" == "$THEME_NAME" ]; then
    echo "✅ Theme is already active"
else
    echo ""
    echo "🔄 Activating theme: $THEME_NAME"
    
    # Activate theme
    RESPONSE=$(curl -s -X PUT \
        -H "Authorization: Ghost ${GHOST_ADMIN_KEY}" \
        -H "Content-Type: application/json" \
        -d "{\"themes\": [{\"name\": \"$THEME_NAME\", \"active\": true}]}" \
        "${GHOST_ADMIN_URL}/themes/${THEME_NAME}/activate/")
    
    # Check if activation was successful
    if echo "$RESPONSE" | jq -e '.themes[] | select(.active==true and .name=="'$THEME_NAME'")' > /dev/null 2>&1; then
        echo "✅ Theme activated successfully!"
    else
        echo "❌ Failed to activate theme"
        echo "   Response: $RESPONSE"
        exit 1
    fi
fi

echo ""
echo "🎉 Done!"