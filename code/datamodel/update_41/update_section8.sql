update rnt_tenant
set SECTION8_ID = 1
where SECTION8_ID = 3;

update RNT_SECTION8_OFFICES_BU
set SECTION8_ID = 1
where SECTION8_ID = 3;

delete from rnt_section8_offices where section8_id = 3;

commit;

CREATE UNIQUE INDEX RNT_SECTION8_OFFICES_U1 ON RNT_SECTION8_OFFICES
(SECTION_NAME)
LOGGING
NOPARALLEL;

