DROP DATABASE IF EXISTS flight_control_system;
CREATE DATABASE flight_control_system;
\c flight_control_system;

CREATE TABLE airport (
    code serial,
    name varchar(50),
    country varchar(30),
    city varchar(30),
    PRIMARY KEY (code)
);

CREATE TABLE plane (
    model varchar(30),
    capacity numeric(5),
    PRIMARY KEY (model)
);

/*For the program table, the days field stores the days on which it operates,
  so I have decided to create a varchar with a maximum of 7
  in which we will store the initials of the days of the week
  */

CREATE TABLE program (
    code serial,
    airline varchar(50),
    days varchar(7),
    PRIMARY KEY (code)
);

CREATE TABLE flight (
    number serial,
    fly_date date,
    empty_seats numeric(3),
    program_code integer,
    plane_model varchar(30),
    PRIMARY KEY (number),
    FOREIGN KEY (program_code)
        REFERENCES program(code),
    FOREIGN KEY (plane_model)
        REFERENCES plane(model)
);

CREATE TABLE scale (
    number serial,
    arrive_code integer,
    departure_code integer,
    flight_number integer,
    PRIMARY KEY (number),
    FOREIGN KEY (arrive_code)
        REFERENCES airPort(code),
    FOREIGN KEY (departure_code)
        REFERENCES airPort(code),
    FOREIGN KEY (flight_number)
        REFERENCES flight(number)
);

CREATE TABLE landing (
    airport_code integer,
    plane_model varchar(30),
    PRIMARY KEY (airport_code,plane_model),
    FOREIGN KEY (airport_code)
        REFERENCES airPort(code),
    FOREIGN KEY (plane_model)
        REFERENCES plane(model)
);

CREATE TABLE airport_has_program (
    airport_code integer,
    program_code integer,
    PRIMARY KEY (airport_code,program_code),
    FOREIGN KEY (airport_code)
        REFERENCES airPort(code),
    FOREIGN KEY (program_code)
        REFERENCES program(code)
);

-- WE ENTER THE AIRPORT DATA
INSERT INTO airport (name, country, city) VALUES
    ('Aeropuerto de Málaga','España','Málaga'),
    ('Aeropuerto de Madrid','España','Madrid'),
    ('Aeropuerto de Barcelona','España','Barcelona'),
    ('Aeropuerto de Sevilla','España','Sevilla'),
    ('Aeropuerto de Ibiza','España','Ibiza');

-- IWE ENTER THE AIRPLANE MODELS
INSERT INTO plane (model, capacity) VALUES
    ('Airbus A380',850),
    ('737-800',189),
    ('737-900ER',180),
    ('737-700',149),
    ('737-600',132);

-- WE ENTER THE FLIGHT SCHEDULES
INSERT INTO program (airline, days) VALUES
    ('Air Europa','LXJ'),
    ('Air Europa Express','LVS'),
    ('Air Horizont','MJV'),
    ('Iberia','LMXJV'),
    ('Vueling','SD');

-- WE ENTER THE FLIGHTS
INSERT INTO flight (fly_date, empty_seats, program_code, plane_model) VALUES
    ('2023/5/25',190,2,'Airbus A380'),
    ('2023/2/2',41,1,'737-800'),
    ('2023/1/23',12,1,'737-800'),
    ('2023/1/9',30,5,'737-600'),
    ('2022/12/23',0,2,'737-800');

-- WE INSERT THE SCALES
INSERT INTO scale (arrive_code,departure_code,flight_number) VALUES
    (1,2,1),
    (1,4,3),
    (3,1,5),
    (4,2,3),
    (5,4,4);

-- WE ENTER THE PLANES THAT CAN LAND AT THE AIRPORTS
INSERT INTO landing (airport_code,plane_model) VALUES
    (1,'Airbus A380'),
    (1,'737-800'),
    (2,'737-800'),
    (3,'Airbus A380'),
    (4,'737-900ER'),
    (5,'737-900ER'),
    (1,'737-900ER');
-- WE ENTER THE AIRPORT WITH YOUR PROGRAM
INSERT INTO airport_has_program (airport_code,program_code) VALUES
    (1,1),
    (1,3),
    (2,5),
    (3,4),
    (4,1),
    (5,2);

