select avg(pay_amount) as avg_amount,
	datediff(max(from_unixtime(paytime, 'yyyy-MM-dd')), min(from_unixtime(paytime, 'yyyy-MM-dd')))
from user_trade
where year(dt) = '2020'
	and user_name = 'SimonWang00';