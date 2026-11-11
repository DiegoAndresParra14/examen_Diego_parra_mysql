# Coworking y oficinas · Modelo relacional MySQL

Ejercicio académico de diseño de una base de datos para gestionar usuarios, membresías, espacios de trabajo, reservas y facturación.

## Qué contiene

El archivo [script.sql](script.sql) define tablas y relaciones para:

- Empresas y usuarios.
- Tipos, estados y asignación de membresías.
- Espacios de trabajo y reservas.
- Servicios adicionales.
- Facturas, pagos, reembolsos y recargos.
- Credenciales de acceso y registros de entrada y salida.
- Auditoría, notificaciones y reportes.

## Conceptos aplicados

Claves primarias y foráneas, restricciones `UNIQUE` y `NOT NULL`, valores predeterminados y acciones referenciales como `ON DELETE CASCADE` y `ON DELETE SET NULL`.

## Cómo revisarlo

Abre `script.sql` en MySQL Workbench o un cliente compatible con MySQL y recorre las secciones numeradas.

**Usa una instancia de práctica:** el script comienza con `DROP DATABASE IF EXISTS CoworkingyOficinas`, por lo que elimina una base existente con ese nombre antes de recrearla.

## Trigger de vencimiento

El trigger se ejecuta BEFORE INSERT y asigna NEW.end_date con SET. Conserva la regla del ejercicio: 30 días desde start_date. No intenta actualizar la misma tabla desde un trigger AFTER INSERT.

## Verificación reproducible

En una base de práctica, ejecuta primero script.sql y luego tests/membership_expiry.sql. La prueba usa registros ficticios dentro de una transacción, verifica el cálculo con una aserción SQL y revierte los datos de prueba. La preparación del esquema sigue siendo destructiva para la base CoworkingyOficinas.

La revisión local comprobó la definición del trigger frente a la [documentación de MySQL](https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html). El esquema completo y la prueba de vencimiento se ejecutaron correctamente en una instancia temporal aislada de MySQL 8.4.13. Esa comprobación no sustituye validar las reglas de negocio de un sistema en producción.

## Alcance

No incluye API, aplicación de reservas, datos iniciales ni consultas operativas completas. Las reglas entre reservas, pagos y estados deben ampliarse antes de un uso real.
