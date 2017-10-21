insert into rnt_user_roles
( role_id
, role_code
, role_name)
values
( rnt_user_roles_seq.nextval
, 'ADVERTISE'
, 'Advertise');

update rnt_user_roles 
set role_name = 'Owner Manager'
where role_code = 'MANAGER_OWNER';