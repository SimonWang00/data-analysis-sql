SELECT  a.age_level,
		a.user_name
FROM
        (SELECT user_name,
                case when age < 20 then "20岁以下"
                     when age >=20 and age age <20 then "20-30岁"
                	 when age >=30 and age age <40 then "30-40岁"
                else "40岁以上" end as age_level
        FROM user_info
        WHERE year(dt) = 2019) a
	LEFT JOIN
		(SELECT user_name,
        FROM user_trade
        WHERE year(dt) = 2019) b
    ON b.user_name = a.user_name
WHERE b.user_name is null
GROUP BY a.age_level;