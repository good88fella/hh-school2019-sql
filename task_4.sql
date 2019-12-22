SELECT (SELECT EXTRACT(MONTH FROM creation_time) as month
        FROM vacancy
        GROUP BY month
        ORDER BY count(*) DESC
        LIMIT 1
       ) as most_vacancys_month_nbr,
       (SELECT EXTRACT(MONTH FROM creation_time) as month
        FROM resume
        GROUP BY month
        ORDER BY count(*) DESC
        LIMIT 1
       ) as most_resumes_month_nbr;
