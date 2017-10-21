set define ^

delete from RNT_BU_SUPPLIERS bus
where BU_SUPPLIER_ID in (
select BU_SUPPLIER_ID
from RNT_BU_SUPPLIERS
, rnt_business_units b
, rnt_suppliers_all s
where b.business_id = bus.business_id
and bus.supplier_id = s.supplier_id
and not exists (select 1
                from rnt_accounts_payable ap
                where ap.supplier_id = s.supplier_id
                and ap.business_id = b.business_id));


update rnt_suppliers_all set supplier_type_id = 9 where name = 'A tiptopped lawn inc';
update rnt_suppliers_all set supplier_type_id = 10 where name = 'AAA Sweetwater Well Drilling';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Ace Hardware';
update rnt_suppliers_all set supplier_type_id = 5 where name = 'Advent Electric LLC';
update rnt_suppliers_all set supplier_type_id = 11 where name = 'Allen Ins';
update rnt_suppliers_all set supplier_type_id = 6 where name = 'American leak detection';
update rnt_suppliers_all set supplier_type_id = 17 where name = 'Apex';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Applaince Liquidators';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Appliance direct';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Applianceville';
update rnt_suppliers_all set supplier_type_id = 2 where name = 'Bank of America';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Blossman';
update rnt_suppliers_all set supplier_type_id = 2 where name = 'Bradford Boltz';
update rnt_suppliers_all set supplier_type_id = 5 where name = 'Brevard Electric';
update rnt_suppliers_all set supplier_type_id = 15 where name = 'Brevard Property appraiser';
update rnt_suppliers_all set supplier_type_id = 4 where name = 'Charles Fulton';
update rnt_suppliers_all set supplier_type_id = 11 where name = 'Citizens Ins';
update rnt_suppliers_all set supplier_type_id = 15 where name = 'Cocoa';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Cocoa water';
update rnt_suppliers_all set supplier_type_id = 2 where name = 'Countrywide';
update rnt_suppliers_all set supplier_type_id = 13 where name = 'Di''s terrazzo inc';
update rnt_suppliers_all set supplier_type_id = 13 where name = 'Excalibar Carpets and Flooring';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'FPL';
update rnt_suppliers_all set supplier_type_id = 13 where name = 'Floor Factory Outlet';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'French Broard Electric Membership Corp';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Garage door company';
update rnt_suppliers_all set supplier_type_id = 9 where name = 'Gary Ledford';
update rnt_suppliers_all set supplier_type_id = 18 where name = 'Google adwords';
update rnt_suppliers_all set supplier_type_id = 7 where name = 'Hobans Home Improvement';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Home Depot';
update rnt_suppliers_all set supplier_type_id = 18 where name = 'Hot Springs Tourism Association';
update rnt_suppliers_all set supplier_type_id = 20 where name = 'Jant Gentry';
update rnt_suppliers_all set supplier_type_id = 14 where name = 'Lewis Barnhart';
update rnt_suppliers_all set supplier_type_id = 5 where name = 'Linwood Cherry';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Lowe''s';
update rnt_suppliers_all set supplier_type_id = 9 where name = 'Mow gators';
update rnt_suppliers_all set supplier_type_id = 15 where name = 'North Carolina Department of Revenue';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Palm bay utilites';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Publix';
update rnt_suppliers_all set supplier_type_id = 13 where name = 'Purcells Dist';
update rnt_suppliers_all set supplier_type_id = 2 where name = 'RBC Centura';
update rnt_suppliers_all set supplier_type_id = 12 where name = 'Russ Freed';
update rnt_suppliers_all set supplier_type_id = 7 where name = 'Scott Mitchell';
update rnt_suppliers_all set supplier_type_id = 2 where name = 'Suntrust Mortgage';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Target';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Titusville water';
update rnt_suppliers_all set supplier_type_id = 19 where name = 'Travel expenses';
update rnt_suppliers_all set supplier_type_id = 6 where name = 'Tru-Flo Plumbing service';
update rnt_suppliers_all set supplier_type_id = 7 where name = 'V & L';
update rnt_suppliers_all set supplier_type_id = 18 where name = 'VRBO.com';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Verizon';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Wal-mart';
update rnt_suppliers_all set supplier_type_id = 7 where name = 'Walter Talarico';
update rnt_suppliers_all set supplier_type_id = 16 where name = 'Waste Management';
update rnt_suppliers_all set supplier_type_id = 8 where name = 'Winn Dixie';
commit;


