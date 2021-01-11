SELECT a.user_name,
		sum(pay_amount),
		sum(refound_amount)
FROM
      (  SELECT user_name,
                sum(pay_amount) pay_amount,
                0 AS refound_amount
        FROM user_trade
        WHERE year(dt) = 2020
	UNION ALL
		SELECT user_name,
                sum(refound_amount) refound_amount,
                0 AS pay_amount
        FROM user_refound
        WHERE year(dt) = 2020
       ) a
GROUP BY a.user_name