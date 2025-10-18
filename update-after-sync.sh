#!/bin/bash

echo "🔄 Wykryto aktualizację main - aktualizuję lokalne images..."

cd local-setup

# Pobierz najnowsze images
docker-compose pull

# Restart kontenerów z nowymi images
docker-compose down
docker-compose up -d

echo "✅ Lokalne images zaktualizowane!"
