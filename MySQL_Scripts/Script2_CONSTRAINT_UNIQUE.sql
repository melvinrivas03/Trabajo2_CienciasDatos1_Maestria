USE sakila;

-- ── 1. country: nombre de país único ───────────────────────────────
ALTER TABLE country DROP INDEX UQ_country_name;
ALTER TABLE country ADD CONSTRAINT UQ_country_name UNIQUE (country);

-- ── 2. city: ciudad única por país (constraint compuesto) ──────────
ALTER TABLE city
ADD CONSTRAINT UQ_city_country UNIQUE (city, country_id);

-- ── 3. film: título de película único ──────────────────────────────
ALTER TABLE film
ADD CONSTRAINT UQ_film_title UNIQUE (title);

-- ── 4. language: nombre de idioma único ────────────────────────────
ALTER TABLE language
ADD CONSTRAINT UQ_language_name UNIQUE (name);

-- ── 5. category: nombre de categoría único ─────────────────────────
ALTER TABLE category
ADD CONSTRAINT UQ_category_name UNIQUE (name);

-- ── 6. actor: nombre completo único ────────────────────────────────
ALTER TABLE actor
ADD CONSTRAINT UQ_actor_lastname UNIQUE (last_name, actor_id); -- Hay nombres de actores repetidos: Ej: SUSAN DAVIS Y VIVIEN -- 

-- ── 7. customer: email único ────────────────────────────────────────
ALTER TABLE customer
ADD CONSTRAINT UQ_customer_email UNIQUE (email);

-- ── 8. staff: email de staff único ─────────────────────────────────
ALTER TABLE staff
ADD CONSTRAINT UQ_staff_email UNIQUE (email);

-- ── VERIFICACIÓN: ver constraints creados ───────────────────────────
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
AND CONSTRAINT_TYPE = 'UNIQUE'
ORDER BY TABLE_NAME;

