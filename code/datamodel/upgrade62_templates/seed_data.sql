declare
 v_lookup_type_id     number;

begin

 select lookup_type_id
 into v_lookup_type_id
 from rnt_lookup_types
 where lookup_type_code = 'ACTION_TYPES';

 insert into rnt_lookup_values
 ( lookup_value_id
 , lookup_code
 , lookup_value
 , lookup_type_id)
 values
 ( 30
 , 'TA'
 , 'Agreement or Lease'
 , v_lookup_type_id);


 insert into rnt_lookup_values
 ( lookup_value_id
 , lookup_code
 , lookup_value
 , lookup_type_id)
 values
 ( 31
 , 'LA'
 , 'Lease Addendum'
 , v_lookup_type_id);

 commit;
end;
/