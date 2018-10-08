drop table if EXISTS tmp.user_activate;
create table tmp.user_activate(
userid int,
activate_day int
);



insert into tmp.user_activate values(1,20170101);
insert into tmp.user_activate values(1,20170102);
insert into tmp.user_activate values(1,20170103);
insert into tmp.user_activate values(1,20170104);
insert into tmp.user_activate values(2,20170101);
insert into tmp.user_activate values(2,20170102);
insert into tmp.user_activate values(2,20170103);


insert into tmp.user_activate values(1,20170110);
insert into tmp.user_activate values(2,20170110);
insert into tmp.user_activate values(3,20170111);
insert into tmp.user_activate values(3,20170112);
insert into tmp.user_activate values(1,20170112);
insert into tmp.user_activate values(2,20170112);

--  求用户连续活跃的区间
RETURE
userid	max_day	min_day	_c3
1	20170104	20170101	[20170101,20170102,20170103,20170104]
1	20170110	20170110	[20170110]
1	20170112	20170112	[20170112]
2	20170103	20170101	[20170101,20170102,20170103]
2	20170110	20170110	[20170110]
2	20170112	20170112	[20170112]
3	20170112	20170111	[20170111,20170112]

SELECT
userid,
 MAX(activate_day) max_day, MIN(activate_day) min_day, COLLECT_set (activate_day)
FROM
(SELECT
a.userid,
 a.activate_day, activate_day -rn num
 FROM
  (SELECT
  userid,
   activate_day, row_number () over (PARTITION BY userid ORDER BY activate_day) rn
  FROM
  tmp.user_activate
  GROUP
   BY userid, activate_day) A) AA
GROUP
 BY userid, num;


--  求用户活跃记录相差1天只算最近一天的记录
RETURE
userid	max_day
1	20170104
1	20170110
1	20170112
2	20170103
2	20170110
2	20170112
3	20170112


SELECT
userid,
 MAX(activate_day) max_day
FROM
(SELECT
a.userid,
 a.activate_day, activate_day -rn num
 FROM
  (SELECT
  userid,
   activate_day, row_number () over (PARTITION BY userid ORDER BY activate_day) rn
  FROM
  tmp.user_activate
  GROUP
   BY userid, activate_day) A) AA
GROUP
 BY userid, num;
