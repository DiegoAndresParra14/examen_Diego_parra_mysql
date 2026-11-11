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

## Estado del ejercicio

El modelo incluye un intento de trigger para calcular el vencimiento de las membresías. Ese bloque requiere corrección antes de ejecutar el script completo: usa `AFTER INSERT` e intenta modificar `NEW.end_date` mediante un `UPDATE` sobre la misma tabla.

Una siguiente mejora es calcular el valor en un trigger `BEFORE INSERT`, revisar la duración según el tipo de membresía y añadir datos de ejemplo y consultas de validación.

Este repositorio presenta el esquema académico actual; no constituye todavía un sistema completo de reservas ni una migración lista para producción.

[Volver al perfil](https://github.com/DiegoAndresParra14)
