# ⚡ Quick Start - Bank Statement Processor

## 15-minutowe wdrożenie

---

## 🎯 Cel

Uruchom pełnoprawny system przetwarzania wyciągów bankowych w 15 minut.

---

## ✅ Checklist Przygotowań

Przed rozpoczęciem upewnij się, że masz:

- [ ] Działającą instancję n8n (localhost:5679 lub cloud)
- [ ] Konto Google (Drive + Sheets)
- [ ] Konto OpenAI z credits
- [ ] (Opcjonalne) Telegram Bot

**Szacowany czas:** 15 minut
**Poziom trudności:** ⭐⭐⚪⚪⚪ (Średni)

---

## 📋 Krok 1: Google Setup (5 min)

### 1.1. Stwórz folder w Google Drive

```
1. Otwórz drive.google.com
2. Nowy folder → "Bank Statements Inbox"
3. Skopiuj ID z URL (końcówka po /folders/)
   Zapisz jako: FOLDER_ID = __________________
```

### 1.2. Stwórz Google Sheet

```
1. Otwórz sheets.google.com
2. Nowy arkusz → "Bank Data"
3. Skopiuj ID z URL (pomiędzy /d/ a /edit)
   Zapisz jako: SHEET_ID = __________________

4. Stwórz 4 arkusze (sheets) o nazwach:
   - Transactions
   - Summary
   - Errors
   - Processing_Log

5. W "Transactions" dodaj nagłówki (wiersz 1):
   processing_id | bank_name | account_number | transaction_date | description | amount | type | status
```

---

## 🔑 Krok 2: API Keys (5 min)

### 2.1. OpenAI

```
1. Idź do: https://platform.openai.com/api-keys
2. Zaloguj się / Zarejestruj
3. Kliknij "+ Create new secret key"
4. Skopiuj klucz (zaczyna się od sk-proj-...)
   Zapisz jako: OPENAI_KEY = __________________
```

### 2.2. Google OAuth (szybka konfiguracja)

```
1. Otwórz: https://console.cloud.google.com
2. Nowy projekt: "n8n-bank"
3. APIs & Services → Enable APIs → Włącz:
   - Google Drive API
   - Google Sheets API
4. Credentials → Create OAuth Client ID
   - Type: Web application
   - Authorized redirect: http://localhost:5679/rest/oauth2-credential/callback
5. Pobierz Client ID i Client Secret
   Zapisz jako:
   GOOGLE_CLIENT_ID = __________________
   GOOGLE_CLIENT_SECRET = __________________
```

---

## 🚀 Krok 3: Import do n8n (3 min)

### 3.1. Otwórz n8n

```bash
# Jeśli używasz lokalnej instancji:
cd /Users/Wiktor/TESTPROG\ BOX/n8n-2lokal
npm run local:start

# Otwórz przeglądarkę:
http://localhost:5679
```

### 3.2. Import workflow

```
1. W n8n UI kliknij "+" → "Import from File"
2. Wybierz plik: workflows/bank-statement-processor-enterprise.json
3. Kliknij "Import"
```

### 3.3. Dodaj credentials (jeden raz)

**Google Drive OAuth2:**

```
1. Kliknij na node "Google Drive - New Files"
2. Credentials → Create New → Google Drive OAuth2 API
3. Wklej Client ID i Client Secret
4. Kliknij "Connect" → Zaloguj się do Google
5. Zapisz
```

**OpenAI API:**

```
1. Kliknij na node "AI Document Classifier"
2. Credentials → Create New → OpenAI API
3. Wklej API Key
4. Zapisz
```

### 3.4. Skonfiguruj podstawowe parametry

**Node: "Google Drive - New Files"**

```
📁 Folder ID: [wklej FOLDER_ID]
```

**Node: "Log Processing Start"**

```
📊 Document ID: [wybierz z listy lub wklej SHEET_ID]
📄 Sheet Name: Processing_Log
```

**Node: "Append to Transactions Sheet"**

```
📊 Document ID: [ten sam SHEET_ID]
📄 Sheet Name: Transactions
```

---

## 🧪 Krok 4: Test (2 min)

### 4.1. Przygotuj testowy plik

Pobierz przykładowy wyciąg lub użyj zrzutu ekranu z banku (PDF/PNG).

### 4.2. Wykonaj test

```
1. Kliknij "Execute Workflow" (przycisk play)
2. Upload testowy plik do folderu Google Drive "Bank Statements Inbox"
3. Obserwuj wykonanie w n8n (30-60 sekund)
4. Sprawdź Google Sheets - czy pojawiły się dane?
```

### 4.3. Weryfikacja

✅ Sprawdź:

- [ ] Google Sheets → arkusz "Transactions" ma nowe wiersze
- [ ] Google Sheets → arkusz "Processing_Log" status = COMPLETED
- [ ] Plik w Google Drive został zachowany (lub przeniesiony jeśli skonfigurowałeś archiwizację)

---

## ⚙️ Krok 5: Aktywacja (opcjonalnie)

Jeśli test przeszedł pomyślnie:

```
1. Kliknij przełącznik "Active" w prawym górnym rogu
2. Teraz workflow będzie automatycznie przetwarzać nowe pliki w folderze
```

---

## 🎉 Gotowe!

Twój system jest uruchomiony! Teraz możesz:

1. **Wrzucać wyciągi** do folderu Google Drive
2. **Automatycznie otrzymywać** dane w Google Sheets
3. **Monitorować** logi w arkuszu "Processing_Log"

---

## 📚 Co dalej?

### Rozbudowa Podstawowa (+ 30 min)

1. **Telegram Notifications** - Dodaj bota dla alertów

   - Przejdź do: [BANK_STATEMENT_PROCESSOR_SETUP.md](./BANK_STATEMENT_PROCESSOR_SETUP.md#34-telegram-bot-opcjonalne---alerty)

2. **Archiwizacja** - Automatycznie przenoś przetworzone pliki

   - Stwórz folder "Archive" w Google Drive
   - Skonfiguruj node "Archive Original File"

3. **Optymalizacja dla Twojego Banku** - Zwiększ dokładność do 99%+
   - Zobacz: [BANK_PROMPTS_PL.md](./BANK_PROMPTS_PL.md)

### Rozbudowa Zaawansowana (+ 2h)

1. **Mistral OCR Fallback** - Dla trudnych dokumentów
2. **AI Validator** - Automatyczna weryfikacja matematyczna
3. **Error Handling** - Zaawansowane logowanie błędów
4. **Dashboard** - Wizualizacje i raporty

**Pełny przewodnik:** [BANK_STATEMENT_PROCESSOR_SETUP.md](./BANK_STATEMENT_PROCESSOR_SETUP.md)

---

## ❓ Problemy?

### Problem: "Insufficient permissions" (Google)

**Rozwiązanie:**

```
1. Google Cloud Console → APIs & Services → Enabled APIs
2. Sprawdź czy Google Drive API i Google Sheets API są włączone
3. OAuth Consent Screen → Status = "Published"
```

### Problem: "OpenAI Rate Limit"

**Rozwiązanie:**

```
1. Dodaj delay 2s między requestami (node "Wait")
2. Lub upgrade OpenAI plan do Tier 1 ($50 spent)
```

### Problem: "Workflow nie wykrywa nowych plików"

**Rozwiązanie:**

```
1. Sprawdź czy workflow jest "Active" (przełącznik w prawym górnym rogu)
2. Sprawdź Folder ID - czy się zgadza?
3. Spróbuj odświeżyć credentials (usuń i dodaj ponownie)
```

---

## 📞 Support

**Szczegółowa dokumentacja:**

- [Pełny Setup](./BANK_STATEMENT_PROCESSOR_SETUP.md)
- [Prompty dla Banków](./BANK_PROMPTS_PL.md)
- [Troubleshooting](./BANK_STATEMENT_PROCESSOR_SETUP.md#troubleshooting)

**Potrzebujesz pomocy?**

- GitHub Issues
- n8n Community Forum

---

## 📊 Benchmark

Po uruchomieniu możesz oczekiwać:

| Metryka                 | Wartość             |
| ----------------------- | ------------------- |
| **Dokładność**          | 97-99%              |
| **Czas przetwarzania**  | 15-30s/dokument     |
| **Koszt**               | ~$0.03/dokument     |
| **Obsługiwane formaty** | PDF, PNG, JPG, TIFF |
| **Max rozmiar pliku**   | 50MB                |

---

**🎯 Miłego automatyzowania! 🚀**

Jeśli workflow działa - zostaw ⭐ na GitHub!
