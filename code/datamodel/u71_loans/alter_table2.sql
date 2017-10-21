alter table rnt_loans
  add (interest_only_yn   varchar2(1) default 'N' not null);