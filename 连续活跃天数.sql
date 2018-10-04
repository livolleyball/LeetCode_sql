求用户的连续活跃天数，以及活跃时间段的起止日期

SELECT *
FROM (SELECT *
   FROM (
       SELECT
        userId,
        MAX(days)   lianxu_days,
        MIN(login_day) start_date,
        MAX(login_day) end_date
       FROM (SELECT
           userId,
           @cont_day :=
           (CASE
           WHEN (@last_userId = userId AND DATEDIFF(created_ts, @last_dt) = 1)
            THEN
             (@cont_day + 1)
           WHEN (@last_userId = userId AND DATEDIFF(created_ts, @last_dt) < 1)
            THEN
             (@cont_day + 0)
           ELSE
            1
           END)                       AS days,
           (@cont_ix := (@cont_ix + IF(@cont_day = 1, 1, 0))) AS cont_ix,
           @last_userId := userId,
           @last_dt := created_ts                login_day
          FROM (SELECT
              userId,
              DATE(createTime) created_ts
             FROM `userAccountLog`
             WHERE userId != 0
             ORDER BY userId, created_ts) AS t,
           (SELECT
            @last_userId := '',
            @last_dt := '',
            @cont_ix := 0,
            @cont_day := 0) AS t1
         ) AS t2
       GROUP BY userId, cont_ix

      ) tmp
   ORDER BY lianxu_days DESC) ntmp
GROUP BY userId;