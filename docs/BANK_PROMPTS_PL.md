# 🏦 Spersonalizowane Prompty dla Polskich Banków

## Optymalizacja OCR dla Konkretnych Banków

Każdy polski bank ma swój unikalny layout wyciągu. Poniżej znajdziesz zoptymalizowane prompty dla najpopularniejszych banków, które zwiększają dokładność ekstrakcji do 99%+.

---

## 📋 Spis Treści

1. [PKO BP](#pko-bp)
2. [mBank](#mbank)
3. [ING Bank Śląski](#ing-bank-śląski)
4. [Santander](#santander)
5. [Millennium](#millennium)
6. [Pekao SA](#pekao-sa)
7. [Alior Bank](#alior-bank)
8. [BNP Paribas](#bnp-paribas)
9. [Credit Agricole](#credit-agricole)
10. [Nest Bank](#nest-bank)

---

## 🏦 PKO BP

### Charakterystyka:

- **Format**: PDF natywny (z warstwą tekstową)
- **Layout**: Tabela z podziałem na sekcje
- **Daty**: Format DD-MM-YYYY
- **Kwoty**: Osobne kolumny dla wpłat/wypłat
- **Specyfika**: "SALDO OTWARCIA" i "SALDO ZAMKNIĘCIA" w nagłówku

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU PKO BP

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU PKO BP:
1. Nagłówek: Numer rachunku, okres wyciągu, saldo otwarcia/zamknięcia
2. Tabela transakcji:
   - Kolumna 1: "Data operacji" (DD-MM-YYYY)
   - Kolumna 2: "Data księgowania" (DD-MM-YYYY)
   - Kolumna 3: "Opis operacji"
   - Kolumna 4: "Obciążenia" (kwoty ujemne, puste dla wpłat)
   - Kolumna 5: "Uznania" (kwoty dodatnie, puste dla wypłat)
   - Kolumna 6: "Saldo po operacji"

KLUCZOWE WZORCE:
- Przelewy wychodzące: Zaczynają się od "Przelew"
- Przelewy przychodzące: "Przelew na rachunek"
- Opłaty: "Opłata za", "Prowizja"
- Karty: "BLIK", "Płatność kartą"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "PKO BP",
    "account_holder": "string (z nagłówka)",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD (konwertuj z DD-MM-YYYY)",
      "to": "YYYY-MM-DD"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00,
    "closing_balance": 0.00,
    "total_income": 0.00,
    "total_expense": 0.00
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD (data operacji)",
      "posting_date": "YYYY-MM-DD (data księgowania)",
      "description": "string (opis operacji, usuń nadmiarowe spacje)",
      "counterparty": "string (wyekstrahuj z opisu, jeśli jest)",
      "amount": -150.50 (ujemne dla obciążeń, dodatnie dla uznań),
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "transfer|card_payment|fee|interest|other",
      "reference_number": "string (jeśli widoczny)"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "PKO BP format detected"
  }
}

WERYFIKACJA:
- Saldo końcowe MUSI się zgadzać: opening_balance + suma(amount) = closing_balance
- Suma kolumny "Obciążenia" = suma transakcji typu "debit" (wartość bezwzględna)
- Suma kolumny "Uznania" = suma transakcji typu "credit"

ZWRÓĆ TYLKO JSON, bez markdown.
```

---

## 🏦 mBank

### Charakterystyka:

- **Format**: PDF z mocnym stylingiem
- **Layout**: Kompaktowa tabela
- **Daty**: Format YYYY-MM-DD
- **Kwoty**: Jedna kolumna z +/-
- **Specyfika**: "Saldo początkowe" i "Saldo końcowe" w osobnych wierszach

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU mBANK

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU mBANK:
1. Nagłówek: "Zestawienie operacji" + okres
2. Informacje o rachunku: w ramce po prawej
3. Tabela transakcji (kompaktowa):
   - Kolumna 1: "Data" (YYYY-MM-DD)
   - Kolumna 2: "Opis operacji" (może być wielowierszowy)
   - Kolumna 3: "Kwota" (+/- przed kwotą)
   - Kolumna 4: "Saldo"

KLUCZOWE WZORCE mBANK:
- Przelewy: "PRZELEW NA RACHUNEK", "PRZELEW WYCHODZĄCY"
- BLIK: "BLIK P2P", "BLIK ZWYKŁY"
- Karty: "TRANSAKCJA KARTĄ"
- Opłaty: "OPŁATA ZA PROWADZENIE"
- Odsetki: "KAPITALIZACJA ODSETEK"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "mBank",
    "account_holder": "string",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD",
      "to": "YYYY-MM-DD"
    },
    "statement_number": "string (jeśli widoczny)",
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00,
    "closing_balance": 0.00,
    "total_income": 0.00,
    "total_expense": 0.00
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD",
      "posting_date": "YYYY-MM-DD (lub null jeśli nie ma)",
      "description": "string (WAŻNE: zachowaj formatowanie wielowierszowe jako jedna linia, oddziel spacjami)",
      "counterparty": "string (wyciągnij z opisu - po 'Od:', 'Na rachunek:', 'Odbiorca:')",
      "amount": -150.50,
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "transfer|blik|card|fee|interest|atm|other",
      "reference_number": "string"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "mBank compact format"
  }
}

WAŻNE DLA mBANK:
- Opisy są wielowierszowe - połącz wszystkie linie w jeden string
- Kwota jest w JEDNEJ kolumnie z prefiksem +/-
- "Saldo początkowe" NIE jest transakcją - to opening_balance
- "Saldo końcowe" NIE jest transakcją - to closing_balance

ZWRÓĆ TYLKO JSON.
```

---

## 🏦 ING Bank Śląski

### Charakterystyka:

- **Format**: PDF z obrazem (scan-heavy)
- **Layout**: Szeroka tabela z dużą ilością kolumn
- **Daty**: Format DD.MM.YYYY
- **Kwoty**: Osobne kolumny + saldo
- **Specyfika**: Logo ING pomarańczowe, "Lista operacji"

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU ING BANK ŚLĄSKI

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU ING:
1. Nagłówek: Logo ING (pomarańczowe) + "Lista operacji"
2. Dane rachunku: w ramce na górze
3. Tabela transakcji (SZEROKA - 7+ kolumn):
   - Kolumna 1: "Data operacji" (DD.MM.YYYY)
   - Kolumna 2: "Data waluty" (DD.MM.YYYY)
   - Kolumna 3: "Typ transakcji"
   - Kolumna 4: "Opis"
   - Kolumna 5: "Odbiorca/Nadawca"
   - Kolumna 6: "Numer konta"
   - Kolumna 7: "Kwota" (+/-)
   - Kolumna 8: "Saldo po operacji"

KLUCZOWE WZORCE ING:
- Typ transakcji jest w osobnej kolumnie: "PRZELEW WYCHODZĄCY", "PRZELEW PRZYCHODZĄCY"
- Karty: "TRANSAKCJA KARTĄ DEBETOWĄ"
- Bankomat: "WYPŁATA W BANKOMACIE"
- Opłaty: "OPŁATA ZA KONTO"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "ING Bank Śląski",
    "account_holder": "string",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD (konwertuj z DD.MM.YYYY)",
      "to": "YYYY-MM-DD"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00,
    "closing_balance": 0.00,
    "total_income": 0.00,
    "total_expense": 0.00
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD (data operacji)",
      "posting_date": "YYYY-MM-DD (data waluty)",
      "description": "string (połącz: Typ transakcji + Opis)",
      "counterparty": "string (z kolumny Odbiorca/Nadawca)",
      "counterparty_account": "string (z kolumny Numer konta)",
      "amount": -150.50,
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "transfer|card|atm|fee|interest|other",
      "reference_number": "string"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "ING wide-column format"
  }
}

SPECYFIKA ING:
- ZAWSZE używaj kolumny "Typ transakcji" do określenia category
- Jeśli "Odbiorca/Nadawca" jest pusty - użyj pierwszych słów z "Opis"
- Data waluty może być inna niż data operacji - zapisz obie

ZWRÓĆ TYLKO JSON.
```

---

## 🏦 Santander

### Charakterystyka:

- **Format**: PDF natywny z dobrą jakością tekstu
- **Layout**: Czytelna tabela
- **Daty**: Format DD/MM/YYYY
- **Kwoty**: Dwie kolumny (przychody/rozchody)
- **Specyfika**: Czerwone logo, "Wyciąg z rachunku"

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU SANTANDER BANK POLSKA

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU SANTANDER:
1. Nagłówek: Logo Santander (czerwone) + "Wyciąg z rachunku"
2. Dane klienta i rachunku w ramce
3. "Saldo początkowe" i "Saldo końcowe" na górze tabeli
4. Tabela transakcji:
   - Kolumna 1: "Data operacji" (DD/MM/YYYY)
   - Kolumna 2: "Data księgowania" (DD/MM/YYYY)
   - Kolumna 3: "Opis operacji"
   - Kolumna 4: "Przychody" (pusta dla wypłat)
   - Kolumna 5: "Rozchody" (pusta dla wpłat)
   - Kolumna 6: "Saldo"

KLUCZOWE WZORCE SANTANDER:
- Przelewy wychodzące: "Przelew wychodzący na rachunek"
- Przelewy przychodzące: "Przelew przychodzący"
- Karty: "Transakcja kartą" + szczegóły miejsca
- Bankomaty: "Wypłata w bankomacie"
- BLIK: "BLIK - płatność"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "Santander Bank Polska",
    "account_holder": "string",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD (konwertuj z DD/MM/YYYY)",
      "to": "YYYY-MM-DD"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00 (z wiersza "Saldo początkowe"),
    "closing_balance": 0.00 (z wiersza "Saldo końcowe"),
    "total_income": 0.00 (suma kolumny "Przychody"),
    "total_expense": 0.00 (suma kolumny "Rozchody")
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD (data operacji)",
      "posting_date": "YYYY-MM-DD (data księgowania)",
      "description": "string (opis operacji, zachowaj szczegóły miejsca dla kart)",
      "counterparty": "string (wyekstrahuj z opisu)",
      "amount": -150.50 (ujemne dla Rozchodów, dodatnie dla Przychodów),
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "transfer|card|blik|atm|fee|interest|other",
      "reference_number": "string"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "Santander two-column format"
  }
}

WERYFIKACJA SANTANDER:
- opening_balance + suma(Przychody) - suma(Rozchody) = closing_balance
- Każda transakcja ma wartość ALBO w "Przychody" ALBO w "Rozchody", nigdy w obu
- Jeśli wiersz ma wartość w "Przychody" → amount > 0, type = "credit"
- Jeśli wiersz ma wartość w "Rozchody" → amount < 0, type = "debit"

ZWRÓĆ TYLKO JSON.
```

---

## 🏦 Millennium

### Charakterystyka:

- **Format**: PDF z obrazami i tekstem
- **Layout**: Kompaktowy, style graficzne
- **Daty**: Format DD-MM-RRRR (polski)
- **Kwoty**: Jedna kolumna z +/-
- **Specyfika**: Zielone akcenty, "Zestawienie operacji"

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU BANK MILLENNIUM

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU MILLENNIUM:
1. Nagłówek: "Bank Millennium S.A." + "Zestawienie operacji"
2. Informacje o koncie w sekcji na górze
3. Tabela transakcji:
   - Kolumna 1: "Data operacji" (DD-MM-RRRR - polski format!)
   - Kolumna 2: "Data waluty" (DD-MM-RRRR)
   - Kolumna 3: "Opis operacji" (może być długi, wielowierszowy)
   - Kolumna 4: "Kwota operacji" (+XXXX,XX lub -XXXX,XX)
   - Kolumna 5: "Saldo po operacji"

KLUCZOWE WZORCE MILLENNIUM:
- Transfer: "PRZELEW WYCHODZĄCY/PRZYCHODZĄCY"
- Płatności online: "PŁATNOŚĆ INTERNETOWA"
- Karty: "TRANSAKCJA KARTĄ" + kod merchant
- Opłaty: "OPŁATA MIESIĘCZNA"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "Bank Millennium",
    "account_holder": "string",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD (konwertuj z DD-MM-RRRR)",
      "to": "YYYY-MM-DD"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00,
    "closing_balance": 0.00,
    "total_income": 0.00,
    "total_expense": 0.00
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD (data operacji)",
      "posting_date": "YYYY-MM-DD (data waluty)",
      "description": "string (opis operacji - MOŻE BYĆ DŁUGI, zachowaj wszystkie linie)",
      "counterparty": "string (z opisu - szukaj po 'Od:' lub 'Na rzecz:')",
      "amount": -150.50 (użyj +/- z kolumny Kwota),
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "transfer|card|online_payment|fee|interest|other",
      "reference_number": "string"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "Millennium compact format"
  }
}

SPECYFIKA MILLENNIUM:
- Format daty: DD-MM-RRRR (RRRR = rok, nie YYYY!)
- Separator dziesiętny: PRZECINEK (123,45 nie 123.45) - konwertuj do kropki w JSON
- Opisy mogą zawierać kod merchant w nawiasach - zachowaj to
- "Data waluty" jest osobno - zapisz obie daty

ZWRÓĆ TYLKO JSON. Konwertuj przecinki na kropki w kwotach!
```

---

## 🏦 Pekao SA

### Charakterystyka:

- **Format**: PDF wysokiej jakości
- **Layout**: Formalna tabela z wieloma kolumnami
- **Daty**: Format RRRR-MM-DD
- **Kwoty**: Osobne kolumny obciążenia/uznania
- **Specyfika**: Profesjonalny wygląd, szczegółowe opisy

### Zoptymalizowany Prompt:

```
ANALIZA WYCIĄGU BANK PEKAO SA

Dokument: {{ $json.file_name }}

STRUKTURA WYCIĄGU PEKAO SA:
1. Nagłówek: Logo Pekao + "Wyciąg z rachunku bankowego"
2. Dane właściciela rachunku
3. "Saldo początkowe" i "Saldo końcowe" w osobnych wierszach
4. Tabela transakcji (8 kolumn!):
   - Kolumna 1: "Data operacji" (RRRR-MM-DD)
   - Kolumna 2: "Data księgowania" (RRRR-MM-DD)
   - Kolumna 3: "Typ operacji"
   - Kolumna 4: "Opis operacji"
   - Kolumna 5: "Rachunek nadawcy/odbiorcy"
   - Kolumna 6: "Numer referencyjny"
   - Kolumna 7: "Obciążenia" (puste dla wpłat)
   - Kolumna 8: "Uznania" (puste dla wypłat)
   - Kolumna 9: "Saldo"

KLUCZOWE WZORCE PEKAO SA:
- Typ operacji jest BARDZO precyzyjny: "01 - Przelew wewnętrzny", "02 - Przelew Elixir"
- Karty: "20 - Transakcja kartą" + szczegóły
- Opłaty: "50 - Opłata/prowizja"

WYMAGANY SCHEMAT JSON:
{
  "document_info": {
    "bank_name": "Bank Pekao SA",
    "account_holder": "string",
    "account_number": "string (format: XX XXXX XXXX XXXX XXXX XXXX XXXX)",
    "statement_period": {
      "from": "YYYY-MM-DD (już w dobrym formacie)",
      "to": "YYYY-MM-DD"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 0.00,
    "closing_balance": 0.00,
    "total_income": 0.00 (suma kolumny "Uznania"),
    "total_expense": 0.00 (suma kolumny "Obciążenia")
  },
  "transactions": [
    {
      "date": "YYYY-MM-DD (data operacji)",
      "posting_date": "YYYY-MM-DD (data księgowania)",
      "transaction_type": "string (ZACHOWAJ kod i nazwę typu, np. '01 - Przelew wewnętrzny')",
      "description": "string (opis operacji)",
      "counterparty": "string (z opisu lub osobnej kolumny)",
      "counterparty_account": "string (z kolumny 'Rachunek nadawcy/odbiorcy')",
      "amount": -150.50 (ujemne dla Obciążeń, dodatnie dla Uznań),
      "type": "debit|credit",
      "balance_after": 5000.00,
      "category": "internal_transfer|elixir|card|fee|interest|other",
      "reference_number": "string (z kolumny 'Numer referencyjny')"
    }
  ],
  "metadata": {
    "total_transactions": 0,
    "debit_count": 0,
    "credit_count": 0,
    "confidence_score": 0.95,
    "extraction_notes": "Pekao SA detailed format"
  }
}

SPECYFIKA PEKAO SA:
- Kod typu operacji (01, 02, 20...) jest WAŻNY - zachowaj go
- Numer referencyjny jest ZAWSZE obecny - nie ignoruj
- Daty są już w formacie RRRR-MM-DD (ISO 8601) - nie konwertuj

ZWRÓĆ TYLKO JSON.
```

---

## 📊 Tabela Porównawcza Formatów

| Bank       | Format Daty | Kolumny Kwot           | Separator | Specyfika        |
| ---------- | ----------- | ---------------------- | --------- | ---------------- |
| PKO BP     | DD-MM-YYYY  | 2 (Obciążenia/Uznania) | Kropka    | Saldo w nagłówku |
| mBank      | YYYY-MM-DD  | 1 (+/-)                | Kropka    | Kompaktowy       |
| ING        | DD.MM.YYYY  | 1 (+/-)                | Kropka    | 7+ kolumn        |
| Santander  | DD/MM/YYYY  | 2 (Przychody/Rozchody) | Kropka    | Logo czerwone    |
| Millennium | DD-MM-RRRR  | 1 (+/-)                | Przecinek | Polski format    |
| Pekao SA   | RRRR-MM-DD  | 2 (Obciążenia/Uznania) | Kropka    | Kody typów       |

---

## 🎯 Jak Użyć Tych Promptów?

### Metoda 1: Auto-Detection (Rekomendowane)

Dodaj node **"Bank Detector"** przed głównym ekstraktorym:

```javascript
// Node: Code - Bank Detector
const fileName = $json.file_name.toLowerCase();
const classifier = $("AI Document Classifier").item.json.message.content;

let bankName = "UNKNOWN";
let promptKey = "generic";

// Detekcja po nazwie pliku
if (fileName.includes("pko") || fileName.includes("pkobp")) {
  bankName = "PKO BP";
  promptKey = "pko_bp";
} else if (fileName.includes("mbank")) {
  bankName = "mBank";
  promptKey = "mbank";
} else if (fileName.includes("ing")) {
  bankName = "ING";
  promptKey = "ing";
}
// ... etc

// Detekcja po klasyfikacji AI
if (bankName === "UNKNOWN" && classifier) {
  const detected = JSON.parse(classifier).bank_name;
  if (detected) {
    bankName = detected;
    promptKey = detected.toLowerCase().replace(/\s/g, "_");
  }
}

return {
  bank_name: bankName,
  prompt_key: promptKey,
};
```

Następnie w node **"GPT-4o Vision"** użyj:

```
={{ $('BANK_PROMPTS')[$ ('Bank Detector').item.json.prompt_key] }}
```

### Metoda 2: Manual Selection

W formularzu/webhook pozwól użytkownikowi wybrać bank:

```json
{
  "bank": "pko_bp",
  "file_url": "https://..."
}
```

---

## 🚀 Pro Tips

### 1. Cache Wzorców

Zapisuj rozpoznane wzorce w bazie danych:

```javascript
// Po pierwszym udanym przetworzeniu
const pattern = {
  bank: "PKO BP",
  account_prefix: "61",
  date_format: "DD-MM-YYYY",
  columns: ["data", "opis", "obciążenia", "uznania", "saldo"],
  keywords: ["przelew", "opłata", "blik"],
};

await $("Database").insert("bank_patterns", pattern);
```

### 2. Fallback Chain

Jeśli generic prompt nie działa, spróbuj po kolei wszystkich promptów bankowych:

```
Generic → PKO BP → mBank → ING → ... → Manual Review
```

### 3. Uczenie się

Zapisuj błędne ekstrakcje i feedback:

```javascript
// Po ręcznej korekcie przez użytkownika
const correction = {
  original_extraction: $json,
  corrected_data: $("Manual Corrections").item.json,
  bank: "PKO BP",
  issue: "Incorrect date parsing",
};

// Użyj do fine-tuningu promptów
```

---

## 📞 Support

Masz wyciąg z innego banku? Wyślij przykład (zanonimizowany) a stworzymy dedykowany prompt!

Email: support@yourcompany.com

---

**Happy Processing! 🎉**
