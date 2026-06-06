-- ============================================================
-- ARCHIVO   : 03_DQL_integridad.sql
-- TIPO      : DQL (Data Query Language)
-- PROYECTO  : Caso Práctico 2 — Ciencias de Datos 1
-- AUTOR     : Melvin H. Rivas Genao
-- FECHA     : Junio 2026
-- BASE DATOS: sakila (MySQL 9.7)
-- ============================================================
-- PROPÓSITO : 10 consultas de verificación y auditoría de
--             integridad referencial. Confirman que los
--             UNIQUE CONSTRAINTS aplicados en 01_DDL_constraints
--             están funcionando correctamente.
-- ============================================================
-- INSTRUCCIÓN: Ejecutar DESPUÉS de 01_DDL_constraints.sql.
--              Cada query debe mostrar el resultado esperado
--              indicado en los comentarios.
-- ============================================================

USE sakila;


-- ============================================================
-- Q1: Listado completo de UNIQUE CONSTRAINTS activos
-- ============================================================
-- Propósito: Confirmar visualmente que los 8 constraints
--            fueron creados exitosamente en el schema.
-- Resultado esperado: 8 filas, una por tabla modificada.
-- ============================================================

SELECT
    TABLE_NAME      AS Tabla,
    CONSTRAINT_NAME AS NombreConstraint,
    CONSTRAINT_TYPE AS Tipo
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA   = 'sakila'
  AND CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY TABLE_NAME;


-- ============================================================
-- Q2: Verificar unicidad en tabla city
-- ============================================================
-- Propósito: Confirmar que no existen combinaciones
--            ciudad + país duplicadas en la tabla city.
-- Resultado esperado: 0 filas (no hay duplicados).
-- ============================================================

SELECT
    city,
    country_id,
    COUNT(*) AS Duplicados
FROM city
GROUP BY city, country_id
HAVING COUNT(*) > 1;


-- ============================================================
-- Q3: Verificar unicidad de emails en tabla customer
-- ============================================================
-- Propósito: Auditar que cada cliente tiene un email único.
-- Resultado esperado: 0 filas (no hay emails repetidos).
-- ============================================================

SELECT
    email,
    COUNT(*) AS Veces
FROM customer
GROUP BY email
HAVING COUNT(*) > 1;


-- ============================================================
-- Q4: Verificar unicidad de títulos en tabla film
-- ============================================================
-- Propósito: Confirmar que no existen películas con el mismo
--            título en el catálogo de inventario.
-- Resultado esperado: 0 filas.
-- ============================================================

SELECT
    title,
    COUNT(*) AS Duplicados
FROM film
GROUP BY title
HAVING COUNT(*) > 1;


-- ============================================================
-- Q5: Países sin ciudades asignadas
-- ============================================================
-- Técnica: LEFT JOIN + WHERE IS NULL (Anti-pattern)
-- Propósito: Detectar países huérfanos sin ciudades
--            registradas — útil para auditoría de datos.
-- ============================================================

SELECT
    co.country AS Pais
FROM country co
LEFT JOIN city ci ON co.country_id = ci.country_id
WHERE ci.city_id IS NULL
ORDER BY co.country;


-- ============================================================
-- Q6: Categorías sin películas asignadas
-- ============================================================
-- Propósito: Detectar categorías vacías que podrían indicar
--            datos inconsistentes en el catálogo.
-- Resultado esperado: 0 filas en Sakila correctamente cargada.
-- ============================================================

SELECT
    c.name AS Categoria
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
WHERE fc.film_id IS NULL;


-- ============================================================
-- Q7: Ver todos los índices UNIQUE por tabla y columna
-- ============================================================
-- Propósito: Vista técnica detallada de los índices únicos
--            activos en todas las tablas del schema sakila.
-- ============================================================

SELECT
    TABLE_NAME  AS Tabla,
    INDEX_NAME  AS NombreIndice,
    COLUMN_NAME AS Columna,
    NON_UNIQUE  AS EsUnico
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila'
  AND NON_UNIQUE   = 0
ORDER BY TABLE_NAME, INDEX_NAME;


-- ============================================================
-- Q8: Resumen de tipos de constraints por tabla
-- ============================================================
-- Propósito: Vista ejecutiva del estado de integridad del
--            schema completo — PRIMARY KEY, UNIQUE, FK.
-- ============================================================

SELECT
    TABLE_NAME      AS Tabla,
    CONSTRAINT_TYPE AS TipoConstraint,
    COUNT(*)        AS Cantidad
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
GROUP BY TABLE_NAME, CONSTRAINT_TYPE
ORDER BY TABLE_NAME;


-- ============================================================
-- Q9: Auditoría de emails duplicados en tabla staff
-- ============================================================
-- Propósito: Verificar que los empleados tienen emails
--            corporativos únicos en el sistema.
-- Resultado esperado: 0 filas.
-- ============================================================

SELECT
    email,
    COUNT(*) AS Veces
FROM staff
GROUP BY email
HAVING COUNT(*) > 1;


-- ============================================================
-- Q10: Auditoría general de integridad — conteo por tabla
-- ============================================================
-- Propósito: Resumen ejecutivo del volumen de datos en las
--            tablas principales para verificar que Sakila
--            se cargó correctamente y está íntegra.
-- Resultado esperado:
--   actor=200, film=1000, city=600, country=109, rental=16044
-- ============================================================

SELECT 'actor'    AS Tabla, COUNT(*) AS TotalRegistros FROM actor
UNION ALL
SELECT 'film',              COUNT(*) FROM film
UNION ALL
SELECT 'city',              COUNT(*) FROM city
UNION ALL
SELECT 'country',           COUNT(*) FROM country
UNION ALL
SELECT 'customer',          COUNT(*) FROM customer
UNION ALL
SELECT 'rental',            COUNT(*) FROM rental
UNION ALL
SELECT 'payment',           COUNT(*) FROM payment
UNION ALL
SELECT 'inventory',         COUNT(*) FROM inventory
ORDER BY Tabla;
