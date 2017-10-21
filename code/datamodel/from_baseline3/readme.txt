For test views must be used next script:
begin
  -- set current user
  RNT_USERS_PKG.SET_USER(1);
  -- set current role 
  --RNT_USERS_PKG.SET_ROLE('OWNER');
  --RNT_USERS_PKG.SET_ROLE('MANAGER');
  RNT_USERS_PKG.SET_ROLE('ADMIN');
end;  

When user created he have password 12345.