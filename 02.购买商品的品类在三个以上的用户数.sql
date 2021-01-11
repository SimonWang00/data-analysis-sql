select user_name, count(a.user_name)
from
	(select user_name, 
     		count(distinct goods_category) as category_num
     from user_trade
     where year(dt) = '2020'
     group by user_name
     having count(distinct goods_category) > 3
    ) a