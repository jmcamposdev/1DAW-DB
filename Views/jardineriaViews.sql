-- 21. Escribir una vista que se llame listado_pagos_clientes que muestre un listado donde aparezcan todos los clientes
-- y los pagos que ha realizado cada uno de ellos. La vista deberá tener las siguientes columnas:
-- nombre y apellidos del cliente concatenados, teléfono, ciudad, pais, fecha_pago, total del pago, id de la transacción
CREATE VIEW listado_pagos_clientes as
    SELECT CONCAT(nombre_cliente,' ',apellido_contacto), telefono, ciudad, pais, fecha_pago, total, id_transaccion
    FROM cliente
    JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente;
;

-- 22. Escribir una vista que se llame listado_pedidos_clientes que muestre un listado donde aparezcan todos los clientes
-- y los pedidos que ha realizado cada uno de ellos. La vista deáber tener las siguientes columnas: nombre y apellidos
-- del cliente concatendados, teléfono, ciudad, pais, código del pedido, fecha del pedido, fecha esperada, fecha de entrega
-- y la cantidad total del pedido, que será la suma del producto de todas las cantidades por el precio de cada unidad,
-- que aparecen en cada línea de pedido.
CREATE VIEW listado_pedidos_clientes as
SELECT CONCAT(nombre_cliente,' ',apellido_contacto) as nombre,telefono, ciudad, pais, pedido.codigo_pedido, fecha_pedido, fecha_esperada, fecha_entrega, SUM(cantidad*precio_venta) AS Suma  FROM cliente
JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
GROUP BY nombre_cliente,apellido_contacto,telefono,ciudad, pais, pedido.codigo_pedido, fecha_pedido, fecha_esperada, fecha_entrega;
-- 23. Utilizar las vistas creadas en los ejercicios 21 y 22 para devolver un listado de los clientes de la ciudad de Madrid que han realizado pagos.
SELECT * FROM listado_pagos_clientes WHERE ciudad = 'Madrid';
-- 24. Ídem para devolver un listado de los clientes que todavía no han recibido su pedido.
SELECT * FROM listado_pedidos_clientes WHERE fecha_entrega IS NULL AND ciudad = 'Madrid';
-- 25. Ídem para calcular el número de pedidos que se ha realizado cada uno de los clientes.
SELECT nombre,COUNT(*)FROM listado_pedidos_clientes WHERE fecha_entrega IS NULL AND ciudad = 'Madrid'
group by nombre;
-- 26. Ídem para calcular el valor del pedido máximo y mínimo que ha realizado cada cliente.
SELECT nombre,max(Suma),MIN(Suma) FROM listado_pedidos_clientes
WHERE fecha_entrega IS NULL AND ciudad = 'Madrid'
GROUP BY nombre;
-- 27. Modificar el nombre de las vista listado_pagos_clientes y asignarle el nombre listado_de_pagos.
-- Una vez que haya modificado el nombre de la vista realizar una consulta utilizando el nuevo nombre de la vista
-- para comprobar que sigue funcionando correctamente.
ALTER VIEW listado_pagos_clientes RENAME TO listado_de_pagos;
SELECT * FROM listado_de_pagos;
-- 28. Eliminar las vistas creadas en los ejercicios 21 y 22.
DROP VIEW listado_de_pagos;
DROP VIEW listado_pedidos_clientes;