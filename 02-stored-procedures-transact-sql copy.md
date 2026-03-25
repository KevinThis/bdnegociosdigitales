# Stored Procedures (Procedimientos Almacenados) en Transact-SQL (SQL SERVER)

1️⃣ Fundamentos

- ¿Qué es un Stored Procedure?

Un **Stored Procedure (SP)** es un bloque de código SQL guardado dentro de la base de datos que puede ejecutarse cuando se necesite. Es decir es un **OBJETO DE LA BASE DE DATOS**

Es similar a una función o método en programación.

Ventajas

1. Reutilizar el código
2. Mejor Rendimiento
3. Mayor seguridad
4. Centralización de lógica de negocio
5. Menos tráfico entre aplicación y servidor

- Sintaxis

![SintaxisSQL](../../img/sp_sintaxis.png)

- Nomenclatura Recomendada

```
spu_<Entidad>_<Acción>
```

| Parte   | Significado                     | Ejemplo |
|--------|---------------------------------|--------|
| spu    | Stored Procedure User           | spu_   |
| Entidad| Tabla o concepto del negocio    | Cliente|
| Acción | Lo que hace                     | Insert |

- Acciones Estándar

Estas son las **acciones más usadas** en sistemas empresariales

| Acción     | Significado          | Ejemplo                |
| ---------- | -------------------- | ---------------------- |
| Insert     | Insertar registro    | spu_Cliente_Insert     |
| Update     | Actualizar           | spu_Cliente_Update     |
| Delete     | Eliminar             | spu_Cliente_Delete     |
| Get        | Obtener uno          | spu_Cliente_Get        |
| List       | Obtener varios       | spu_Cliente_List       |
| Search     | Búsqueda con filtros | spu_Cliente_Search     |
| Exists     | Validar si existe    | spu_Cliente_Exists     |
| Activate   | Activar registro     | spu_Cliente_Activate   |
| Deactivate | Desactivar           | spu_Cliente_Deactivate |

- Ejemplo completo

Suponer que tenemos una tabla cliente

🚀 Insertar Cliente
```
spu_Cliente_Insert
```

🚀 Actualizar Cliente
```
spu_Cliente_Update
```

🚀 Obtener Cliente por id
```
spu_Cliente_Get
```

🚀 Listar todos los Cliente
```
spu_Cliente_List
```

🚀 Buscar Cliente
```
spu_Cliente_Search
```

2️⃣ Parámetros en Stored Procedures

Los párametros permiten enviar datos al procedimiento

```sql
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
```

```sql
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

EXEC usp_nombre_mayusculas 'Pepe';
```

3️⃣ Parametros de salida

Los parametros OUTPUT devuelve valores al usuario

```sql

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
```

4️⃣ CASE 

Sirve para evaluar condiciones como un switch o if multiple

