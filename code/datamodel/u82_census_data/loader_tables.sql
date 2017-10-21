create table asc_pums_housing 
( RT            varchar2(1)
, SERIALNO      varchar2(13)
, DIVISION      varchar2(1)
, PUMA          varchar2(5)
, REGION        varchar2(1)
, ST            varchar2(2)
, ADJHSG        number
, ADJINC        number
, WGTP          varchar2(5)
, NP            number
, HTYPE         number
, ACR           number
, AGS           number
, BDS           number
, BLD           number
, BUS           number
, CONP          number
, ELEP          number
, FS            number
, FULP          number
, GASP          number
, HFL           number
, INSP          number
, KIT           number
, MHP           number
, MRGI          number
, MRGP          number
, MRGT          number
, MRGX          number
, PLM           number
, RMS           number
, RNTM          number
, RNTP          number
, SMP           number
, TEL           number
, TEN           number
, VACS          number
, VAL           number
, VEH           number
, WATP          number
, YBL           number
, FES           number
, FINCP         number
, FPARC         number
, GRNTP         number
, GRPIP         number
, HHL           number
, HHT           number
, HINCP         number
, HUGCL         number
, HUPAC         number
, HUPAOC        number
, HUPARC        number
, LNGI          number
, MV            number
, NOC           number
, NPF           number
, NPP           number
, NR            number
, NRC           number
, OCPIP         number
, PARTNER       number
, PSF           number
, R18           number
, R60           number
, R65           number
, RESMODE       number
, SMOCP         number
, SMX           number
, SRNT          number
, SVAL          number
, TAXP          number
, WIF           number
, WKEXREL       number
, WORKSTAT      number
, FACRP         number
, FAGSP         number
, FBDSP         number
, FBLDP         number
, FBUSP         number
, FCONP         number
, FELEP         number
, FFSP          number
, FFULP         number
, FGASP         number
, FHFLP         number
, FINSP         number
, FKITP         number
, FMHP          number
, FMRGIP        number
, FMRGP         number
, FMRGTP        number
, FMRGXP        number
, FMVP          number
, FPLMP         number
, FRMSP         number
, FRNTMP        number
, FRNTP         number
, FSMP          number
, FSMXHP        number
, FSMXSP        number
, FTAXP         number
, FTELP         number
, FTENP         number
, FVACSP        number
, FVALP         number
, FVEHP         number
, FWATP         number
, FYBLP         number
, WGTP1         number
, WGTP2         number
, WGTP3         number
, WGTP4         number
, WGTP5         number
, WGTP6         number
, WGTP7         number
, WGTP8         number
, WGTP9         number
, WGTP10        number
, WGTP11        number
, WGTP12        number
, WGTP13        number
, WGTP14        number
, WGTP15        number
, WGTP16        number
, WGTP17        number
, WGTP18        number
, WGTP19        number
, WGTP20        number
, WGTP21        number
, WGTP22        number
, WGTP23        number
, WGTP24        number
, WGTP25        number
, WGTP26        number
, WGTP27        number
, WGTP28        number
, WGTP29        number
, WGTP30        number
, WGTP31        number
, WGTP32        number
, WGTP33        number
, WGTP34        number
, WGTP35        number
, WGTP36        number
, WGTP37        number
, WGTP38        number
, WGTP39        number
, WGTP40        number
, WGTP41        number
, WGTP42        number
, WGTP43        number
, WGTP44        number
, WGTP45        number
, WGTP46        number
, WGTP47        number
, WGTP48        number
, WGTP49        number
, WGTP50        number
, WGTP51        number
, WGTP52        number
, WGTP53        number
, WGTP54        number
, WGTP55        number
, WGTP56        number
, WGTP57        number
, WGTP58        number
, WGTP59        number
, WGTP60        number
, WGTP61        number
, WGTP62        number
, WGTP63        number
, WGTP64        number
, WGTP65        number
, WGTP66        number
, WGTP67        number
, WGTP68        number
, WGTP69        number
, WGTP70        number
, WGTP71        number
, WGTP72        number
, WGTP73        number
, WGTP74        number
, WGTP75        number
, WGTP76        number
, WGTP77        number
, WGTP78        number
, WGTP79        number
, WGTP80        number)
tablespace MGT_DATA1;

create table asc_zipuma
( zipcode      number
, state_code   number
, puma2k       number
, state        varchar2(2)
, zipname      varchar2(64)
, puma2k_name  varchar2(32)
, longitude    number
, latitude     number
, total_hu     number
, afact        number)
tablespace MGT_DATA1;

create index asc_zipuma_n1 on asc_zipuma(zipcode) tablespace mgt_data1;

create table asc_bkpuma
( county        number
, tract         number
, bg            number
, state_code    number
, puma2k        number
, state         varchar2(2)
, cntyname      varchar2(64)
, PUMA2kName    number
, pop10         number
, afact         number)
tablespace mgt_data1;
create index asc_bkpuma_n1 on asc_bkpuma(county) tablespace mgt_data1;

create table asc_millage_rates
( id           number
, county       varchar2(64)
, millage      number)
tablespace mgt_data1;

create table asc_tax_values
( prop_id      number
, tax_value    number)
tablespace mgt_data1;