select sex,
		if (level >5 "��", "��"),
		count(distinct user_name)
from user_info
group by sex,
		if (level >5 "��", "��");