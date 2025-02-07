## Opisy tabel

### Zamówienia

#### Orders
Zawiera podstawowe informacje o zamówieniach studentów.

- **OrderID** `int` - klucz główny, identyfikator zamówienia
- **StudentID** `int` - klucz obcy, identyfikator studenta
- **OrderDate** `datetime` - data złożenia zamówienia
  - warunek: `OrderDate >= '2000-01-01'`

```sql
CREATE TABLE Orders (
   OrderID int NOT NULL,
   StudentID int NOT NULL,
   OrderDate datetime NOT NULL CHECK (OrderDate >= '2000-01-01'),
   CONSTRAINT Orders_pk PRIMARY KEY (OrderID)
);

ALTER TABLE Orders ADD CONSTRAINT Orders_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);
```

#### OrderDetails
Zawiera szczegółowe informacje o zamówieniach.

- **OrderID** `int` - klucz główny, klucz obcy, identyfikator zamówienia
- **ActivityID** `int` - klucz główny, klucz obcy, identyfikator aktywności
- **mustPayInTime** `bit` - informacja o tym, czy student musi opłacić zamówienie w terminie, aby uzyskać dostęp do aktywności
  - wartość domyślna: `1`
- **PaidDate** `datetime` nullable - data opłacenia zamówienia
  - wartość domyślna: `null`
  - warunek: `PaidDate >= '2000-01-01'`
- **AmountPaid** `money` - kwota, która została opłacona
  - wartość domyślna: `0`
  - warunek: `AmountPaid >= 0`

```sql
CREATE TABLE OrderDetails (
   OrderID int NOT NULL,
   ActivityID int NOT NULL,
   mustPayInTime bit NOT NULL DEFAULT 1,
   AmountPaid money NOT NULL DEFAULT 0 CHECK (AmountPaid >= 0),
   PaidDate datetime NULL DEFAULT NULL CHECK (PaidDate >= '2000-01-01'),
   CONSTRAINT OrderDetails_pk PRIMARY KEY (OrderID, ActivityID)
);

ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Activities 
 FOREIGN KEY (ActivityID) 
 REFERENCES Activities (ActivityID);

ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders 
 FOREIGN KEY (OrderID) 
 REFERENCES Orders (OrderID);
```

#### ShoppingCart
Zawiera informacje na temat aktywności dodanych do koszyków studentów.

- **StudentID** `int` - klucz główny, klucz obcy, identyfikator studenta
- **ActivityID** `int` - klucz obcy, identyfikator aktywności

```sql
CREATE TABLE ShoppingCart (
   StudentID int NOT NULL,
   ActivityID int NOT NULL,
   CONSTRAINT ShoppingCart_pk PRIMARY KEY (StudentID, ActivityID)
);

ALTER TABLE ShoppingCart ADD CONSTRAINT ShoppingCart_Activities 
 FOREIGN KEY (ActivityID) 
 REFERENCES Activities (ActivityID);

ALTER TABLE ShoppingCart ADD CONSTRAINT ShoppingCart_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);
```

#### Activities
Zawiera podstawowe informacje o aktywnościach.

- **ActivityID** `int` - klucz główny, identyfikator aktywności
- **FullPrice** `money` `nullable` - cena zakupu danej aktywności
    - warunek: `FullPrice >= 0`
- **isAvailable** `bit` - informacja o tym, czy dany produkt jest dostępny
    - wartość domyślna: `1`

```sql
CREATE TABLE Activities (
   ActivityID int  NOT NULL,
   FullPrice money  NULL CHECK (FullPrice >= 0),
   isAvailable bit  NOT NULL DEFAULT 1,
   CONSTRAINT Activities_pk PRIMARY KEY  (ActivityID)
);
```