# Contenedor SQLSERVER Sin Volumen

## Despliegue del Motor de Base de Datos (Docker)
Para este entorno de desarrollo se ha optado por un contenedor efímero (sin volumen). Esto significa que el entorno es ideal para pruebas de concepto, ya que al eliminar el contenedor se restablece todo a cero.

Para realizar la instalación de **SQL Server Managment Studio 2022** se deja la opción de `ISO` y lo dejamos en idioma `Inglés` y descargamos lo descargamos.

![Img](/img/sqliso.png)



``` shell
Bashdocker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserver \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```
**Análisis de la Configuración**

- `-e "ACCEPT_EULA=Y"`: Firma digitalmente la licencia de uso para permitir el arranque.

- `-e "MSSQL_SA_PASSWORD=P@ssw0rd"`: Define la llave maestra de acceso. Nota: La complejidad es obligatoria por seguridad del motor.
- `-p 1438:1433` **Dato Crítico** 
   - El contenedor escucha internamente en el puerto estándar `1433`.
   - Tú accedes desde Windows por el puerto `1435`.
   
- `--name servidorsqlserver`: Etiqueta la instancia para facilitar su gestión.
- `mcr.microsoft.com/...`: Garantiza el uso de la imagen oficial de Microsoft.

## Herramienta de Gestión: SQL Server Management Studio (SSMS)
Se utilizas SSMS para administrar visualmente la base de datos. Esta herramienta actúa como el "cliente" que envía instrucciones al "servidor" (Docker).

**Proceso de Conexión**

Para vincular SSMS con tu contenedor Docker, se debe configurar el cuadro de diálogo "Connect to Server" con estos parámetros:

| Server  | Valor a ingresar | Explicación |
| - |- | - |
| ServerType|`Database Engine` | El motor que corre en el contenedor.|
|Server name|`localhost,1438`|Importante: Se usa una coma (`,`) para especificar el puerto personalizado definido en el comando Docker.|
|Authentication|`SQL Server Authentication`|Docker no usa autenticación de Windows por defecto.|
|Login|`sa`|Usuario administrador por defecto (System Administrator).|
|Password|`P@ssw0rd`|La contraseña definida en tu variable -e.|

## Ejecución de Script SQL (DDL)
Una vez conectado, se procedió a ejecutar el script `01-sql-ldd.sql` visualizado en tu entorno. Este script tiene dos objetivos: **Creación del entorno y Definición de la estructura de datos.**

**Creación del Espacio de Trabajo**
``` shell
SQL
CREATE DATABASE tienda;
GO
use tienda;
GO
```
- **Función:** Genera un contenedor lógico llamado tienda y cambia el contexto de ejecución para que las tablas futuras se guarden ahí y no en la base de datos del sistema (master).

**Modelado de la Tabla `cliente`**

Se define la entidad principal con reglas de negocio específicas (tipos de datos y restricciones).
``` shell
SQL
CREATE TABLE cliente (
    id int not null,                    -- Identificador numérico
    nombre nvarchar(30) not null,       -- Texto variable (hasta 30 caracteres)
    apaterno nvarchar(10) not null,     -- Apellido paterno
    amaterno nvarchar(10) null,         -- Apellido materno (Opcional, permite NULL)
    sexo nchar(1) not null,             -- Un solo carácter (ej: 'M' o 'F')
    edad int not null,                  -- Número entero
    direccion nvarchar(80) not null,    -- Dirección física
    rfc nvarchar(20) not null,          -- Identificador fiscal
    limitecredito money not null default 500.0 -- Valor monetario con un mínimo predefinido
);
GO
```
### Puntos Clave del Script
- **`nvarchar` vs `nchar`:** Se usa `nvarchar` para longitudes variables (ahorra espacio si el nombre es corto) y `nchar` para datos fijos (como el sexo, que siempre es 1 letra).
- **`DEFAULT 500.0`:** Si al insertar un cliente no especificas su límite de crédito, el sistema le asignará automáticamente 500.0.
- **`Restricciones (NOT NULL)`:** Garantizan la integridad de la información; no se puede registrar un cliente sin nombre o RFC.

## Resumen del Flujo de Trabajo
- **Terminal:** Levantas el servidor con `docker run` en el puerto `1435`.
- **SSMS:** Te conectas apuntando a `localhost,1438` con credenciales `sa`.
- **Editor SQL:** Ejecutas el script DDL para crear la estructura (`tienda` y `cliente`).
- **Resultado:** Tienes una base de datos operativa lista para recibir datos (INSERTs).

``` shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1435:1433 --name servidorsqlserver\
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
``` 