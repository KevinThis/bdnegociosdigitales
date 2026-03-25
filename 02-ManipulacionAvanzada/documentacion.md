# ¿Qué es una subconsulta?

Una subconsulta (subquery) es un select dentro de otro SELECT. Puede devolver:

1. Un solo valor (escalar)
1. Una lista de valores (una columna, varias filas)
1. Una tabla (varias columnas y/o varias filas)
1. Según lo que devuelva, se elige el operador correcto (=, IN, EXISTS, etc).


Una subconsulta es una consulta anidada dentro de otra consulta que permite 
resolver problemas en varios niveles de información

```
Dependiendo de donde se coloque y que retorne, cambia su comportamiento.
```

5 grandes formas de usarlas:

1. Subconsultas escalares.
2. Subconsultas con IN, ANY, ALL.
3. Subconsultas correlacionadas. 
4. Subconsultas en Select.
5. Subconsultas en From (Tablas derivadas).

## Escalares

Devuelve un único valor, por eso se pueden utilizar con
operadores (=, >, <).

Ejemplo:

```sql
SELECT *
FROM Pedidos
WHERE Total = (
	SELECT MAX(Total)
	FROM Pedidos
);
``` 

## Subconsultas con IN, ANY, ALL

Devuelve varios valores con una sola columna (IN)

> Seleccionar todos los clientes que han hecho pedidos
```sql
-- Clientes que han hecho pedidos

SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM Clientes AS c
INNER JOIN pedidos AS p
ON c.id_cliente = p.id_cliente;

-- Clientes que han pedido mayores a 800
SELECT id_cliente
FROM Pedidos
WHERE Total > 800;

SELECT *
FROM Pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
	WHERE Total > 800
);

-- Seleccionar todos los clientes de la ciudad de CDMX que hayan hecho pedidos
SELECT id_cliente
FROM Pedidos;

USE bdsubconsultas;

SELECT *
FROM Clientes
WHERE Ciudad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

-- Seleccionar clientes que no han hecho pedidos
SELECT id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente NOT IN (
	SELECT id_cliente
	FROM Pedidos
);

SELECT *
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente;

SELECT c.id_cliente, c.Nombre, c.Ciudad
FROM Pedidos AS p
RIGHT JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL;

-- Seleccionar los pedidos de clientes de Monterrey
SELECT id_cliente
FROM Clientes
WHERE Ciudad = 'Monterrey';

SELECT *
FROM Pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM Clientes
	WHERE Ciudad = 'Monterrey'
);

SELECT *
FROM clientes AS c
LEFT JOIN Pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE c.Ciudad = 'Monterrey';
```

## Clausula ANY

- Compara un valor contra una lista
- La condición se cumple si se cumple con AL MENOS UNO

```sql
Valor > ANY (subconsulta)
```

> Es como decir: Mayor que al menos uno de los valores

- Seleccionar pedidos mayores que algún pedido de luis (id_cliente=2)

```sql
-- Operador ANY

-- Seleccionar pedidos mayores que algún pedido de luis (id_cliente=2)

-- Primero la subconsulta

SELECT Total
FROM Pedidos
WHERE id_cliente = 2;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar los pedidos mayores (total) de algún pedido de Ana (id_cliente=1)
SELECT Total
FROM Pedidos
WHERE id_cliente = 1;

SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 1
);

-- Seleccionar los pedidos mayores que algún pedido superior (total) a 500

SELECT Total
FROM Pedidos
WHERE Total > 500;

SELECT *
FROM Pedidos
WHERE Total > ANY (
	SELECT Total
	FROM Pedidos
	WHERE Total > 500
);
```

## Clausula ALL
Se cumple contra todos los valores

```sql
valor > ALL (subconsulta)
```
Significa:

- Mayor que todos los valores

```sql
-- Operador ALL

-- Seleccionar los pedidos donde el total sea mayor a todos los totales de los pedidos de Luis

-- Subconsulta
SELECT Total
FROM Pedidos
WHERE id_cliente = 2;

SELECT Total
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE Total > ALL (
	SELECT Total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar todos los clientes donde su id sea menor que todos los clientes de la ciudad de México

SELECT id_cliente
FROM Clientes
WHERE Ciudad = 'CDMX';

SELECT *
FROM Clientes
WHERE id_cliente < ALL (
	SELECT id_cliente
	FROM Clientes
	WHERE Ciudad = 'CDMX'
);
```

## Subconsultas correlacionadas

> Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta
una vez por cada fila

---

1. Seleccionar los clientes cuyo total de compras sea mayor a 1000