-- 41 Indian River Property Appraiser
-- Convert source_pk = 31370000009118000012.0 to alt_key=313700000091180000120


--Palm beach (60)
--convert 18424425180010262 to 18-42-44-25-18-001-0262 for use in tax query
--http://pbctax.manatron.com/tabs/propertyTax/accountdetail.aspx?p=18-42-44-25-18-001-0262

merge into pr_properties p
using 
(select substr(source_pk, 1, 2)||'-'
      ||substr(source_pk, 3, 2)||'-'
      ||substr(source_pk, 5, 2)||'-'
      ||substr(source_pk, 7, 2)||'-'
      ||substr(source_pk, 9, 2)||'-'
      ||substr(source_pk, 11, 3)||'-'
      ||substr(source_pk, 14, 4) alt_key
 ,    source_pk
 ,    prop_id
 from pr_properties pp
 where source_id = 60) s
on (p.prop_id = s.prop_id)
when matched then update
set alt_key = s.alt_key;


     
--Pasco County (61)
--Source_pk=1725310150000001580
--Tax=http://search.pascotaxes.com/Search/prclmain.aspx?parcel=3125170150000001580
--17 25 31 0150000001580
--31 25 17 0150000001580

merge into pr_properties p
using
(select substr(source_pk, 5, 2)
      ||substr(source_pk, 3, 2)
      ||substr(source_pk, 1, 2)
      ||substr(source_pk, 7, 13) alt_key
 ,    source_pk
 ,    prop_id
 from pr_properties pp
 where source_id = 61) s
on (p.prop_id = s.prop_id)
when matched then update
set alt_key = s.alt_key;


-- Brevard
-- Swap source_pk/alt_key for rows that were seeded from DOR file

merge into pr_properties p
using
(select source_pk
 ,      alt_key
 ,      prop_id
 from pr_properties
 where source_id=3
 and length(alt_key) < length(source_pk)) s
on (p.prop_id = s.prop_id)
when matched then update
set source_pk = s.alt_key
,   alt_key   = s.source_pk;


--Liberty (49) replace ' ' with '-'
--http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_liberty&KEY=030-5S-7W-02181 026
--http://qpublic6.qpublic.net/fl_display_dw.php?county=fl_liberty&KEY=030-5S-7W-02181-026

merge into pr_properties p
using
(select source_pk
 ,      replace(source_pk, ' ', '-') alt_key
 ,      prop_id
 from pr_properties
 where source_id=49) s
on (p.prop_id = s.prop_id)
when matched then update
set alt_key = s.alt_key;


--Highlands County (38)
--C 07 37 30 040 0100 0010
--source = C07373004001000010
--C07373004001000010 - C 07 37 30 040 0100 0010 ->  30 37 07 04001000010 C
-- 30370704001000010C
--http://www.appraiser.co.highlands.fl.us/perl/re2html.pl?strap=30370704001000010C

merge into pr_properties p
using
(select substr(source_pk, 6, 2)
      ||substr(source_pk, 4, 2)
      ||substr(source_pk, 2, 2)
      ||substr(source_pk, 8, 11)
      ||substr(source_pk, 1, 1) alt_key
 ,    source_pk
 ,    prop_id
 from pr_properties pp
 where source_id = 38) s
on (p.prop_id = s.prop_id)
when matched then update
set alt_key = s.alt_key;

--Volusia: source_id=4
--swap alt_key and source pk if length(source_pk) > length(alt_key)
--SQL> select source_pk, alt_key from pr_properties where prop_id=2095733;
--SOURCE_PK                        ALT_KEY
-------------------------------- --------------------------
--33153901200050                   3510020
--SQL> select source_pk, alt_key from pr_properties where prop_id=654483;
--SOURCE_PK                        ALT_KEY
-------------------------------- --------------------------
--3508491

merge into pr_properties p
using
(select source_pk
 ,      alt_key
 ,      prop_id
 from pr_properties
 where source_id=4
 and length(alt_key) < length(source_pk)) s
on (p.prop_id = s.prop_id)
when matched then update
set source_pk = s.alt_key
,   alt_key   = s.source_pk;
