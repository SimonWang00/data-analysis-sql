select goods_category,
		count(distinct user_name) as user_num,
		sum(pay_amount) as total_amount,
from user_trade
where dt between "2020-01-01" and "2020-06-30"
group by goods_category;