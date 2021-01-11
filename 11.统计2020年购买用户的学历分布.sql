select b.educiation,
		count(distinct a.user_name)
from
	(select distinct user_name 
     from user_trade 
     where year(dt) = 2020) a
     left join 
     		(select user_name, get_json_object(extra1, "$.educiation") from user_info) b
     on a.user_name = b.user_name
group by b.educiation