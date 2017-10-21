alter table pr_sources add
( rets_login_url      varchar2(4000)
, rets_username       varchar2(256)
, rets_password       varchar2(256));

update pr_sources 
set rets_login_url = 'http://sef.rets.interealty.com/Login.asmx/Login'
,   rets_username = 'sRuSanW'
,   rets_password = 'fds83b43'
where source_id = 8;

update pr_sources 
set rets_login_url = 'http://retsgw.flexmls.com:80/rets2_1/Login'
,   rets_username = 'spc.rets.3222516'
,   rets_password = 'enapt-ulent90'
where source_id = 6;

update pr_sources 
set rets_login_url = 'http://rets.mfrmls.com/contact/rets/login'
,   rets_username = 'RETS534'
,   rets_password = '7+Er+7aqeD'
where source_id = 7;