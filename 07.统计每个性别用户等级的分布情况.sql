select sex,
		if (level >5 "ธ฿", "ตอ"),
		count(distinct user_name)
from user_info
group by sex,
		if (level >5 "ธ฿", "ตอ");