select Course_Number, Course_Name, count(*) ccount
from ldr_license_edu
group by Course_Number, Course_Name having count(*) > 150
order by ccount;