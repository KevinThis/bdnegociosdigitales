
# Triggers en SQL Server

## 1. ¿Qué es un trigger?

Un trigger (disparador) es un bloque de código SQL que se ejecuta automáticamente cuando ocurre un evento
en una tabla.

Eventos principales:
    - Insert
    - Delete
    - Update

Nota: No se ejecutan manualment, se activan solos

## 2. Para que sirven
    - Validaciones
    - Auditoría (guardar historial)
    - Reglas de negocio
    - Automatización

## 3. Tipos de Triggers en SQL Server
    - AFTER TRIGGER

    Se ejecuta después del evento

    - INSTEAD OF TRIGGER

    Reemplaza la operación original

## 4. Sintaxis básica

    ```sql
    CREATE OR ALTER TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
    END;
    ```

## 5. Tablas especiales

| Tabla | Contenido |
| :--- | :--- |
| inserted | Nuevo Datos |
| deleted | Datos anteriores |