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

-- list all tables in this database
SELECT 