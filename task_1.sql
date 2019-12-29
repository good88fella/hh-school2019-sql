CREATE TABLE specialization
(
    specialization_id serial PRIMARY KEY,
    name              varchar(220) DEFAULT ''::varchar NOT NULL
);


CREATE TABLE vacancy_body
(
    vacancy_body_id        serial PRIMARY KEY,
    area_id                integer,
    address_id             integer,
    specialization_id      integer[],
    company_name           varchar(220) DEFAULT ''::varchar NOT NULL,
    name                   varchar(220) DEFAULT ''::varchar NOT NULL,
    text                   text,
    work_experience        integer      DEFAULT 0           NOT NULL,
    compensation_from      bigint       DEFAULT 0,
    compensation_to        bigint       DEFAULT 0,
    test_solution_required boolean      DEFAULT false       NOT NULL,
    work_schedule_type     integer      DEFAULT 0           NOT NULL,
    employment_type        integer      DEFAULT 0           NOT NULL,
    compensation_gross     boolean,
    driver_license_types   varchar(5)[],
    CONSTRAINT vacancy_body_work_employment_type_validate CHECK ((employment_type = ANY (ARRAY [0, 1, 2, 3, 4]))),
    CONSTRAINT vacancy_body_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY [0, 1, 2, 3, 4])))
);


CREATE TABLE vacancy
(
    vacancy_id      serial PRIMARY KEY,
    vacancy_body_id integer,
    employer_id     integer,
    creation_time   timestamp            NOT NULL,
    expire_time     timestamp            NOT NULL,
    visible         boolean DEFAULT true NOT NULL,
    FOREIGN KEY (vacancy_body_id) REFERENCES vacancy_body (vacancy_body_id)
);


CREATE TABLE resume_body
(
    resume_body_id       serial PRIMARY KEY,
    specialization_id    integer[],
    user_first_name      varchar(150) DEFAULT ''::varchar NOT NULL,
    user_surname         varchar(150) DEFAULT ''::varchar NOT NULL,
    user_city            varchar(220) DEFAULT ''::varchar NOT NULL,
    user_date_of_birth   date         DEFAULT NULL,
    user_sex             boolean      DEFAULT NULL,
    user_citizenship     varchar(220) DEFAULT ''::varchar NOT NULL,
    name                 varchar(220) DEFAULT ''::varchar NOT NULL,
    text                 text,
    work_experience      integer      DEFAULT 0           NOT NULL,
    work_schedule_type   integer      DEFAULT 0           NOT NULL,
    compensation_from    bigint       DEFAULT 0,
    compensation_to      bigint       DEFAULT 0,
    driver_license_types varchar(5)[],
    CONSTRAINT resume_work_schedule_type_validate CHECK ((work_schedule_type = ANY (ARRAY [0, 1, 2, 3, 4])))
);


CREATE TABLE resume
(
    resume_id      serial PRIMARY KEY,
    resume_body_id integer,
    user_id        integer,
    creation_time  timestamp            NOT NULL,
    active         boolean DEFAULT true NOT NULL,
    FOREIGN KEY (resume_body_id) REFERENCES resume_body (resume_body_id)
);


CREATE TABLE response
(
    response_id   serial PRIMARY KEY,
    vacancy_id    integer,
    resume_id     integer,
    disabled      boolean DEFAULT false NOT NULL,
    response_time timestamp             NOT NULL
);
