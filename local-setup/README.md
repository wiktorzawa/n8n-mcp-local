# Lokalny Setup n8n + n8n-MCP

Lokalne środowisko do testowania n8n i n8n-MCP w kontenerach Docker.

## 🚀 Quick Start

```bash
# Uruchom lokalne środowisko
./start-local.sh

# Dostęp:
# n8n:     http://localhost:5679
# n8n-mcp: http://localhost:3001
#
# Login do n8n:
# User: admin
# Pass: local123
```

## 📂 Struktura

```
local-setup/
├── docker-compose.yml          # Konfiguracja kontenerów
├── start-local.sh              # Skrypt startowy
├── sync-database.sh            # Sync bazy danych
├── n8n-data/                   # Dane n8n (workflow, credentials)
├── n8n-mcp-data/               # Baza danych n8n-mcp
│   └── nodes.db                # 60MB - 536 nodes + 2,676 templates
└── logs/                       # Logi n8n-mcp

```

## 🔄 Synchronizacja Bazy Danych

**WAŻNE:** Lokalne kontenery używają **własnej kopii** bazy danych w `n8n-mcp-data/`.

### Kiedy synchronizować?

Uruchom synchronizację po:

- ✅ `npm run fetch:templates` (nowe templates)
- ✅ `npm run update:n8n` (nowe wersje node'ów)
- ✅ `npm run rebuild` (rebuild bazy)

### Jak synchronizować?

```bash
cd local-setup/
./sync-database.sh
```

Skrypt automatycznie:

1. Tworzy backup starej bazy
2. Kopiuje `data/nodes.db` → `local-setup/n8n-mcp-data/nodes.db`
3. Restartuje kontener `n8n-mcp-local`

## 🎯 Przepływ Pracy

### Development → Lokalne Testy

```bash
# 1. Aktualizuj dane w głównym projekcie
cd /Users/Wiktor/TESTPROG\ BOX/n8n-2lokal/
npm run fetch:templates        # Pobierz nowe templates
npm run update:n8n             # Aktualizuj node'y

# 2. Synchronizuj z lokalnym setupem
cd local-setup/
./sync-database.sh             # Skopiuj zaktualizowaną bazę

# 3. Testuj lokalnie
# n8n: http://localhost:5679
# n8n-mcp: http://localhost:3001
```

## 🐳 Zarządzanie Kontenerami

```bash
# Start
docker-compose up -d

# Stop
docker-compose down

# Restart pojedynczego serwisu
docker-compose restart n8n-mcp-local

# Logi
docker-compose logs -f n8n-mcp-local

# Status
docker-compose ps
```

## 🔍 Weryfikacja

### Sprawdź bazę danych

```bash
# Liczba templates
sqlite3 n8n-mcp-data/nodes.db "SELECT COUNT(*) FROM templates;"
# Powinno być: 2676

# Liczba node'ów
sqlite3 n8n-mcp-data/nodes.db "SELECT COUNT(*) FROM nodes;"
# Powinno być: 536

# Top 5 templates
sqlite3 n8n-mcp-data/nodes.db "SELECT name, views FROM templates ORDER BY views DESC LIMIT 5;"
```

### Sprawdź API

```bash
# Health check
curl http://localhost:3001/health

# MCP endpoint
curl http://localhost:3001/mcp
```

## 📊 Różnice: Lokalne vs Production

| Aspekt            | Lokalne Kontenery           | Production Image       |
| ----------------- | --------------------------- | ---------------------- |
| **Baza danych**   | `local-setup/n8n-mcp-data/` | `/app/data/` (w image) |
| **Źródło danych** | Kopiowana z `data/`         | Wbudowana w image      |
| **Aktualizacje**  | Manual sync                 | Rebuild image          |
| **Environment**   | development                 | production             |
| **Logi**          | debug                       | info                   |

## ⚠️ Problemy i Rozwiązania

### Brak templates w lokalnej wersji

**Problem:** Lokalna baza jest pusta lub nieaktualna.

**Rozwiązanie:**

```bash
./sync-database.sh
```

### Kontener nie startuje

**Sprawdź:**

```bash
docker-compose logs n8n-mcp-local
docker-compose ps
```

### Baza danych zablokowana

**Jeśli baza jest w użyciu:**

```bash
docker-compose stop n8n-mcp-local
./sync-database.sh
docker-compose start n8n-mcp-local
```

## 🎓 Dodatkowe Komendy

```bash
# Rebuild image lokalnie (jeśli modyfikujesz kod)
cd ..
docker build -t n8n-mcp:local .
# Następnie zmień w docker-compose.yml: image: n8n-mcp:local

# Czyszczenie starych backup'ów
find n8n-mcp-data/ -name "*.backup.*" -mtime +7 -delete

# Reset całego środowiska
docker-compose down -v
rm -rf n8n-data/* n8n-mcp-data/* logs/*
./start-local.sh
./sync-database.sh
```

## 📝 Notatki

- Baza danych `nodes.db` zawiera zarówno node'y jak i templates (nie ma oddzielnego `templates.db`)
- Lokalne kontenery używają prebuilt image z GitHub
- Automatyczne updates są wyłączone (`REBUILD_ON_START=false`)
- N8N API key w tym setupie jest mock'owany (dla testów UI)

## 🔗 Linki

- [Główny README projektu](../README.md)
- [Dokumentacja n8n-MCP](../docs/README.md)
- [Docker Troubleshooting](../docs/DOCKER_TROUBLESHOOTING.md)
