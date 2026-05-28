/*Primera consulta: ¿Qué hace?: Cuenta cuántas películas pertenecen a cada categoría usando JOIN entre 3 tablas. Demuestra GROUP BY y ORDER BY. */

USE sakila;

SELECT
    c.name AS Categoria,
    COUNT(f.film_id) AS TotalPeliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY TotalPeliculas DESC;

/*Segunda consulta: ¿Qué hace?: En MySQL usamos LIMIT en lugar de TOP (SQL Server). CONCAT une nombre y apellido en una sola columna.*/ 
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS NombreActor,
    COUNT(fa.film_id) AS NumPeliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY NumPeliculas DESC
LIMIT 10;

/*Tercera consulta: ¿Qué hace?: JOIN básico entre city y country. Lista todas las ciudades con su país correspondiente ordenadas alfabéticamente.*/ 
SELECT
    ci.city AS Ciudad,
    co.country AS Pais
FROM city ci
JOIN country co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city;

/*Cuarta consulta: ¿Qué hace?: Encadena 3 tablas para contar cuántas veces se rentó cada película. Patrón clásico de análisis de negocio.*/ 
SELECT
    f.title AS Pelicula,
    COUNT(r.rental_id) AS VecesRentada
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY VecesRentada DESC
LIMIT 10;

/*Quinta consulta: ¿Qué hace?: Calcula el gasto total por cliente usando SUM(). Identifica los mejores clientes del negocio.*/ 
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS Cliente,
    SUM(p.amount) AS TotalPagado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY TotalPagado DESC
LIMIT 10;

/*Sexta consulta: ¿Qué hace?: Análisis estadístico básico con AVG, MIN, MAX. ROUND redondea a 2 decimales. Relaciona con métricas descriptivas.*/ 
SELECT
    c.name AS Categoria,
    ROUND(AVG(f.length), 2) AS DuracionPromedio_min,
    MIN(f.length) AS DuracionMinima,
    MAX(f.length) AS DuracionMaxima
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY DuracionPromedio_min DESC;

/*Septima consulta: ¿Qué hace?: JOIN de 4 tablas para mostrar cuántas copias de películas tiene cada tienda. Análisis de inventario.*/
SELECT
    s.store_id AS Tienda,
    a.address AS Direccion,
    ci.city AS Ciudad,
    COUNT(i.inventory_id) AS CantidadCopias
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN inventory i ON s.store_id = i.store_id
GROUP BY s.store_id, a.address, ci.city;

/*Octava consulta: ¿Qué hace?: Subconsulta en el FROM (derived table). Filtra clientes frecuentes con HAVING. Demuestra SQL intermedio-avanzado.*/ 
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS Cliente,
    c.email AS Correo,
    r.TotalRentas
FROM customer c
JOIN (
    SELECT customer_id, COUNT(*) AS TotalRentas
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 30
) AS r ON c.customer_id = r.customer_id
ORDER BY r.TotalRentas DESC;

/*Novena consulta: ¿Qué hace?: Técnica LEFT JOIN + WHERE IS NULL para encontrar películas sin ninguna renta. Patrón muy usado en análisis de datos perdidos.*/
SELECT f.film_id, f.title AS Pelicula
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;

-- /*Decima consulta: ¿Qué hace?: CREATE OR REPLACE VIEW (sintaxis MySQL) encapsula un JOIN complejo en un objeto reutilizable. Las vistas mejoran la mantenibilidad y el rendimiento.*/ 
-- Crear la vista --
CREATE OR REPLACE VIEW vw_resumen_peliculas AS
SELECT
    f.film_id,
    f.title AS Titulo,
    f.rental_rate AS PrecioRenta,
    f.length AS Duracion,
    f.rating AS Clasificacion,
    c.name AS Categoria,
    l.name AS Idioma
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id;

-- Consultar la vista --
SELECT * FROM vw_resumen_peliculas
WHERE Clasificacion = 'PG-13'
ORDER BY PrecioRenta DESC
LIMIT 20;


