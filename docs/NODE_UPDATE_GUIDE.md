# 🔄 Aktualizacja Węzłów n8n - Kompletny Przewodnik

## 📋 Spis Treści

- [Metody Aktualizacji](#metody-aktualizacji)
- [Proces Aktualizacji](#proces-aktualizacji)
- [Lokalny Setup](#lokalny-setup)
- [Diagnostyka](#diagnostyka)
- [Harmonogram](#harmonogram)

---

## ⚡ Metody Aktualizacji

### **Metoda 1: Automatyczna Aktualizacja (ZALECANA)**

```bash
# 1. Sprawdź dostępne aktualizacje (bez zmian)
npm run update:n8n:check

# 2. Wykonaj pełną aktualizację z testami
npm run update:n8n
```

### **Metoda 2: Ręczna Aktualizacja**

```bash
# 1. Zainstaluj najnowsze wersje
npm install n8n@latest n8n-core@latest n8n-workflow@latest @n8n/n8n-nodes-langchain@latest

# 2. Przebuduj projekt
npm run build

# 3. Odśwież bazę danych węzłów (KLUCZOWE!)
npm run rebuild

# 4. Waliduj zmiany
npm run validate
```

---

## 🔄 Proces Aktualizacji - Co się dzieje?

### **Krok po kroku (npm run update:n8n)**

```
1️⃣ Sprawdzanie Aktualizacji
   ├─→ Pobiera najnowsze wersje z npm registry
   ├─→ Sprawdza kompatybilność zależności
   └─→ Wyświetla listę zmian

2️⃣ Aktualizacja package.json
   ├─→ n8n (główny pakiet)
   ├─→ n8n-core (silnik workflow)
   ├─→ n8n-workflow (typy i logika)
   └─→ @n8n/n8n-nodes-langchain (węzły AI)

3️⃣ Instalacja Zależności
   └─→ npm install (aktualizuje package-lock.json)

4️⃣ Budowanie TypeScript
   └─→ npm run build (kompiluje src/ → dist/)

5️⃣ Odbudowa Bazy Węzłów ⚠️ KLUCZOWY KROK!
   ├─→ Skanuje node_modules dla węzłów n8n
   ├─→ Ekstrahuje definicje 536+ węzłów
   ├─→ Parsuje dokumentację
   ├─→ Generuje bazę SQLite (data/nodes.db)
   └─→ Sanityzuje 2653 szablony

6️⃣ Walidacja
   └─→ npm run validate (testuje krytyczne węzły)
```

---

## 🏠 Lokalny Setup - Aktualizacja Kontenerów

### **Aktualizacja Projektu + Kontenerów**

```bash
# 1. Zaktualizuj projekt
npm run update:n8n

# 2. Przejdź do local-setup
cd local-setup

# 3. Pobierz najnowsze obrazy Docker
docker-compose pull

# 4. Zrestartuj kontenery
docker-compose restart

# 5. Sprawdź status
docker-compose ps

# 6. Monitoruj logi
docker-compose logs -f n8n-mcp-local
```

### **Pełna Reinstalacja Kontenerów**

```bash
cd local-setup

# Zatrzymaj i usuń kontenery
docker-compose down

# Pobierz najnowsze obrazy
docker-compose pull

# Uruchom na nowo
docker-compose up -d

# Sprawdź logi
docker-compose logs -f
```

---

## 📊 Diagnostyka po Aktualizacji

### **Sprawdź Wersje Pakietów**

```bash
npm list n8n n8n-core n8n-workflow @n8n/n8n-nodes-langchain --depth=0
```

**Przykładowy wynik:**

```
n8n-mcp@2.18.10 /Users/Wiktor/TESTPROG BOX/n8n-2lokal
├── @n8n/n8n-nodes-langchain@1.114.0
├── n8n-core@1.114.0
├── n8n-workflow@1.111.0
└── n8n@1.114.4
```

### **Sprawdź Statystyki Bazy Węzłów**

```bash
npm run validate
```

**Przykładowy wynik:**

```
✅ nodes-base.httpRequest
✅ nodes-base.code
✅ nodes-base.slack
✅ nodes-langchain.agent

📊 Results: 4 passed, 0 failed

📈 Database Statistics:
   Total nodes: 535
   AI tools: 269
   Triggers: 108
   Versioned: 140
   Packages: 2

📚 Documentation Coverage:
   Nodes with docs: 475/535 (89%)
```

### **Test MCP Endpoint (lokalny setup)**

```bash
curl http://localhost:3001/health
```

**Oczekiwany wynik:**

```json
{
  "status": "healthy",
  "timestamp": "2025-10-12T07:22:30.332Z",
  "database": {
    "nodes": 535,
    "aiTools": 269,
    "templates": 2653
  }
}
```

---

## 📅 Harmonogram Aktualizacji

### **Zalecane Częstotliwości**

| Typ Aktualizacji     | Częstotliwość         | Komenda                    |
| -------------------- | --------------------- | -------------------------- |
| 🔍 **Sprawdzanie**   | Co tydzień            | `npm run update:n8n:check` |
| 🚀 **Minor/Patch**   | Co 2-4 tygodnie       | `npm run update:n8n`       |
| 🔥 **Major Release** | Po analizie changelog | Ręczna aktualizacja        |
| 🐛 **Hotfix**        | Natychmiast           | `npm run update:n8n`       |

### **Automatyczna Aktualizacja (GitHub Actions)**

Projekt ma skonfigurowany workflow `.github/workflows/update-n8n-deps.yml`:

- ✅ Sprawdza aktualizacje **co poniedziałek o 2:00 AM**
- ✅ Tworzy **Pull Request** z aktualizacjami
- ✅ Uruchamia **pełne testy** (3336 testów)
- ✅ Generuje **changelog**

---

## 🔧 Narzędzia Developerskie

### **Dostępne Komendy**

```bash
# Aktualizacje
npm run update:n8n:check     # Sprawdź dostępne aktualizacje (dry-run)
npm run update:n8n            # Pełna aktualizacja z testami

# Budowanie
npm run build                 # Kompiluj TypeScript
npm run rebuild               # Odbuduj bazę węzłów
npm run rebuild:optimized     # Zoptymalizowana odbudowa

# Walidacja
npm run validate              # Waliduj krytyczne węzły
npm test                      # Uruchom wszystkie testy (3336)
npm run test:unit             # Testy jednostkowe (2766)
npm run test:integration      # Testy integracyjne (570)

# Development
npm run dev                   # Build + rebuild + validate
npm start                     # Uruchom MCP server (stdio)
npm run start:http            # Uruchom MCP server (HTTP)

# Szablony
npm run fetch:templates       # Pobierz nowe szablony z n8n.io
npm run fetch:templates:update # Aktualizuj istniejące szablony
npm run sanitize:templates    # Oczyszczaj dane szablonów
```

---

## ⚠️ Troubleshooting

### Problem: `test-nodes.js not found`

**Rozwiązanie:** Usunięto nieistniejący skrypt z `package.json` i `update-n8n-deps.js`

```bash
# Sprawdź poprawkę
git diff package.json scripts/update-n8n-deps.js
```

### Problem: Baza węzłów nie zaktualizowała się

**Rozwiązanie:**

```bash
# Wymuś pełną odbudowę
rm -f data/nodes.db
npm run build
npm run rebuild
```

### Problem: Kontenery Docker używają starych obrazów

**Rozwiązanie:**

```bash
cd local-setup
docker-compose down
docker-compose pull
docker-compose up -d
```

### Problem: Niezgodność wersji zależności

**Rozwiązanie:**

```bash
# Wyczyść node_modules i reinstaluj
rm -rf node_modules package-lock.json
npm install
npm run build
npm run rebuild
```

---

## 📝 Ostatnia Aktualizacja

**Data:** 2025-10-12  
**Wersje:**

- n8n: `1.114.4`
- n8n-core: `1.114.0`
- n8n-workflow: `1.111.0`
- @n8n/n8n-nodes-langchain: `1.114.0`

**Statystyki:**

- ✅ 536 węzłów
- ✅ 269 narzędzi AI
- ✅ 2653 szablony
- ✅ 89% pokrycie dokumentacją

---

## 📚 Dodatkowe Zasoby

- [n8n Release Notes](https://github.com/n8n-io/n8n/releases)
- [n8n-MCP Changelog](../CHANGELOG.md)
- [Dependency Management](../DEPENDENCY_UPDATES.md)
- [Testing Guide](../testing-architecture.md)

---

**Autor:** n8n-MCP Development Team  
**Licencja:** MIT
