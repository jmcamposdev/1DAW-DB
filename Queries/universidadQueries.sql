-- Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y
-- además su nif termina en K.
SELECT nombre,apellido1,apellido2,telefono FROM persona WHERE tipo = 'profesor' AND nif LIKE '%K' AND telefono = '';

-- Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna
-- asignatura en el Grado en Ingeniería Informática (Plan 2015).
SELECT DISTINCT departamento.nombre FROM departamento
JOIN profesor ON id = profesor.id_departamento
JOIN asignatura on profesor.id_profesor = asignatura.id_profesor
JOIN grado on asignatura.id_grado = grado.id
where grado.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';

SELECT DISTINCT nombre FROM persona
JOIN matricula ON persona.id = matricula.id_alumno
JOIN curso_escolar ON matricula.id_curso_escolar = curso_escolar.id
WHERE inicio = 2018 AND fin = 2019;

SELECT * from curso_escolar;

-- Devuelve un listado con las asignaturas que no tienen un profesor asignado.
SELECT profesor.id_profesor,nombre FROM asignatura
LEFT JOIN profesor ON asignatura.id_profesor = profesor.id_profesor
WHERE profesor.id_profesor IS NULL;

-- Devuelve un listado con todos los departamentos que tienen alguna asignatura
-- que no se haya impar- tido en ningún curso escolar. El resultado debe mostrar el nombre del departamento
-- y el nombre de la asignatura que no se haya impartido nunca.
SELECT nombre FROM asignatura
LEFT JOIN matricula ON asignatura.id = matricula.id_asignatura
WHERE id_alumno IS NULL;

SELECT DISTINCT departamento.nombre FROM departamento
LEFT JOIN profesor ON departamento.id = profesor.id_departamento
LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
LEFT JOIN matricula ON asignatura.id = matricula.id_asignatura
WHERE id_alumno IS NULL AND asignatura.nombre IS NOT NULL;

SELECT DISTINCT dep.nombre, asig.nombre, asig.id FROM asignatura AS asig
    LEFT JOIN matricula ON asig.id = matricula.id_asignatura
LEFT JOIN profesor AS prof ON asig.id_profesor = prof.id_profesor
    LEFT JOIN departamento AS dep ON prof.id_departamento = dep.id
WHERE matricula.id_asignatura IS NULL
ORDER BY asig.id;

-- Devuelve el número total de alumnas que hay.
select COUNT(nombre) FROM persona WHERE sexo = 'M' AND tipo = 'alumno';

-- Devuelve un listado con el nombre de todos los grados existentes en la base de datos
-- y el número de asignaturas que tiene cada uno, de los grados que tengan más de 40 asignaturas asociadas.
SELECT grado.nombre,COUNT(asignatura.id) FROM grado
JOIN asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.nombre
HAVING COUNT(asignatura.id) > 40;

-- Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que hay para cada tipo de asignatura.
-- El resultado debe tener tres columnas: nombre del grado, tipo de asignatura y la suma de los créditos de todas las asignaturas
-- que hay de ese tipo. Ordene el resultado de mayor a menor por el número total de crédidos.
SELECT grado.nombre,asignatura.tipo,SUM(creditos) as suma FROM grado
JOIN asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.nombre,asignatura.tipo
ORDER BY grado.nombre,suma DESC;

-- Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de los cursos escolares.
-- El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar
-- y otra con el número de alumnos matriculados.
SELECT inicio, COUNT(DISTINCT id_alumno) FROM matricula
JOIN curso_escolar ON matricula.id_curso_escolar = curso_escolar.id
GROUP BY inicio;

-- Devuelve un listado con el número de asignaturas que imparte cada profesor.
-- El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura.
-- El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas.
-- El resultado estará ordenado de mayor a menor por el número de asignaturas.
SELECT persona.id,persona.nombre,persona.apellido1,persona.apellido2,COUNT(asignatura.id) FROM persona
LEFT JOIN  asignatura ON persona.id = asignatura.id_profesor
GROUP BY persona.id, persona.nombre, persona.apellido1, persona.apellido2
ORDER BY COUNT(persona.id) DESC ;

-- Subconsultas
-- Devuelve todos los datos del alumno más joven.
SELECT nombre,apellido1,apellido2 FROM persona
WHERE tipo = 'alumno' AND fecha_nacimiento = (
    SELECT MAX(fecha_nacimiento) FROM persona WHERE tipo = 'alumno'
    );
select nombre,apellido1,MAX(fecha_nacimiento) FROM persona
GROUP BY nombre, apellido1
ORDER BY MAX(fecha_nacimiento) DESC
LIMIT 1;

-- Devuelve un listado con los profesores que no está anasociados a un departamento
SELECT nombre,apellido1,apellido2 FROM persona
WHERE tipo = 'profesor' AND id NOT IN (
    SELECT id_profesor FROM profesor
    );

SELECT * FROM profesor;
