-- Crea una Base de Datos
CREATE DATABASE tienda;
GO

use tienda;

-- Crear tabla cliente
CREATE TABLE cliente (
    id int not null,
    nombre nvarchar(30) not null,
    apaterno nvarchar(10) not null,
    amaterno nvarchar(10) null,
    sexo nchar(1) not null,
    edad int not null,
    direccion nvarchar(80) not null,
    rfc nvarchar(20) not null,
    limitecredito money not null default 500.0
);
GO

-- Restricciones

CREATE TABLE clientes(
   cliente_id INT NOT NULL PRIMARY KEY,
   nombre nvarchar(30) NOT NULL,
   apellido_paterno nvarchar(20) NOT NULL,
   apellido_materno nvarchar (20),
   edad INT NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   limite_credito MONEY NOT NULL
);
GO

INSERT INTO clientes
VALUES (1, 'GOKU', 'LINTERNA', 'SUPERMAN', 450, '1578-01-17', 100);

INSERT INTO clientes
VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000)

INSERT INTO clientes
VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000)

INSERT INTO clientes
(nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES ('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26)

INSERT INTO clientes
VALUES (4, 'Vanesa', 'Buena Vista', NULL, 26, '2000-04-25', 3000);
GO

INSERT INTO clientes
VALUES
(5, 'Soyla', 'Vaca', 'Del Corral', 42, '1983-04-06', 78955),
(6, 'Bad Bunny', 'Perez', 'Sinsentido', 22,'1999-05-06', 85858),
(7, 'Jos  Luis', 'Herrera', 'Gallardo', 42,'1983-04-06', 14000);



SELECT *
FROM clientes;

SELECT cliente_id, nombre, edad, limite_credito
FROM clientes;


SELECT GETDATE(); -- obtine la fecha del sistema

CREATE TABLE clientes_2(
  cliente_id int not null identity(1,1),
  nombre nvarchar(50) not null,
  edad int not null,
  fecha_registro date default GETDATE(),
  limite_credito money not null,
  CONSTRAINT pk_clientes_2
  PRIMARY KEY (cliente_id)
);

 SELECT * FROM clientes_2;

 INSERT INTO clientes_2 VALUES ('Chespirito', 78, DEFAULT, 45500);
 INSERT INTO clientes_2 (nombre, edad, limite_credito) VALUES ('Batman', 45, 89000);
 INSERT INTO clientes_2 VALUES ('Robin', 35, '2026-01-19', 89.32);
 INSERT INTO clientes_2 (limite_credito, edad, nombre, fecha_registro) VALUES (89.1, 24, 'flash reverso', '2026-01-21');
 
 -- forma de insertar valores a una tabla M�S RAPIDO

 CREATE TABLE suppliers (
    supplier_id int not null identity(1,1),
    [name] nvarchar(30) not null,
    date_register date not null default GETDATE(),
    tipo char(1) not null,
    credit_limit money not null,
    constraint pk_suppliers
    primary key ( supplier_id),
    constraint unique_name
    unique ([name]),
    constraint chk_credit_limit 
    check (credit_limit > 0.0 and credit_limit <= 50000),
    constraint chk_tipo
    check (tipo in ('A','B','C'))
 );

 INSERT INTO suppliers 
 values ('barcel', default, 'A', 25000);

 INSERT INTO suppliers
 values (UPPER('bimbo'), default, UPPER('c'), 45000);

  INSERT INTO suppliers
 values (UPPER('tia rosa'), '2026-01-21', UPPER('B'), 40000);

 INSERT INTO suppliers (name, tipo, credit_limit)
 values (UPPER('coca-cola'), UPPER('a'), 36000);


 select * FROM suppliers;

 -----crear base de datos dborders  

 create database dborders;
 go

 use dborders;
 go

  create table custumers(
     custumer_id int not null identity(1,1),
     first_name nvarchar(20) not null,
     last_name nvarchar(30),
     [address] nvarchar(80) not null,
     number int,
     constraint pk_custumers
     primary key (custumer_id)
  );
  go

  CREATE TABLE suppliers (
    supplier_id int not null,
    [name] nvarchar(30) not null,
    date_register date not null default GETDATE(),
    tipo char(1) not null,
    credit_limit money not null,
    constraint pk_suppliers
    primary key ( supplier_id),
    constraint unique_name
    unique ([name]),
    constraint chk_credit_limit 
    check (credit_limit > 0.0 and credit_limit <= 50000),
    constraint chk_tipo
    check (tipo in ('A','B','C')) --forma simplificada del OR
 );
 go


 -------------------------------
  create table products (
    product_id int not null identity(1,1),
    [name] nvarchar(40) not null,
    quantity int not null,
    unit_price money not null,
    supplier_id int,
    constraint pk_products
    primary key (product_id),
    constraint unique_name_productos
    unique ([name]),
    constraint chk_quantity
    check (quantity between 1 and 100),---en la forma simplificada del AND
    constraint chk_unitprice
    check ( unit_price > 0 and unit_price <= 100000),
    constraint fk_products_suppliers
    foreign key (supplier_id)
    references suppliers (supplier_id)
    on delete no action
    on update no action
 );
 go
 ---------------------------
  

 create table products (
    product_id int not null identity(1,1),
    [name] nvarchar(40) not null,
    quantity int not null,
    unit_price money not null,
    supplier_id int,
    constraint pk_products
    primary key (product_id),
    constraint unique_name_productos
    unique ([name]),
    constraint chk_quantity
    check (quantity between 1 and 100),---en la forma simplificada del AND
    constraint chk_unitprice
    check ( unit_price > 0 and unit_price <= 100000),
    constraint fk_products_suppliers
    foreign key (supplier_id)
    references suppliers (supplier_id)
    on delete set null
    on update set null
 );
 go

 drop table products;
 drop table suppliers;


 --
 alter table products
 drop constraint fk_products_suppliers;

 ---borrar tabla
 Drop table suppliers;



 ---Permite cambiar la estructura de una columna en la tabla

  ALTER TABLE products
  ALTER COLUMN supplier_id INT null;

  update products
  set supplier_id = null;



 INSERT INTO suppliers 
 values (1,'chino S.A.', default, 'A', 25000);

 INSERT INTO suppliers
 values (2, UPPER('Chanclotas'), default, UPPER('c'), 45000);

  INSERT INTO suppliers
 values (3, UPPER('Ramam-ma'), '2026-01-21', UPPER('B'), 40000);

select * from suppliers;

 insert into products  
 values ('papas', 10, 5.3, 1);

 insert into products  
 values ('rollos primavera', 20, 100, 1);

 insert into products  
 values ('chanclas pata de gallo', 50, 20, 10);

 insert into products  
 values ('chanclas buenas', 30, 57, 10);

 insert into products  
 values ('ramita chiquita', 56, 58.23, 3);

 insert into products  
 values ('azulito', 100, 15.3, NULL);

 use dborders

 --Comprobascion de ON DELETE no action
 --primero debemos eliminar los hijos (los id de los que se quieren borrar
 
 DELETE FROM products WHERE supplier_id = 1;
 --eliminar al padre

 DELETE FROM suppliers
 WHERE supplier_id = 1;

 --Comprobar el update no action

 update suppliers
 set supplier_id = 10
 where supplier_id = 2;


 --Drop table products

 select * from suppliers;
 select * from products;
 
 delete from products
 where supplier_id = 1;

 ---practica sola cambiar id de los productos al que se quiera
 
 update products
 set supplier_id = 2
 where product_id IN (19,20);

  update products
 set supplier_id = 3
 where product_id = 10;

 ------------------------- cambiar supplier chanclotas a 10 de id

  update suppliers
 set supplier_id = 10
 where supplier_id = 2;

  update products
 set supplier_id = 20
 where supplier_id is null;

---------------------------------------

update products 
set supplier_id = null
where supplier_id = 2;

update products 
set supplier_id = 10
where produc_id IN (3,4;

 select * from suppliers;
 select * from products;


 ---comprobar on delete set null----

 delete suppliers
 where supplier_id = 10;

 --comprobar on update set null

 update suppliers 
 set supplier_id = 20
 where supplier_id = 1;