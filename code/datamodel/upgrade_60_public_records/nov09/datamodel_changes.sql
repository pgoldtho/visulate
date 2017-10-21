alter table pr_properties modify acreage number;

declare
  cursor cur_acres is
  select prop_id
  ,      "Acreage" acreage
  from brd_acres;
  v_counter pls_integer := 0;
begin
  for a_rec in cur_acres loop
    v_counter := v_counter + 1;
    update pr_properties
    set acreage = a_rec.acreage
    where prop_id = a_rec.prop_id;
    if v_counter > 500 then
      commit;
      v_counter := 0;
    end if;
  end loop;
  commit;
end;
/



create sequence  PR_SOURCES_SEQ start with 4;
create sequence  PR_PROPERTIES_SEQ start with 472040;
create sequence  PR_OWNERS_SEQ start with 865011;
create sequence  PR_BUILDINGS_SEQ start with 423624;

alter table pr_property_sales drop constraint pr_property_sales_pk;
drop index pr_property_sales_pk;


alter table pr_property_sales add constraint pr_property_sales_pk
unique(prop_id, new_owner_id, sale_date);

@pr_records_pkg

	