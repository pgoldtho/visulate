update pr_millage_rates r
set rent_rate = (select rent_rate from pr_millage_rates r2 where r2.id = r.id and r2.year=2012)
where year=2013;
