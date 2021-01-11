select user_name,
		sum(pay_amount) as total_amount
from user_trade
where dt between '2020-11-01' and '2020-11-30'
group by user_name,
order by total_amount limit 10;