select get_json_object(extra1,"$.phone_brand") as phone_brand,
		count(distinct user_id) as user_num
from user_info
group by get_json_object(extra1,"$.phone_brand");