DROP DATABASE IF EXISTS Instituto;
CREATE DATABASE Instituto;
USE Instituto; -- In MySQL
\c Institulo -- In Postgres

CREATE TABLE Alumnos (
num INT PRIMARY KEY,
nombre VARCHAR(30),
fnac DATE,
media DECIMAL(4, 2),
curso VARCHAR(2));

INSERT INTO Alumnos VALUES 
(1, 'Antonio Arroz', '2010-01-01', 5.1, '1A'),
(2, 'Bea Boniato', '2009-02-02', 6.75, '1B'),
(3, 'Cristina Cristal', '2009-03-03', 7.23, '1B'),
(4, 'David Dado', '2009-04-04', 8.5, '1B'),
(5, 'Ernesto Escarola', '2008-05-05', 9.0, '2A'),
(6, 'Francisco Frio', '2008-06-06', 9.5, '2A'),
(7, 'Gema Gato', '2008-07-07', 9.99, '2A'),
(8, 'Helena Huerto', '2007-08-08', 10, '2A'),
(9, 'Irene Idea', '2007-09-09', 5.45, '2B'),
(10, 'Julia Jarra', '2007-10-10', 6.66, '2B'),
(11, 'Kika Kenya', '2006-11-11', 7.77, '2B'),
(12, 'Luna Lima', '2006-12-12', 8.88, '2B');