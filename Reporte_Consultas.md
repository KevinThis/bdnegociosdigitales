# Documentación de scripts SQL - Consultas simples y Agregadas

## Índice

1. [Vista general](#vista-general)  
2. [01 SQL-LDD-LMD: Crear BD, tablas y restricciones](#01-sql-ldd-lmd-crear-bd-tablas-y-restricciones)  
3. [02 Consultas Simples - Consultas SELECT básicas](#02-consultas-simples---consultas-select-básicas)  
4. [03 Funciones de Agregado - GROUP BY y HAVING](#03-funciones-de-agregado---group-by-y-having)  

---

## Vista General

- **01 SQL-LDD**
  - Crea bases de datos y tablas, definiendo las restricciones (`PK`, `UNIQUE`, `CHECK`, `DEFAULT`), usa `IDENTITY`, crea relaciones con foreign keys y prueba de comportamientos `ON DELETE/ON UPDATE`.

- **02 Consultas Simples**
  - Muestra consultas `SELECT` típicas sobre tablas tipo Northwind (`Products`, `Orders`, `Customers`), proyecciones, alias, campos calculados, filtros `WHERE`, `IN`, `BETWEEN`, `LIKE`, `NULL`, y funciones de fecha.

- **03 Funciones de Agregado**
  - Usa funciones de agregado (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) y agrupa con `GROUP BY`, filtración de grupos con `HAVING`. También se realiza la agregación básica y agregación con `JOIN` por cliente, por empleado, por categoría, etc.

---

## 01 SQL-LDD-LMD: Crear BD, tablas y restricciones

### Objetivo del script
1) Crear bases de datos y tablas.  
2) Definir reglas para asegurar consistencia y restricciones.  
3) Insertar y modificar datos para comprobar que las reglas funcionan.

---

### 1) Crear base de datos y seleccionar el contexto

```sql
CREATE DATABASE tienda;
GO
USE tienda;
```
- `CREATE DATABASE` crea la BD.
- `USE` selecciona esa BD para que todo lo siguiente se ejecute ahí.
- `GO` separa “lotes” (batch). No es SQL puro; es del cliente/herramienta de SQL Server.

---

### 2) Crear tablas con tipos, NULL/NOT NULL y DEFAULT

```sql
CREATE TABLE cliente (
  id INT NOT NULL,
  nombre NVARCHAR(30) NOT NULL,
  amaterno NVARCHAR(10) NULL,
  limitecredito MONEY NOT NULL DEFAULT 500.0
);
```
- `NVARCHAR(n)`: texto Unicode.
- `NULL / NOT NULL`: permite o no valores vacíos.
- `DEFAULT 500.0`: si no se manda ese campo en el `INSERT`, se toma el valor 500.0.

---

### 3) Restricciones principales: PRIMARY KEY, UNIQUE, CHECK

```sql
CREATE TABLE suppliers (
  supplier_id INT NOT NULL IDENTITY(1,1),
  [name] NVARCHAR(30) NOT NULL,
  tipo CHAR(1) NOT NULL,
  credit_limit MONEY NOT NULL,

  CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id),
  CONSTRAINT unique_name UNIQUE ([name]),
  CONSTRAINT chk_credit_limit CHECK (credit_limit > 0.0 AND credit_limit <= 50000),
  CONSTRAINT chk_tipo CHECK (tipo IN ('A','B','C'))
);
```

- `PRIMARY KEY`: identifica de forma única cada registro y no permite NULL.
- `UNIQUE`: evita duplicados en una columna.
- `CHECK`: valida reglas rango de crédito y valores permitidos para cada tipo.
- `IDENTITY(1,1)`: genera el `supplier_id` automáticamente auto‑incremental.

---

### 4) INSERT: Formas típicas

```sql
-- Insert básico (mejor: siempre listar columnas)
INSERT INTO suppliers ([name], tipo, credit_limit)
VALUES (UPPER('coca-cola'), UPPER('a'), 36000);

-- Insert múltiple (más rápido para varios registros)
INSERT INTO clientes VALUES
(5, 'Soyla', 'Vaca', 'Del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'Sinsentido', 22, '1999-05-06', 85858);
```

- `UPPER()` convierte a mayúsculas.
- Insert múltiple mete varias filas en una sola instrucción.

**Nota importante (por `IDENTITY`):**
- Si una tabla tiene `IDENTITY`, lo normal es no insertar ese ID manualmente.  Forma correcta:

```sql
INSERT INTO clientes_2 (nombre, edad, limite_credito)
VALUES ('Chespirito', 78, 45500);
```

---

### 5) Claves foráneas FOREIGN KEY y reglas ON DELETE / ON UPDATE

En `dborders`, el script crea `products` y los liga a `suppliers`:

```sql
CREATE TABLE products (
  product_id INT NOT NULL IDENTITY(1,1),
  [name] NVARCHAR(40) NOT NULL,
  supplier_id INT NULL,
  CONSTRAINT pk_products PRIMARY KEY (product_id),
  CONSTRAINT fk_products_suppliers FOREIGN KEY (supplier_id)
    REFERENCES suppliers (supplier_id)
    ON DELETE SET NULL
    ON UPDATE SET NULL
);
```
- `FOREIGN KEY`: obliga a que `products.supplier_id` exista en `suppliers.supplier_id` (o sea `NULL`).
- `ON DELETE SET NULL`: si se borra un proveedor, los productos que lo referencian se quedan con `supplier_id = NULL` no se borran.
- `ON UPDATE SET NULL`: si se cambia el id del proveedor, los productos se quedan en `NULL`.

El script también contiene `NO ACTION`, que básicamente impide borrar/actualizar al “padre” si existen “hijos” apuntándole.

---

### 6) ALTER, DROP y Manejo de constraints

- **Quitar** una FK (`ALTER TABLE ... DROP CONSTRAINT`).
- **Borrar** tablas (`DROP TABLE`).
- **Cambiar** datos de una columna (`ALTER TABLE ... ALTER COLUMN`).

**Qué hace:** es el “mantenimiento” típico cuando cambias el diseño del esquema.

---

## 02 Consultas Simples - Consultas SELECT básicas

### Objetivo del script
Practicar consultas `SELECT` desde lo más simple hasta filtros y patrones, usando tablas estilo Northwind:

- `Products`, `Categories`, `Customers`, `Orders`, `[Order Details]`.

---

### 1) SELECT básico y proyección - Elegir columnas

```sql
SELECT *
FROM Products;

SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products;
```

- `SELECT *` trae todas las columnas.
- Proyección: trae solo lo necesario.

---

### 2) Alias

```sql
SELECT
  ProductID AS [NUMERO DE PRODUCTO],
  ProductName AS [NOMBRE DE PRODUCTO],
  UnitPrice AS [PRECIO UNITARIO]
FROM Products;
```

- `AS` renombra columnas para que el reporte sea legible.

---

### 3) Campos calculados

```sql
SELECT
  ProductID,
  UnitPrice,
  UnitsInStock,
  (UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;
```
- Calcula un valor “al vuelo” (precio × stock) sin guardarlo en la tabla.

---

### 4) TOP y ORDER BY - Limitar y Ordenar

```sql
SELECT TOP 10 *
FROM Products
ORDER BY UnitPrice DESC;
```

- `TOP 10` limita filas.
- `ORDER BY ... DESC` ordena de mayor a menor.

---

### 5) WHERE: Filtros con comparaciones y lógica (AND/OR/NOT)

```sql
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20 AND UnitsInStock < 100;
```

- Filtra productos por precio y stock al mismo tiempo.

---

### 6) NULL: Se compara con IS NULL / IS NOT NULL

```sql
SELECT CustomerID, OrderDate, ShipRegion
FROM Orders
WHERE ShipRegion IS NULL;
```

- Encuentra órdenes sin región asignada.

---

### 7) IN, BETWEEN, LIKE - Pertenencia, rangos y patrones

**IN - Lista**
```sql
SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');
```

**BETWEEN - Rango**
```sql
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
ORDER BY UnitPrice;
```

**LIKE - Patrón**
```sql
-- empieza con A
SELECT CustomerID, CompanyName
FROM Customers
WHERE CompanyName LIKE 'A%';

-- contiene "me"
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE City LIKE '%me%';
```
- `IN`: simplifica muchos `OR`.
- `BETWEEN`: rango inclusivo (incluye 20 y 40).
- `LIKE`: comodines `%` (cualquier cadena) y `_` (un carácter).

---

### 8) Funciones de fecha (YEAR/MONTH/DAY/DATEPART/DATENAME)

```sql
SELECT
  OrderID,
  OrderDate,
  YEAR(OrderDate) AS Año,
  DATEPART(QUARTER, OrderDate) AS Trimestre,
  DATENAME(WEEKDAY, OrderDate) AS DiaSemana
FROM Orders
WHERE OrderDate > '1997-12-31';
```

- Extrae partes de una fecha para análisis (por año, trimestre, día de la semana).

---

## 03 Funciones de Agregado - GROUP BY y HAVING

### Objetivo del script
1) Usar funciones que devuelven un solo resultado (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`).  
2) Agrupar resultados con `GROUP BY`.  
3) Filtrar grupos con `HAVING`.  
4) Combinar con `JOIN` para reportes reales.

---

### 1) DISTINCT y COUNT

```sql
SELECT DISTINCT Country
FROM Customers;

SELECT COUNT(*) AS [Total de Ordenes]
FROM Orders;
```

- `DISTINCT` quita duplicados.
- `COUNT(*)` cuenta filas (incluye aunque haya NULL en columnas).

Diferencia clave:
> - `COUNT(*)` cuenta filas.
> - `COUNT(columna)` cuenta solo filas donde esa columna **no es NULL**.

---

### 2) MAX / MIN

```sql
SELECT MAX(UnitPrice) AS [Precio más Alto]
FROM Products;

SELECT MIN(OrderDate) AS [Fecha más vieja]
FROM Orders;
```

- Encuentra el valor más alto / más bajo.

---

### 3) SUM y AVG - Sumas y Promedios

```sql
SELECT SUM(UnitPrice) AS [Suma de precios]
FROM Products;

SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS [Total de ventas]
FROM [Order Details];
```

- Suma precios o importes (incluyendo el descuento).

---

### 4) GROUP BY: Agregar por categoría, cliente, etc.

**Conteo de productos por categoría**.

```sql
SELECT CategoryID, COUNT(*) AS [Total de Productos]
FROM Products
GROUP BY CategoryID
ORDER BY [Total de Productos] DESC;
```

- Agrupa productos por `CategoryID`.
- Dentro de cada grupo cuenta cuántos productos hay.

**Promedio de precio por proveedor redondeado**

```sql
SELECT
  SupplierID,
  ROUND(AVG(UnitPrice), 2) AS PrecioPromedio
FROM Products
GROUP BY SupplierID
ORDER BY PrecioPromedio DESC;
```

---

### 5) JOIN + GROUP BY: Agregados por nombre de cliente

```sql
SELECT  
  c.CompanyName,
  COUNT(*) AS [Número de Ordenes]
FROM Orders AS o
INNER JOIN Customers AS c
  ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY [Número de Ordenes] DESC;
```

- Une órdenes con clientes.
- Cuenta cuántas órdenes hizo cada cliente.

---

### 6) HAVING: Filtrar grupos

**Clientes con más de 10 pedidos**.

```sql
SELECT CustomerID, COUNT(*) AS [Número de Ordenes]
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 10
ORDER BY [Número de Ordenes] DESC;
```

- `WHERE` filtra filas antes de agrupar.
- `HAVING` filtra después de agrupar (por eso puede usar `COUNT`, `SUM`, etc.).

---

### 7) Agregación con varias tablas - Ventas por empleado

```sql
SELECT
  CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre Completo],
  ROUND(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) AS [Importe]
FROM Employees AS e
INNER JOIN Orders AS o
  ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] AS od
  ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName
HAVING SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) > 100000
ORDER BY [Importe] DESC;
```

- Calcula ventas totales por empleado.
- Muestra solo quienes superan 100,000 en ventas.