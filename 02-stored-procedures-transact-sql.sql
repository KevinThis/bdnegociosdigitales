/* ============================ STORED PROCEDURES ============================ */

CREATE DATABASE bdstored;
GO

USE bdstored;
GO

-- Ejemplo Simple

CREATE PROCEDURE usp_Mensaje_Saludar
    -- No tendrá parámetros
AS
BEGIN
    PRINT 'Hola Mundo Transact SQL desde SQL SERVER';
END;
GO

-- Ejecutar
EXECUTE usp_Mensaje_Saludar;
GO

CREATE PROC usp_Mensaje_Saludar2
    -- No tendrá parámetros
AS
BEGIN
    PRINT 'Hola Mundo Ing en TI';
END;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar2;
GO

CREATE OR ALTER PROC usp_Mensaje_Saludar3
    -- No tendrá parámetros -- Para cambiar el nombre o datos
AS
BEGIN
    PRINT 'Hola Mundo Entornos Virtuales y Negocios Digitales';
END;
GO

-- Eliminar un SP
DROP PROCEDURE usp_Mensaje_Saludar3;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar3;
GO

-- Crear un SP que muestre la fecha actual del sistema
CREATE OR ALTER PROC usp_Servidor_FechaActual

AS
BEGIN
    SELECT CAST(GETDATE () AS DATE) AS [ FECHA DEL SISTEMA ]
END;
GO

-- Ejecutar
EXEC usp_Servidor_FechaActual;

-- Crear un SP que muestre el nombre de la base de datos (DB_NAME())
CREATE OR ALTER PROC spu_Dbname_get
AS
BEGIN
    SELECT
    HOST_NAME() AS [MACHINE],
    SUSER_NAME() AS [SQLUSER],
    SYSTEM_USER AS [SYSTEMUSER],
    DB_NAME() AS [DATABASE NAME],
    APP_NAME() AS [APPLICATION];
END;
GO

-- Ejecutar
EXEC spu_Dbname_get;
GO

/*=============================== STORED PROCEDURES CON PARÁMETROS===========================*/
CREATE OR ALTER PROC usp_persona_saludar
    @nombre VARCHAR(50) -- Parámetro de entrada
AS
BEGIN
    PRINT 'Hola ' + @nombre;
END;
GO

EXEC usp_persona_saludar 'Israel';
EXEC usp_persona_saludar 'Artemio';
EXEC usp_persona_saludar @Nombre = 'Bryan';

DECLARE @name VARCHAR(50);
SET @name = 'Yael';

EXEC usp_persona_saludar @name

/* Todo: Ejemplo con consultas, vamos a crear una tabla de clientes basada en la tabla de Customers de Northwind */
SELECT CustomerID, CompanyName
INTO Customers
FROM NORTHWND.dbo.Customers;
GO

-- Crear un SP que busque un cliente en específico
CREATE OR ALTER PROC spu_Customer_buscar
@id NCHAR(10)
AS
BEGIN

    SET @id = TRIM(@id);
    PRINT (@id)
    PRINT LEN(@id)

    IF LEN(@id) <= 0 OR LEN(@id) > 5
    BEGIN
        PRINT('El ID debe estar en el rango de 1 a 5 de tamaño');
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
    BEGIN
        SELECT CustomerID AS [Número], CompanyName AS [Cliente]
        FROM Customers
        WHERE CustomerID = @id;
    END
    ELSE
        PRINT 'El cliente no existe en la BD'
END;
GO

SELECT *
FROM Customers
WHERE CustomerID = '';

-- Ejecutar
EXEC spu_Customer_buscar 'YUTTT ';

SELECT 1
FROM NORTHWND.dbo.Categories
WHERE NOT EXISTS(
SELECT 1
FROM Customers
WHERE CustomerID = 'ANTONi');

-- Ejercicios: Crear un SP que reciba un número y que verifique que no sea negativo, si es negativo imprimir
-- valor no válido, y si no multiplicarlo por cinco y mostrarlo para mostrar usar un select
CREATE OR ALTER PROCEDURE usp_numero_multiplicar
@number INT
AS
BEGIN
    IF @number <= 0
    BEGIN
      PRINT 'El número no puede ser negativo ni cero'
      RETURN;
    END

      SELECT (@number * 5) AS [OPERACION];
END;
GO

EXEC usp_numero_multiplicar - 34;
EXEC usp_numero_multiplicar 0;
EXEC usp_numero_multiplicar 5;
GO

-- Ejercicio 2: Crear un SP que reciba un nombre y lo imprima en mayúsculas
CREATE OR ALTER PROCEDURE usp_nombre_mayusculas
@name VARCHAR(15)
AS
BEGIN
    SELECT UPPER(@name) AS [NAME]
END;
GO
EXEC usp_nombre_mayusculas 'Pepe';
GO
/* ========================= Parametros de salida ============================*/

CREATE OR ALTER PROC spu_numeros_sumar
    @a INT,
    @b INT,
    @resultado INT OUTPUT
AS
BEGIN
    SET @resultado = @a + @b
END;
GO

DECLARE @res INT
EXEC spu_numeros_sumar 5,7, @res OUTPUT
SELECT @res AS [Resultado]
GO

CREATE OR ALTER PROC spu_numeros_sumar2
    @a INT,
    @b INT,
    @resultado INT OUTPUT
AS
BEGIN
    SELECT @resultado = @a + @b
END;
GO

DECLARE @res INT
EXEC spu_numeros_sumar2 5,7, @res OUTPUT
SELECT @res AS [Resultado]
GO

-- Crear un sp que devuelva el area en un circulo
CREATE OR ALTER PROC spu_area_circulo
@radio DECIMAL(10,2),
@area DECIMAL(10,2) OUTPUT
AS
BEGIN
    -- SET @area = PI() * @radio = @radio
    SET @area = PI() * @radio * @radio
END;
GO

DECLARE @r DECIMAL(10,2)
EXEC spu_area_circulo 2,4, @r OUTPUT;
SELECT  @r AS [area del circulo];
GO

-- Crear un sp que reciba un id_cliente y devuelve el nombre
CREATE OR ALTER PROC spu_cliente_obtener
 @id NCHAR(10),
 @nombre NVARCHAR(40)
AS 
BEGIN
    IF LEN(@id) = 5
    BEGIN
        IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
        BEGIN
            SELECT @nombre = CompanyName
            FROM Customers
            WHERE CustomerID = @id
            RETURN;
        END
        PRINT 'El customer no existe';
        RETURN;
    END
    PRINT 'El id debe ser de tamaño 5';
END;
GO

DECLARE @nombre NVARCHAR(40)
EXEC spu_cliente_obtener 'ANTON', @nombre OUTPUT
SELECT @nombre AS [Nombre del cliente];
GO

/*========================== CASE ==================================*/

CREATE OR ALTER PROC spu_evaluar_Calificacion
@calif INT
AS
BEGIN
    SELECT 
        CASE 
            WHEN @calif >= 90 THEN 'Excelente'
            WHEN @calif >= 70 THEN 'Aprobado' 
            WHEN @calif >= 60 THEN 'Regular'
            ELSE 'No lo aprueba Kanye West'
        END AS [Resultado]
END;

EXEC spu_evaluar_Calificacion 100;
EXEC spu_evaluar_Calificacion 75;
EXEC spu_evaluar_Calificacion 55;
EXEC spu_evaluar_Calificacion 65;
GO

-- Case dentro de un select caso real
USE NORTHWND;

SELECT * FROM NORTHWND.dbo.Products;

CREATE TABLE bdstored.dbo.Productos
(
    nombre VARCHAR(50),
    precio MONEY
);

-- Inserta los datos basados en la consulta (Select)
INSERT INTO bdstored.dbo.Productos
SELECT 
    ProductName, UnitPrice
FROM NORTHWND.dbo.Products;

SELECT * FROM bdstored.dbo.Productos
GO

-- Ejercicio con CASE

SELECT 
    nombre, precio,
    CASE  
        WHEN precio >= 200 THEN 'Caro'
        WHEN precio >= 100 THEN 'Medio'
        ELSE 'Barato'
        END AS [Categoria]
FROM bdstored.dbo.Productos;


-- Selecciona los clientes con su nombre, pais,ciudad, region (Los valores NULOS visualizalos con la leyenda SIN REGION,
-- ademas quiero que todo el resultado en mayusculas )
USE NORTHWND;
GO

CREATE OR ALTER VIEW vw_buena
AS
SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(C.Country) AS [Country],
    UPPER(C.City) AS [City],
    UPPER(ISNULL(C.Region,'Sin Region')) AS [Region Limpia],
    UPPER(CONCAT(E.FirstName,' ',E.LastName)) AS [Full Name],
    ROUND(SUM(OD.Quantity * OD.UnitPrice),2) AS [Total],
    CASE 
     WHEN SUM(OD.Quantity * OD.UnitPrice) >=30000 AND SUM(OD.Quantity * OD.UnitPrice) <= 60000 THEN 'GOLD'
     WHEN SUM(OD.Quantity * OD.UnitPrice) >=10000 AND SUM(OD.Quantity * OD.UnitPrice) < 30000 THEN 'SILVER'
     ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS C
INNER JOIN
NORTHWND.dbo.Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Employees AS E
ON E.EmployeeID = O.EmployeeID
GROUP BY CompanyName, C.City, C.Country, C.Region,CONCAT(E.FirstName,' ',E.LastName); 
GO

CREATE OR ALTER PROC spu_informe_clientes_empleados
@nombre VARCHAR(50),
@region VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM vw_buena
    WHERE [Full Name] = @nombre
    AND [Region Limpia] = @region
END;

EXEC spu_informe_clientes_empleados 'andrew fuller', 'sin region'

SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(C.Country) AS [Country],
    UPPER(C.City) AS [City],
    UPPER(ISNULL(C.Region,'Sin Region')) AS [Region Limpia],
    UPPER(CONCAT(E.FirstName,' ',E.LastName)) AS [Full Name],
    ROUND(SUM(OD.Quantity * OD.UnitPrice),2) AS [Total],
    CASE 
     WHEN SUM(OD.Quantity * OD.UnitPrice) >=30000 AND SUM(OD.Quantity * OD.UnitPrice) <= 60000 THEN 'GOLD'
     WHEN SUM(OD.Quantity * OD.UnitPrice) >=10000 AND SUM(OD.Quantity * OD.UnitPrice) < 30000 THEN 'SILVER'
     ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS C
INNER JOIN
NORTHWND.dbo.Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Employees AS E
ON E.EmployeeID = O.EmployeeID
WHERE UPPER(CONCAT(E.FirstName,' ',E.LastName)) = UPPER('ANDREW FULLER')
AND   UPPER(ISNULL(C.Region,'Sin Region')) =   UPPER('Sin Region')
GROUP BY CompanyName, C.City, C.Country, C.Region,CONCAT(E.FirstName,' ',E.LastName)
ORDER BY [Total] DESC; 