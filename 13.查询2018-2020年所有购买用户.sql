-- Ð´·¨1 --
select count(distinct a.user_name),
		count(a.user_name)
from
	(
        	select user_name from user_trade_2018
        union all 
            select user_name from user_trade_2019
        union all
            select user_name from user_trade_2020
    ) a
    
-- Ð´·¨2 --
select count(distinct a.user_name),
		count(a.user_name)
from
	(
        	select user_name 
        	from user_trade_2018
        union 
            select user_name 
            from user_trade_2019
        union
            select user_name 
            from user_trade_2020
    ) a