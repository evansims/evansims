#!/bin/bash
set -e

echo "🔄 Ghost Redirects Update Script"
echo "==============================="

# Configuration
REDIRECTS_FILE="/tmp/redirects.yaml"
GHOST_CONTENT="/var/lib/ghost/content"
DEST_FILE="$GHOST_CONTENT/data/redirects.yaml"

# Check if redirects file exists
if [ ! -f "$REDIRECTS_FILE" ]; then
    echo "❌ No redirects file found at $REDIRECTS_FILE"
    exit 1
fi

echo ""
echo "📋 Current redirects configuration:"
cat "$REDIRECTS_FILE"

# Ensure data directory exists
mkdir -p "$GHOST_CONTENT/data"

# Copy redirects file
echo ""
echo "📦 Installing redirects to $DEST_FILE..."
cp "$REDIRECTS_FILE" "$DEST_FILE"

# Set proper ownership
chown node:node "$DEST_FILE"

echo "✅ Redirects updated successfully"

echo ""
echo "🔄 Restarting Ghost to apply changes..."
# Ghost watches the redirects file and should reload automatically
# but we can trigger a reload by touching the file
touch "$DEST_FILE"

echo ""
echo "🎉 Done! Redirects have been updated."
echo ""
echo "Note: Ghost should automatically detect the change and reload the redirects."
echo "If redirects aren't working, you may need to restart the Ghost container."