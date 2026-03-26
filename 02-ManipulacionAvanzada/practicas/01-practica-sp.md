# Práctica: Venta con Store Procedure en SQL Server

## Objetivo
Resolver la práctica creando una base de datos llamada **bdpracticas**, sus tablas, la carga de catálogos desde **NORTHWND** y un **Store Procedure** llamado `usp_agregar_venta` con validaciones, `TRY...CATCH` y transacciones.

---

## 1. Base de datos
Se crea la base de datos:

```sql
CREATE DATABASE bdpracticas;
```

Después se selecciona para trabajar en ella:

```sql
USE bdpracticas;
```

---

## 2. Diseño lógico de las tablas
La práctica usa dos tablas de catálogo y dos tablas de operación.

### CatProducto
Guarda el catálogo de productos tomado de `NORTHWND.dbo.Products`.

Campos:
- `id_producto`: llave primaria, tipo `INT IDENTITY`
- `nombre_producto`: nombre del producto
- `existencia`: cantidad disponible en almacén
- `precio`: precio actual del producto

### CatCliente
Guarda el catálogo de clientes tomado de `NORTHWND.dbo.Customers`.

Campos:
- `cliente_id`: llave primaria, tipo `NCHAR(5)`
- `nombre_cliente`: nombre del cliente
- `pais`: país del cliente
- `ciudad`: ciudad del cliente

### TblVenta
Representa el encabezado de una venta.

Campos:
- `id_venta`: llave primaria, tipo `INT IDENTITY`
- `fecha`: fecha de la venta
- `id_cliente`: llave foránea hacia `CatCliente`

### TblDetalleVenta
Representa el detalle de la venta.

Campos:
- `id_venta`: llave foránea hacia `TblVenta`
- `id_producto`: llave foránea hacia `CatProducto`
- `precio_venta`: precio al momento de vender
- `cantidad_vendido`: cantidad vendida

Su llave primaria es compuesta:
- `(id_venta, id_producto)`

---

## 3. Relación entre tablas
Las relaciones quedan así:

- **CatCliente 1 : N TblVenta**
  - Un cliente puede tener muchas ventas.
  - Cada venta pertenece a un solo cliente.

- **TblVenta 1 : N TblDetalleVenta**
  - Una venta puede tener uno o varios detalles.
  - Cada detalle pertenece a una sola venta.

- **CatProducto 1 : N TblDetalleVenta**
  - Un producto puede aparecer en muchos detalles de venta.
  - Cada detalle usa un solo producto.

---

## 4. Carga de datos desde NORTHWND
Los catálogos no se llenan manualmente. Se cargan desde la base `NORTHWND`.

### CatProducto
Se toman estos datos de `NORTHWND.dbo.Products`:
- `ProductName` → `nombre_producto`
- `UnitsInStock` → `existencia`
- `UnitPrice` → `precio`

### CatCliente
Se toman estos datos de `NORTHWND.dbo.Customers`:
- `CustomerID` → `cliente_id`
- `CompanyName` → `nombre_cliente`
- `Country` → `pais`
- `City` → `ciudad`

Esto respeta lo que pidió el pizarrón: usar las tablas de catálogo como base de datos maestra para las ventas.

---

## 5. Lógica del Store Procedure `usp_agregar_venta`
El Store Procedure recibe:

- `@id_cliente`
- `@id_producto`
- `@cantidad_vendido`

Su proceso es este:

1. Inicia una transacción.
2. Verifica si el cliente existe en `CatCliente`.
3. Verifica si el producto existe en `CatProducto`.
4. Verifica que la cantidad vendida sea mayor a cero.
5. Obtiene el precio y la existencia actual del producto.
6. Verifica si hay existencia suficiente.
7. Inserta el encabezado en `TblVenta` usando la fecha actual con `GETDATE()`.
8. Inserta el detalle en `TblDetalleVenta`.
9. Actualiza la existencia en `CatProducto` con la operación:

```sql
existencia = existencia - cantidad_vendido
```

10. Si todo sale bien, hace `COMMIT`.
11. Si algo falla, hace `ROLLBACK` en el bloque `CATCH`.

---

## 6. Validaciones importantes
Para que la práctica tenga lógica y no se confundan los datos, se agregaron estas validaciones:

- No se permite vender a un cliente inexistente.
- No se permite vender un producto inexistente.
- No se permite vender cantidad cero o negativa.
- No se permite vender más piezas de las que existen.
- El precio de venta se toma directamente desde `CatProducto`, para evitar capturarlo manualmente y provocar errores.
- La venta y el detalle se guardan dentro de la misma transacción para que no queden datos incompletos.

---

## 7. Aclaración importante sobre la instrucción del pizarrón
En el pizarrón aparece una instrucción que dice algo como:

- “Verificar si el cliente existe. Si existe la Store termina”
- “Verificar si el producto existe. Si existe la Store termina”

Eso, lógicamente, produciría un error de negocio, porque si el cliente o el producto sí existen, entonces la venta sí debería continuar.

Por esa razón, la solución correcta se implementó así:

- **si el cliente no existe, la Store termina**
- **si el producto no existe, la Store termina**

Ese ajuste no contradice la práctica; al contrario, corrige la lógica del proceso.

---

## 8. Restricciones agregadas
Se agregaron restricciones para mejorar la integridad de los datos:

- `existencia >= 0`
- `precio >= 0`
- `cantidad_vendido > 0`
- `precio_venta >= 0`

Esto ayuda a que la base sea más consistente y profesional.

---

## 9. Ejemplo de ejecución
Ejemplo de venta correcta:

```sql
EXEC dbo.usp_agregar_venta
    @id_cliente = 'ALFKI',
    @id_producto = 1,
    @cantidad_vendido = 2;
```

### Posibles errores controlados
- `Error: el cliente no existe en CatCliente.`
- `Error: el producto no existe en CatProducto.`
- `Error: la cantidad_vendido debe ser mayor a cero.`
- `Error: no hay existencia suficiente para realizar la venta.`

---

## 10. Consultas para revisar resultados
```sql
SELECT * FROM dbo.CatCliente;
SELECT * FROM dbo.CatProducto;
SELECT * FROM dbo.TblVenta;
SELECT * FROM dbo.TblDetalleVenta;
```

---

## 11. Commit, merge y push
El commit solicitado sería:

```bash
git add .
git commit -m "Practica venta con Store Procedure"
```

Después haces merge a `main`:

```bash
git checkout main
git merge nombre-de-tu-rama
```

Y al final haces push:

```bash
git push origin main
```

---

## 12. Conclusión de la solución
La solución propuesta cumple la práctica porque:

- crea la base `bdpracticas`
- construye el diagrama relacional solicitado
- usa como origen los catálogos de `NORTHWND`
- implementa el Store Procedure con validaciones
- utiliza `TRY...CATCH` y transacciones
- actualiza la existencia del producto
- evita inconsistencias en la información