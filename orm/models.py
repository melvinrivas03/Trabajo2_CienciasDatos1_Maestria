# orm/models.py
# Models: List<Entity> + CRUD completo por entidad.
# Patrón Repository: encapsula acceso a datos.

from typing import List, Optional
from orm.db_context import SakilaDbContext
from orm.entities  import CountryEntity, CityEntity, FilmEntity


class CountryModel:
    """Repositorio para CountryEntity."""

    def get_all(self, limit: int = 50) -> List[CountryEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT country_id, country, last_update FROM country ORDER BY country LIMIT %s',
                (limit,)
            )
        return [CountryEntity.from_row(r) for r in rows]

    def get_by_id(self, cid: int) -> Optional[CountryEntity]:
        with SakilaDbContext() as ctx:
            row = ctx.fetchone(
                'SELECT country_id, country, last_update FROM country WHERE country_id = %s',
                (cid,)
            )
        return CountryEntity.from_row(row) if row else None

    def add(self, entity: CountryEntity) -> CountryEntity:
        with SakilaDbContext() as ctx:
            ctx.execute(
                'INSERT INTO country (country) VALUES (%s)',
                (entity.country,)
            )
            entity.country_id = ctx.last_id()
        return entity

    def update(self, entity: CountryEntity) -> bool:
        with SakilaDbContext() as ctx:
            ctx.execute(
                'UPDATE country SET country = %s WHERE country_id = %s',
                (entity.country, entity.country_id)
            )
        return True

    def delete(self, cid: int) -> bool:
        with SakilaDbContext() as ctx:
            ctx.execute('DELETE FROM country WHERE country_id = %s', (cid,))
        return True

    def search(self, fragment: str) -> List[CountryEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT country_id, country, last_update FROM country WHERE country LIKE %s',
                (f'%{fragment}%',)
            )
        return [CountryEntity.from_row(r) for r in rows]


class CityModel:
    """Repositorio para CityEntity."""

    def get_all(self, limit: int = 50) -> List[CityEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT city_id, city, country_id, last_update FROM city ORDER BY city LIMIT %s',
                (limit,)
            )
        return [CityEntity.from_row(r) for r in rows]

    def get_by_country(self, country_id: int) -> List[CityEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT city_id, city, country_id, last_update FROM city WHERE country_id = %s ORDER BY city',
                (country_id,)
            )
        return [CityEntity.from_row(r) for r in rows]

    def add(self, entity: CityEntity) -> CityEntity:
        with SakilaDbContext() as ctx:
            ctx.execute(
                'INSERT INTO city (city, country_id) VALUES (%s, %s)',
                (entity.city, entity.country_id)
            )
            entity.city_id = ctx.last_id()
        return entity

    def delete(self, city_id: int) -> bool:
        with SakilaDbContext() as ctx:
            ctx.execute('DELETE FROM city WHERE city_id = %s', (city_id,))
        return True


class FilmModel:
    """Repositorio para FilmEntity."""

    def get_all(self, limit: int = 20) -> List[FilmEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT film_id, title, description, language_id, rental_duration, '
                'rental_rate, length, replacement_cost, rating '
                'FROM film ORDER BY title LIMIT %s',
                (limit,)
            )
        return [FilmEntity.from_row(r) for r in rows]

    def get_by_rating(self, rating: str) -> List[FilmEntity]:
        with SakilaDbContext() as ctx:
            rows = ctx.fetchall(
                'SELECT film_id, title, description, language_id, rental_duration, '
                'rental_rate, length, replacement_cost, rating '
                'FROM film WHERE rating = %s ORDER BY title',
                (rating,)
            )
        return [FilmEntity.from_row(r) for r in rows]

    def add(self, entity: FilmEntity) -> FilmEntity:
        with SakilaDbContext() as ctx:
            ctx.execute(
                '''INSERT INTO film
                   (title, description, language_id, rental_duration,
                    rental_rate, length, replacement_cost, rating)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)''',
                (entity.title, entity.description, entity.language_id,
                 entity.rental_duration, entity.rental_rate, entity.length,
                 entity.replacement_cost, entity.rating)
            )
            entity.film_id = ctx.last_id()
        return entity

    def update_rate(self, film_id: int, new_rate: float) -> bool:
        with SakilaDbContext() as ctx:
            ctx.execute(
                'UPDATE film SET rental_rate = %s WHERE film_id = %s',
                (new_rate, film_id)
            )
        return True

    def delete(self, film_id: int) -> bool:
        with SakilaDbContext() as ctx:
            ctx.execute('DELETE FROM film WHERE film_id = %s', (film_id,))
        return True


# ══ PRUEBA RÁPIDA ══════════════════════════════════
if __name__ == '__main__':
    print('\n── CountryModel: primeros 5 países ──')
    model = CountryModel()
    for c in model.get_all(5):
        print(f'  {c}')

    print('\n── FilmModel: primeras 5 películas ──')
    film_model = FilmModel()
    for f in film_model.get_all(5):
        print(f'  {f}')