DROP DATABASE IF EXISTS workers;
CREATE DATABASE workers;
\c workers;

CREATE TABLE workers(
    id serial,
    name varchar(50),
    fee money,
    job varchar(30),
    supervisor_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (supervisor_id)
        REFERENCES workers(id)
);

CREATE TABLE buildings(
    id serial,
    address varchar(60),
    type varchar(30),
    level numeric,
    category numeric,
    PRIMARY KEY (id)
);

CREATE TABLE assignments(
    worker_id integer,
    building_id integer,
    start_date date,
    days numeric,
    PRIMARY KEY (worker_id,building_id,start_date),
    FOREIGN KEY (worker_id)
        REFERENCES workers(id),
    FOREIGN KEY (building_id)
        REFERENCES buildings(id)
);

INSERT INTO workers (id, name, fee, job, supervisor_id) VALUES (1235, 'M. Faraday', 12.5, 'electrician',1311),
                                                               (1311, 'C. Coulomb', 15.5,'electrician',1311),
                                                               (1412, 'C. Nemo', 13.75,'plumber',1520),
                                                               (1520, 'H. Rickover', 11.75,'plumber',1520),
                                                               (2920, 'R. Garret', 10.0,'builder',2920),
                                                               (3001, 'J. Barrister', 8.2,'carpenter',3231),
                                                               (3231, 'P. Mason', 17.4,'carpenter',3231);

INSERT INTO buildings(id, address, type, level, category) VALUES (111, '1213 Aspen', 'office', 4, 1),
                                                                 (210, '1011 Birch', 'office', 3, 1),
                                                                 (312, '123 Elm', 'office', 2, 2),
                                                                 (435, '456 Maple', 'shop', 1, 1),
                                                                 (460, '1415 Beach', 'warehouse', 3, 3),
                                                                 (515, '789 Oak', 'residential', 3, 2);

INSERT INTO  assignments(worker_id, building_id, start_date, days) VALUES (1235, 312, '2001-10-10', 5),
                                                                          (1235, 515, '2001-10-17', 22),
                                                                          (1311, 435, '2001-10-08', 12),
                                                                          (1311, 460, '2001-10-23', 24),
                                                                          (1412, 111, '2001-12-01', 4),
                                                                          (1412, 210, '2001-11-15', 12),
                                                                          (1412, 312, '2001-10-01', 10),
                                                                          (1412, 435, '2001-10-15', 15),
                                                                          (1412, 460, '2001-10-08', 18),
                                                                          (1412, 515, '2001-11-05', 8),
                                                                          (1520, 312, '2001-10-30', 17),
                                                                          (1520, 515, '2001-10-09', 14),
                                                                          (2920, 210, '2001-11-10', 15),
                                                                          (2920, 435, '2001-10-28', 10),
                                                                          (2920, 460, '2001-10-05', 18),
                                                                          (3001, 111, '2001-10-08', 14),
                                                                          (3001, 210, '2001-10-27', 14),
                                                                          (3231, 111, '2001-10-10', 8),
                                                                          (3231, 312, '2001-10-24', 20);