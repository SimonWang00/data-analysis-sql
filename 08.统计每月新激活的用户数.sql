select substr(firstactivetime, 1,7) as month,
		count(distinct user_name)
from user_info
group by sub(firstactivetime, 1,7);