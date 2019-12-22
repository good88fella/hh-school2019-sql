INSERT INTO specialization(name)
SELECT (SELECT string_agg(substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                 (random() * 61)::integer, 1), '')
        FROM generate_series(1, 1 + (random() * 210 + i % 10)::integer) AS name)
FROM generate_series(1, 100) AS g(i);


INSERT INTO vacancy_body (area_id, address_id, specialization_id,
                          name, compensation_from, compensation_to,
                          test_solution_required, work_schedule_type, employment_type,
                          compensation_gross)
SELECT (random() * 1000 + 1)::integer     AS area_id,
       (random() * 50000 + 1)::integer    AS address_id,
       ARRAY [(random() * 100 + 1)::integer, (random() * 100 + 1)::integer, (random() * 100 + 1)::integer]
                                          AS specialization_id,
       (SELECT string_agg(substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                 (random() * 61)::integer, 1), '')
        FROM generate_series(1, 1 + (random() * 210 + i % 10)::integer) AS name),
       (25000 + random() * 25000)::bigint AS compensation_from,
       (50000 + random() * 50000)::bigint AS compensation_to,
       (random() > 0.5)                   AS test_solution_required,
       floor(random() * 5)                AS work_schedule_type,
       floor(random() * 5)                AS employment_type,
       (random() > 0.5)                   AS compensation_gross
FROM generate_series(1, 10000) AS g(i);


INSERT INTO vacancy (vacancy_body_id, creation_time, expire_time, employer_id, visible)
SELECT (SELECT vacancy_body_id FROM vacancy_body WHERE vacancy_body_id = i)              AS vacancy_body_id,
       '2018-01-01'::timestamp - (random() * 365 * 24 * 3600 * 2) * '1 second'::interval AS creation_time,
       '2020-01-01'::timestamp + (random() * 365 * 24 * 3600) * '1 second'::interval     AS expire_time,
       (random() * 1000000)::integer                                                     AS employer_id,
       (random() > 0.5)                                                                  AS visible
FROM generate_series(1, 10000) AS g(i);


INSERT INTO resume_body (specialization_id, name, work_schedule_type,
                         compensation_from, compensation_to)
SELECT ARRAY [(random() * 100 + 1)::integer, (random() * 100 + 1)::integer, (random() * 100 + 1)::integer]
                                          AS specialization_id,
       (SELECT string_agg(substr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                 (random() * 61)::integer, 1), '')
        FROM generate_series(1, 1 + (random() * 210 + i % 10)::integer) AS name),
       floor(random() * 5)                AS work_schedule_type,
       (25000 + random() * 25000)::bigint AS compensation_from,
       (50000 + random() * 50000)::bigint AS compensation_to
FROM generate_series(1, 100000) AS g(i);


INSERT INTO resume (resume_body_id, user_id, creation_time, active)
SELECT (SELECT resume_body_id FROM resume_body WHERE resume_body_id = i)             AS resume_body_id,
       (random() * 1000000 + 1)::integer                                             AS user_id,
       '2018-01-01'::timestamp + (random() * 365 * 24 * 3600) * '1 second'::interval AS creation_time,
       (random() > 0.5)                                                              AS active
FROM generate_series(1, 100000) AS g(i);


INSERT INTO response (vacancy_id, resume_id, disabled, response_time)
SELECT floor(random() * 10000 + 1)                                                   AS vacancy_id,
       floor(random() * 10000 + 1)                                                   AS resume_id,
       (random() > 0.5)                                                              AS disabled,
       '2019-01-01'::timestamp + (random() * 365 * 24 * 3600) * '1 second'::interval AS response_time
FROM generate_series(1, 50000);
