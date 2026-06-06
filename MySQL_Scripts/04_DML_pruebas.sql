-- ============================================================
-- ARCHIVO   : 04_DML_pruebas.sql
-- TIPO      : DML (Data Manipulation Language)
-- PROYECTO  : Caso Práctico 2 — Ciencias de Datos 1
-- AUTOR     : Melvin H. Rivas Genao
-- FECHA     : Junio 2026
-- BASE DATOS: sakila (MySQL 9.7)
-- ============================================================
-- PROPÓSITO : Pruebas de inserción para demostrar que los
--             UNIQUE CONSTRAINTS rechazan datos duplicados.
--             Estas pruebas generan errores intencionales
--             (Error 1062) que evidencian que la integridad
--             de la base de datos está funcionando.
-- ============================================================
-- ⚠️  ADVERTENCIA: Este script contiene INSERTs de prueba.
--     Los que tienen comentario "debe fallar" generarán
--     Error 1062 intencionalmente — eso es el resultado
--     correcto y esperado.
-- ============================================================

USE sakila;


-- ============================================================
-- PRUEBA 1: Constraint en tabla country
-- ============================================================
-- Demuestra que UQ_country_name rechaza países duplicados.
-- ============================================================

-- Paso 1: Insertar un país nuevo (debe tener éxito)
INSERT INTO country (country) VALUES ('Dominican Republic Test');

-- Paso 2: Intentar insertar el mismo país (DEBE FALLAR)
-- Error esperado: 1062 - Duplicate entry 'Dominican Republic Test'
--                        for key 'country.UQ_country_name'
INSERT INTO country (country) VALUES ('Dominican Republic Test');

-- Paso 3: Limpiar el registro de prueba
DELETE FROM country WHERE country = 'Dominican Republic Test';


-- ============================================================
-- PRUEBA 2: Constraint en tabla actor
-- ============================================================
-- Demuestra que UQ_actor_lastname rechaza actores duplicados.
-- ============================================================

-- Paso 1: Insertar un actor nuevo (debe tener éxito)
INSERT INTO actor (first_name, last_name) VALUES ('JUAN', 'PEREZ');

-- Paso 2: Intentar insertar el mismo apellido + ID combinación
-- (DEBE FALLAR por el constraint compuesto)
-- Error esperado: 1062 - Duplicate entry para UQ_actor_lastname
INSERT INTO actor (first_name, last_name) VALUES ('PEDRO', 'PEREZ');

-- Paso 3: Limpiar los registros de prueba
DELETE FROM actor WHERE last_name = 'PEREZ' AND first_name IN ('JUAN', 'PEDRO');


-- ============================================================
-- PRUEBA 3: Constraint en tabla film
-- ============================================================
-- Demuestra que UQ_film_title rechaza títulos duplicados.
-- ============================================================

-- Paso 1: Insertar película de prueba (debe tener éxito)
INSERT INTO film (
    title, language_id, rental_duration,
    rental_rate, replacement_cost
) VALUES (
    'TEST FILM CONSTRAINT', 1, 3, 2.99, 19.99
);

-- Paso 2: Intentar insertar película con el mismo título (DEBE FALLAR)
-- Error esperado: 1062 - Duplicate entry 'TEST FILM CONSTRAINT'
--                        for key 'film.UQ_film_title'
INSERT INTO film (
    title, language_id, rental_duration,
    rental_rate, replacement_cost
) VALUES (
    'TEST FILM CONSTRAINT', 1, 5, 4.99, 29.99
);

-- Paso 3: Limpiar el registro de prueba
DELETE FROM film WHERE title = 'TEST FILM CONSTRAINT';


-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================
-- Confirmar que los registros de prueba fueron limpiados
-- y la base de datos quedó en su estado original.
-- ============================================================

SELECT 'Registros Dominican Republic Test en country:' AS Verificacion,
       COUNT(*) AS Resultado
FROM country
WHERE country = 'Dominican Republic Test'

UNION ALL

SELECT 'Registros PEREZ en actor:',
       COUNT(*)
FROM actor
WHERE last_name = 'PEREZ'

UNION ALL

SELECT 'Registros TEST FILM en film:',
       COUNT(*)
FROM film
WHERE title = 'TEST FILM CONSTRAINT';

-- Resultado esperado: Los 3 conteos deben ser 0.
-- Esto confirma que la base de datos quedó limpia
-- después de las pruebas de integridad.
