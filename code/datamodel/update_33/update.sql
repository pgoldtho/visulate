UPDATE RNT_USERS
SET IS_SUBSCRIBED_YN = NVL(IS_SUBSCRIBED_YN, 'N')
/

commit
/

alter table rnt_users modify (IS_SUBSCRIBED_YN varchar2(1) not null)
/