SELECT * FROM Clientes;
SELECT * FROM Representantes;
SELECT * FROM Oficinas; 
SELECT * FROM Productos;
SELECT * FROM Pedidos;

-- Crear una vista que visualice el total de los importes por productos

CREATE OR ALTER VIEW vw_importes_productos
AS
SELECT 
	pr.Descripcion AS [Nombre Producto], 
	SUM(p.Importe) AS [Total],
	SUM(p.Importe * 1.15) AS [ImporteDescuento]
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON p.Fab = pr.Id_fab
AND p.Producto = pr.Id_producto
GROUP BY pr.Descripcion;

SELECT * FROM vw_importes_productos
WHERE [Nombre Producto] LIKE '%brazo%'
AND ImporteDescuento > 34000;

-- Seleccionar los nombres de los representantes y las oficinas en donde trabajan

CREATE OR ALTER VIEW vw_representantes_oficinas
AS
SELECT 
	r.Nombre, 
	r.Ventas AS [ventasrepresentante],
	o.Oficina, 
	o.Ciudad, 
	o.Region,
	o.Ventas AS [ventasoficinas]
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Oficina_Rep = o.Oficina;

SELECT *
FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo';

SELECT *
FROM vw_representantes_oficinas
ORDER BY Nombre DESC;

-- Seleccionar los pedidos con fecha en importe, el nombre del representante que lo realizo y al cliente que lo solicito

SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	c.Empresa,
	r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = p.Rep;

-- Seleccionar los pedidos con fecha en importe, el nombre del representante que lo realizo y al cliente que lo solicito

SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	c.Empresa,
	r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli;

-- Lista los pedidos atendidos por representantes cuyo puesto sea "jefe de ventas". Muestra Num_Pedido, FechaPedido, Nombre, Puesto e importe. Ordena por importe descendente
SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	r.Nombre,
	r.Puesto,
	p.Importe
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli
WHERE r.Puesto = 'Jefe Ventas'
ORDER BY p.Importe DESC;

-- Obtén la lista única de empresas que hayan comprado productos cuya Descripcion inicie con "Serie". Devuelve solo la columna Empresa y ordenala alfabeticamente.
SELECT DISTINCT
	c.Empresa
FROM Clientes AS c
INNER JOIN Pedidos AS p
ON c.Num_Cli = p.Cliente
INNER JOIN Productos AS pr
ON pr.Id_fab = p.Fab
AND pr.Id_producto = p.Producto
WHERE pr.Descripcion LIKE '%Serie%'
ORDER BY c.Empresa;

-- Para cada producto vendido, calcula TotalUnidades (suma de Cantidad) y TotalImporte (suma de Importe). Muestra: Fab, Producto, Descripcion, TotalUnidades y TotalImporte. Ordena por TotalImporte descendente.
SELECT
	p.Fab,
	p.Producto,
	pr.Descripcion,
	SUM(p.Cantidad) AS TotalUnidades,
	SUM(p.Importe) AS TotalImporte
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON pr.Id_fab = p.Fab
AND pr.Id_producto = p.Producto
GROUP BY p.Fab, p.Producto, pr.Descripcion
ORDER BY TotalImporte DESC;

-- Identifica representantes con al menos 2 pedidos y con TotalImporte (suma de Importe) >= 20000. Muestra: Num_Empl, Nombre, NumPedidos y TotalImporte. Ordena por TotalImporte descendente.
SELECT
	r.Num_Empl,
	r.Nombre,
	COUNT(p.Num_Pedido) AS NumPedidos,
	SUM(p.Importe) AS TotalImporte
FROM Representantes AS r
INNER JOIN Pedidos AS p
ON r.Num_Empl = p.Rep
GROUP BY r.Num_Empl, r.Nombre
HAVING COUNT(p.Num_Pedido) >= 2 AND SUM(p.Importe) >= 20000
ORDER BY TotalImporte DESC;

-- Encuentra pedidos donde el Importe sea distinto de (Precio*Cantidad) del producto asociado. Muestra: Num_Pedido, Descripcion, Precio, Cantidad, Importe y Diferencia = Importe-(Precio*Cantidad).
SELECT
	p.Num_Pedido,
	pr.Descripcion,
	pr.Precio,
	p.Cantidad,
	p.Importe,
	(p.Importe - (pr.Precio * p.Cantidad)) AS Diferencia
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON pr.Id_fab = p.Fab AND pr.Id_producto = p.Producto
WHERE p.Importe <> (pr.Precio * p.Cantidad);

-- Crea la vista vw_ProductosMasVendidos_C con columnas: Id_fab, Id_producto, Descripcion, UnidadesVendidas (suma de Cantidad). Incluye solo productos con UnidadesVendidas >= 20.
CREATE OR ALTER VIEW vw_ProductosMasVendidos_C
AS
SELECT
	p.Fab AS Id_fab,
	p.Producto AS Id_producto,
	pr.Descripcion,
	SUM(p.Cantidad) AS UnidadesVendidas
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON pr.Id_fab = p.Fab AND pr.Id_producto = p.Producto
GROUP BY p.Fab, p.Producto, pr.Descripcion
HAVING SUM(p.Cantidad) >= 20;

-- Crea la vista vw_PedidoFull_C con columnas: Num_Pedido, Fecha_Pedido, Empresa, NombreRep, Ciudad, Region, Descripcion, Cantidad, Importe.
CREATE OR ALTER VIEW vw_PedidoFull_C
AS
SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	c.Empresa,
	r.Nombre AS NombreRep,
	o.Ciudad,
	o.Region,
	pr.Descripcion,
	p.Cantidad,
	p.Importe
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli
INNER JOIN Oficinas AS o
ON o.Oficina = r.Oficina_Rep
INNER JOIN Productos AS pr
ON pr.Id_fab = p.Fab AND pr.Id_producto = p.Producto;

--Lista pedidos entre 01/dic/1989 y 28/feb/1990 que cumplan: (Importe > 10000) o (Cantidad >= 20). Muestra: Num_Pedido, Fecha_Pedido, Empresa, Cantidad e Importe. Ordena por Fecha_Pedido ascendente.
SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	c.Empresa,
	p.Cantidad,
	p.Importe
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
WHERE p.Fecha_Pedido BETWEEN '1989-12-01' AND '1990-02-28'
AND (p.Importe > 10000 OR p.Cantidad >= 20)
ORDER BY p.Fecha_Pedido ASC;