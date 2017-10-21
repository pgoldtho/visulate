update pr_properties
set parcel_id = replace(parcel_id, '-', '')
where source_id =59;

delete from pr_property_owners
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));

delete from pr_property_owners
where mailing_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));                               
                               
delete from pr_taxes
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));
                               
delete from pr_property_photos
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));
                               
delete from pr_property_links
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));
                               
delete from pr_property_usage
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));                              

delete from pr_locations                              
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));


delete from pr_property_sales
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));
                               
delete from mls_photos
where mls_id in
(select mls_id
from mls_listings
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id)));
                               
delete from mls_listings
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));                              

 alter table RNT_PROPERTIES disable constraint RNT_PROPERTIES_R1;

                               
delete from pr_properties
where prop_id in (select prop_id
                  from pr_properties p1
                  where source_id = 59
                  and rowid > (select min(rowid)
                               from pr_properties p2
                               where p2.source_id = 59
                               and p2.parcel_id = p1.parcel_id));

