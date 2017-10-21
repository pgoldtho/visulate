

update pr_values
set rent = 10.36
,   cap_rate = 6.5
where prop_class = 'A';

update pr_values
set rent = 7.89
,   cap_rate = 8
where prop_class = 'B';

update pr_values
set rent = 6.47
,   cap_rate = 9.5
where prop_class = 'C';


update pr_values
set vacancy_percent = 8
,   mgt_percent = 10
where prop_class = 'A'
and ucode in (110, 121, 135, 414, 464, 465, 514);

update pr_values
set vacancy_percent = 15
,   mgt_percent = 10
where prop_class = 'B'
and ucode in (110, 121, 135, 414, 464, 465, 514);

update pr_values
set vacancy_percent = 25
,   mgt_percent = 10
where prop_class = 'C'
and ucode in (110, 121, 135, 414, 464, 465, 514);


update pr_values
set vacancy_percent = 15
,   mgt_percent = 10
where prop_class = 'A'
and ucode < 100;

update pr_values
set vacancy_percent = 25
,   mgt_percent = 10
where prop_class = 'B'
and ucode < 100;

update pr_values
set vacancy_percent = 40
,   mgt_percent = 10
where prop_class = 'C'
and ucode < 100;

update pr_values
set maintenance = 0.52
,   replacement = 0.97;

commit;
