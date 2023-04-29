DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
\c company;

CREATE TABLE employees (
    employee_id serial,
    first_name varchar(30),
    last_name varchar(30),
    birthdate date,
    address varchar(80),
    gender  char,
    salary money,
    supervisor_id integer,
    department_id integer,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (supervisor_id)
        REFERENCES employees(employee_id)
);

CREATE TABLE departments (
    department_id serial,
    name varchar(30),
    manager_id integer,
    PRIMARY KEY (department_id),
    FOREIGN KEY (manager_id)
    REFERENCES employees(employee_id)
);

ALTER TABLE employees
    ADD CONSTRAINT fk_employees
        FOREIGN KEY (department_id)
            REFERENCES departments (department_id);

CREATE TABLE projects (
    project_id serial,
    name varchar(30),
    place varchar(50),
    budget money,
    department_id serial,
    PRIMARY KEY (project_id),
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

CREATE TABLE works_in (
    employee_id integer,
    project_id integer,
    total_time interval,
    PRIMARY KEY (employee_id,project_id),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id),
    FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
);


INSERT INTO employees (employee_id ,first_name, last_name, birthdate, address, gender, salary) VALUES
    (1,'Jose Maria','Campos Trujillo','2004-05-01','Avenida Dílar','M',1200),
    (2,'Hugo','Campos','2005-01-24','Calle Carlos Cano','M',3000),
    (3,'Adrian','Gomez','1996-06-12','Calle la Esperanza','M',1200),
    (4,'Sandra','Gonzalez','2002-09-05','Calle Juan Vazquez','F',2000),
    (5,'Andrea','Trujillo','1998-04-23','Calle Paz 2','F',2000);

INSERT INTO employees (employee_id, first_name, last_name, birthdate, address, gender) VALUES
    (6,'Antonio','Abolafio','1992-03-02','Calle Rodrigez','M');

INSERT INTO departments (department_id, name, manager_id) VALUES
    (1,'Marketing',1),
    (2,'Research',2),
    (3,'Data',3);

UPDATE employees SET department_id=1 WHERE employee_id=1;
UPDATE employees SET department_id=2,supervisor_id=1 WHERE employee_id=2;
UPDATE employees SET department_id=3,supervisor_id=2 WHERE employee_id=3;
UPDATE employees SET department_id=2,supervisor_id=1 WHERE employee_id=4;
UPDATE employees SET department_id=2,supervisor_id=5 WHERE employee_id=6;

INSERT INTO projects (project_id, name, place, budget, department_id) VALUES
    (1,'Dog Ecommerce','Sala 1',25000,1),
    (2,'Finance Plan','Sacromonte',15000,3),
    (3,'Repair Computer','Sidney',2000,2),
    (4,'Repair Dock','Montoro',1000,2),
    (5,'Cat Landing Page','Sydney',1000,1),
    (6,'Landing Page','Sala 1',2000,1),
    (7,'WordPress','Sala 4',3000,1),
    (8,'Finance','Sala 1',25000,3),
    (9,'Joomla','Sala 1',10000,1),
    (10,'Repair Computer','Sala 4',200,2);

INSERT INTO works_in (employee_id, project_id, total_time) VALUES
    (1,1,'2:3:2'),
    (2,2,'1:2:40'),
    (3,5,'1:0:0'),
    (4,8,'5:40:10'),
    (4,4,'5:50:10');