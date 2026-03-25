-- Subconsulta escalar (un valor)

-- Escalar en Select

SELECT 
	o.OrderID,
	(od.Quantity * od.UnitPrice) AS [Total],
	(SELECT AVG((od.Quantity * od.UnitPrice)) FROM [Order Details] AS od) AS [AVGTOTAL]
FROM Orders AS o
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID;

-- Mostrar el nombre del producto y el precio promedio de todos los productos

SELECT
	DISTINCT  p.ProductName,
	(SELECT AVG((od.UnitPrice)) FROM [Order Details] AS od)
	FROM Products AS p
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID;
	
-- Mostrar cada empleado y la cantidad total de pedidos que tiene (Subconsulta Correlacionada)

SELECT 
	e.EmployeeID,
	FirstName,
	Lastname,
	(
	SELECT COUNT(*)
	FROM Orders	AS o
	WHERE e.EmployeeID = o.EmployeeID
	) AS [N�mero de Pedidos]
FROM Employees AS e

SELECT 
	e.EmployeeID,
	FirstName,
	LastName,
	COUNT(o.OrderID) AS [Numero de Ordenes]
FROM Employees AS e
INNER JOIN Orders AS o
ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, FirstName, LastName;

SELECT *
FROM Employees


-- Mostrar cada cliente y la fecha de su ultimo pedido

-- Mostrar pedidos con nombre del cliente y total del pedido (sum)

SELECT
	o.OrderID,
	c.CompanyName,
	(SELECT SUM(od.Quantity * od.UnitPrice) 
	FROM [Order Details] AS od
	WHERE od.OrderID = o.OrderID) AS [Total]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID;

-- Datos de Ejemplo

CREATE DATABASE bdsubconsultas;
GO

USE bdsubconsultas;
GO

CREATE TABLE Clientes(
	id_cliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Nombre NVARCHAR(50) NOT NULL,
	Ciudad NCHAR(20) NOT NULL
);

CREATE TABLE Pedidos(
	id_pedido INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL,
	Total MONEY NOT NULL,
	Fecha DATE NOT NULL,
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (id_cliente)
	REFERENCES Clientes(id_cliente)
);

-- Consulta Escalar:

SELECT * FROM
[Order Details]


INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

-- Seleccionar los pedidos en donde  el total sea igual al total m�ximo de ellos

SELECT MAX(Total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE Total = (
	SELECT MAX(Total)
	FROM Pedidos
);

SELECT TOP 1 p.id_pedido, c.Nombre, p.Fecha, p.Total
FROM Pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
ORDER BY p.Total DESC;

SELECT p.id_pedido, c.Nombre, p.Fecha, p.Total
FROM Pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.Total = (
	SELECT MAX(Total)
	FROM Pedidos
);

SELECT * FROM Pedidos;
SELECT * FROM Clientes;

-- Seleccionar los pedidos mayores al promedio

SELECT AVG(Total)
FROM Pedidos;

SELECT * FROM
Pedidos
WHERE Total > (
	SELECT AVG(Total)
	FROM Pedidos
);

-- Seleccionar todos los pedidos del cliente que tenga el menor id

SELECT MIN(id_cliente)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM Pedidos
);

SELECT id_cliente, COUNT(*)	AS [N�mero de Pedidos]
FROM Pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM Pedidos
)
GROUP BY id_cliente;

-- Mostrar los datos del pedido de la �ltima orden

SELECT MAX(Fecha)
FROM Pedidos;

SELECT p.id_pedido, c.Nombre, p.Fecha, p.Total
FROM Pedidos AS p
INNER JOIN clientes AS c
ON p.id_cliente = c.id_cliente
WHERE Fecha = (
	SELECT MAX(Fecha)
	FROM Pedidos
);

-- Mostrar todos los pedidos con un total que sea el m�s bajo

SELECT MIN(Total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE Total = (
	SELECT MIN(Total)
	FROM Pedidos
);

-- Seleccionar los pedidos con el nombre del cliente cuyo total (Freight) sea
-- mayor al promedio general de FREIGHT

USE NORTHWND;

SELECT AVG(Freight)
FROM Orders;

SELECT o.OrderID, c.CompanyName, CONCAT(e.FirstName, ' ', e.LastName) AS [FULLNAME],
o.Freight
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
INNER JOIN Employees AS e
ON  e.EmployeeID = o.EmployeeID
WHERE o.Freight > (
	SELECT AVG(Freight)
	FROM Orders
)
ORDER BY o.Freight DESC;

-- Subqueries con IN, ANY, ALL (Llevan una sola columna)
-- La clausula IN

-- Clientes que han hecho pedidos

SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM Clientes AS c
INNER JOIN pedidos AS p
ON c.id_cliente = p.id_cliente;

-- Clientes que han pedido mayores a 800
SELECT id_cliente
FROM Pedidos
WHERE Total > 800;

SELECT *
FROM Pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
	WHERE Total > 800
);

-- Seleccionar todos los clientes de la ciudad de CDMX que hayan hecho pedidos
SELECT id_cliente
FROM Pedidos;

USE bdsubconsultas;

SELECT *
FROM Clientes
WHERE Ciudad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

-- Seleccionar clientes que no han hecho pedidos
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente NOT IN (
	SELECT id_cliente
	FROM Pedidos
);

SELECT *
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente;

SELECT c.id_cliente, c.Nombre, c.Ciudad
FROM Pedidos AS p
RIGHT JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL;

-- Seleccionar los pedidos de clientes de Monterrey
SELECT id_cliente
FROM Clientes
WHERE Ciudad = 'Monterrey';

SELECT *
FROM Pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Clientes
	WHERE Ciudad = 'Monterrey'
);

SELECT *
FROM clientes AS c
LEFT JOIN Pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE c.Ciudad = 'Monterrey';

-- Operador ANY

-- Seleccionar pedidos mayores que algún pedido de luis (id_cliente=2)

-- Primero la subconsulta

SELECT Total
FROM Pedidos
WHERE id_cliente = 2;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar los pedidos mayores (total) de algún pedido de Ana (id_cliente=1)
SELECT Total
FROM Pedidos
WHERE id_cliente = 1;

SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 1
);

-- Seleccionar los pedidos mayores que algún pedido superior (total) a 500

SELECT Total
FROM Pedidos
WHERE Total > 500;

SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE Total > 500
);

-- Operador ALL

-- Seleccionar los pedidos donde el total sea mayor a todos los totales de los pedidos de Luis

-- Subconsulta
SELECT Total
FROM Pedidos
WHERE id_cliente = 2;

SELECT Total
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE Total > ALL (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar todos los clientes donde su id sea menor que todos los clientes de la ciudad de México

SELECT id_cliente
FROM Clientes
WHERE Ciudad = 'CDMX';

SELECT *
FROM Clientes
WHERE id_cliente < ALL (
	SELECT id_cliente
	FROM Clientes
	WHERE Ciudad = 'CDMX'
);

-- Subconsulta Correlacionadas

SELECT SUM(Total)
FROM Pedidos AS p;

SELECT *
FROM Clientes AS c
WHERE (
	SELECT SUM(Total)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1000;

SELECT SUM(Total)
FROM Pedidos AS p
WHERE p.id_cliente = 1;

-- Seleccionar todos los clientes que han hecho más de un pedido

SELECT COUNT(*)
FROM Pedidos AS p
WHERE p.id_cliente = 2;

SELECT id_cliente, Nombre, Ciudad
FROM Clientes AS c
WHERE (
	SELECT COUNT(*)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1;

-- Seleccionar todos los pediddos en donde su total debe ser mayor al promedio de los totales hechos por los clientes

SELECT AVG(Total)
FROM Pedidos AS p
WHERE p.id_cliente;

SELECT *
FROM Pedidos AS p
WHERE Total > (
	SELECT AVG(Total)
	FROM Pedidos AS pe
	WHERE pe.id_cliente = p.id_cliente
);

-- Seleccionar todos los clientes cuyo pedido máximo sea mayor a 1200

SELECT MAX(Total)
FROM Pedidos AS p
WHERE p.id_cliente = 3;

SELECT id_cliente, Nombre, Ciudad
FROM Clientes AS c
WHERE (
	SELECT MAX(Total)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1200;




