#!/bin/bash

echo "🚀 Uruchamianie lokalnego n8n + n8n-mcp..."

# Sprawdź czy Docker działa
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker nie działa. Uruchom Docker Desktop."
    exit 1
fi

# Pobierz najnowsze images
echo "📦 Pobieranie najnowszych images..."
docker pull n8nio/n8n:latest
docker pull ghcr.io/czlonkowski/n8n-mcp:latest

# Uruchom serwisy
echo "🔄 Uruchamianie kontenerów..."
docker-compose up -d

# Sprawdź status
echo "✅ Status kontenerów:"
docker-compose ps

echo ""
echo "🌐 Dostępne serwisy:"
echo "   n8n:     http://localhost:5679"
echo "   n8n-mcp: http://localhost:3001"
echo ""
echo "🔑 Logowanie do n8n:"
echo "   User: admin"
echo "   Pass: local123"
