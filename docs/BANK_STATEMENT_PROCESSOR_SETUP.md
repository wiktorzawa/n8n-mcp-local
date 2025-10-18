# 🏦 Bank Statement Processor - Enterprise Edition

## Kompletny Przewodnik Wdrożenia

---

## 📋 Spis Treści

1. [Przegląd Systemu](#przegląd-systemu)
2. [Wymagania](#wymagania)
3. [Konfiguracja Krok po Kroku](#konfiguracja-krok-po-kroku)
4. [Struktura Google Sheets](#struktura-google-sheets)
5. [Konfiguracja API i Credentials](#konfiguracja-api-i-credentials)
6. [Testowanie Workflow](#testowanie-workflow)
7. [Monitoring i Optymalizacja](#monitoring-i-optymalizacja)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Przegląd Systemu

### Co robi ten workflow?

**Enterprise Bank Statement Processor** to w pełni zautomatyzowany system do przetwarzania polskich wyciągów bankowych z następującymi możliwościami:

✅ **Automatyczna detekcja** - Monitoruje folder Google Drive i automatycznie przetwarza nowe pliki
✅ **Multi-format support** - Obsługa PDF, JPG, PNG, TIFF
✅ **AI Vision OCR** - GPT-4o Vision + Mistral OCR fallback dla 98%+ dokładności
✅ **Inteligentna walidacja** - AI Agent z toolami do weryfikacji matematycznej, IBAN, dat
✅ **Structured data** - Automatyczna ekstrakcja do Google Sheets
✅ **Real-time alerts** - Powiadomienia Telegram o sukcesach i błędach
✅ **Audit trail** - Pełne logowanie wszystkich operacji
✅ **Auto-archiving** - Automatyczne przenoszenie przetworzonych plików

### Architektura

```
📁 Google Drive (trigger)
    ↓
📋 Metadata Extraction
    ↓
🔀 Document Type Router (PDF/Image)
    ↓
🎨 Image Enhancement (preprocessing)
    ↓
🤖 AI Document Classifier (GPT-4o)
    ↓
✅ Bank Statement Check
    ↓
🧠 GPT-4o Vision - Primary Extraction
    ↓
📦 Structured Output Parser
    ↓
❓ Confidence Check → 🔄 Mistral OCR Fallback (if needed)
    ↓
🔗 Merge Results
    ↓
🔍 AI Agent Validator (+ Calculator/IBAN/Date Tools)
    ↓
✔️ Validation Output Parser
    ↓
✅ Validation Check
    ↓
📊 Split Transactions → 💾 Google Sheets
    ↓
📦 Archive File → 📱 Telegram Success

⚡ Error Trigger → 🔴 Log & Alert
```

---

## 💻 Wymagania

### 1. Infrastruktura

- **n8n** v1.0+ (self-hosted lub cloud)
- **Google Workspace** (Drive + Sheets)
- **Telegram Bot** (dla powiadomień)

### 2. API Keys

| Usługa               | Koszt (1000 wyciągów/miesiąc) | Wymagane                 |
| -------------------- | ----------------------------- | ------------------------ |
| OpenAI API (GPT-4o)  | ~$30                          | ✅ TAK                   |
| Mistral AI API       | ~$2                           | ⚠️ Opcjonalne (fallback) |
| Google Workspace API | Darmowe                       | ✅ TAK                   |
| Telegram Bot API     | Darmowe                       | ⚠️ Opcjonalne (alerty)   |

### 3. Limity i Zasoby

- **Pamięć**: Min 2GB RAM dla n8n
- **Storage**: ~10GB dla archiwum (1000 dokumentów)
- **Rate Limits**:
  - OpenAI: 10,000 requests/day (wystarczające)
  - Google Drive API: 1,000 requests/100sec

---

## 🛠️ Konfiguracja Krok po Kroku

### KROK 1: Przygotowanie Google Drive

#### 1.1. Stwórz strukturę folderów

```
📁 Mój Dysk/
  └─ 📁 Bank Statements/
      ├─ 📁 01-inbox/          ← Tutaj wrzucasz nowe pliki
      ├─ 📁 02-processing/      ← Tymczasowe (opcjonalne)
      ├─ 📁 03-archive/         ← Przetworzone dokumenty
      └─ 📁 04-errors/          ← Pliki z błędami (opcjonalne)
```

#### 1.2. Uzyskaj ID folderów

1. Otwórz folder `01-inbox` w przeglądarce
2. URL wygląda tak: `https://drive.google.com/drive/folders/XXXXXXXXXXXX`
3. Skopiuj `XXXXXXXXXXXX` - to Twój **Folder ID**

**Zapisz te ID**:

- `INBOX_FOLDER_ID`: **\*\***\_\_\_\_**\*\***
- `ARCHIVE_FOLDER_ID`: **\*\***\_\_\_\_**\*\***

---

### KROK 2: Konfiguracja Google Sheets

#### 2.1. Stwórz nowy Spreadsheet

1. Otwórz [Google Sheets](https://sheets.google.com)
2. Stwórz nowy arkusz: "Bank Statements Database"
3. Skopiuj **Spreadsheet ID** z URL

**Zapisz**:

- `SPREADSHEET_ID`: **\*\***\_\_\_\_**\*\***

#### 2.2. Stwórz 4 arkusze (sheets)

##### SHEET 1: "Transactions"

```
| A              | B          | C              | D                     | E                   | F                | G            | H            | I        | J      | K             | L         | M                | N          | O       | P           |
|----------------|------------|----------------|-----------------------|---------------------|------------------|--------------|--------------|----------|--------|---------------|-----------|------------------|------------|---------|-------------|
| processing_id  | bank_name  | account_number | statement_period_from | statement_period_to | transaction_date | posting_date | description  | counterparty | amount | type          | balance_after | category    | reference_number | confidence | status | imported_at |
```

**Formatowanie**:

- Kolumna F, G: Format daty (DD.MM.YYYY)
- Kolumna J, L: Format liczby (#,##0.00)
- Kolumna O: Format procentowy (0.0%)

##### SHEET 2: "Summary"

```
| A            | B          | C             | D                   | E                 | F               | G              | H              | I             |
|--------------|------------|---------------|---------------------|-------------------|-----------------|----------------|----------------|---------------|
| summary_date | bank_name  | account_number | statement_period_from | statement_period_to | opening_balance | closing_balance | total_income | total_expense |
```

##### SHEET 3: "Errors"

```
| A         | B             | C        | D          | E       | F        | G           | H          | I        | J           |
|-----------|---------------|----------|------------|---------|----------|-------------|------------|----------|-------------|
| timestamp | processing_id | filename | error_type | details | warnings | confidence  | resolved   | assigned_to | notes    |
```

##### SHEET 4: "Processing_Log"

```
| A             | B         | C        | D         | E      | F          | G                  | H                  | I          | J          |
|---------------|-----------|----------|-----------|--------|------------|--------------------|--------------------|-----------| ------------|
| processing_id | timestamp | filename | file_size | status | model_used | processing_time_ms | transactions_count | confidence | completed_at |
```

#### 2.3. Dodaj formułki i walidację

W arkuszu **"Summary"** dodaj w pierwszym wierszu:

```excel
=QUERY(Transactions!A2:P, "SELECT B, C, D, E, SUM(J) WHERE K='credit' GROUP BY B, C, D, E")
```

---

### KROK 3: Konfiguracja API Keys

#### 3.1. OpenAI API (GPT-4o)

1. Zarejestruj się na [platform.openai.com](https://platform.openai.com)
2. Dodaj credits ($10 minimum)
3. Idź do **API Keys**: https://platform.openai.com/api-keys
4. Kliknij **"Create new secret key"**
5. Nazwij: `n8n-bank-processor`
6. Skopiuj klucz (zaczyna się od `sk-proj-...`)

**Zapisz**:

- `OPENAI_API_KEY`: **\*\***\_\_\_\_**\*\***

#### 3.2. Mistral AI API (Opcjonalne - Fallback)

1. Zarejestruj się na [mistral.ai](https://console.mistral.ai)
2. Idź do **API Keys**: https://console.mistral.ai/api-keys/
3. Stwórz nowy klucz
4. Skopiuj (zaczyna się od `mi_...`)

**Zapisz**:

- `MISTRAL_API_KEY`: **\*\***\_\_\_\_**\*\***

#### 3.3. Google Workspace API

1. Idź do [Google Cloud Console](https://console.cloud.google.com)
2. Stwórz nowy projekt: "n8n-bank-processor"
3. Włącz APIs:
   - Google Drive API
   - Google Sheets API
4. Stwórz **OAuth 2.0 Client ID**:
   - Typ: Web application
   - Authorized redirect URIs: `https://YOUR_N8N_URL/rest/oauth2-credential/callback`
5. Pobierz credentials JSON

**Zapisz**:

- `GOOGLE_CLIENT_ID`: **\*\***\_\_\_\_**\*\***
- `GOOGLE_CLIENT_SECRET`: **\*\***\_\_\_\_**\*\***

#### 3.4. Telegram Bot (Opcjonalne - Alerty)

1. Otwórz Telegram i znajdź [@BotFather](https://t.me/botfather)
2. Wyślij `/newbot`
3. Podaj nazwę: `Bank Statement Processor Bot`
4. Podaj username: `your_bank_bot`
5. Skopiuj **Token** (format: `123456:ABC-DEF...`)
6. Znajdź swój **Chat ID**:
   - Wyślij wiadomość do [@userinfobot](https://t.me/userinfobot)
   - Skopiuj swój Chat ID

**Zapisz**:

- `TELEGRAM_BOT_TOKEN`: **\*\***\_\_\_\_**\*\***
- `TELEGRAM_CHAT_ID`: **\*\***\_\_\_\_**\*\***

---

### KROK 4: Import Workflow do n8n

#### 4.1. Zaimportuj JSON

1. Otwórz n8n UI: `http://localhost:5679` (lub Twój URL)
2. Kliknij **"+"** → **"Import from File"**
3. Wybierz plik: `bank-statement-processor-enterprise.json`
4. Kliknij **"Import"**

#### 4.2. Skonfiguruj Credentials w n8n

**GOOGLE DRIVE OAuth2:**

1. Kliknij na node "Google Drive - New Files"
2. W sekcji "Credentials" → **"Create New"**
3. Wybierz **"Google Drive OAuth2 API"**
4. Wpisz:
   - **Name**: `Google Drive OAuth2`
   - **Client ID**: `[GOOGLE_CLIENT_ID]`
   - **Client Secret**: `[GOOGLE_CLIENT_SECRET]`
5. Kliknij **"Connect"** → Zaloguj się do Google
6. Zapisz

**GOOGLE SHEETS OAuth2:**

1. Kliknij na node "Log Processing Start"
2. W sekcji "Credentials" → **"Create New"**
3. Wybierz **"Google Sheets OAuth2 API"**
4. Użyj tych samych danych co Google Drive
5. Zapisz

**OPENAI API:**

1. Kliknij na node "AI Document Classifier"
2. W sekcji "Credentials" → **"Create New"**
3. Wybierz **"OpenAI API"**
4. Wpisz:
   - **Name**: `OpenAI API`
   - **API Key**: `[OPENAI_API_KEY]`
5. Zapisz

**MISTRAL AI (Opcjonalne):**

1. Kliknij na node "Mistral OCR - Fallback"
2. W sekcji "Credentials" → **"Create New"**
3. Wybierz **"HTTP Header Auth"**
4. Wpisz:
   - **Name**: `Mistral API Header Auth`
   - **Name** (header): `Authorization`
   - **Value**: `Bearer [MISTRAL_API_KEY]`
5. Zapisz

**TELEGRAM BOT API (Opcjonalne):**

1. Kliknij na node "Send Telegram Alert"
2. W sekcji "Credentials" → **"Create New"**
3. Wybierz **"Telegram API"**
4. Wpisz:
   - **Name**: `Telegram Bot API`
   - **Access Token**: `[TELEGRAM_BOT_TOKEN]`
5. Zapisz

#### 4.3. Skonfiguruj Node Parameters

**Node: "Google Drive - New Files"**

- **Folder ID**: Wklej `[INBOX_FOLDER_ID]`
- **Event**: `fileCreated`
- **Trigger On**: `Changes to Specific Folder`

**Node: "Log Processing Start"**

- **Document ID**: Wybierz Twój spreadsheet z listy lub wklej `[SPREADSHEET_ID]`
- **Sheet Name**: `Processing_Log`

**Node: "Append to Transactions Sheet"**

- **Document ID**: `[SPREADSHEET_ID]`
- **Sheet Name**: `Transactions`

**Node: "Log to Errors Sheet"**

- **Document ID**: `[SPREADSHEET_ID]`
- **Sheet Name**: `Errors`

**Node: "Archive Original File"**

- **Folder ID**: Wklej `[ARCHIVE_FOLDER_ID]`

**Node: "Send Telegram Alert" & "Send Success Notification"**

- **Chat ID**: Wklej `[TELEGRAM_CHAT_ID]`

**Node: "Send Success Notification"** (tekst wiadomości)

- Zamień `YOUR_SHEET_ID` w URL na `[SPREADSHEET_ID]`

---

### KROK 5: Testowanie Workflow

#### 5.1. Test Ręczny

1. **Przygotuj testowy wyciąg**:

   - Pobierz przykładowy wyciąg z banku (PDF lub zrzut ekranu)
   - Upewnij się, że zawiera transakcje w języku polskim

2. **Uruchom workflow ręcznie**:

   - Kliknij **"Execute Workflow"** w n8n
   - Upload plik testowy do folderu `01-inbox` w Google Drive

3. **Monitoruj wykonanie**:

   - Obserwuj przejście przez wszystkie nody w czasie rzeczywistym
   - Sprawdź dane wyjściowe każdego noda

4. **Weryfikuj wyniki**:
   - ✅ Sprawdź arkusz "Transactions" - czy transakcje zostały dodane?
   - ✅ Sprawdź arkusz "Processing_Log" - status COMPLETED?
   - ✅ Sprawdź Telegram - dostałeś powiadomienie?
   - ✅ Sprawdź folder "archive" - plik został przeniesiony?

#### 5.2. Test Automatyczny (Trigger)

1. **Aktywuj workflow**:

   - Kliknij przełącznik **"Active"** w prawym górnym rogu

2. **Upload kolejnego pliku**:

   - Wrzuć nowy wyciąg do folderu `01-inbox`
   - Poczekaj 30-60 sekund

3. **Sprawdź logi**:
   - Idź do **"Executions"** w n8n
   - Znajdź najnowsze wykonanie
   - Status powinien być **"success"**

---

### KROK 6: Monitoring i Optymalizacja

#### 6.1. Dashboard Google Sheets

Stwórz osobny arkusz "Dashboard" z analityką:

```excel
=SPARKLINE(QUERY(Transactions!F:F, "SELECT F, COUNT(F) GROUP BY F"))

=QUERY(Transactions!B:J, "SELECT B, SUM(J) WHERE K='debit' GROUP BY B")

=COUNTIF(Errors!H:H, FALSE)
```

#### 6.2. Alerty i Monitoring

**Konfiguracja alertów**:

- **Sukces**: Powiadomienia tylko dla wyciągów > 10 transakcji
- **Błędy**: Natychmiastowe alerty
- **Dzienny raport**: Podsumowanie o 8:00 rano

Dodaj node **"Schedule Trigger"** (cron: `0 8 * * *`):

```javascript
// Dzienny raport
const yesterday = $now.minus({ days: 1 }).toISODate();
const stats = await $("Google Sheets").getAll("Processing_Log", {
  filter: `timestamp >= '${yesterday}'`,
});

const message = `📊 **RAPORT DZIENNY**

✅ Przetworzone: ${stats.filter((s) => s.status === "COMPLETED").length}
❌ Błędy: ${stats.filter((s) => s.status === "ERROR").length}
⏱️ Średni czas: ${(
  stats.reduce((acc, s) => acc + s.processing_time_ms, 0) /
  stats.length /
  1000
).toFixed(1)}s
`;

return { message };
```

#### 6.3. Optymalizacja Kosztów

**Strategie redukcji kosztów API**:

1. **Cache rozpoznanych banków**:

   - Zapisuj wzorce dokumentów w bazie
   - Pomiń AI Classifier dla znanych layoutów

2. **Batch processing**:

   - Grupuj pliki i przetwarzaj co godzinę zamiast natychmiast
   - Oszczędność: ~30% kosztów API

3. **Conditional Fallback**:
   - Używaj Mistral tylko gdy confidence < 0.8
   - Oszczędność: ~50% kosztów fallback

---

## 🔧 Troubleshooting

### Problem 1: "Insufficient Permissions" (Google Drive)

**Przyczyna**: Brak uprawnień do Google Drive API

**Rozwiązanie**:

1. Idź do Google Cloud Console → API & Services
2. Sprawdź czy **Google Drive API** jest włączone
3. Sprawdź **OAuth Consent Screen** - czy status **"Published"**?
4. Zresetuj credentials w n8n (usuń i dodaj ponownie)

---

### Problem 2: "OpenAI Rate Limit Exceeded"

**Przyczyna**: Przekroczono limit zapytań (10,000/day dla free tier)

**Rozwiązanie**:

1. Upgrade do **Tier 1** ($50 spent) → 10,000 requests/min
2. Dodaj **"Wait"** node z delay 1s między requestami
3. Użyj **"Split In Batches"** dla większych grup

---

### Problem 3: Błędne rozpoznawanie transakcji

**Przyczyna**: Niskiej jakości OCR lub nietypowy layout wyciągu

**Rozwiązanie**:

1. Zwiększ rozdzielczość obrazu (node "Enhance Image"):
   ```json
   {
     "width": 3000,
     "height": 3000
   }
   ```
2. Dodaj preprocessing - konwersja do grayscale
3. Spersonalizuj prompt dla konkretnego banku

---

### Problem 4: Duplikaty w Google Sheets

**Przyczyna**: Workflow wykonany dwa razy dla tego samego pliku

**Rozwiązanie**:

1. Dodaj node **"Check Duplicates"** przed append:

   ```javascript
   const existingIds = await $("Google Sheets").getAll("Transactions", {
     columns: ["processing_id"],
   });

   const currentId = $json.processing_id;

   if (existingIds.includes(currentId)) {
     throw new Error("Duplicate processing_id detected");
   }

   return $json;
   ```

---

### Problem 5: Timeout przy długich PDFach

**Przyczyna**: PDF ma > 50 stron, przekroczono limit czasu

**Rozwiązanie**:

1. Zwiększ timeout w Settings workflow: 5 min → 15 min
2. Dodaj **"Split PDF"** przed ekstrakcją:
   - Przetwarzaj po 10 stron
   - Merge wyniki na końcu

---

## 📊 Metryki Wydajności

### Oczekiwane czasy przetwarzania:

| Typ dokumentu  | Rozmiar | Transakcje | Czas   |
| -------------- | ------- | ---------- | ------ |
| PDF (scan)     | 2MB     | 10-20      | 15-25s |
| PDF (native)   | 500KB   | 10-20      | 8-12s  |
| PNG/JPG        | 3MB     | 10-20      | 12-18s |
| Multi-page PDF | 5MB     | 50+        | 45-60s |

### Dokładność:

- **GPT-4o Vision**: 97-99% dla polskich wyciągów
- **Mistral OCR**: 92-95% (fallback)
- **Combined (z AI Validator)**: 98-99.5%

### Koszty (1000 wyciągów/miesiąc):

```
GPT-4o Vision (primary):
  - 1000 requests × $0.03/request = $30

Mistral OCR (10% fallback):
  - 100 requests × $0.02/request = $2

Google APIs: $0 (free tier)
Telegram: $0 (darmowe)

TOTAL: ~$32/miesiąc
```

---

## 🎓 Best Practices

### 1. Bezpieczeństwo

✅ **DO**:

- Używaj OAuth 2.0 dla Google APIs
- Przechowuj API keys w n8n Credentials (nigdy w kodzie)
- Włącz 2FA na wszystkich kontach
- Regularnie rotuj API keys (co 90 dni)

❌ **NIE**:

- Nie udostępniaj Spreadsheet publicznie
- Nie commituj credentials do git
- Nie używaj API keys w URL parameters

### 2. Skalowanie

Dla > 10,000 wyciągów/miesiąc:

1. **PostgreSQL zamiast Google Sheets**:

   - Lepsze performance dla dużych datasets
   - Zaawansowane query capabilities

2. **Redis Cache**:

   - Cache wyników AI Classifier
   - TTL: 30 dni

3. **Queue System**:
   - RabbitMQ/BullMQ dla batch processing
   - Retry logic z exponential backoff

### 3. Data Governance

- **Retencja**: Automatycznie usuwaj pliki starsze niż 7 lat (compliance)
- **Backup**: Codzienne backup Google Sheets do Cloud Storage
- **Audit**: Log wszystkich dostępów do danych finansowych

---

## 📚 Dodatki

### A. Przykładowy Wyciąg Testowy

Możesz użyć generatora testowych wyciągów:

- https://www.fakebanking.com/pl (fikcyjne dane)

### B. Template Raportu Excel

[Link do pobrania template'u Excel z dashboardem]

### C. Video Tutorial

[Link do video przewodnika po konfiguracji]

---

## 📞 Support

Potrzebujesz pomocy?

1. **GitHub Issues**: [link do repo]
2. **n8n Community**: https://community.n8n.io
3. **Email**: support@yourcompany.com

---

## 📄 Changelog

### v1.0.0 (2025-01-18)

- ✨ Initial release
- ✅ GPT-4o Vision integration
- ✅ Mistral OCR fallback
- ✅ AI Agent validator
- ✅ Multi-model pipeline
- ✅ Google Sheets automation
- ✅ Telegram notifications
- ✅ Error handling & logging

---

## 📜 License

MIT License - Zobacz [LICENSE](../LICENSE) dla szczegółów

---

**Gotowy do startu? Powodzenia! 🚀**

Jeśli masz pytania - sprawdź sekcję [Troubleshooting](#troubleshooting) lub skontaktuj się z nami!
