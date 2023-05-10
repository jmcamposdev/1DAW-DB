DROP DATABASE IF EXISTS Empresa;
CREATE DATABASE IF NOT EXISTS Empresa
  CHARACTER SET utf8 COLLATE utf8_spanish2_ci;
USE Empresa;
-- Tablas

CREATE TABLE Empleados (
  numemp INT,
  nombre VARCHAR(30) NULL,
  edad INT NULL,
  oficina INT NULL,
  puesto VARCHAR(30) NULL,
  contrato DATE NULL,
  CONSTRAINT PRIMARY KEY (numemp)
)ENGINE = INNODB;


CREATE TABLE Oficinas (
  oficina INT NOT NULL,
  ciudad VARCHAR(30) NULL,
  superficie INT NULL,
  ventas DECIMAL(8,2) DEFAULT 0 NOT NULL,
  CONSTRAINT PRIMARY KEY (oficina)
)ENGINE = INNODB;

ALTER TABLE Empleados ADD CONSTRAINT fkOficina FOREIGN KEY (oficina) REFERENCES Oficinas(oficina);


-- Insertamos datos
INSERT INTO Oficinas(oficina, ciudad, superficie, ventas)
VALUES (11,'Sevilla',100, 10000),
  (12,'Cádiz', 100, 8500),
  (13,'La Coruña', 350, 1300),
  (21,'Badajoz', 200, 5060),
  (22,'La Coruña', 180, 1234.56),
  (23,'Murcia', 350, 1000.50),
  (24,'Oviedo', 500, 7500),
  (31,'Zamora', 200, 15000.15),
  (32,'Almeria', 200, 0);
  
INSERT INTO Empleados(numemp, nombre, edad, oficina, puesto, contrato)
VALUES 
  (101, 'Antonio Alondra', 	45, 	12,	'Representante',		'2016-10-20'),
  (102, 'Beatriz Búho', 	33, 	12, 'Director ventas',		'2017-05-19'),
  (103, 'Claudia Cisne', 	29, 	12, 'Representante',		'2017-03-01'),
  (104, 'Daniel Dingo', 	21, 	21, 'Administrativo',		'2015-12-10'),
  (105, 'Ernesto Elefante', 37, 	13, 'Gerente',				'2018-02-12'),
  (106, 'Francisco Foca', 	52, 	11, 'Recepcionista',		'2018-06-14'),
  (107, 'Guillermo Gato', 	19, 	22, 'Becario',				'2011-11-14'),
  (108, 'Helena Halcón', 	62, 	21, 'Directora general',	'2019-10-12'),
  (109, 'Isabel Ibis', 		31, 	11, 'Representante',		'2019-10-12'),
  (110, 'Julia Jirafa', 	41, 	NULL,'Auxiliar de servicios','2020-01-13'),
  (111, 'Kenia Koala', 		23, 	31, 'Recepcionista', 		'2020-01-03'),
  (112, 'Lorena Loro',		27, 	31, 'Director', 			'2020-01-04'),
  (113, 'María Marmota',	52, 	31, 'Comercial', 			'2021-01-05'),
  (114, 'Nadia Narval',		29, 	32, 'Administrativo', 		'2021-01-07'),
  (115, 'Ñaki Ñu',			18, 	24, 'Comercial',  			'2021-02-03'),
  (116, 'Oscar Oso',		30, 	24, 'Auxiliar de servicios', '2019-03-03'),
  (117, 'Pedro Pelícano',	44, 	11, 'Comercial', 			'2019-04-03'),
  (118, 'Qi Quebrantahuesos',33,	11, 'Administrativo', 		'2018-05-03'),
  (119, 'Raquel Ratón',		43, 	12, 'Representante', 		'2017-06-03'),
  (120, 'Sonia Salmón',		60, 	22, 'Administrativo', 		'2017-07-03');


-- Asignamos permisos al usuario Pepe con contraseña 12345.

GRANT ALL PRIVILEGES ON Empresa.*
TO Pepe@localhost IDENTIFIED BY '12345';


