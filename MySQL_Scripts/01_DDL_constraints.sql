-- ============================================================
-- ARCHIVO   : 01_DDL_constraints.sql
-- TIPO      : DDL (Data Definition Language)
-- PROYECTO  : Caso Práctico 2 — Ciencias de Datos 1
-- AUTOR     : Melvin H. Rivas Genao
-- FECHA     : Junio 2026
-- BASE DATOS: sakila (MySQL 9.7)
-- ============================================================
-- PROPÓSITO : Mejorar la integridad referencial de la base de
--             datos Sakila aplicando UNIQUE CONSTRAINTS sobre
--             8 tablas críticas. Esto garantiza que el motor
--             MySQL rechace automáticamente datos duplicados
--             sin necesidad de lógica adicional en el código.
-- ============================================================
-- NOTA      : Ejecutar este script UNA SOLA VEZ por instancia.
--             Si los constraints ya existen, ejecutar primero
--             el bloque DROP INDEX correspondiente.
-- ============================================================

USE sakila;

-- ── 1. TABLA: country ────────────────────────────────────────
-- Garantiza que no existan dos países con el mismo nombre.
-- Ejemplo violación: INSERT INTO country VALUES ('Mexico') dos veces.

ALTER TABLE country
ADD CONSTRAINT UQ_country_name UNIQUE (country);


-- ── 2. TABLA: city ───────────────────────────────────────────
-- Constraint COMPUESTO: la combinación ciudad + país debe ser única.
-- Permite que exista "San Pedro" en distintos países pero no
-- dos "San Pedro" en el mismo país.

ALTER TABLE city
ADD CONSTRAINT UQ_city_country UNIQUE (city, country_id);


-- ── 3. TABLA: film ───────────────────────────────────────────
-- Garantiza que no existan dos películas con el mismo título
-- en el catálogo de inventario.

ALTER TABLE film
ADD CONSTRAINT UQ_film_title UNIQUE (title);


-- ── 4. TABLA: language ───────────────────────────────────────
-- Garantiza que cada idioma aparezca una sola vez en el catálogo.

ALTER TABLE language
ADD CONSTRAINT UQ_language_name UNIQUE (name);


-- ── 5. TABLA: category ───────────────────────────────────────
-- Garantiza unicidad en los nombres de categorías cinematográficas.

ALTER TABLE category
ADD CONSTRAINT UQ_category_name UNIQUE (name);


-- ── 6. TABLA: actor ──────────────────────────────────────────
-- Constraint COMPUESTO sobre last_name + actor_id.
-- Nota técnica: Sakila contiene actores con nombres completos
-- repetidos (ej: SUSAN DAVIS, VIVIEN LEIGH), por eso se usa
-- last_name + actor_id en lugar de first_name + last_name.

ALTER TABLE actor
ADD CONSTRAINT UQ_actor_lastname UNIQUE (last_name, actor_id);


-- ── 7. TABLA: customer ───────────────────────────────────────
-- Garantiza que cada cliente tenga un email único en el sistema.
-- Fundamental para comunicaciones y recuperación de cuentas.

ALTER TABLE customer
ADD CONSTRAINT UQ_customer_email UNIQUE (email);


-- ── 8. TABLA: staff ──────────────────────────────────────────
-- Garantiza que cada empleado tenga un email corporativo único.

ALTER TABLE staff
ADD CONSTRAINT UQ_staff_email UNIQUE (email);


-- ============================================================
-- VERIFICACIÓN FINAL: Confirmar que los 8 constraints
-- fueron creados exitosamente en el schema de sakila.
-- ============================================================

SELECT
    TABLE_NAME    AS Tabla,
    CONSTRAINT_NAME AS NombreConstraint,
    CONSTRAINT_TYPE AS Tipo
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
  AND CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY TABLE_NAME;

-- Resultado esperado: 8 filas, una por cada tabla modificada.
