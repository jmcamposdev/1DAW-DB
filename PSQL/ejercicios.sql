/*
    1. Escribir una función que reciba dos números y devuelva su suma.
    A continuación, escribir un procedimiento que muestre la suma al usuario.
 */

CREATE OR REPLACE FUNCTION sumar_numeros(a INTEGER, b INTEGER)
    RETURNS INTEGER AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE mostrar_suma(a INTEGER, b INTEGER)
    LANGUAGE plpgsql AS $$
DECLARE
    resultado INTEGER;
BEGIN
    resultado := sumar_numeros(a, b);
    RAISE NOTICE 'La suma de % y % es %', a, b, resultado;
END;
$$;

SELECT sumar_numeros(1, 2);
call mostrar_suma(1, 2);




-- 2. Codificar un procedimiento que reciba una cadena de texto y la visualice al revés.
CREATE OR REPLACE PROCEDURE texto_al_reves(cadena text)
    LANGUAGE plpgsql AS $$
DECLARE
    longitud integer := length(cadena);
    cadena_invertida text := '';
BEGIN
    FOR i IN REVERSE longitud..1 LOOP
        cadena_invertida := cadena_invertida || substring(cadena FROM i FOR 1);
    END LOOP;
    RAISE NOTICE 'La cadena invertida es %', cadena_invertida;
END;
$$;

CALL texto_al_reves('Hola mundo');

-- 3. Escribir una función que reciba una fecha y devuelva el año de la fecha (como número).
CREATE OR REPLACE FUNCTION obtener_anio(fecha DATE)
    RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM fecha);
END;
$$ LANGUAGE plpgsql;

SELECT obtener_anio('2020-01-01');

-- 4. Dado el siguiente procedimiento:
-- CREATE OR REPLACE PROCEDURE crear_depart (
-- v_num_dept depart.dept_no%TYPE,
-- v_dnombre depart.dnombre%TYPE DEFAULT 'PROVISIONAL', v_loc depart.loc%TYPE DEFAULT ‘PROVISIONAL’)
-- AS
-- $$ BEGIN
-- INSERT INTO depart VALUES (v_num_dept, v_dnombre, v_loc); END; $$

-- Indicar cuáles de las siguientes llamadas son correctas y cuáles no:
-- 1o. crear_depart;
-- 2o. crear_depart(50);
-- 3o. crear_depart('COMPRAS');
-- 4o. crear_depart(50,'COMPRAS');
-- 5o. crear_depart('COMPRAS', 50);
-- 6o. crear_depart('COMPRAS', 'VALENCIA');
-- 7o. crear_depart(50, 'COMPRAS', 'VALENCIA'); 8o. crear_depart('COMPRAS', 50, 'VALENCIA'); 9o. crear_depart('VALENCIA', ‘COMPRAS’); 10o. crear_depart('VALENCIA', 50);

-- Correctas : 2, 4, 7

-- 5. Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma.
CREATE OR REPLACE PROCEDURE sumar_numeros(numeros INTEGER[5])
AS $$
DECLARE
    suma INTEGER := 0;
BEGIN
    IF array_length(numeros, 1) > 5 THEN
        RAISE EXCEPTION 'El arreglo no puede tener más de 5 elementos';
    END IF;

    FOR i IN 1..array_length(numeros, 1) LOOP
            suma := suma + numeros[i];
        END LOOP;
    RAISE NOTICE 'La suma de los números es: %', suma;
END;
$$ LANGUAGE plpgsql;

CALL sumar_numeros(ARRAY[1, 2, 3, 4, 5]);

-- 6. Realizar los siguientes procedimientos y funciones sobre la base de datos jardineria:

-- 1. Función: calcular_precio_total_pedido
-- Descripción: Dado un código de pedido la función debe calcular la suma total del pedido. Tenga en cuenta que un pedido puede contener varios productos diferentes y varias cantidades de cada producto.
-- Parámetros de entrada: codigo_pedido (INT)
-- Parámetros de salida: El precio total del pedido (FLOAT)

CREATE OR REPLACE FUNCTION calcular_precio_total_pedido(codigo_pedido INT)
RETURNS FLOAT
AS $$
DECLARE
    precio_total FLOAT;
BEGIN
    SELECT SUM(precio_unidad * cantidad) INTO precio_total
    FROM pedido
    JOIN detalle_pedido USING (codigo_pedido)
    JOIN producto USING (codigo_producto)
    WHERE pedido.codigo_pedido = $1;
    RETURN precio_total;
END$$ LANGUAGE plpgsql;

-- 2. Función: calcular_suma_pedidos_cliente
-- Descripción: Dado un código de cliente la función debe calcular la suma total de todos los pedidos realizados por el cliente. Deberá hacer uso de la función calcular_precio_total_pedido que ha desarrollado en el apartado anterior.
-- Parámetros de entrada: codigo_cliente (INT)
-- Parámetros de salida: La suma total de todos los pedidos del cliente (FLOAT)

CREATE OR REPLACE FUNCTION calcular_suma_pedidos_cliente(codigo_cliente INT)
RETURNS FLOAT
AS $$
DECLARE
    suma_pedidos FLOAT;
BEGIN
    SELECT SUM(calcular_precio_total_pedido(codigo_pedido)) INTO suma_pedidos
    FROM pedido
    WHERE pedido.codigo_cliente = $1;
    RETURN suma_pedidos;
END$$ LANGUAGE plpgsql;

-- 3. Función: calcular_suma_pagos_cliente
-- Descripción: Dado un código de cliente la función debe calcular la suma total de los pagos realizados por ese cliente.
-- Parámetros de entrada: codigo_cliente (INT)
-- Parámetros de salida: La suma total de todos los pagos del cliente (FLOAT)

CREATE OR REPLACE FUNCTION calcular_suma_pagos_cliente(codigo_cliente INT)
RETURNS FLOAT
AS $$
DECLARE
    suma_pagos FLOAT;
BEGIN
    select * from (SELECT SUM(total) INTO suma_pagos
        FROM pago
        WHERE pago.codigo_cliente = $1) pS;
    RETURN suma_pagos;
END$$ LANGUAGE plpgsql;

-- 4. Procedimiento: calcular_pagos_pendientes
-- Descripción: Deberá calcular los pagos pendientes de todos los clientes. Para saber si un cliente tiene algún pago pendiente deberemos calcular cuál es la cantidad de todos los pedidos y los pagos que ha realizado. Si la cantidad de los pedidos es mayor que la de los pagos entonces ese cliente tiene pagos pendientes.
-- Deberá insertar en una tabla llamada clientes_con_pagos_pendientes los siguientes datos: id_cliente, suma_total_pedidos, suma_total_pagos, pendiente_de_pago

CREATE OR REPLACE PROCEDURE calcular_pagos_pendientes()
AS $$
DECLARE
    codigo_cliente INT;
    suma_total_pedidos FLOAT;
    suma_total_pagos FLOAT;
    pendiente_de_pago FLOAT;
BEGIN
    FOR codigo_cliente IN SELECT codigo_cliente FROM cliente
    LOOP
        SELECT calcular_suma_pedidos_cliente(codigo_cliente) INTO suma_total_pedidos;
        SELECT calcular_suma_pagos_cliente(codigo_cliente) INTO suma_total_pagos;
        IF suma_total_pedidos > suma_total_pagos THEN
            pendiente_de_pago := suma_total_pedidos - suma_total_pagos;
            INSERT INTO clientes_con_pagos_pendientes VALUES (codigo_cliente, suma_total_pedidos, suma_total_pagos, pendiente_de_pago);
        END IF;
    END LOOP;
END$$ LANGUAGE plpgsql;

-- 7. Escribir un procedimiento que modifique la localidad de una oficina de la base de datos de jardinería.
-- El procedimiento recibirá como parámetros el número y la localidad nueva

CREATE PROCEDURE modificarLocalidadOficina (numero VARCHAR(10), localidad VARCHAR(50))
AS $$
BEGIN
    UPDATE oficina SET ciudad = localidad WHERE codigo_oficina = numero;
END$$ LANGUAGE plpgsql;

SELECT * FROM oficina;
CALL modificarLocalidadOficina('BOS-USA', 'Madrid');

-- 8. Codificar un procedimiento que reciba como parámetros un numero de departamento, un importe y un porcentaje;
-- y suba el salario a todos los empleados del departamento indicado en la llamada.
-- La subida será el porcentaje o el importe indicado en la llamada (el que sea más beneficioso para el empleado en cada caso empleado).

CREATE OR REPLACE PROCEDURE subida_salario (codigo_departamento INTEGER, importe MONEY, porcentaje INTEGER)
AS $$
BEGIN
    UPDATE employees
    SET salary = salary + GREATEST(importe, (salary * (porcentaje / 100.0)))::MONEY
    WHERE department_id = codigo_departamento;

END$$ LANGUAGE plpgsql;

CALL subida_salario(1, 100::money, 10);

-- 9. En la misma base de datos del ejercicio anterior, escribir un procedimiento que suba el sueldo de todos los empleados
-- que ganen menos que el salario medio de su departamento. La subida será del 50% de la diferencia entre el salario del
-- empleado y la media de su departamento. Se deberá asegurar que la transacción no se quede a medias, y se gestionarán los posibles errores.
CREATE OR REPLACE PROCEDURE igualarSalario() AS
$$ DECLARE
    depAvgSal RECORD;
    employeeData RECORD;
    subida DECIMAL;
BEGIN
    FOR depAvgSal IN SELECT department_id, avg(salary::decimal) AS avg FROM employees GROUP BY department_id
        LOOP
            RAISE NOTICE 'ID department: %', depAvgSal.department_id;
            RAISE NOTICE 'ID avg: %', depAvgSal.avg;
            FOR employeeData IN SELECT employee_id, salary::decimal FROM employees WHERE department_id = depAvgSal.department_id
                LOOP
                    RAISE NOTICE 'ID employee: %', employeeData.employee_id;
                    RAISE NOTICE 'Salary: %', employeeData.salary;
                    IF employeeData.salary < depAvgSal.avg THEN
                        subida = 0.5 * (depAvgSal.avg - employeeData.salary);
                        RAISE NOTICE 'Subida prevista: %', subida;
                    END IF;
                    UPDATE employees SET salary = salary + subida::money WHERE employee_id = employeeData.employee_id;
                END LOOP;
        END LOOP;
END $$ LANGUAGE plpgsql;

CALL igualarSalario();

SELECT * FROM employees;


-- 11. Cambiar la solución del ejercicio anterior para permitir la eliminación físicamente del registro
-- de la tabla empleados pero guardar una copia del registro eliminado en una tabla llamada ex_empleados,
-- guardando también en esa tabla la fecha de la baja.

-- Creamos la tabla ex_empleados con los mismos campos que la tabla empleado
CREATE TABLE ex_empleados (
                              id serial NOT NULL,
                              codigo_empleado INTEGER NOT NULL,
                              nombre VARCHAR(50) NOT NULL,
                              apellido1 VARCHAR(50) NOT NULL,
                              apellido2 VARCHAR(50) DEFAULT NULL,
                              extension VARCHAR(10) NOT NULL,
                              email VARCHAR(100) NOT NULL,
                              codigo_oficina VARCHAR(10) NOT NULL,
                              codigo_jefe INTEGER DEFAULT NULL,
                              puesto VARCHAR(50) DEFAULT NULL,
                              PRIMARY KEY (id)
);

-- Creamos la función que se ejecutará antes de eliminar un registro de la tabla empleado
CREATE OR REPLACE FUNCTION baja_empleado()
    RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO ex_empleados (codigo_empleado, nombre, apellido1, apellido2, extension, email, codigo_oficina, codigo_jefe, puesto) VALUES
        (OLD.codigo_empleado, OLD.nombre, OLD.apellido1, OLD.apellido2, OLD.extension, OLD.email, OLD.codigo_oficina, OLD.codigo_jefe, OLD.puesto);
    RETURN OLD;
END$$ LANGUAGE plpgsql;

-- Creamos el trigger que ejecutará la función anterior
CREATE TRIGGER tr_baja_empleado
    BEFORE DELETE ON empleado
    FOR EACH ROW
EXECUTE PROCEDURE baja_empleado();

-- PROBAMOS EL TRIGGER
DELETE FROM empleado WHERE codigo_empleado = 33;
SELECT * FROM empleado;
SELECT * FROM ex_empleados;


-- 12. Queremos que no se puedan eliminar físicamente los pedidos, en vez de eliminarlo, se marcará como baja.
-- Para ello debemos añadir a la tabla de pedidos un campo baja que contendrá un valor lógico TRUE o FALSE (no podrá contener ningún otro valor).
-- Por defecto estará puesto a FALSE (no se ha borrado) y cuando se intente borrar el pedido,
-- en vez de borrar el pedido se cambiará el valor de este campo.

-- Añadir un campo baja a la tabla pedido
ALTER TABLE pedido ADD COLUMN baja BOOLEAN DEFAULT FALSE;


CREATE OR REPLACE FUNCTION eliminar_pedido()
    RETURNS trigger AS $$
BEGIN
    -- Cambiamos el valor del campo 'baja' a TRUE
    UPDATE pedido SET baja = TRUE WHERE codigo_pedido = OLD.codigo_pedido;
    -- Retornamos NULL para evitar que se elimine físicamente el registro
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evitar_eliminacion_pedido
    BEFORE DELETE ON pedido
    FOR EACH ROW
EXECUTE FUNCTION eliminar_pedido();

-- Comprobamos que no se puede eliminar físicamente un pedido
DELETE FROM pedido WHERE codigo_pedido = 2;
SELECT * FROM pedido;




