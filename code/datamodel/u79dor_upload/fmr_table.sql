create table pr_fmr
 ( FIPS               varchar2(16)
 , Rent0              number
 , Rent1              number
 , Rent2              number
 , Rent3              number
 , Rent4              number
 , county             number
 , State              number
 , CouSub             varchar2(16)
 , pop2000            number
 , countyname         varchar2(128)
 , CBSASub            varchar2(128)
 , Areaname           varchar2(128)
 , county_town_name   varchar2(128)
 , state_alpha        varchar2(4))
 tablespace pr_loader;