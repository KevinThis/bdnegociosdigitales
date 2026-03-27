# Proceso de la práctica

## 1. Creación de la base de datos
Primero se crea la base de datos `bdpracticas` y después se selecciona para trabajar en ella.

![alt text](/img/imaga.png)

## 2. Eliminación de objetos anteriores
Antes de crear todo de nuevo, se eliminan las tablas y el procedimiento almacenado si ya existen. Esto se hace para evitar errores al ejecutar varias veces el script.

Se eliminan los siguientes objetos:
- `TblDetalleVenta`
- `TblVenta`
- `CatCliente`
- `CatProducto`
- `usp_agregar_venta`

![alt text](/img/imaga2.png)

## 3. Creación de tablas
Después se crean las tablas necesarias para la práctica.

### `CatProducto`
Guarda la información de los productos:
- id del producto
- nombre
- existencia
- precio

### `CatCliente`
Guarda la información de los clientes:
- id del cliente
- nombre
- país
- ciudad

### `TblVenta`
Guarda la venta principal:
- id de la venta
- fecha
- cliente

### `TblDetalleVenta`
Guarda el detalle de la venta:
- id de la venta
- id del producto
- precio de venta
- cantidad vendida

Además, se usan llaves foráneas para relacionar correctamente las tablas.

![alt text](/img/imaga3.png)

## 4. Carga de datos
Una vez creadas las tablas, se cargan datos desde la base `NORTHWND`.

- Los productos se insertan en `CatProducto`
- Los clientes se insertan en `CatCliente`

Esto permite trabajar con información real para hacer las pruebas del procedimiento.

![alt text](/img/imaga4.png)

## 5. Creación del stored procedure
Se crea el procedimiento almacenado `usp_agregar_venta`, el cual recibe tres datos:

- `@id_cliente`
- `@id_producto`
- `@cantidad_vendido`

Este procedimiento se encarga de registrar una venta completa.

![alt text](/img/imaga5.png)

## 6. Validaciones realizadas
Antes de guardar la venta, el procedimiento revisa varias condiciones.

### Cliente
Se verifica que el cliente exista. Si no existe, se usa `THROW` para mostrar el error.

### Producto
Se verifica que el producto exista. Si no existe, también se usa `THROW`.

### Cantidad
Se revisa que la cantidad vendida sea mayor a 0. Si no cumple, se genera error.

### Existencia
Se consulta la existencia actual del producto. Si no hay suficiente stock, se muestra error.

![alt text](/img/imaga6.png)

## 7. Registro de la venta
Si todas las validaciones son correctas, entonces se realiza el proceso de venta:

1. Se inicia una transacción con `BEGIN TRANSACTION`
2. Se inserta la venta en `TblVenta`
3. Se obtiene el id de la venta con `SCOPE_IDENTITY()`
4. Se inserta el detalle en `TblDetalleVenta`
5. Se actualiza la existencia del producto en `CatProducto`
6. Se guarda todo con `COMMIT`

## 8. Manejo de errores
El procedimiento usa `TRY...CATCH` para controlar errores.

- Si todo sale bien, la venta se guarda correctamente.
- Si ocurre un error, se ejecuta `ROLLBACK` para deshacer los cambios.

Esto ayuda a que la información no quede incompleta.

## 9. Pruebas realizadas
Se ejecutaron varias pruebas para comprobar el funcionamiento del procedimiento:

- venta correcta
- cliente inexistente
- producto inexistente
- cantidad inválida
- existencia insuficiente

Estas pruebas sirven para comprobar que las validaciones funcionan y que el procedimiento responde correctamente en cada caso.

## 10. Consultas de verificación
Al final del script se ejecutan consultas `SELECT` para revisar la información guardada en las tablas:

- `CatProducto`
- `CatCliente`
- `TblVenta`
- `TblDetalleVenta`

Estas consultas permiten comprobar si la venta se registró correctamente y si la existencia del producto cambió como debía.

![alt text](/img/imaga7.png)