-- ============================================================
-- PRACTICA: VENTA CON STORED PROCEDURE
-- Base de datos: bdpracticas
-- Referencia: NORTHWND
-- ============================================================

-- 1) CREAR BASE DE DATOS
    CREATE DATABASE bdpracticas;
GO

USE bdpracticas;
GO

-- 2) ELIMINAR OBJETOS SI YA EXISTEN
IF OBJECT_ID('dbo.TblDetalleVenta', 'U') IS NOT NULL
    DROP TABLE dbo.TblDetalleVenta;
GO

IF OBJECT_ID('dbo.TblVenta', 'U') IS NOT NULL
    DROP TABLE dbo.TblVenta;
GO

IF OBJECT_ID('dbo.CatCliente', 'U') IS NOT NULL
    DROP TABLE dbo.CatCliente;
GO

IF OBJECT_ID('dbo.CatProducto', 'U') IS NOT NULL
    DROP TABLE dbo.CatProducto;
GO

IF OBJECT_ID('dbo.usp_agregar_venta', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_agregar_venta;
GO

-- 3) CREAR TABLAS
CREATE TABLE dbo.CatProducto
(
    Id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto NVARCHAR(40) NOT NULL,
    existencia INT NOT NULL,
    precio MONEY NOT NULL
);
GO

CREATE TABLE dbo.CatCliente
(
    Id_cliente NCHAR(5) PRIMARY KEY,
    nombre_cliente NVARCHAR(40) NOT NULL,
    pais NVARCHAR(15),
    ciudad NVARCHAR(15)
);
GO

CREATE TABLE dbo.TblVenta
(
    Id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    Id_cliente NCHAR(5) NOT NULL,
    CONSTRAINT FK_TblVenta_CatCliente
        FOREIGN KEY (Id_cliente) REFERENCES dbo.CatCliente(Id_cliente)
);
GO

CREATE TABLE dbo.TblDetalleVenta
(
    Id_venta INT NOT NULL,
    Id_producto INT NOT NULL,
    precio_venta MONEY NOT NULL,
    cantidad_vendido INT NOT NULL,
    CONSTRAINT PK_TblDetalleVenta PRIMARY KEY (Id_venta, Id_producto),
    CONSTRAINT FK_TblDetalleVenta_TblVenta
        FOREIGN KEY (Id_venta) REFERENCES dbo.TblVenta(Id_venta),
    CONSTRAINT FK_TblDetalleVenta_CatProducto
        FOREIGN KEY (Id_producto) REFERENCES dbo.CatProducto(Id_producto)
);
GO

-- 4) CARGAR DATOS DE CATALOGO DESDE NORTHWND
INSERT INTO dbo.CatProducto (nombre_producto, existencia, precio)
SELECT ProductName, UnitsInStock, UnitPrice
FROM NORTHWND.dbo.Products;
GO

INSERT INTO dbo.CatCliente (Id_cliente, nombre_cliente, pais, ciudad)
SELECT CustomerID, CompanyName, Country, City
FROM NORTHWND.dbo.Customers;
GO

-- 5) STORED PROCEDURE
CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta
    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendido INT
AS
BEGIN
    DECLARE @id_venta INT;
    DECLARE @precio_venta MONEY;
    DECLARE @existencia_actual INT;

    BEGIN TRY
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.CatCliente
            WHERE Id_cliente = @id_cliente
        )
        BEGIN
            THROW 50001, 'Error: el cliente no existe.', 1;
        END

        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.CatProducto
            WHERE Id_producto = @id_producto
        )
        BEGIN
            THROW 50002, 'Error: el producto no existe.', 1;
        END

        IF @cantidad_vendido <= 0
        BEGIN
            THROW 50003, 'Error: la cantidad vendida debe ser mayor a 0.', 1;
        END

        SELECT
            @precio_venta = precio,
            @existencia_actual = existencia
        FROM dbo.CatProducto
        WHERE Id_producto = @id_producto;

        IF @existencia_actual < @cantidad_vendido
        BEGIN
            THROW 50004, 'Error: no hay existencia suficiente.', 1;
        END

        BEGIN TRANSACTION;

        INSERT INTO dbo.TblVenta (fecha, Id_cliente)
        VALUES (CAST(GETDATE() AS DATE), @id_cliente);

        SET @id_venta = SCOPE_IDENTITY();

        INSERT INTO dbo.TblDetalleVenta (Id_venta, Id_producto, precio_venta, cantidad_vendido)
        VALUES (@id_venta, @id_producto, @precio_venta, @cantidad_vendido);

        UPDATE dbo.CatProducto
        SET existencia = existencia - @cantidad_vendido
        WHERE Id_producto = @id_producto;

        COMMIT;
        PRINT 'Venta registrada correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END

        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- 6) PRUEBAS
-- Venta válida
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ALFKI',
    @id_producto = 1,
    @cantidad_vendido = 5;
GO

-- Cliente que no existe
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ZZZZZ',
    @id_producto = 1,
    @cantidad_vendido = 2;
GO

-- Producto que no existe
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ALFKI',
    @id_producto = 9999,
    @cantidad_vendido = 2;
GO

-- Error en la cantidad de venta
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ALFKI',
    @id_producto = 1,
    @cantidad_vendido = 0;
GO

-- Error en la existencia
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ALFKI',
    @id_producto = 1,
    @cantidad_vendido = 99999;
GO

-- 7) CONSULTAS DE VERIFICACION
SELECT * FROM dbo.CatProducto;
SELECT * FROM dbo.CatCliente;
SELECT * FROM dbo.TblVenta;
SELECT * FROM dbo.TblDetalleVenta;
GO