SELECT	hour(firstactivetime),
		a.user_name
FROM
		(SELECT user_name
		FROM user_trade_2019
	UNION ON
    	SELECT user_name
		FROM user_trade_2020) a
	LEFT JOIN user_info b
	ON a.user_name = b.user_name
GROUP BY hour(firstactivetime);