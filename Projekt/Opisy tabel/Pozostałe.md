## Opisy tabel

### Pozostałe

#### Rooms
Przechowuje informacje na temat dostępnych pomieszczeń.

- **RoomID** `int` - klucz główny, identyfikator pomieszczenia
- **Capacity** `int` - liczba osób, która zmieści się w sali
  - warunek: `Capacity >= 0`

```sql
CREATE TABLE Rooms (
   RoomID int NOT NULL,
   Capacity int NOT NULL CHECK (Capacity >= 0),
   CONSTRAINT Rooms_pk PRIMARY KEY (RoomID)
);
```