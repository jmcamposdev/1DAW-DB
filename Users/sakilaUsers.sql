-- 1. Crear un usuario root y utilizarlo para iniciar sesión en la base de datos sakila del servidor local
CREATE USER root WITH PASSWORD 'root';

-- 2. Crear un usuario con nombre de usuario myuser y contraseña mypass
CREATE USER myuser PASSWORD 'mypass';

-- 3. Crear un nuevo usuario testUser con una contraseña testpwd.
-- El usuario testUser tiene permisos de consulta y actualización en todos los datos, y se le otorgan permisos SELECT y UPDATE en todas las tablas de datos
CREATE USER testUser WITH PASSWORD 'testpwd';
GRANT SELECT,UPDATE ON ALL TABLES IN SCHEMA public TO testuser;

-- 4. Crear una nueva cuenta con el nombre de usuario customer1 y contraseña customer1
CREATE USER customer1 PASSWORD 'customer1';

-- 5. Utilizar DROP USER para eliminar el usuario 'myuser' @ 'localhost'
DROP USER myuser;

-- 6. Cambiar la contraseña del usuario root a "rootpwd2":
ALTER USER root WITH PASSWORD 'rootpwd2';

-- 7. Utilizar la instrucción GRANT para crear un nuevo usuario grantUser con la contraseña "grantpwd".
-- El usuario grantUser tiene permisos de consulta e inserción para todos los datos, y además concede permisos GRANT.
CREATE USER grantUser WITH PASSWORD 'grantpwd';
GRANT SELECT,INSERT ON ALL TABLES IN SCHEMA public TO grantUser WITH GRANT OPTION;

-- 8. Utilizar la instrucción REVOKE para cancelar el permiso de actualización del usuario testUser
REVOKE UPDATE ON ALL TABLES IN SCHEMA public FROM testuser;

-- 9. Consultar la información de permisos del usuario testUser

-- 10. Crea usuarios y permisos para la base de datos Sakila considerando las siguientes restricciones de seguridad:
-- • Administrador: todos los permisos.
-- • Operador nivel 1: tiene acceso de lectura en todas las tablas. Puede operar en todas tablas
-- menos en la tabla payment donde sólo puede consultar. No puede modificar la estructura de
-- ninguna tabla.
-- • Operador nivel 2: puede consultar todas las tablas y modificar las tablas customer y payment
-- menos los campos customer_id, create_date y last_update.
CREATE ROLE administrator;
GRANT ALL ON DATABASE sakila TO administrator;

CREATE ROLE operador1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO operador1;
REVOKE SELECT ON payment FROM operador1;

CREATE ROLE operador2;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO operador2;
GRANT UPDATE (store_id,first_name,last_name,email,address_id,activebool,active) ON customer TO operador2;
GRANT UPDATE (payment_id,staff_id,rental_id,amount,payment_date) ON payment To operador2;
