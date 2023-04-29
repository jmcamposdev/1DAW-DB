DROP DATABASE IF EXISTS videoclup;
CREATE DATABASE videoclup;
\c videoclup;


CREATE TABLE pelicula(
    codigo numeric,
    titulo varchar(50),
    año numeric(4),
    genero varchar(50),
    director varchar(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE cliente(
    numero_socio numeric,
    nombre varchar(50),
    apellidos varchar(50),
    direccion varchar(100),
    telefono numeric(9),
    codigo_postal numeric(5),
    primary key (numero_socio)
);

CREATE TABLE alquila(
    numero_socio numeric,
    codigo_pelicula numeric,
    fecha_inicio date,
    fecha_fin date,
    PRIMARY KEY (numero_socio,codigo_pelicula,fecha_inicio),
    FOREIGN KEY(numero_socio)
    REFERENCES cliente(numero_socio),
    FOREIGN KEY(codigo_pelicula)
    REFERENCES pelicula(codigo)
);

INSERT INTO pelicula VALUES
(1, 'Primera Pelicula',1999, 'Accción', 'Juan Antonio'),
(2, 'Segunda Pelicula',2004,'Fantasia', 'Alvaro Campos'),
(3, 'Tercera Pelicula',2004,'Fantasia','Antonio Gomez'),
(4, 'Cuarta Pelicula',1989, 'Tensión','Alex Jimenez'),
(5, 'Quinta Pelicula',1997, 'Comedia', 'Juan Antonio');

INSERT INTO cliente VALUES
(1,'Jose Maria','Campos','Calle Juan Vazquez',654736918,18007),
(2,'Paco','Gomez','Calle Victoria',542398673,18001),
(3,'Alvaro','Hidalgo','Avenida Gloria',658946710,19876);

INSERT INTO alquila VALUES
(1,1,'2022/11/10','2022/11/14');
