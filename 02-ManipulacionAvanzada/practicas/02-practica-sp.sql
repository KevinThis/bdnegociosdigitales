USE bdpracticas;
GO

-- El TYPE se crea solo una vez. Si ya existe, no se vuelve a ejecutar.

CREATE TYPE dbo.TypeDetalleVenta AS TABLE
(
    Id_producto INT NOT NULL,
    cantidad_vendido INT NOT NULL
);
GO

-- STORED PROCEDURE. Registrar una venta con varios productos
CREATE OR ALTER PROCEDURE dbo.usp_agregar_venta_productos
    @id_cliente NCHAR(5),
    @detalle dbo.TypeDetalleVenta READONLY
AS
BEGIN
    DECLARE @id_venta INT;

    BEGIN TRY

        -- Validar que el cliente exista
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.CatCliente
            WHERE Id_cliente = @id_cliente
        )
        BEGIN
            THROW 50001, 'Error: el cliente no existe.', 1;
        END

        -- Validar que se hayan enviado productos
        IF NOT EXISTS
        (
            SELECT 1
            FROM @detalle
        )
        BEGIN
            THROW 50002, 'Error: debe enviar al menos un producto.', 1;
        END

        -- Validar cantidades mayores a 0
        IF EXISTS
        (
            SELECT 1
            FROM @detalle
            WHERE cantidad_vendido <= 0
        )
        BEGIN
            THROW 50003, 'Error: la cantidad vendida debe ser mayor a 0.', 1;
        END

        -- Validar que no se repita el mismo producto
        IF EXISTS
        (
            SELECT Id_producto
            FROM @detalle
            GROUP BY Id_producto
            HAVING COUNT(*) > 1
        )
        BEGIN
            THROW 50004, 'Error: no se debe repetir el mismo producto.', 1;
        END

        -- Validar que los productos existan 
        IF EXISTS
        (
            SELECT 1
            FROM @detalle d
            LEFT JOIN dbo.CatProducto p
                ON d.Id_producto = p.Id_producto
            WHERE p.Id_producto IS NULL
        )
        BEGIN
            THROW 50005, 'Error: uno o más productos no existen.', 1;
        END

        -- Validar existencia suficiente
        IF EXISTS
        (
            SELECT 1
            FROM @detalle d
            INNER JOIN dbo.CatProducto p
                ON d.Id_producto = p.Id_producto
            WHERE d.cantidad_vendido > p.existencia
        )
        BEGIN
            THROW 50006, 'Error: no hay existencia suficiente.', 1;
        END

        BEGIN TRANSACTION;

            -- Insertar encabezado de venta
            INSERT INTO dbo.TblVenta (fecha, Id_cliente)
            VALUES (CAST(GETDATE() AS DATE), @id_cliente);

            SET @id_venta = SCOPE_IDENTITY();

            -- Insertar detalle de venta
            INSERT INTO dbo.TblDetalleVenta
            (
                Id_venta,
                Id_producto,
                precio_venta,
                cantidad_vendido
            )
            SELECT
                @id_venta,
                d.Id_producto,
                p.precio,
                d.cantidad_vendido
            FROM @detalle d
            INNER JOIN dbo.CatProducto p
                ON d.Id_producto = p.Id_producto;

            -- Actualizar existencias
            UPDATE p
            SET p.existencia = p.existencia - d.cantidad_vendido
            FROM dbo.CatProducto p
            INNER JOIN @detalle d
                ON p.Id_producto = d.Id_producto;

        COMMIT;
        PRINT 'Venta registrada correctamente.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Prueba del Procedimiento
DECLARE @productos AS dbo.TypeDetalleVenta;

INSERT INTO @productos (Id_producto, cantidad_vendido)
VALUES
    (1, 2),
    (2, 5);

EXEC dbo.usp_agregar_venta_productos
    @id_cliente = 'ALFKI',
    @detalle = @productos;
GO

-- Consultas de verificación
SELECT * FROM dbo.TblVenta;
SELECT * FROM dbo.TblDetalleVenta;
SELECT * FROM dbo.CatProducto WHERE Id_producto IN (1, 2);
GO