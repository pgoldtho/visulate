create table brvd_geo as
select RENUM, LONGITUDE, LATITUDE
from "Address"@brvd;