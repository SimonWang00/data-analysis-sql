SELECT	a.year,
		a.month,
		a.pay_amount,
		SUM(a.pay_amount) OVER(partition by a.year order by a.month)
FROM
	(SELECT year(dt) year,
     		month(dt) month,
     		SUM(pay_amount) pay_amount
     FROM user_trade
     WHERE year(dt) in (2019, 2020)
     GROUP BY year(dt),
     			month(dt)
    )a