select a.age_type,
	   if (a.marriage_status = 1, "�ѻ�","δ��"),
	   count(distinct a.user_id)
from 
	(
        select case when age < 20 then "20������"
        			 when age >= 20 and age < 30 then "20-30��"
        			 when age >= 30 and age < 40 then "30-40��"
        		else "40������" end as age_type,
            get_json_object(extra1, "$.marriage_status") as marriage_status,
            user_id
        from user_info
        where to_date(firstactivetime) between "2020-01-01" and "2020-12-31"
    ) a
where a.age_type in ["20-30��", "30-40��"]
group by a.age_type,
		if (a.marriage_status=1,  "�ѻ�","δ��");