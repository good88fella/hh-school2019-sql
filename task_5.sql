SELECT vacancy_body.name AS vacancy_name
FROM (SELECT vacancy.vacancy_id,
             vacancy.vacancy_body_id
      FROM vacancy,
           response
      WHERE vacancy.vacancy_id = response.vacancy_id
        AND response.response_time - vacancy.creation_time <= interval '7 day'
      GROUP BY vacancy.vacancy_id
      HAVING count(*) < 5
      UNION ALL
      SELECT vacancy.vacancy_id,
             vacancy.vacancy_body_id
      FROM vacancy
      WHERE vacancy.vacancy_id NOT IN (SELECT vacancy_id FROM response)) AS tmpTable,
     vacancy_body
WHERE tmpTable.vacancy_body_id = vacancy_body.vacancy_body_id
ORDER BY vacancy_body.name;
