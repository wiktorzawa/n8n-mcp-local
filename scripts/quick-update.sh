#!/bin/bash

# 🚀 Quick Update Script for n8n-MCP
# Szybka aktualizacja węzłów n8n

set -e

# Kolory dla output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 n8n-MCP Quick Update${NC}"
echo ""

# Sprawdź czy jesteśmy w głównym katalogu projektu
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Błąd: Uruchom skrypt z głównego katalogu projektu${NC}"
    exit 1
fi

# Funkcja do wyświetlania statusu
show_status() {
    echo -e "${BLUE}▶${NC} $1"
}

# Funkcja do wyświetlania sukcesu
show_success() {
    echo -e "${GREEN}✅${NC} $1"
}

# Funkcja do wyświetlania ostrzeżenia
show_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

# 1. Sprawdź dostępne aktualizacje
show_status "Sprawdzam dostępne aktualizacje..."
npm run update:n8n:check

echo ""
read -p "Czy chcesz kontynuować aktualizację? (t/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[TtYy]$ ]]; then
    echo -e "${YELLOW}Anulowano aktualizację${NC}"
    exit 0
fi

# 2. Wykonaj aktualizację
show_status "Wykonuję aktualizację..."
npm run update:n8n

# 3. Sprawdź wersje
show_status "Sprawdzam zainstalowane wersje..."
npm list n8n n8n-core n8n-workflow @n8n/n8n-nodes-langchain --depth=0

# 4. Sprawdź czy lokalny setup jest uruchomiony
if [ -d "local-setup" ]; then
    echo ""
    show_status "Znaleziono lokalny setup Docker..."
    
    cd local-setup
    if docker-compose ps | grep -q "Up"; then
        show_status "Aktualizuję kontenery Docker..."
        docker-compose pull
        docker-compose restart
        show_success "Kontenery zaktualizowane"
        
        # Sprawdź health check
        sleep 5
        if curl -s http://localhost:3001/health > /dev/null; then
            show_success "n8n-MCP działa poprawnie: http://localhost:3001"
        else
            show_warning "n8n-MCP może potrzebować więcej czasu na uruchomienie"
        fi
    else
        show_warning "Kontenery nie są uruchomione. Uruchom: cd local-setup && docker-compose up -d"
    fi
    cd ..
fi

echo ""
show_success "Aktualizacja zakończona pomyślnie!"
echo ""
echo -e "${BLUE}📊 Statystyki:${NC}"
npm run validate | grep -A 10 "Database Statistics"

echo ""
echo -e "${GREEN}✨ Gotowe!${NC}"

