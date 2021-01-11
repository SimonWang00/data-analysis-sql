select case when age < 20 then "20岁以下"
			 when age >=20 and age < 30 then "20-30岁"
		 	 when age >=30 and age < 40 then "30-40岁"
		else "40岁以上" end,
		count(distinct user_name)
from user_info
group by case when age < 20 then "20岁以下"
			 when age >=20 and age<30 then "20-30岁"		
			 when age >=30 and age<40 then "30-40岁"
		else "40岁以上" end;