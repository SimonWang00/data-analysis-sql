SELECT a.month,
		a.pay_amount_1,
		SUM(a.pay_amount_1) OVER(order by a.month)
FROM
	(SELECT month(dt) month,
     sum(pay_amount) pay_amount_1
     FROM user_trade
     WHERE year(dt) = 2020
     GROUP BY month(dt)
	)a