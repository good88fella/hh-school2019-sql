EXPLAIN ANALYZE WITH resume_spec AS (
         SELECT resume.resume_id,
                specialization_id AS resume_spec_ids
         FROM resume
                  JOIN resume_body
                       USING (resume_body_id)
     ),
     vacancy_spec AS (
         SELECT vacancy.vacancy_id,
                specialization_id AS vacancy_spec_ids
         FROM vacancy
                  JOIN vacancy_body
                       USING (vacancy_body_id)
     ),
     most_response_spec AS (
         SELECT resume_id,
                MODE() WITHIN GROUP (ORDER BY vacancy_spec_ids) AS most_resp_spec_ids
         FROM (
                  SELECT response.resume_id,
                         vacancy_spec.vacancy_spec_ids
                  FROM response
                           JOIN vacancy_spec
                                USING (vacancy_id)
              ) AS response_spec
         GROUP BY resume_id
     )
SELECT resume_spec.resume_id,
       resume_spec_ids,
       most_resp_spec_ids
FROM most_response_spec
         JOIN resume_spec
              USING (resume_id)
ORDER BY resume_id;
