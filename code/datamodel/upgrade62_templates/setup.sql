alter table rnt_agreement_actions 
add comments_clob clob;

update rnt_agreement_actions
set comments_clob = comments;

alter table rnt_agreement_actions 
rename column comments to comments_varchar;


alter table rnt_agreement_actions 
rename column comments_clob to comments;


create table rnt_doc_templates
( template_id         number       not null
, name                varchar2(32) not null
, business_id         number
, content             clob
, constraint rnt_doc_templates_pk primary key (template_id)
, constraint rnt_doc_templates_r1 foreign key (business_id)
  references rnt_business_units(business_id));

create unique index rnt_doc_templates_u1 
    on rnt_doc_templates (name, business_id);

create sequence rnt_doc_templates_seq;