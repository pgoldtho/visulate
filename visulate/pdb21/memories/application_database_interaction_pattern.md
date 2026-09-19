# Application-to-Database Interaction Pattern in Visulate

## Architectural Paradigm
The Visulate architecture enforces strict encapsulation between the web application layer (PHP) and the database storage layer (Oracle). Rather than using an object-relational mapping (ORM) framework or issuing direct raw SQL DML statements, the system relies on a **Database-Centric Service Layer**.

```
[ PHP Application Layer ] (code/php/classes/database/*.class.php)
          │
          ├──────────────────────────┐
          │ (SELECT queries)         │ (DML / Mutations via stored procedures)
          ▼                          ▼
[ Abstraction Views (*_V) ]   [ PL/SQL Package Layer (*_PKG) ]
  - Checksum calculation        - Optimistic concurrency verification
  - Display denormalization     - Multi-table transaction integrity
  - Role-based filtering        - Business rules & posting engines
          │                          │
          └───────────┬──────────────┘
                      ▼
            [ Core Storage Tables ]
            (RNT_*, PR_*, MLS_*, SUNBIZ_*)
```

## Key Components of the Pattern

### 1. Presentation Abstraction Views (`*_V`)
- **Read Decoupling**: All application reads target views rather than base tables.
- **Optimistic Concurrency Control**: Every view computes a row checksum using `RNT_SYS_CHECKSUM_REC_PKG`.
- **Pre-Joined Lookups**: Lookups (e.g., status codes, business unit names, account types) are denormalized in the view so PHP data classes can bind directly to UI components.

### 2. PL/SQL Package API Layer (`*_PKG`)
- **DML Encapsulation**: Inserts, updates, and deletes are managed through PL/SQL procedures (e.g. `RNT_PROPERTIES_PKG`, `RNT_LEDGER_PKG`, `RNT_ACCOUNTS_PAYABLE_PKG`).
- **Checksum Verification**: On update/delete, the package recomputes the checksum on the persisted row and compares it against the checksum submitted by the web client. If mismatched, the mutation is rejected.
- **Transactional Invariants**: Automated accounting postings (`RNT_PT_RULES`) and spatial validation (`SDO_GEOMETRY`) are executed atomically within the package boundary.

### 3. PHP Data Access Classes (`code/php/classes/database/`)
- PHP classes mirror functional domains:
  - `rnt_ledger.class.php` / `rnt_journal.class.php`: Interacts with `RNT_LEDGER_ENTRIES_V` and calls `RNT_LEDGER_PKG`.
  - `rnt_acc_payable.class.php` / `rnt_acc_receivable.class.php`: Manages invoicing and payment allocations.
  - `rnt_properties.class.php`: Interfaces with property, unit, and lease structures.
- Queries are executed using parameterized Oracle OCI8 bind variables against `*_V` views.

### 4. Database-Driven Application Configuration & Navigation
- Access control and UI hierarchy are stored directly in the database:
  - `RNT_MENUS`, `RNT_MENU_TABS`, `RNT_MENU_PAGES`, and `RNT_MENU_ROLES`.
  - `Menu3.class.php` inspects the active user role and business unit assignment (`RNT_USER_ASSIGNMENTS`) to dynamically construct UI navigation.
