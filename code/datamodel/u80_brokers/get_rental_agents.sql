select la.city
       ||', '|| la.Licensee_Name
       ||', '|| la.address1
       ||', '||Course_Name
       ||', '||Course_date
from pr_licensed_agents la
,    pr_courses c
,    pr_agent_courses ac
where la.city in ('FORT LAUDERDALE', 'FT LAUDERDALE', 'FT. LAUDERDALE',
'MIAMI', 'MIAMI BEACH', 'MIAMI GARDENS', 'MIAMI LAKES', 'MIAMI SHORES', 'MIAMI SPRINGS', 'SOUTH MIAMI',
'TAMPA', 'ST. PETERSBURG', 'ST PETERSBURG')
and la.License_Number = ac.License_Number
and ac.course_number = c.course_number
and (c.course_name like '%TENANT%' or
     c.course_name like '%TENNANT%' or
     c.course_name like '%PROPERTY MANAGEMENT%')
order by la.city, la.Licensee_Name, Course_date;