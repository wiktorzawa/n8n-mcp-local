#!/bin/bash

echo "🔄 Synchronizacja bazy danych n8n-mcp..."

# Ścieżki
SOURCE_DB="../data/nodes.db"
TARGET_DB="./n8n-mcp-data/nodes.db"

# Sprawdź czy źródło istnieje
if [ ! -f "$SOURCE_DB" ]; then
    echo "❌ Nie znaleziono źródłowej bazy: $SOURCE_DB"
    exit 1
fi

# Backup starej bazy (jeśli istnieje)
if [ -f "$TARGET_DB" ]; then
    BACKUP_NAME="./n8n-mcp-data/nodes.db.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📦 Backup starej bazy: $BACKUP_NAME"
    cp "$TARGET_DB" "$BACKUP_NAME"
fi

# Kopiuj nową bazę
echo "📋 Kopiowanie $SOURCE_DB → $TARGET_DB"
cp "$SOURCE_DB" "$TARGET_DB"

# Sprawdź rozmiar
SOURCE_SIZE=$(du -h "$SOURCE_DB" | cut -f1)
TARGET_SIZE=$(du -h "$TARGET_DB" | cut -f1)

echo "✅ Baza zsynchronizowana!"
echo "   Źródło: $SOURCE_SIZE"
echo "   Cel:    $TARGET_SIZE"

# Sprawdź templates
TEMPLATE_COUNT=$(sqlite3 "$TARGET_DB" "SELECT COUNT(*) FROM templates;" 2>/dev/null || echo "0")
echo "   Templates: $TEMPLATE_COUNT"

# Restart kontenera (jeśli działa)
if docker ps --format '{{.Names}}' | grep -q "n8n-mcp-local"; then
    echo ""
    echo "🔄 Restartuję kontener n8n-mcp-local..."
    docker-compose restart n8n-mcp-local
    echo "✅ Kontener zrestartowany"
fi

echo ""
echo "🎉 Synchronizacja zakończona!"

