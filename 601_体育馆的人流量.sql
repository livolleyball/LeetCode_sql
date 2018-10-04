X 市建了一个新的体育馆，每日人流量信息被记录在这三列信息中：序号 (id)、日期 (date)、 人流量 (people)。

请编写一个查询语句，找出高峰期时段，要求连续三天及以上，并且每天人流量均不少于100。

Create table If Not Exists stadium (id int, date DATE NULL, people int)
Truncate table stadium
insert into stadium (id, date, people) values ('1', '2017-01-01', '10')
insert into stadium (id, date, people) values ('2', '2017-01-02', '109')
insert into stadium (id, date, people) values ('3', '2017-01-03', '150')
insert into stadium (id, date, people) values ('4', '2017-01-04', '99')
insert into stadium (id, date, people) values ('5', '2017-01-05', '145')
insert into stadium (id, date, people) values ('6', '2017-01-06', '1455')
insert into stadium (id, date, people) values ('7', '2017-01-07', '199')
insert into stadium (id, date, people) values ('8', '2017-01-08', '188')



解题思路：
1.标记每天人流量均不少于100，并且连续排序；
2.发现连续三天及3天以上；

SELECT id,`date`,people
 FROM (SELECT id, `date`, people,consecutive,
	CASE WHEN consecutive >= 3 THEN @pending := 3
         ELSE @pending := @pending - 1
	END AS tmp,
    IF(@pending > 0, 1, 0) AS include
 FROM (SELECT id, `date`, people,
      CASE WHEN people >= 100 THEN @count := @count + 1
		   ELSE @count := 0
	  END AS consecutive
      FROM stadium, (SELECT @count := 0) t1
) A, (SELECT @pending := 0) t2
ORDER BY A.id DESC  -- 必须倒排
) AA WHERE include = 1
ORDER BY AA.id ASC