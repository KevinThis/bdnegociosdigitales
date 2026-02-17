# Documentación de Comandos de Contenedores Docker para SGBD

## Comando para contenedor de SQL Server sin Volumen

## Introducción y Prerrequisitos
Docker permite empaquetar una base de datos completa (incluyendo sus configuraciones y dependencias) en un "contenedor". Esto elimina la necesidad de instalaciones complejas en el sistema operativo anfitrión.

Entorno de Instalación (Windows):Para ejecutar los comandos descritos en este reporte en Windows, se requiere:

- WSL2 (Windows Subsystem for Linux): Docker utiliza el kernel de Linux dentro de Windows para ejecutar estos contenedores de manera eficiente.

- Docker Desktop para Windows: La interfaz gráfica y el motor que gestiona los contenedores.

## Análisis de Comandos de Despliegue (Docker Run)
A continuación, se desglosa la sintaxis utilizada para desplegar SQL Server 2019. Se presentan dos escenarios: volátil (sin persistencia) y persistente (con volúmenes).

#### Contenedor Efímero (Sin Volumen)

Este comando crea una base de datos que perderá toda la información si el contenedor es eliminado. Ideal para pruebas rápidas.
``` shell
Bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```
#### Contenedor Persistente (Con Volumen)
Este es el comando recomendado para desarrollo. Los datos se guardan en un volumen gestionado por Docker, sobreviviendo al reinicio o eliminación del contenedor.
``` shell
Bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -v volume-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```
# Desglose Técnico Línea por Línea
Aquí se explica la función técnica de cada bandera (flag) utilizada en los scripts:
``` shell
docker run
```
**Creación**

Ordena al daemon de Docker descargar la imagen (si no existe) e iniciar una nueva instancia (contenedor).
``` shell
-e "ACCEPT_EULA=Y"
```
**Variable de Entorno**

Específico de Microsoft SQL Server. Acepta obligatoriamente los términos de licencia para que el motor arranque.
``` shell
-e "MSSQL_SA_PASSWORD=..."
```
**Seguridad**

Define la contraseña del usuario SA (System Administrator). Nota: Debe ser robusta (mayúsculas, números, símbolos) o el contenedor se apagará inmediatamente.
``` shell
-p 1435:1433
```
**Mapeo de Puertos**

Conecta el puerto de tu PC con el del contenedor.
- 1435 (Host): Puerto que usarás en Windows para conectarte.
- 1433 (Container): Puerto interno estándar donde escucha SQL Server.
``` shell
--name servidorsqlserver
```
**Identificación**

Asigna un nombre legible al contenedor para no tener que referirse a él por su ID alfanumérico aleatorio.
``` shell
-v volume-mssqlevnd:/var...
```
**Persistencia (Volumen)**

Mapea un almacenamiento físico.
- `volume-mssqlevnd`: Nombre del volumen en Docker Windows.
- `/var/opt/mssql`: Ruta interna (Linux) donde SQL Server guarda los archivos `.mdf` y `.ldf`.
``` shell
-d
```
**Detached Mode**

Ejecuta el contenedor en segundo plano. Sin esto, la terminal quedaría bloqueada mostrando los logs de la base de datos.
``` shell
mcr.microsoft.com/...
```
**Imagen Base**

La "receta" exacta que se va a usar. Indica que usaremos la versión 2019 oficial del repositorio de Microsoft.

## Operaciones SQL Post-Despliegue
Una vez que el contenedor está corriendo en el puerto `1435`, se ejecutan los siguientes scripts DDL (Definición de datos y DML (Manipulación de datos).

- Para ejecutar esto, necesitas conectarte al contenedor usando un cliente como Azure Data Studio, SSMS o DBeaver apuntando a `localhost,1435`.

**Creación de la Estructura (DDL)**
``` shell
SQL
-- Crea la base de datos lógica --
CREATE DATABASE bdevnd;
GO

-- Selecciona la base de datos para operar --
USE bdevnd;
GO

-- Crea la tabla con una llave primaria autoincremental --
CREATE TABLE tbl1(
   id INT not null IDENTITY(1,1),  -- El ID aumenta solo (1, 2, 3...)
   nombre NVARCHAR(20) not null,   -- Almacena texto Unicode
   CONSTRAINT pk_tbl1 PRIMARY KEY (id) -- Regla de integridad
);
GO
```
**Inserción y Consulta de Datos (DML)**
``` shell
SQL
-- Inserta registros en la tabla creada --
INSERT INTO tbl1
VALUES ('Docker'),
       ('Git'),
       ('Github'),
       ('Postgres');
GO

-- Recupera la información para verificar --
SELECT * FROM tbl1;      -- Muestra ID y Nombre
SELECT nombre FROM tbl1; -- Muestra solo la columna Nombre
```
## Resumen de Rutas Críticas
Es vital entender dónde residen los datos físicamente para evitar pérdidas:
- **Ruta Interna del Contenedor:** `/var/opt/mssql/data` 
Aquí es donde el SQL Server (que corre sobre un mini-Linux dentro de Docker) cree que está guardando los datos.

- **Volumen de Docker (Windows):** `volume-mssqlevnd` Docker Desktop gestiona este espacio en tu disco duro real para asegurar que los datos de la ruta interna anterior no se borren al apagar el contenedor.

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
``` 
## Comando para contenedor de SQL Server con volumen

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver \
   -v volume-mssqlevnd:/var/opt/mssql \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
``` 

`/var/opt/mssql/data`

CREATE DATABASE bdevnd;
GO

USE bdevnd;
GO

CREATE TABLE tbl1(
   id INT not null IDENTITY(1,1),
   nombre NVARCHAR(20) not null,
   CONSTRAINT pk_tbl1
   PRIMARY KEY (id)
);
GO

INSERT INTO tbl1
VALUES ('Docker'),
       ('Git'),
       ('Github'),
       ('Postgres');
GO

SELECT *
FROM tbl1;

SELECT nombre
FROM tbl1;