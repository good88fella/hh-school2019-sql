CREATE TABLE resume_change
(
    resume_change_id serial PRIMARY KEY,
    resume_body_id   integer,
    last_change_time timestamp,
    old_resume_jsonb jsonb
);

CREATE OR REPLACE FUNCTION save_resume_change()
    RETURNS TRIGGER AS
$trigger_resume_change$
BEGIN
    INSERT INTO resume_change(resume_body_id, last_change_time, old_resume_jsonb)
    VALUES (OLD.resume_body_id,
            now(),
            to_jsonb(OLD.*));
    IF NEW IS NULL
    THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;

$trigger_resume_change$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_resume_change
    BEFORE UPDATE OR DELETE
    ON resume_body
    FOR EACH ROW
EXECUTE PROCEDURE save_resume_change();

--******************** test
UPDATE resume_body
SET name = 'test_name'
WHERE resume_body_id = 1;

UPDATE resume_body
SET name = 'test_name1'
WHERE resume_body_id = 1;

UPDATE resume_body
SET name = 'test_name2'
WHERE resume_body_id = 2;

DELETE
FROM resume
WHERE resume_body_id = 3;
DELETE
FROM resume_body
WHERE resume_body_id = 3;
--********************

SELECT resume_body_id,
       last_change_time,
       old_resume_jsonb ->> 'name' AS old_title,
       CASE
           WHEN lead(old_resume_jsonb ->> 'name') OVER (PARTITION BY resume_body_id) IS NULL
               THEN (SELECT name
                     FROM resume_body
                     WHERE resume_body.resume_body_id = resume_change.resume_body_id)
           ELSE lead(old_resume_jsonb ->> 'name') OVER (PARTITION BY resume_body_id)
           END                     AS new_title
FROM resume_change
WHERE resume_body_id = 1;
