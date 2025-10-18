# 🧪 Przykładowe Dane Testowe - Bank Statement Processor

## 📋 Plik Testowy #1: PKO BP Wyciąg (Fikcyjne Dane)

### Dane do wklejenia w testowy PDF/dokument:

```
═══════════════════════════════════════════════════════════
              POWSZECHNA KASA OSZCZĘDNOŚCI BANK POLSKI S.A.
═══════════════════════════════════════════════════════════

WYCIĄG Z RACHUNKU

Właściciel rachunku: Jan Kowalski
Numer rachunku: PL 61 1020 1026 0000 0123 4567 8901
Okres wyciągu: 01-01-2024 do 31-01-2024

SALDO OTWARCIA (01-01-2024): 5,000.00 PLN
SALDO ZAMKNIĘCIA (31-01-2024): 4,325.50 PLN

───────────────────────────────────────────────────────────

ZESTAWIENIE OPERACJI

Data       Data        Opis operacji                      Obciążenia  Uznania   Saldo
operacji   księgowania                                    (PLN)       (PLN)     (PLN)
──────────────────────────────────────────────────────────────────────────────────────

02-01-2024 02-01-2024 Przelew wychodzący                  -150.00              4,850.00
                      Odbiorca: ENERGA-OPERATOR SA
                      Tytułem: Opłata za energię 12/2023

05-01-2024 05-01-2024 Przelew na rachunek                             3,500.00 8,350.00
                      Od: ABC EMPLOYER Sp. z o.o.
                      Tytułem: Wynagrodzenie za 12/2023

08-01-2024 08-01-2024 BLIK - płatność                     -45.90               8,304.10
                      Sklep: BIEDRONKA 1234
                      Lokalizacja: WARSZAWA

12-01-2024 12-01-2024 Płatność kartą                      -125.00              8,179.10
                      Karta: **** 5678
                      Merchant: ALLEGRO.PL

15-01-2024 15-01-2024 Przelew wychodzący                  -1,200.00            6,979.10
                      Odbiorca: WŁAŚCICIEL MIESZKANIA
                      Tytułem: Czynsz - Styczeń 2024

18-01-2024 18-01-2024 Wypłata w bankomacie                -500.00              6,479.10
                      Bankomat: ATM-PKO-WA-12345
                      Lokalizacja: ul. Marszałkowska 1

22-01-2024 22-01-2024 BLIK P2P                            -80.00               6,399.10
                      Odbiorca tel: +48 123 456 789
                      Tytułem: Zwrot za kolację

25-01-2024 25-01-2024 Opłata za prowadzenie rachunku     -5.00                6,394.10
                      Okres: 01/2024

28-01-2024 28-01-2024 Przelew wychodzący                  -1,500.00            4,894.10
                      Odbiorca: ORANGE POLSKA S.A.
                      Tytułem: Faktura 123/01/2024

30-01-2024 30-01-2024 Przelew na rachunek                             850.00   5,744.10
                      Od: KLIENT XYZ
                      Tytułem: Zwrot VAT

31-01-2024 31-01-2024 Kapitalizacja odsetek                           1.40     5,745.50
                      Okres: 01/2024
                      Stopa: 0.01%

31-01-2024 31-01-2024 Podatek Belki                       -20.00               5,725.50
                      Od odsetek: 1.40 PLN

───────────────────────────────────────────────────────────

PODSUMOWANIE:
Obroty w okresie:
- Obciążenia: -3,625.90 PLN
- Uznania: +4,351.40 PLN

Saldo końcowe: 5,725.50 PLN

───────────────────────────────────────────────────────────
Dokument wygenerowany: 01-02-2024 12:00:00
───────────────────────────────────────────────────────────
```

### Oczekiwany wynik ekstrakcji:

```json
{
  "document_info": {
    "bank_name": "PKO BP",
    "account_holder": "Jan Kowalski",
    "account_number": "PL 61 1020 1026 0000 0123 4567 8901",
    "statement_period": {
      "from": "2024-01-01",
      "to": "2024-01-31"
    },
    "currency": "PLN"
  },
  "balances": {
    "opening_balance": 5000.0,
    "closing_balance": 5725.5,
    "total_income": 4351.4,
    "total_expense": 3625.9
  },
  "transactions": [
    {
      "date": "2024-01-02",
      "posting_date": "2024-01-02",
      "description": "Przelew wychodzący - Odbiorca: ENERGA-OPERATOR SA - Tytułem: Opłata za energię 12/2023",
      "counterparty": "ENERGA-OPERATOR SA",
      "amount": -150.0,
      "type": "debit",
      "balance_after": 4850.0,
      "category": "transfer"
    },
    {
      "date": "2024-01-05",
      "posting_date": "2024-01-05",
      "description": "Przelew na rachunek - Od: ABC EMPLOYER Sp. z o.o. - Tytułem: Wynagrodzenie za 12/2023",
      "counterparty": "ABC EMPLOYER Sp. z o.o.",
      "amount": 3500.0,
      "type": "credit",
      "balance_after": 8350.0,
      "category": "transfer"
    }
    // ... pozostałe transakcje
  ],
  "metadata": {
    "total_transactions": 12,
    "debit_count": 8,
    "credit_count": 4,
    "confidence_score": 0.98
  }
}
```

---

## 📋 Plik Testowy #2: mBank Wyciąg (Uproszczony)

```
═══════════════════════════════════════════════════════════
                    mBANK S.A.
              Zestawienie operacji
═══════════════════════════════════════════════════════════

Rachunek: PL 78 1140 2004 0000 3002 7891 2345
Właściciel: Anna Nowak
Okres: 2024-02-01 do 2024-02-29

Saldo początkowe: 2,500.00 PLN

───────────────────────────────────────────────────────────

Data       Opis operacji                          Kwota      Saldo

2024-02-01 PRZELEW WYCHODZĄCY                     -85.00     2,415.00
           Na rachunek: PL 12 3456...
           Odbiorca: Sklep ABC

2024-02-03 BLIK ZWYKŁY                            -120.00    2,295.00
           Lokalizacja: LIDL WARSZAWA

2024-02-05 PRZELEW NA RACHUNEK                    +2,800.00  5,095.00
           Od: PRACODAWCA XYZ Sp. z o.o.
           Tytuł: Wypłata 02/2024

2024-02-10 TRANSAKCJA KARTĄ                       -250.00    4,845.00
           Karta: mKarta *1234
           RTV EURO AGD WARSZAWA

2024-02-15 OPŁATA ZA PROWADZENIE                  -5.90      4,839.10
           Pakiet: mKonto Intensive
           Okres: 02/2024

───────────────────────────────────────────────────────────

Saldo końcowe: 4,839.10 PLN

Obroty:
Przychody: +2,800.00 PLN
Rozchody: -460.90 PLN

───────────────────────────────────────────────────────────
```

---

## 🧪 Scenariusze Testowe

### Test 1: Podstawowa Ekstrakcja

**Cel:** Sprawdzić czy wszystkie transakcje są wykryte

**Kroki:**

1. Upload "PKO BP Wyciąg" do Google Drive
2. Poczekaj na wykonanie workflow
3. Sprawdź Google Sheets - arkusz "Transactions"

**Oczekiwany wynik:**

- ✅ 12 transakcji w arkuszu
- ✅ Saldo początkowe: 5,000.00
- ✅ Saldo końcowe: 5,725.50 (uwaga: w przykładzie błąd - powinno być zgodne z sumą)
- ✅ Status: COMPLETED

---

### Test 2: Walidacja Matematyczna

**Cel:** Sprawdzić AI Agent Validator

**Plik:** Użyj PKO BP wyciągu, ale **zmień** saldo końcowe na błędne (np. 999.99)

**Kroki:**

1. Stwórz dokument z błędnym saldem
2. Upload do Google Drive
3. Poczekaj na wykonanie

**Oczekiwany wynik:**

- ❌ Walidacja fail
- ✅ Wpis w arkuszu "Errors"
- ✅ Telegram alert z opisem błędu: "Balance mismatch"

---

### Test 3: Fallback do Mistral OCR

**Cel:** Testować inteligentny fallback

**Plik:** Zrób "brutalny" scan (niska jakość, przekrzywiony)

**Kroki:**

1. Wydrukuj PKO wyciąg
2. Zeskanuj w niskiej rozdzielczości (150 DPI)
3. Upload

**Oczekiwany wynik:**

- ⚠️ GPT-4o confidence < 0.85
- ✅ Automatic fallback do Mistral OCR
- ✅ Merge wyników
- ✅ Status: COMPLETED (może być niższa confidence)

---

### Test 4: Nieobsługiwany Dokument

**Cel:** Sprawdzić rejection dla non-bank documents

**Plik:** Upload np. faktury VAT lub paragonu (nie wyciągu)

**Oczekiwany wynik:**

- ❌ AI Classifier: document_type = "INVOICE" (not BANK_STATEMENT)
- ❌ Workflow stop na "Is Bank Statement?" node
- ✅ Wpis w "Errors" z type = "WRONG_DOCUMENT_TYPE"

---

### Test 5: Multi-page PDF

**Cel:** Testować długie wyciągi (50+ transakcji)

**Plik:** Stwórz PDF z 3+ stronami transakcji

**Oczekiwany wynik:**

- ✅ Wszystkie strony processed
- ✅ Wszystkie transakcje w Google Sheets
- ⏱️ Processing time: 45-90s (dłużej niż normalnie)

---

## 📊 Expected Metrics dla Testów

### Performance Benchmarks:

| Test Case             | Processing Time | Confidence | Status                 |
| --------------------- | --------------- | ---------- | ---------------------- |
| Test 1 (clean PDF)    | 15-25s          | 0.95-0.99  | ✅ PASS                |
| Test 2 (invalid data) | 20-30s          | 0.80-0.95  | ❌ FAIL (expected)     |
| Test 3 (low quality)  | 30-45s          | 0.85-0.92  | ✅ PASS (via fallback) |
| Test 4 (wrong doc)    | 10-15s          | N/A        | ❌ REJECTED (expected) |
| Test 5 (multi-page)   | 45-90s          | 0.92-0.97  | ✅ PASS                |

---

## 🎓 Advanced Test Scenarios

### Test 6: Duplikaty

**Setup:** Upload ten sam plik 2 razy

**Oczekiwany wynik:**

- Node "Check Duplicates" powinien wykryć i zignorować drugi upload
- (wymaga dodania custom node - patrz docs)

---

### Test 7: Różne Banki

**Setup:** Upload wyciągi z 3 różnych banków jednocześnie

**Oczekiwany wynik:**

- AI Classifier rozpoznaje każdy bank
- Odpowiednie prompty używane
- Wszystkie przetworzone poprawnie

---

### Test 8: Stress Test

**Setup:** Upload 50 wyciągów naraz

**Oczekiwany wynik:**

- Kolejka workflow obsługuje batch
- Wszystkie pliki eventually processed
- Brak crashes/timeouts

---

## 🔧 Generating Test Data

### Python Script do Generowania Testowych Wyciągów:

```python
#!/usr/bin/env python3
"""
Generate fake Polish bank statements for testing
"""

from datetime import datetime, timedelta
import random

def generate_transaction(date, balance):
    types = [
        ("Przelew wychodzący", -random.randint(50, 500)),
        ("Przelew na rachunek", random.randint(1000, 5000)),
        ("BLIK - płatność", -random.randint(20, 150)),
        ("Płatność kartą", -random.randint(30, 300)),
        ("Wypłata w bankomacie", -random.randint(100, 500))
    ]

    desc, amount = random.choice(types)
    new_balance = balance + amount

    return {
        "date": date.strftime("%d-%m-%Y"),
        "description": desc,
        "amount": amount,
        "balance": new_balance
    }

# Usage
start_date = datetime(2024, 1, 1)
balance = 5000.00
transactions = []

for i in range(20):
    trans_date = start_date + timedelta(days=i*2)
    trans = generate_transaction(trans_date, balance)
    transactions.append(trans)
    balance = trans["balance"]

# Print as table
for t in transactions:
    print(f"{t['date']} | {t['description']:30} | {t['amount']:>10.2f} | {t['balance']:>10.2f}")
```

---

## 📝 Test Checklist

Przed production deployment, upewnij się że przeszły wszystkie testy:

- [ ] Test 1: Podstawowa ekstrakcja ✅
- [ ] Test 2: Walidacja matematyczna ✅
- [ ] Test 3: Fallback do Mistral ✅
- [ ] Test 4: Rejection niewłaściwych dokumentów ✅
- [ ] Test 5: Multi-page PDF ✅
- [ ] Test 6: Detekcja duplikatów ✅
- [ ] Test 7: Różne banki ✅
- [ ] Test 8: Stress test (50 docs) ✅
- [ ] Telegram notifications działają ✅
- [ ] Google Sheets poprawnie wypełnione ✅
- [ ] Error logging działa ✅
- [ ] Archiving plików działa ✅

---

## 🎯 Quality Assurance

### Acceptance Criteria:

✅ **Accuracy**: > 95% dla clean documents
✅ **Performance**: < 30s per document (standard)
✅ **Reliability**: < 1% system errors
✅ **User Experience**: Clear error messages

---

**Happy Testing! 🧪**

Pytania? Zobacz [FAQ](../docs/BANK_STATEMENT_PROCESSOR_SETUP.md#faq)
