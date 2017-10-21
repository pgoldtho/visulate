update pr_usage_codes set parent_ucode = 1 where ucode in (90001, 90004, 90005, 90009);
update pr_usage_codes set parent_ucode = 11 where ucode in (90003, 90008);
update pr_usage_codes set parent_ucode = 12 where ucode in (90017, 90018, 90019, 90024);
update pr_usage_codes set parent_ucode = 13 where parent_ucode = 93000;
update pr_usage_codes set parent_ucode = 14 where parent_ucode = 15;
update pr_usage_codes set parent_ucode = 14 where ucode in (90011, 90012,
    90013, 90014, 90015, 90016, 90021, 90022, 90023, 90025, 90026, 90027, 90029, 90030);

update pr_usage_codes set parent_ucode = 16 where ucode in (90051, 90052, 90053, 90054,
    90055, 90056, 90057, 90058, 90059, 90060, 90061, 90062, 90063, 90064, 90065, 90066,
    90067, 90068, 90069, 94000, 90050);

update pr_usage_codes set parent_ucode = 17 where ucode in (90007, 90039);
update pr_usage_codes set parent_ucode = 18 where ucode in (90006, 90074);
update pr_usage_codes set parent_ucode = 19 where ucode in (90073, 90078);
update pr_usage_codes set parent_ucode = 23 where ucode in (90035, 90036, 90037, 90038, 90031, 90032, 90034, 90033);
update pr_usage_codes set parent_ucode = 24 where ucode in (90020, 90071, 90072, 90075, 90076, 90077, 90079);

update pr_usage_codes set parent_ucode = 3 where ucode in (90028);
update pr_usage_codes set parent_ucode = 4 where ucode in (90002);



REM Supermarket
delete from pr_property_usage pu1
where ucode=1400
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90014);
update pr_property_usage set ucode=90014 where ucode=1400;

REM College
delete from pr_property_usage pu1
where ucode=8400
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90084);
update pr_property_usage set ucode=90084 where ucode=8400; 

REM Hospital
delete from pr_property_usage pu1
where ucode=8500
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90085);
update pr_property_usage set ucode=90085 where ucode=8500;


REM Church
delete from pr_property_usage pu1
where ucode=7100
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90071);
update pr_property_usage set ucode=90071 where ucode=7100;

REM Cooperative
delete from pr_property_usage pu1
where ucode=514
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90005);
update pr_property_usage set ucode=90005 where ucode=514;

REM Department Store
delete from pr_property_usage pu1
where ucode=1300
and exists (select 1 from pr_property_usage pu2
            where pu2.prop_id = pu1.prop_id
            and pu2.ucode = 90013);
update pr_property_usage set ucode=90013 where ucode=1300;



