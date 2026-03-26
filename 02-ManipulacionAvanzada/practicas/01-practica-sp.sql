-- ============================================================
-- PRACTICA: VENTA CON STORED PROCEDURE
-- Base de datos: bdpracticas
-- Referencia: NORTHWND
--
-- Esta version esta alineada a lo visto en clase:
-- - CREATE OR ALTER PROCEDURE
-- - IF / NOT EXISTS / RETURN
-- - PRINT para mensajes de validacion
-- - TRY...CATCH
-- - BEGIN TRANSACTION / COMMIT / ROLLBACK
-- - SCOPE_IDENTITY()
-- ============================================================


-- ============================================================
-- 1) CREAR BASE DE DATOS
-- ============================================================
IF DB_ID('bdpracticas') IS NULL
BEGIN
    CREATE DATABASE bdpracticas;
END
GO

USE bdpracticas;
GO


-- ============================================================
-- 2) ELIMINAR OBJETOS SI YA EXISTEN
--    Se elimina en orden inverso para no chocar con las FK.
-- ============================================================
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


-- ============================================================
-- 3) CREAR TABLAS
-- ============================================================
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


-- ============================================================
-- 4) CARGAR DATOS DE CATALOGO DESDE NORTHWND
-- ============================================================
INSERT INTO dbo.CatProducto (nombre_producto, existencia, precio)
SELECT
    ProductName,
    UnitsInStock,
    UnitPrice
FROM NORTHWND.dbo.Products
ORDER BY ProductID;
GO

INSERT INTO dbo.CatCliente (Id_cliente, nombre_cliente, pais, ciudad)
SELECT
    CustomerID,
    CompanyName,
    Country,
    City
FROM NORTHWND.dbo.Customers
ORDER BY CustomerID;
GO


-- ============================================================
-- 5) STORED PROCEDURE
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta
    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendido INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_venta INT;
    DECLARE @precio_venta MONEY;
    DECLARE @existencia_actual INT;

    -- Validar cliente
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CatCliente
        WHERE Id_cliente = @id_cliente
    )
    BEGIN
        PRINT 'Error: el cliente no existe.';
        RETURN;
    END

    -- Validar producto
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CatProducto
        WHERE Id_producto = @id_producto
    )
    BEGIN
        PRINT 'Error: el producto no existe.';
        RETURN;
    END

    -- Validar cantidad
    IF @cantidad_vendido <= 0
    BEGIN
        PRINT 'Error: la cantidad_vendido debe ser mayor a 0.';
        RETURN;
    END

    -- Obtener precio y existencia actual del producto
    SELECT
        @precio_venta = precio,
        @existencia_actual = existencia
    FROM dbo.CatProducto
    WHERE Id_producto = @id_producto;

    -- Validar existencia suficiente
    IF @existencia_actual < @cantidad_vendido
    BEGIN
        PRINT 'Error: no hay existencia suficiente.';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar venta con la fecha actual
        INSERT INTO dbo.TblVenta (fecha, Id_cliente)
        VALUES (CAST(GETDATE() AS DATE), @id_cliente);

        SET @id_venta = SCOPE_IDENTITY();

        -- Insertar detalle de venta
        INSERT INTO dbo.TblDetalleVenta (Id_venta, Id_producto, precio_venta, cantidad_vendido)
        VALUES (@id_venta, @id_producto, @precio_venta, @cantidad_vendido);

        -- Actualizar existencia del producto
        UPDATE dbo.CatProducto
        SET existencia = existencia - @cantidad_vendido
        WHERE Id_producto = @id_producto;

        COMMIT TRANSACTION;

        PRINT 'Venta registrada correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- ============================================================
-- 6) PRUEBAS
-- ============================================================
-- Prueba correcta
EXEC dbo.usp_agregar_venta 'ALFKI', 1, 5;
GO

-- Cliente no existente
EXEC dbo.usp_agregar_venta 'ZZZZZ', 1, 2;
GO

-- Producto no existente
EXEC dbo.usp_agregar_venta 'ALFKI', 9999, 2;
GO

-- Cantidad invalida
EXEC dbo.usp_agregar_venta 'ALFKI', 1, 0;
GO

-- Sin existencia suficiente
EXEC dbo.usp_agregar_venta 'ALFKI', 1, 99999;
GO


-- ============================================================
-- 7) CONSULTAS DE VERIFICACION
-- ============================================================
SELECT * FROM dbo.CatProducto;
SELECT * FROM dbo.CatCliente;
SELECT * FROM dbo.TblVenta;
SELECT * FROM dbo.TblDetalleVenta;
GO
