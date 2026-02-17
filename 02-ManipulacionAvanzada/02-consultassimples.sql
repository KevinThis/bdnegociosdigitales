-- Consultas simples con SQL-LMD

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

-- Proyección (seleccionar algunos campos)

SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock
FROM Products;

-- Alias de columnas

SELECT 
	ProductID AS [NUMERO DE PRODUCTO], 
	ProductName 'NOMBRE DE PRODUCTO', 
	UnitPrice AS [PRECIO UNITARIO], 
	UnitsInStock AS STOCK
FROM Products;

SELECT 
	CompanyName AS CLIENTE,
	City AS CIUDAD,
	Country AS PAÍS
FROM Customers;

-- Campos calculados

-- Seleccionar los productos y calcular el valor del inventario
SELECT *,(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock,
	(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

-- Calcular el importe de venta
SELECT 
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	(UnitPrice * Quantity) AS IMPORTE
FROM [Order Details];

SELECT *
FROM [Order Details]
-- Seleccionar la venta con el calculo del importe con descuento