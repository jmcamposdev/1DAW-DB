-- Bloque B

-- Consultas multitabla (Composición interna) (INNER JOIN | NATURAL JOIN)
-- 1.4.5 11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente
SELECT c.nombre_cliente,g.gama
FROM cliente c
JOIN pedido pe ON (c.codigo_cliente=pe.codigo_cliente)
JOIN detalle_pedido dp ON (pe.codigo_pedido=dp.codigo_pedido)
JOIN producto p ON (dp.codigo_producto=p.codigo_producto)
JOIN gama_producto g ON (p. gama=g. gama)
GROUP BY c.nombre_cliente, g.gama
ORDER BY c.nombre_cliente;

-- Consultas multitabla (Composición externa) (LEFT | RIGHT | NATURAL | INNER)
-- 1.4.6 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes
-- de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
SELECT DISTINCT oficina.*
FROM oficina
         JOIN empleado ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE oficina.codigo_oficina NOT IN (
    SELECT DISTINCT oficina.codigo_oficina
    FROM oficina
             JOIN empleado ON empleado.codigo_oficina = oficina.codigo_oficina
             JOIN cliente ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
             JOIN pedido ON pedido.codigo_cliente = cliente.codigo_cliente
             JOIN detalle_pedido ON detalle_pedido.codigo_pedido = pedido.codigo_pedido
             JOIN producto ON producto.codigo_producto = detalle_pedido.codigo_producto
             JOIN gama_producto ON gama_producto.gama = producto.gama
    WHERE gama_producto.gama = 'Frutales'
);

-- Consultas resumen
-- 1.4.7 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT codigo_pedido,COUNT(DISTINCT codigo_producto)
FROM detalle_pedido
GROUP BY codigo_pedido;

-- 1.4.7 17. La misma información que en la pregunta anterior,pero agrupa da por código de producto filtrada por los
-- códigos que empiecen por OR.
SELECT codigo_producto,SUM(cantidad*detalle_pedido.precio_unidad) IMPONIBLE,
       SUM(cantidad*precio_unidad)*0.21 IVA,
       SUM(cantidad*precio_unidad)*1.21  TOTAL
FROM detalle_pedido WHERE codigo_producto LIKE 'OR%'
GROUP BY codigo_producto
ORDER BY codigo_producto;

-- Subconsultas
-- Con operadores básicos de comparación
-- 1.4.8.1 3. Devuelve el nombre del producto del que se han vendido más unidades.
-- (Tenga encuenta que tendrá que calcular cuál es el número total de unidades que
-- se han vendido de cada producto a partir de los datos de la tabla detalle_pedido)
SELECT nombre,codigo_producto
FROM producto
WHERE codigo_producto = (SELECT codigo_producto
                         FROM detalle_pedido
                         GROUP BY codigo_producto
                         ORDER BY SUM(cantidad) DESC
                         LIMIT 1);

-- 1.4.8.1.6 Devuelve el producto que menos unidades tiene en stock.
SELECT nombre
FROM producto
WHERE codigo_producto = (SELECT codigo_producto
                         FROM producto
                         GROUP BY codigo_producto
                         ORDER BY min(cantidad_en_stock)
                         LIMIT 1);


-- Subconsultas con ALL y ANY
-- 1.4.8.2.9 Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT nombre FROM producto
WHERE precio_venta >= ANY(SELECT MAX(precio_venta) FROM producto);


-- Subconsultas con IN y NOT IN
-- 1.4.8.3.14 Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT nombre,codigo_producto FROM producto
WHERE codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido);


-- Subconsultas con EXISTS y NOT EXISTS
-- 1.4.8.4.21 -- Devuelve un listado de Los productos que han aparecido en un pedido alguna vez
SELECT nombre,codigo_producto FROM producto as p1
WHERE EXISTS (SELECT codigo_producto FROM detalle_pedido as dp WHERE p1.codigo_producto = dp.codigo_producto);

-- Consultas variadas
-- 1.4.9.2 Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos.
-- Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.
SELECT nombre_cliente,SUM(total) FROM cliente
JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
GROUP BY nombre_cliente;
