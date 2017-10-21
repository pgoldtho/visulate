update pr_property_sales
set price = round(32750000/139)
where price = 32750000
and sale_date = '16-DEC-02';


update pr_property_sales
set price = round(1492100/101)
where price = 1492100
and sale_date = '18-SEP-2002';

update pr_property_sales
set price = round(2825000/63)
where price = 2825000
and sale_date = '30-JUL-2003';

update pr_property_sales
set price = round(9775000/30)
where price = 9775000
and sale_date = '19-APR-2002';

update pr_property_sales
set price = round(352000/40)
where price = 352000
and sale_date = '04-OCT-2004';

update pr_property_sales
set price = round(250000/70)
where price = 250000
and sale_date = '29-MAR-2002'
and prop_id != 243698;

update pr_property_sales
set price = round(147300/70)
where price = 147300
and sale_date = '10-SEP-2003';

update pr_property_sales
set price = round(3857200/150)
where price = 3857200
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(2832200/150)
where price = 2832200
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(2148900/150)
where price = 2148900
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(2084800/150)
where price = 2084800
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(1147400/150)
where price = 1147400
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(976500/150)
where price = 976500
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(864400/150)
where price = 864400
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(603700/150)
where price = 603700
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(422800/150)
where price = 422800
and sale_date = '10-AUG-2005';

update pr_property_sales
set price = round(6260000/13)
where price =      6260000
and sale_date = '13-JAN-2004';

update pr_property_sales
set price = round(18440000/74)
where price =      18440000
and sale_date = '09-DEC-2005';

update pr_property_sales
set price = round(17725000/21)
where price =      17725000
and sale_date = '25-MAY-2006';

update pr_property_sales
set price = round(4000000/13)
where price =      4000000
and sale_date = '09-DEC-2005';

update pr_property_sales
set price = round(675000/9)
where price =    675000
and sale_date = '31-JAN-2005';


update pr_property_sales
set price = round(2900000/34)
where price =   2900000
and sale_date = '08-NOV-2002';

update pr_property_sales
set price = round(3980000/80)
where price = 3980000
and sale_date = '24-FEB-2003';

update pr_property_sales
set price = round(285000/8)
where price = 285000
and sale_date = '29-AUG-2003';

update pr_property_sales
set price = round(2550000/5)
where price = 2550000
and sale_date = '10-JUN-2003'

update pr_property_sales
set price = round(210000/4)
where price =      210000
and sale_date = '31-JUL-2003'
and prop_id != 691971;

update pr_property_sales
set price = round(270000/13)
where price =      270000
and sale_date = '01-AUG-2002';

update pr_property_sales
set price = round(360000/13)
where price =      360000
and sale_date = '01-AUG-2002'
and prop_id != 459844;

update pr_property_sales
set price = round(200000/8)
 where price =      200000
 and sale_date = '22-MAY-2002';

update pr_property_sales
set price = round(160000/4)
 where price =      160000
 and sale_date = '01-APR-2002';
 
update pr_property_sales
set price = round(175000/8)
 where price =      175000
 and sale_date = '30-JUL-2002';

update pr_property_sales
set price = round(135500/6)
where price =      135500
and sale_date = '02-OCT-2002';

update pr_property_sales
set price = round(1800000/7)
where price =      1800000
and sale_date = '24-JUL-2003';
 
update pr_property_sales
set price = round(2036000/7)
where price =      2036000
and sale_date = '17-NOV-2003';

update pr_property_sales
set price = round(500000/2)
where price =      500000
and sale_date = '01-JUN-2005';
 
truncate table pr_values;
@../u66_pr_estimates/seed_values