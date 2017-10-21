-- Create table
create table RNT_LEADS
(
  LEAD_ID            NUMBER not null,
  PEOPLE_BUSINESS_ID NUMBER,
  LEAD_DATE          DATE,
  LEAD_STATUS        VARCHAR2(16),
  LEAD_TYPE          VARCHAR2(16),
  REF_PROP_ID        NUMBER,
  FOLLOW_UP          NUMBER,
  UCODE              NUMBER,
  CITY               VARCHAR2(64),
  MIN_PRICE          NUMBER,
  MAX_PRICE          NUMBER,
  LTV_TARGET         NUMBER,
  LTV_QUALIFIED_YN   VARCHAR2(1),
  DESCRIPTION        VARCHAR2(4000)
);

-- Add comments to the columns 
comment on column RNT_LEADS.LEAD_ID
  is 'System generated key';
comment on column RNT_LEADS.PEOPLE_BUSINESS_ID
  is 'Foreign key to RNT_PEOPLE_BU';
comment on column RNT_LEADS.LEAD_DATE
  is 'Date the lead was first reported';
comment on column RNT_LEADS.LEAD_STATUS
  is 'Active or Inactive';
comment on column RNT_LEADS.LEAD_TYPE
  is 'Buy, Sell, Lease or Landlord';
comment on column RNT_LEADS.REF_PROP_ID
  is 'Reference property.  Foreign key to PR_PROPERTIES';
comment on column RNT_LEADS.FOLLOW_UP
  is 'Integer value holding number of days to next follow-up';
comment on column RNT_LEADS.UCODE
  is 'Property type that the customer is looking for or offering.  Foreign key to PR_USAGE_CODES';
comment on column RNT_LEADS.CITY
  is 'Where to they want to buy or sell?';
comment on column RNT_LEADS.MIN_PRICE
  is 'Minimum price';
comment on column RNT_LEADS.MAX_PRICE
  is 'Maximum price';
comment on column RNT_LEADS.LTV_TARGET
  is 'Percentage value for target loan to value';
comment on column RNT_LEADS.LTV_QUALIFIED_YN
  is 'Is the lead (pre) qualified for the loan they need?';
comment on column RNT_LEADS.DESCRIPTION
  is 'Text description of the property';

-- Create/Recreate primary, unique and foreign key constraints 
alter table RNT_LEADS
  add constraint RNT_LEADS_PK primary key (LEAD_ID)
  using index tablespace RNT_DATA2
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );