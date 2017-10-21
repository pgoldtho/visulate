insert into rnt_suppliers_all
( supplier_id, name, phone1, supplier_type_id)
values
(0, 'No Vendor', '888-888-8888', 1);

update rnt_properties set status='PURCHASED' where status is null;

commit;