-- ============================================================
-- ARCHIVO   : 02_DQL_consultas.sql
-- TIPO      : DQL (Data Query Language)
-- PROYECTO  : Caso Práctico 2 — Ciencias de Datos 1
-- AUTOR     : Melvin H. Rivas Genao
-- FECHA     : Junio 2026
-- BASE DATOS: sakila (MySQL 9.7)
-- ============================================================
-- PROPÓSITO : 10 consultas SQL de análisis y exploración sobre
--             la base de datos Sakila. Cubren desde JOINs
--             básicos hasta subconsultas, funciones de
--             agregación, análisis estadístico y vistas.
-- ============================================================
-- INSTRUCCIÓN: Ejecutar cada consulta individualmente con
--              Ctrl+Shift+Enter en MySQL Workbench para ver
--              los resultados por separado.
-- ============================================================

USE sakila;


-- ============================================================
-- CONSULTA 1: Películas por categoría con conteo total
-- ============================================================
-- Técnica: JOIN triple + GROUP BY + COUNT() + ORDER BY DESC
-- Propósito: Identificar qué categorías dominan el catálogo.
-- ============================================================

SELECT
    c.name              AS Categoria,
    COUNT(f.film_id)    AS TotalPeliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f           ON fc.film_id    = f.film_id
GROUP BY c.name
ORDER BY TotalPeliculas DESC;


-- ============================================================
-- CONSULTA 2: Top 10 actores con más películas
-- ============================================================
-- Técnica: JOIN doble + GROUP BY + ORDER BY DESC + LIMIT
-- Propósito: Identificar los actores más productivos del catálogo.
-- Nota: MySQL usa LIMIT (SQL Server usa TOP).
-- ============================================================

SELECT
    CONCAT(a.first_name, ' ', a.last_name)  AS NombreActor,
    COUNT(fa.film_id)                        AS NumPeliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY NumPeliculas DESC
LIMIT 10;


-- ============================================================
-- CONSULTA 3: Ciudades y sus países
-- ============================================================
-- Técnica: JOIN básico entre city y country
-- Propósito: Listar todas las ciudades con su país
--            correspondiente ordenadas alfabéticamente.
-- ============================================================

SELECT
    ci.city     AS Ciudad,
    co.country  AS Pais
FROM city ci
JOIN country co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city;


-- ============================================================
-- CONSULTA 4: Top 10 películas más rentadas
-- ============================================================
-- Técnica: JOIN triple (film → inventory → rental) + COUNT
-- Propósito: Identificar los títulos más populares del negocio.
-- ============================================================

SELECT
    f.title             AS Pelicula,
    COUNT(r.rental_id)  AS VecesRentada
FROM film f
JOIN inventory i ON f.film_id       = i.film_id
JOIN rental r    ON i.inventory_id  = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY VecesRentada DESC
LIMIT 10;


-- ============================================================
-- CONSULTA 5: Top 10 clientes por ingresos totales
-- ============================================================
-- Técnica: JOIN con payment + SUM() + ORDER BY DESC
-- Propósito: Identificar los clientes de mayor valor económico.
-- ============================================================

SELECT
    CONCAT(c.first_name, ' ', c.last_name)  AS Cliente,
    SUM(p.amount)                            AS TotalPagado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY TotalPagado DESC
LIMIT 10;


-- ============================================================
-- CONSULTA 6: Estadísticas de duración por categoría
-- ============================================================
-- Técnica: AVG, MIN, MAX + ROUND + GROUP BY
-- Propósito: Análisis estadístico de la duración de películas
--            agrupado por categoría cinematográfica.
-- ============================================================

SELECT
    c.name                          AS Categoria,
    ROUND(AVG(f.length), 2)         AS DuracionPromedio_min,
    MIN(f.length)                   AS DuracionMinima,
    MAX(f.length)                   AS DuracionMaxima
FROM film f
JOIN film_category fc ON f.film_id       = fc.film_id
JOIN category c       ON fc.category_id  = c.category_id
GROUP BY c.name
ORDER BY DuracionPromedio_min DESC;


-- ============================================================
-- CONSULTA 7: Inventario disponible por tienda
-- ============================================================
-- Técnica: JOIN cuádruple (store → address → city → inventory)
-- Propósito: Análisis de distribución de copias por sucursal.
-- ============================================================

SELECT
    s.store_id              AS Tienda,
    a.address               AS Direccion,
    ci.city                 AS Ciudad,
    COUNT(i.inventory_id)   AS CantidadCopias
FROM store s
JOIN address a    ON s.address_id   = a.address_id
JOIN city ci      ON a.city_id      = ci.city_id
JOIN inventory i  ON s.store_id     = i.store_id
GROUP BY s.store_id, a.address, ci.city;


-- ============================================================
-- CONSULTA 8: Clientes con más de 30 rentas (subconsulta)
-- ============================================================
-- Técnica: Subconsulta en FROM (Derived Table) + HAVING
-- Propósito: Identificar clientes frecuentes usando SQL avanzado.
-- ============================================================

SELECT
    CONCAT(c.first_name, ' ', c.last_name)  AS Cliente,
    c.email                                  AS Correo,
    r.TotalRentas
FROM customer c
JOIN (
    SELECT customer_id, COUNT(*) AS TotalRentas
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 30
) AS r ON c.customer_id = r.customer_id
ORDER BY r.TotalRentas DESC;


-- ============================================================
-- CONSULTA 9: Películas que nunca han sido rentadas
-- ============================================================
-- Técnica: LEFT JOIN + WHERE IS NULL (Anti-pattern)
-- Propósito: Detectar títulos sin actividad en el inventario.
--            Patrón muy usado en análisis de datos faltantes.
-- ============================================================

SELECT
    f.film_id,
    f.title AS Pelicula
FROM film f
LEFT JOIN inventory i ON f.film_id       = i.film_id
LEFT JOIN rental r    ON i.inventory_id  = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;


-- ============================================================
-- CONSULTA 10: Vista reutilizable de resumen de películas
-- ============================================================
-- Técnica: CREATE OR REPLACE VIEW + JOIN múltiple
-- Propósito: Encapsular lógica compleja en un objeto reutilizable.
--            Las vistas mejoran la mantenibilidad del código SQL.
-- ============================================================

-- Paso 1: Crear o reemplazar la vista
CREATE OR REPLACE VIEW vw_resumen_peliculas AS
SELECT
    f.film_id,
    f.title         AS Titulo,
    f.rental_rate   AS PrecioRenta,
    f.length        AS Duracion,
    f.rating        AS Clasificacion,
    c.name          AS Categoria,
    l.name          AS Idioma
FROM film f
JOIN film_category fc ON f.film_id        = fc.film_id
JOIN category c       ON fc.category_id   = c.category_id
JOIN language l       ON f.language_id    = l.language_id;

-- Paso 2: Consultar la vista con filtro por clasificación
SELECT *
FROM vw_resumen_peliculas
WHERE Clasificacion = 'PG-13'
ORDER BY PrecioRenta DESC
LIMIT 20;
