-- Pruebas de verificación de integridad --
 
-- Q1: Intentar insertar país duplicado (debe fallar)-- 
INSERT INTO country (country) VALUES ('Argentina');
-- Segunda inserción → debe lanzar: Error 1062: Duplicate entry
INSERT INTO country (country) VALUES ('Argentina');

-- Q2: Ver todos los UNIQUE constraints del schema sakila -- 
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila' AND CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY TABLE_NAME;

-- Q3: Verificar que no hay ciudades duplicadas por país -- 
SELECT city, country_id, COUNT(*) AS Duplicados
FROM city
GROUP BY city, country_id
HAVING COUNT(*) > 1;
-- 						----> Resultado esperado: 0 filas <----

-- Q4: Verificar emails duplicados en customer -- 
SELECT email, COUNT(*) AS Veces
FROM customer
GROUP BY email
HAVING COUNT(*) > 1;

-- Q5: Verificar títulos de películas duplicados -- 
SELECT title, COUNT(*) AS Duplicados
FROM film
GROUP BY title
HAVING COUNT(*) > 1;

-- Q6: Intentar insertar actor con nombre duplicado--
INSERT INTO actor (first_name, last_name) VALUES ('JUAN', 'PEREZ');
-- Este debe fallar con Error 1062
INSERT INTO actor (first_name, last_name) VALUES ('JUAN', 'PEREZ');


-- Q7: Países sin ciudades asignadas -- 
SELECT co.country AS Pais
FROM country co
LEFT JOIN city ci ON co.country_id = ci.country_id
WHERE ci.city_id IS NULL
ORDER BY co.country;


-- Q8: Categorías sin películas asignadas -- 
SELECT c.name AS Categoria
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
WHERE fc.film_id IS NULL;


-- Q9: Ver índices UNIQUE de todas las tablas -- 
SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila' AND NON_UNIQUE = 0
ORDER BY TABLE_NAME, INDEX_NAME;


-- Q10: Resumen de tipos de constraints por tabla -- 
SELECT TABLE_NAME AS Tabla,
    CONSTRAINT_TYPE AS Tipo,
    COUNT(*) AS Cantidad
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
GROUP BY TABLE_NAME, CONSTRAINT_TYPE
ORDER BY TABLE_NAME;

