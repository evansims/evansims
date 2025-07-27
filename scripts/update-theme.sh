#!/bin/bash
# Script to ensure Ghost picks up theme changes

echo "🔄 Updating Ghost theme..."

# Copy CSS to built directory
echo "📦 Building theme assets..."
cd ghost-theme
cp assets/css/screen.css assets/built/screen.css

# Update theme version to force Ghost to reload
echo "📝 Updating theme version..."
CURRENT_VERSION=$(grep '"version"' package.json | sed -E 's/.*"version": "([^"]+)".*/\1/')
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
PATCH=$((VERSION_PARTS[2] + 1))
NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.$PATCH"
sed -i.bak "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" package.json
rm package.json.bak

echo "✅ Theme updated to version $NEW_VERSION"
echo ""
echo "📋 Next steps for Dokploy:"
echo "1. Commit and push these changes"
echo "2. Redeploy in Dokploy"
echo "3. Restart Ghost container if needed: docker-compose restart ghost"
echo "4. Clear Ghost cache: Visit /ghost/settings/labs and use 'Clear cache' button"
echo "5. Re-activate theme in Ghost Admin if necessary"