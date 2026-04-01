# Práctica de stored procedure: Venta con varios productos

## Objetivo

Para resolver la práctica se utilizó un **TYPE** como tabla tipo y un **stored procedure** que recibe el cliente y el detalle de productos vendidos.

La tabla tipo permite enviar varios productos en un solo parámetro, por lo que no es necesario ejecutar una venta por cada artículo.

## Base de datos
Se utilizo la siguiente base de datos.

![alt text](/img/coda.png)

## Tabla type

![alt text](/img/coda1.png)

Esta tabla tipo se usa para recibir el detalle de la venta. En ella se envían:

- `Id_producto`: identificador del producto.
- `cantidad_vendido`: cantidad que se desea vender.

## Stored procedure

El procedimiento creado fue `dbo.usp_agregar_venta_productos`.

Recibe dos parámetros:

- `@id_cliente`: cliente al que se le registra la venta.
- `@detalle`: tabla tipo con los productos y cantidades.



## Validaciones realizadas

Antes de guardar la venta, el procedimiento revisa varias condiciones para evitar errores en los datos.

### 1. Validación del cliente
Se verifica que el cliente exista en la tabla `CatCliente`.

Si no existe, se genera el mensaje:

```sql
THROW 50001, 'Error: el cliente no existe.', 1;
```

### 2. Validación de productos enviados
Se comprueba que la tabla `@detalle` tenga al menos un registro.

Si no se envían productos, se genera el mensaje:

```sql
THROW 50002, 'Error: debe enviar al menos un producto.', 1;
```

### 3. Validación de cantidades
Se revisa que la cantidad vendida sea mayor a 0.

Si alguna cantidad es menor o igual a 0, se genera el mensaje:

```sql
THROW 50003, 'Error: la cantidad vendida debe ser mayor a 0.', 1;
```

### 4. Validación de productos repetidos
Se valida que el mismo producto no se repita dentro de `@detalle`.

Si hay productos duplicados, se genera el mensaje:

```sql
THROW 50004, 'Error: no se debe repetir el mismo producto.', 1;
```

### 5. Validación de existencia del producto
Se comprueba que todos los productos enviados existan en `CatProducto`.

Si alguno no existe, se genera el mensaje:

```sql
THROW 50005, 'Error: uno o más productos no existen.', 1;
```

### 6. Validación de inventario suficiente
Se valida que la cantidad solicitada no sea mayor a la existencia disponible.

Si no hay suficiente inventario, se genera el mensaje:

```sql
THROW 50006, 'Error: no hay existencia suficiente.', 1;
```

![alt text](/img/coda2.png)

## Proceso que realiza el stored procedure

Después de pasar las validaciones, el procedimiento ejecuta la venta dentro de una transacción.

### 1. Inicia transacción
Se usa `BEGIN TRANSACTION` para asegurar que toda la operación se complete correctamente.

### 2. Inserta la venta
Se guarda el encabezado de la venta en `TblVenta` con la fecha actual y el cliente.

```sql
INSERT INTO dbo.TblVenta (fecha, Id_cliente)
VALUES (CAST(GETDATE() AS DATE), @id_cliente);
```

### 3. Obtiene el id de la venta
Se recupera el identificador generado con:

```sql
SET @id_venta = SCOPE_IDENTITY();
```

Esto permite relacionar la venta principal con sus productos en el detalle.

### 4. Inserta el detalle de la venta
Se agregan los productos vendidos a `TblDetalleVenta`, tomando el precio actual desde `CatProducto`.

### 5. Actualiza existencias
Después de registrar la venta, se descuenta del inventario la cantidad vendida de cada producto.

```sql
UPDATE p
SET p.existencia = p.existencia - d.cantidad_vendido
FROM dbo.CatProducto p
INNER JOIN @detalle d
    ON p.Id_producto = d.Id_producto;
```

### 6. Confirma la operación
Si todo sale bien, se ejecuta `COMMIT` y se muestra el mensaje:

```sql
PRINT 'Venta registrada correctamente.';
```

### 7. Manejo de errores
Si ocurre algún problema, se ejecuta `ROLLBACK` para deshacer la operación y se muestra el error con `ERROR_MESSAGE()`.

## Prueba realizada

Para probar el procedimiento se declaró una variable del tipo `dbo.TypeDetalleVenta` y se insertaron dos productos:

![alt text](/img/coda3.png)

Después se ejecutó el procedimiento:

```sql
EXEC dbo.usp_agregar_venta_productos
    @id_cliente = 'ALFKI',
    @detalle = @productos;
```

## Consultas de verificación

Al final se usaron consultas para comprobar que la venta se registró correctamente.

### 1. Verificación en `TblVenta`
Permite confirmar que se creó el encabezado de la venta con su cliente y fecha.

```sql
SELECT * FROM dbo.TblVenta;
```

### 2. Verificación en `TblDetalleVenta`
Permite comprobar que los productos quedaron guardados dentro de la misma venta.

```sql
SELECT * FROM dbo.TblDetalleVenta;
```

### 3. Verificación en `CatProducto`
Permite revisar que la existencia de los productos vendidos disminuyó correctamente.

```sql
SELECT * FROM dbo.CatProducto WHERE Id_producto IN (1, 2);
```

## Resultado observado

Los resultados esperados son los siguientes:

- En `TblVenta` debe aparecer una venta registrada para el cliente `ALFKI`.
- En `TblDetalleVenta` deben aparecer dos registros, uno por cada producto vendido.
- En `CatProducto` deben mostrarse los productos `1` y `2` con la existencia actualizada después de la venta.

![alt text](/img/coda4.png)

![alt text](/img/coda5.png)
