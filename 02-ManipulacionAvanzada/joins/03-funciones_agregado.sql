/*
	Funciones de Agregado:

	1. sum()
	2. max()
	3. min()
	4. avg()
	5. count(*)
	6. count(campo)

	Nota: Estas funciones solamente regresan un solo registro
*/

-- Seleccionar los países de donde son los clientes

SELECT DISTINCT Country
FROM Customers;

-- Agregación count(*) cuenta el número de registros que tiene una tabla

SELECT COUNT(*) AS [Total de Ordenes]
FROM Orders;

-- Seleccionar el precio máximo de los productos
SELECT *
FROM Products
ORDER BY UnitPrice DESC;

SELECT MAX(UnitPrice) AS [Precio más Alto]
FROM Products;

-- Seleccionar la fecha de compra más actual
SELECT MAX(OrderDate) AS [Fecha más reciente]
FROM Orders;

SELECT MIN(OrderDate) AS [Fecha más vieja]
FROM Orders;

-- Seleccionar el año de la fecha de compra más reciente
SELECT MAX(YEAR(OrderDate)) AS [Fecha más reciente]
FROM Orders;

SELECT YEAR(MAX(OrderDate))
FROM Orders;

SELECT MAX(DATEPART(YEAR, OrderDate))
FROM Orders;

SELECT DATEPART(YEAR, MAX(OrderDate)) AS [Año]
FROM Orders;

-- Cuál es la mínima cantidad de pedidos
SELECT MIN(UnitPrice) AS [Mínima cantidad de pedidos]
FROM [Order Details];

-- Cuál es el importe más bajo de las compras
SELECT (UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
ORDER BY [Importe] ASC;

SELECT (UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
ORDER BY (UnitPrice * Quantity * (1-Discount)) ASC;

SELECT MIN ((UnitPrice * Quantity * (1-Discount))) AS [Importe]
FROM [Order Details];

-- Obtener el total de los precios de los productos
SELECT SUM(UnitPrice) AS [Total de los productos]
FROM Products;


-- Obtener el total de dinero percibido por las ventas
SELECT SUM((UnitPrice * Quantity * (1-Discount))) AS [Total de las ventas]
FROM [Order Details];

-- Seleecionar las ventas totales de los productos 4, 10 y 20
SELECT SUM(UnitPrice * Quantity * (1-Discount)) AS [Importe]
FROM [Order Details]
WHERE ProductID IN (4,10,20)
GROUP BY ProductID;

--Seleccionar el número de órdenes hechas por los siguientes clientes
Around the Horn,
Bólido Comidas preparadas,
Chop-suey Chinese

select * from [Order Details];
select * from Orders;
select * from Customers;

select COUNT(CustomerID) AS [PEDIDOS DE TRES CLIENTES], CustomerID from Orders
where CustomerID in ('AROUT', 'BOLID', 'CHOPS')
group by CustomerID;

-- Seleccionar el total de órdenes del segundo trimestre de 1995
select * from Orders;

select COUNT(DATEPART(Quarter, OrderDate)) AS [Ordenes del segundo Trimestre] from Orders
where YEAR(OrderDate) = '1996';

-- Seleccionar el número de órdenes entre 1996 a 1997
select * from Orders;

SELECT Count(*) as [Numero de ordenes] 
FROM Orders
WHERE YEAR(OrderDate) BETWEEN 1996 AND 1997;

--  Seleccionar el número de clientes que comienzan con A o que comienzan con B
SELECT * FROM customers;

SELECT COUNT(CompanyName) AS [Número de Clientes]
FROM customers 
WHERE CompanyName LIKE 'a%' OR CompanyName LIKE 'b%'; 

--  Seleccionar el número de clientes que comienzan con B y que termina con S
SELECT COUNT(*) AS [Número de Clientes]
FROM Customers 
WHERE CompanyName LIKE 'b%s';

-- Seleccionar el número de órdenes realizadas por el cliente Chop-suey Chinese en 1996
SELECT * FROM [Order Details];
SELECT * FROM Orders;
SELECT * FROM Customers;
SELECT * FROM Customers 

SELECT COUNT(*) AS [Número de ordenes], CustomerID, SUM(OrderID) AS [Suma de las Ordenes]
FROM Orders
WHERE YEAR(OrderDate) = 1996 AND CustomerID = 'CHOPS'
GROUP BY CustomerID;
-----------------------------------------------------------------------------------------------------
/*
	GROUP BY Y HAVIN
*/
SELECT  
	Customers.CompanyName,
	COUNT(*) AS [Número de Ordenes]
FROM Orders
INNER JOIN
Customers
ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName
ORDER BY 2 DESC;

SELECT  
	c.CompanyName,
	COUNT(*) AS [Número de Ordenes]
FROM Orders AS o
INNER JOIN
Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY 2 DESC;
-----------------------------------------------------------------------------------------------------

-- Seleccionar el número de productos (conteo) por categoría, mostrar CategoriaID, TotaldeProductos, 
-- ordenarlos de mayor a menor por el TotaldeProductos
SELECT * FROM Products

SELECT CategoryID, COUNT(*) AS [Total de Productos]
FROM Products
GROUP BY CategoryID
ORDER BY 2 DESC;

SELECT CategoryID, COUNT(*) AS [Total de Productos]
FROM Products
GROUP BY CategoryID
ORDER BY COUNT(*) DESC;

-- Seleccionar el precio promedio por proveedor de los productos. Redondear a dos decimales el resultado
-- Ordenar de forma descendente por el precio promedio
SELECT
	SupplierID,
	ROUND(SUM(UnitPrice) / COUNT(*), 2) AS PrecioPromedio
	FROM Products
	GROUP BY SupplierID
	ORDER BY PrecioPromedio DESC;

-- Seleccionar el número de clientes por país. Ordenarlos por país alfabeticamente 
SELECT * FROM Customers

SELECT COUNT(*) AS [Ordenarlos por país alfabeticamente],
	Country
FROM Customers
GROUP BY Country;

SELECT COUNT(*) AS TotalOrdenes_1997
FROM Orders
WHERE DATEPART(QUARTER, OrderDate) = 2
AND DATEPART(YEAR, OrderDate) = 1997;

SELECT OrderDate, datepart(q, OrderDate), DATEPART(y, OrderDate)
FROM Orders
WHERE DATEPART(y, OrderDate) = 

-- Obtener la cantidad total vendida agrupada por producto y pedido
SELECT *, (UnitPrice * Quantity) AS [Total]
FROM [Order Details];

SELECT ProductID, SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
GROUP BY ProductID
ORDER BY ProductID

SELECT ProductID, OrderID, SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID

SELECT ProductID, OrderID, SUM(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, [Total] DESC

SELECT *, 
	(UnitPrice * Quantity) AS [Total]
FROM [Order Details]
WHERE OrderID = 10847
AND ProductID = 1

-- Seleccionar la cantidad máxima vendida por producto en cada pedido
SELECT ProductID, OrderID, MAX(Quantity) AS [Cantidad Máxima]
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, OrderID;

-- Seleccionar el total de órdenes que fueron enviadas Alemania

SELECT COUNT(*) AS [Total Ordenes Alemania]
FROM Orders
WHERE ShipCountry = 'Germany';

SELECT ShipCountry, COUNT(*) AS [Total Ordenes Alemania]
FROM Orders
GROUP BY ShipCountry;

SELECT COUNT(CustomerID)
FROM Customers;

SELECT COUNT(Region)
FROM Customers;

-- Selecciona de cuantas ciudades son las ciudades de los clientes

SELECT city
FROM Customers
ORDER BY city ASC;

SELECT COUNT(city)
FROM Customers;

SELECT DISTINCT city
FROM Customers
ORDER BY city ASC;

SELECT COUNT(DISTINCT city) AS [Ciudades Clientes]
FROM Customers;

/* Flujo lógico de ejecución en SQL

1. From
2. Join
3. Where
4. Group by
5. Having
6. Select
7. Distinct
8. Order by

*/

-- Having (filtro de grupos)

-- Seleccionar los clientes que hayan realizado más de 10 pedidos
SELECT CustomerID, COUNT(*) AS [Número de Ordenes]
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT CustomerID, COUNT(*) AS [Número de Ordenes]
FROM Orders
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT CustomerID, ShipCountry, COUNT(*) AS [Número de Ordenes]
FROM Orders
WHERE ShipCountry IN ('Germany','France','Brazil')
GROUP BY CustomerID, ShipCountry
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

SELECT c.CompanyName, COUNT(*) AS [Número de Ordenes]
FROM Orders AS o
INNER JOIN
Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY CompanyName
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

-- Seleccionar los empleados que hayan gestionado pedidos por un total superior a 100,000 en ventas
-- (Mostrar el ID del empleado, el nombre y total de compras)

SELECT
	CONCAT(e.FirstName,' ', e.LastName) AS [Nombre Completo], 
	(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS [IMPORTE]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
ORDER BY e.FirstName;

SELECT
	CONCAT(e.FirstName,' ', e.LastName) AS [Nombre Completo], 
	ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2 ) AS [IMPORTE]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 100000
ORDER BY [IMPORTE] DESC;

-- Seleccionar el número de productos vendidos en más de 20 pedidos distintos
-- Mostrar el id del producto, el nombre del producto, el número de ordenes
SELECT 
	p.ProductID,
	p.ProductName,
	COUNT(DISTINCT o.OrderID) AS [Numero de Pedidos]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
INNER JOIN Orders AS o
ON o.OrderID = od.OrderID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(DISTINCT o.OrderID) > 20
ORDER BY 3 DESC

-- Seleccionar los productos no descontinuados, calcular el precio promedio vendido y
-- mostrar solo aquellos que se hayan vendido en menos de 15 pedidos
SELECT
	p.ProductName,
	AVG(od.UnitPrice) AS [Precio Promedio]
FROM Products AS p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID
WHERE p.Discontinued = 0
GROUP BY p.ProductName
HAVING COUNT(OrderID) < 15;

-- Seleccionar el precio máximo de productos por categoría, pero solo si la suma de unidades
-- es menor a 200 y además que no esten descontinuadas
SELECT 
	c.CategoryID,
	c.CategoryName,
	p.ProductName,
	MAX(p.UnitPrice) AS [Precio Maximo]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0
GROUP BY c.CategoryID, c.CategoryName, p.ProductName
HAVING SUM(p.UnitsInStock) < 200
ORDER BY CategoryName DESC, p.ProductName ASC