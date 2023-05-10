DROP DATABASE IF EXISTS Instituto;
CREATE DATABASE Instituto;
-- USE Instituto; -- In MySQL
\c Institulo -- In Postgres

CREATE TABLE Alumnos (
num SERIAL PRIMARY KEY, -- AUTO_INCREMENT in MySQL
nombre VARCHAR(30),
fnac DATE,
media DECIMAL(4, 2),
curso VARCHAR(2));

INSERT INTO Alumnos (nombre, fnac, media, curso )VALUES
('Antonio Arroz', '2010-01-01', 5.1, '1A'),
('Bea Boniato', '2009-02-02', 6.75, '1B'),
('Cristina Cristal', '2009-03-03', 7.23, '1B'),
('David Dado', '2009-04-04', 8.5, '1B'),
('Ernesto Escarola', '2008-05-05', 9.0, '2A'),
('Francisco Frio', '2008-06-06', 9.5, '2A'),
('Gema Gato', '2008-07-07', 9.99, '2A'),
('Helena Huerto', '2007-08-08', 10, '2A'),
('Irene Idea', '2007-09-09', 5.45, '2B'),
('Julia Jarra', '2007-10-10', 6.66, '2B'),
('Kika Kenya', '2006-11-11', 7.77, '2B'),
('Luna Lima', '2006-12-12', 8.88, '2B');