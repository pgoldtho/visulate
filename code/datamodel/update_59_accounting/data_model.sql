create table rnt_account_types
( account_type        varchar2(32) not null
, display_title       varchar2(32) not null
, constraint rnt_account_types_pk
  primary key (account_type));

comment on table rnt_account_types is
'Records generic account types e.g. Asset, Liability, Equity and Expense';

comment on column rnt_account_types.account_type
 is 'Unique name for account type classification';
comment on column rnt_account_types.display_title
 is 'Value to display on reports or forms';


create table rnt_default_accounts
( account_number      number       not null
, name                varchar2(64) not null
, account_type        varchar2(32) not null
, current_balance_yn  varchar2(1)  not null
, constraint rnt_default_accounts_pk
  primary key (account_number)
, constraint rnt_default_accounts_fk1
  foreign key (account_type) references rnt_account_types (account_type));

create unique index rnt_default_accounts_u1
  on rnt_default_accounts (name);

create index rnt_default_accounts_n1
on rnt_default_accounts (account_type);


comment on table rnt_default_accounts is
'Records a default chart of accounts.  Used to generate an initial chart of accounts for a business unit.';

comment on column rnt_default_accounts.account_number
is '4 digit identifier';
comment on column rnt_default_accounts.name
is 'Unique account name';
comment on column rnt_default_accounts.account_type
is 'Foreign key to rnt_account_types';
comment on column rnt_default_accounts.current_balance_yn
is 'Are balance values for this account considered current when the books are closed?';



create table rnt_accounts
( account_id          number        not null
, account_number      number        not null
, business_id         number        not null
, name                varchar2(64)  not null
, account_type        varchar2(32)  not null
, current_balance_yn  varchar2(1)   not null
, user_assign_id      number
, people_business_id  number
, constraint rnt_accounts_pk
  primary key (account_id)
, constraint rnt_accounts_fk1
  foreign key (account_type) references rnt_account_types (account_type));

create unique index rnt_accounts_u1 
on rnt_accounts(account_number, business_id);

create index rnt_accounts_n1 on rnt_accounts(business_id);

comment on table rnt_accounts is
'Records the chart of accounts for a business unit.  Each business unit has its own chart of accounts.  An initial chart of accounts can be generated from rnt_default_accounts and then editied to add, remove or rename the defaults.  Each account must be recorded in the context of a business unit.  Optional foreign keys to rnt_user_assignments and rnt_people_bu allow an account to be associated with a Visulate user or tenant.';

comment on column rnt_accounts.account_id 
is 'System generated unique identifier';
comment on column rnt_accounts.account_number 
is 'Unique account number in the context of the account''s business unit';
comment on column rnt_accounts.business_id 
is 'The business unit that this account belongs to. Foreign key to rnt_business_units';
comment on column rnt_accounts.name 
is 'The display name for this account.';
comment on column rnt_accounts.account_type 
is 'Foreign key to rnt_account_types';
comment on column rnt_accounts.current_balance_yn 
is 'Are balance values for this account considered current?';
comment on column rnt_accounts.user_assign_id 
is 'Identifies the Visulate user that owns this account.';
comment on column rnt_accounts.people_business_id 
is 'Identifies a the tenant that owns the account.';


create table rnt_account_periods
( period_id         number          not null
, business_id       number          not null
, start_date        date            not null
, closed_yn         varchar2(1)     not null
, constraint rnt_account_periods_pk primary key (period_id)
, constraint rnt_account_periods_fk1 foreign key (business_id)
  references rnt_business_units(business_id));

create unique index rnt_account_periods_u1
  on rnt_account_periods (business_id, start_date);

Comment on table rnt_account_periods is
'Accounting period for a business unit.  Each period is uniquely identified by a business id and start date.  Periods can be closed or open.  Updates are not allowed for data in closed accounting periods';

comment on column rnt_account_periods.period_id is 'System generated unique identifier';
comment on column rnt_account_periods.business_id is 'Foreign key to rnt_business_units';
comment on column rnt_account_periods.start_date is 'The first day in the accounting period';
comment on column rnt_account_periods.closed_yn is 'Is this accounting period closed?';




create table rnt_account_balances
( account_id        number          not null
, period_id         number          not null
, opening_balance   number          not null
, constraint rnt_account_balances_pk
   primary key (account_id, period_id)
, constraint rnt_account_balances_fk1
   foreign key (account_id) references rnt_accounts (account_id)
, constraint rnt_account_balances_fk2
   foreign key (period_id) references rnt_account_periods (period_id)
);

create index rnt_account_balances_n1 on 
  rnt_account_balances (period_id);

comment on table rnt_account_balances
is 'Records the balance amount for an account after all the transactions in an accounting period have been processed.';


comment on column rnt_account_balances.account_id 
is 'Foreign key to rnt_accounts';
comment on column rnt_account_balances.period_id 
is 'The accounting period that the balance relates to';
comment on column rnt_account_balances.opening_balance 
is 'The value of the account on the statement date.';

create table rnt_ledger_entries
( ledger_id         number          not null
, entry_date        date            not null
, description       varchar2(4000)   not null
, debit_account     number          not null
, credit_account    number          not null
, payment_type_id   number          not null
, ar_id             number
, ap_id             number
, pay_alloc_id      number
, property_id       number
, constraint rnt_ledger_entries_pk primary key (ledger_id)
, constraint rnt_ledger_entries_fk1
  foreign key (debit_account) references rnt_accounts(account_id)
, constraint rnt_ledger_entries_fk2
  foreign key (credit_account) references rnt_accounts(account_id)
, constraint rnt_ledger_entries_fk3
  foreign key (ar_id) references rnt_accounts_receivable(ar_id)
, constraint rnt_ledger_entries_fk4
  foreign key (ap_id) references rnt_accounts_payable(ap_id)
, constraint rnt_ledger_entries_fk5
  foreign key (pay_alloc_id) references rnt_payment_allocations(pay_alloc_id)
, constraint rnt_ledger_entries_fk6
  foreign key (payment_type_id) references rnt_payment_types(payment_type_id)
, constraint rnt_ledger_entries_fk7
  foreign key (property_id) references rnt_properties(property_id)
);

comment on table rnt_ledger_entries is
'General ledger that records transaction details from the AR and AP journals.  Populated automatically using rules defined in rnt_pt_rules.  Users can update entries while working on a trial balance.';

comment on column rnt_ledger_entries.ledger_id 
is 'System generated unique identifier';
comment on column rnt_ledger_entries.entry_date 
is 'Transaction date';
comment on column rnt_ledger_entries.description 
is 'Short description of the transaction';
comment on column rnt_ledger_entries.debit_account 
is 'The account to debit for the transaction';
comment on column rnt_ledger_entries.credit_account 
is 'The account to credit for the transaction';
comment on column rnt_ledger_entries.ar_id 
is 'Foreign key to the accounts receivable entry for this transaction';
comment on column rnt_ledger_entries.ap_id 
is 'Foreign key to the accounts payable entry for this transaction';
comment on column rnt_ledger_entries.pay_alloc_id 
is 'Foreign key to the payment details for this transaction';


create table rnt_pt_rules
( business_id        number       not null
, payment_type_id    number       not null
, transaction_type   varchar2(32) not null
, debit_account      number       not null
, credit_account     number       not null
, constraint rnt_pt_rules_pk
  primary key (business_id, payment_type_id, transaction_type)
, constraint rnt_pt_rules_fk1
  foreign key (business_id) references rnt_business_units(business_id)
, constraint rnt_pt_rules_fk2
  foreign key (payment_type_id) references rnt_payment_types(payment_type_id)
, constraint rnt_pt_rules_fk3
  foreign key (debit_account) references rnt_accounts(account_id)
, constraint rnt_pt_rules_fk4
  foreign key (credit_account) references rnt_accounts(account_id)
, constraint rnt_pt_rules_ck1 check (transaction_type in ('APS','APP', 'ARS', 'ARP', 'DEP'))
);

comment on table rnt_pt_rules is
'Records rules for generating ledger entires from the AR and AP journals.  Each rule has a transaction type of AR|AP Scheduled or Paid.  Scheduled payments map to entries in the AR or AP tables.  Paid map to rows in rnt_payment_allocations';

comment on column rnt_pt_rules.business_id 
is 'Foreign key to rnt_business unit';
comment on column rnt_pt_rules.payment_type_id 
is 'Foreign key to rnt_payment_types';
comment on column rnt_pt_rules.transaction_type 
is ' AR|AP Scheduled or Paid';
comment on column rnt_pt_rules.debit_account 
is 'Account to debit for transactions of this type';
comment on column rnt_pt_rules.credit_account 
is 'Account to credit for transactions of this type.';




create table rnt_default_pt_rules
( payment_type_id     number       not null
, transaction_type    varchar2(32) not null
, debit_account       number       not null
, credit_account      number       not null
, constraint rnt_default_pt_rules_pk
  primary key (payment_type_id, transaction_type)
, constraint rnt_default_pt_rules_fk1
  foreign key (payment_type_id) references rnt_payment_types (payment_type_id)
, constraint rnt_default_pt_rules_fk2
  foreign key (debit_account) references rnt_default_accounts (account_number)
, constraint rnt_default_pt_rules_fk3
  foreign key (credit_account) references rnt_default_accounts (account_number)
, constraint rnt_default_pt_rules_ck1 check 
    (transaction_type in ('APS','APP', 'ARS', 'ARP', 'DEP'))
);

comment on table rnt_default_pt_rules is
'Records default rules for populating rnt_pt_rules';

comment on column rnt_default_pt_rules.payment_type_id 
is 'Foreign key to rnt_payment_types';
comment on column rnt_default_pt_rules.transaction_type
is 'AR|AP Scheduled or Paid';
comment on column rnt_default_pt_rules.debit_account 
is 'FK to rnt_default_accounts ';
comment on column rnt_default_pt_rules.credit_account 
is 'FK to rnt_default_accounts ';


create sequence rnt_accounts_seq;
create sequence rnt_account_periods_seq;
create sequence rnt_default_accounts_seq;
create sequence rnt_ledger_entries_seq;