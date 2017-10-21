-- Create table
create table RNT_LEAD_ACTIONS
(
  ACTION_ID   NUMBER not null,
  LEAD_ID     NUMBER,
  ACTION_DATE DATE,
  ACTION_TYPE VARCHAR2(16),
  BROKER_ID   NUMBER,
  DESCRIPTION VARCHAR2(4000)
);

-- Add comments to the columns 
comment on column RNT_LEAD_ACTIONS.ACTION_ID
  is 'System generated key';
comment on column RNT_LEAD_ACTIONS.LEAD_ID
  is 'Foreign key to RNT_LEADS';
comment on column RNT_LEAD_ACTIONS.ACTION_DATE
  is 'Date of the action';
comment on column RNT_LEAD_ACTIONS.ACTION_TYPE
  is 'Valid values: Phone Call, Email, Letter, Referral, Offer, Counter Offer, Sale Agreed, Inspection, Withdrawn, Closing.';
comment on column RNT_LEAD_ACTIONS.BROKER_ID
  is 'Foreign key to PR_LICENCED_AGENTS';
comment on column RNT_LEAD_ACTIONS.DESCRIPTION
  is 'Action details.';

-- Create/Recreate primary, unique and foreign key constraints 
alter table RNT_LEAD_ACTIONS
  add constraint RNT_LEAD_ACTIONS_PK primary key (ACTION_ID)
  using index 
  tablespace RNT_DATA2
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
