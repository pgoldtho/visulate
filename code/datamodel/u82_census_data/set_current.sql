update pr_taxes
set current_yn = 'Y'
where prop_id in (select prop_id from pr_taxes t1
                  where not exists (select 1 from pr_taxes t2 where t2.prop_id = t1.prop_id and t2.current_yn='Y'));
