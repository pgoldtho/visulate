delete from pr_licensed_agents
where rowid not in
 (select min(rowid)
  from   pr_licensed_agents
  group by License_Number);

commit;  

alter table pr_licensed_agents add constraint pr_licensed_agents_pk primary key (License_Number);

update pr_licensed_agents l1
set Employer_License_Number = ''
where Employer_License_Number is not null
 and not exists (select 1 from pr_licensed_agents l2 where l2.License_Number = l1.Employer_License_Number);

commit;

alter table pr_licensed_agents add constraint pr_licensed_agents_fk1
  foreign key (Employer_License_Number) references pr_licensed_agents(License_Number);

delete from pr_courses where course_number is null;
delete from pr_courses
where rowid not in
 (select min(rowid)
  from   pr_courses
  group by course_Number);

commit;
alter table pr_courses add constraint pr_courses_pk primary key (course_number);

delete from pr_agent_courses
where rowid not in
 (select min(rowid)
  from pr_agent_courses
  group by License_Number, Course_Number, Course_Date);

delete from   pr_agent_courses where Course_Number is null;

commit;
alter table pr_agent_courses add constraint pr_agent_courses_pk
primary key (License_Number, Course_Number, Course_Date);


delete from pr_agent_courses ac
where not exists (select 1 from pr_licensed_agents la where la.License_Number = ac.License_Number);

alter table pr_agent_courses add constraint pr_agent_courses_fk1
foreign key (License_Number) references  pr_licensed_agents(License_Number);

alter table pr_agent_courses add constraint pr_agent_courses_fk2
foreign key (course_Number) references  pr_courses(course_Number);

create index pr_agent_courses_n1 on pr_agent_courses(course_Number);
create index pr_licensed_agents_n1 on pr_licensed_agents(Employer_License_Number);

create index pr_licensed_agents_n2 on pr_licensed_agents(zipcode);
create index rnt_zipcodes_n1 on rnt_zipcodes(PLACE_NAME, STATE_NAME);
