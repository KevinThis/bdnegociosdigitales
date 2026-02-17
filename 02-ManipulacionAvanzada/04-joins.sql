/**
JOINS

1. INNER JOIN
2. LEFT JOIN
3. RIGHT JOIN
4. FULL JOIN
**/

-- Seleccionar las categorías y sus productos

SELECT 
	Categories.CategoryID, 
	Categories.CategoryName,
	Products.ProductID,
	Products.ProductName,
	Products.UnitPrice,
	Products.UnitsInStock,
	(Products.UnitPrice * Products.UnitsInStock) 
	AS [Precio Inventario]
FROM Categories
INNER JOIN Products
ON Categories.CategoryID = products.CategoryID
WHERE Categories.CategoryID = 9;