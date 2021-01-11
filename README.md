# data-analysis-sql
基于hive sql的数据分析工作



## **1.建模用到的模型表：**

点击查看：[数据仓库模型](./00.数据分析中的表结构.md)



## **2.日常工作中常用的hive语句归纳：**

### 1.统计指定用户2020年的平均支付金额，以及2020年最大的支付日期与最小的支付日期的时间间隔

```sql
select avg(pay_amount) as avg_amount,
	datediff(max(from_unixtime(paytime, 'yyyy-MM-dd')), min(from_unixtime(paytime, 'yyyy-MM-dd')))
from user_trade
where year(dt) = '2020'
	and user_name = 'SimonWang00';
```

> Notes：不允许嵌套组合聚合函数，如avg(count(*))

### 2.统计2020年购买商品的品类在三个以上的用户数

```sql
select user_name, count(a.user_name)
from
	(select user_name, 
     		count(distinct goods_category) as category_num
     from user_trade
     where year(dt) = '2020'
     group by user_name
     having count(distinct goods_category) > 3
    ) a
```

思路：

1. 先查询出每个人购买的品类数；
2. 用having筛选出品类数大于2的用户；
3. 统计符合条件的用户数。

> select 的嵌套中，子表要给个别名，方便访问子表中的字段

### 3.统计2020年11月，支付金额最多的TOP10用户

```sql
select user_name,
		sum(pay_amount) as total_amount
from user_trade
where dt between '2020-11-01' and '2020-11-30'
group by user_name,
order by total_amount limit 10;
```

### 4.统计以下四个年龄段20岁以下，20-30岁，30-40岁和40岁以上的用户数

```sql
select case when age < 20 then "20岁以下"
			 when age >=20 and age < 30 then "20-30岁"
		 	 when age >=30 and age < 40 then "30-40岁"
		else "40岁以上" end,
		count(distinct user_name)
from user_info
group by case when age < 20 then "20岁以下"
			 when age >=20 and age<30 then "20-30岁"		
			 when age >=30 and age<40 then "30-40岁"
		else "40岁以上" end;
```

> group by后面接select的字段名

### 5.用户激活时间在2020年，年龄段在20-30岁和30-40岁的婚姻状况分布

```sql
select a.age_type,
	   if (a.marriage_status = 1, "已婚","未婚"),
	   count(distinct a.user_id)
from 
	(
        select case when age < 20 then "20岁以下"
        			 when age >= 20 and age < 30 then "20-30岁"
        			 when age >= 30 and age < 40 then "30-40岁"
        		else "40岁以上" end as age_type,
            get_json_object(extra1, "$.marriage_status") as marriage_status,
            user_id
        from user_info
        where to_date(firstactivetime) between "2020-01-01" and "2020-12-31"
    ) a
where a.age_type in ["20-30岁", "30-40岁"]
group by a.age_type,
		if (a.marriage_status=1,  "已婚","未婚");
```

思路：

1. 先选出激活时间在2020年的用户，并把他们的年龄段计算好，还要提取出婚姻状况；
2. 取出年龄段在20-30岁用户和年龄段在30-40岁用户，把他们的婚姻状况转义成可理解的说明；
3. 聚合计算，针对年龄段和婚姻状况的聚合。

### 6.统计2020年1月到6月，每个品类有多少人购买，累计金额是多少

```sql
select goods_category,
		count(distinct user_name) as user_num,
		sum(pay_amount) as total_amount,
from user_trade
where dt between "2020-01-01" and "2020-06-30"
group by goods_category;
```

### 7.统计每个性别用户等级的分布情况

```sql
select sex,
		if (level >5 "高", "低"),
		count(distinct user_name)
from user_info
group by sex,
		if (level >5 "高", "低");
```

> 性别男女，级别高低，计数

### 8.统计每月新激活的用户数

```sql
select substr(firstactivetime, 1,7) as month,
		count(distinct user_name)
from user_info
group by sub(firstactivetime, 1,7);
```

> substr截取的年月份，如2020-11-01 12:00，截取结果是2011-11。

### 9.统计不同手机品牌的用户数

```sql
select get_json_object(extra1,"$.phone_brand") as phone_brand,
		count(distinct user_id) as user_num
from user_info
group by get_json_object(extra1,"$.phone_brand");
```

> get_json_object内置函数将字符串转化为json

### 10.统计2020年购买又退款的用户

```sql
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
```

### 11.统计2020年购买用户的学历分布

```sql
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
```

> a表要大且存在重复，b表小且唯一，所以选用left join

### 12.统计2018和2019年购买，但是2020年没有购买的用户

```sql
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
```

> a表和b表内联，然后和c表左联，连接后user_name为空的代表未在2020年购买的用户

### 13.查询2018-2020年所有购买用户

```sql
-- 写法1 --
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
    
-- 写法2 --
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
```

> union all和union的区别，union all只会将结果合并返回，union会去重且排序

### 14.对2020年每个用户的支付金额和退款金额进行汇总

```sql
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
```

> 汇总需要有user_name, pay_amount和refound_amount三个字段，合并前可以赋值0作为占位符。

### 15.统计2019年首次注册激活，但是没有支付的用户年龄分布

```sql
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
```

思路如下：

1. 先找出2019年首次激活的用户，对用户年龄段进行处理；
2. 用户表连接user_trade表；
3. 按照年龄分组查询。

> age字段处理后，要用别名，因为外部在使用该字段了

### 16.统计2019年和2020年交易用户，其激活时间分布

```sql
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
```

思路如下：

1. 查找去重2020年交易用户表；
2. 将1中的表与用户信息表连接；
3. 按照时间分组（按照小时计）。

### 17.统计2020年每月的支付总额和当年的累计支付总额

```sql
SELECT a.month,
		a.pay_amount_1,
		SUM(a.pay_amount_1) OVER(order by a.month)
FROM
	(SELECT month(dt) month,
     sum(pay_amount) pay_amount_1
     FROM user_trade
     WHERE year(dt) = 2020
     GROUP BY month(dt)
	)a
```

> sum() over(条件)，窗口函数。

### 18.统计2019，2020年每月的支付总额和当年的累计总额

```sql
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
```

> 按年分区，统计每个分区的累计值。
>
> 窗口函数用法总结：
>
> sum(A)[avg(A)]  over(partition by B order by C rows between D1 and D2)
>
> A-代表需要加工的字段名称，B-分组字段名，C-排序字段名，D-计算的行数范围

### 19.统计出2020年支付金额排名在第10、20、30名的用户

```sql
SELECT a.user_name,
		a.pay_amount,
		a.rank
FROM
	(SELECT user_name,
    		sum(pay_amount) pay_amount,
     		rank() over(order by pay_amount desc) rank
    FROM user_trade
    WHERE year(dt)=2020
    GROUP BY user_name) a
WHERE a.rank in (10,20,30)
```

