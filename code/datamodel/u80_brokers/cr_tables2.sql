create table pr_licensed_agents as
select  License_Number
,       Licensee_Name
,       DBA_Name
,       nRank license_type
,       Address1
,       Address2
,       Address3
,       City
,       State
,       to_number(regexp_substr(zip, '[0-9]{5}')) zipcode
,       Primary_Status
,       Secondary_Status
,       to_date(regexp_substr(License_Date, '[0-9]+/[0-9]+/[0-9]+'), 'mm/dd/yyyy') license_date
,       Sole_Proprietor
,       Employer_License_Number
from ldr_license;

create table pr_courses as
select distinct lower(regexp_replace(course_name, '\W', '')) as Course_Number
,      Course_Name from ldr_license_edu;

create table pr_agent_courses as
select distinct regexp_substr(lic, '[0-9]+')        License_Number
,      lower(regexp_replace(course_name, '\W', '')) Course_Number
,      to_date(Course_End_Date, 'DD-MON-YY')        Course_Date
,      course_credit_hours
from ldr_license_edu;
