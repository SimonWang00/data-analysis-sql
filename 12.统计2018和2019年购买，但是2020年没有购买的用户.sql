select a.user_name
from
	select a.user_name
	from
        (select distinct user_name
         from user_trade_2018
        ) a
        join 
            (select distinct user_name
             from user_trade_2019
            ) b on a.user_name = b.user_name
        left join
        	(select user_name
             from user_trade_2020
            ) c
        on a.user_name = c.user_name
 where c.user_name is null