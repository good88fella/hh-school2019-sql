SELECT vacancy_body.name AS vacancy_name
FROM (
         SELECT vacancy.vacancy_id,
                vacancy.vacancy_body_id
         FROM vacancy,
              response
         WHERE vacancy.vacancy_id = response.vacancy_id
           AND response.response_time - vacancy.creation_time <= interval '7 day 00:00:00'
         GROUP BY vacancy.vacancy_id
         HAVING count(*) < 5
         UNION ALL
         SELECT vacancy.vacancy_id,
                vacancy.vacancy_body_id
         FROM vacancy
                  LEFT JOIN response
                            USING (vacancy_id)
         WHERE response.vacancy_id IS NULL
     ) AS tmpTable,
     vacancy_body
WHERE tmpTable.vacancy_body_id = vacancy_body.vacancy_body_id
ORDER BY vacancy_body.name;
