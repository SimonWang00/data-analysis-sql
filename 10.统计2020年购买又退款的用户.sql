select a.user_name
from 
    (select distinct user_name 
    from user_trade
    where year(dt) = '2020') a
join
    (select distinct user_name 
    from user_refound
    where year(dt) = '2020') b
on a.user_name = b.user_name