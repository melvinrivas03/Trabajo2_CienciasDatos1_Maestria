# orm/entities.py
# Entidades: cada clase mapea 1:1 con una tabla de MySQL.
# Cada instancia = una fila de esa tabla.

from dataclasses import dataclass
from typing import Optional
from datetime import datetime


@dataclass
class CountryEntity:
    """
    Mapea tabla: country
    Columnas: country_id (PK), country, last_update
    """
    country:     str
    country_id:  Optional[int]      = None
    last_update: Optional[datetime] = None

    def __str__(self):
        return f'Country(id={self.country_id}, name={self.country})'

    @classmethod
    def from_row(cls, row) -> 'CountryEntity':
        """Crea una entidad desde una fila de MySQL."""
        return cls(
            country_id=row[0],
            country=row[1],
            last_update=row[2] if len(row) > 2 else None
        )


@dataclass
class CityEntity:
    """
    Mapea tabla: city
    Columnas: city_id (PK), city, country_id (FK), last_update
    """
    city:        str
    country_id:  int
    city_id:     Optional[int]      = None
    last_update: Optional[datetime] = None

    def __str__(self):
        return f'City(id={self.city_id}, name={self.city}, pais_id={self.country_id})'

    @classmethod
    def from_row(cls, row) -> 'CityEntity':
        return cls(
            city_id=row[0],
            city=row[1],
            country_id=row[2],
            last_update=row[3] if len(row) > 3 else None
        )


@dataclass
class FilmEntity:
    """
    Mapea tabla: film
    """
    title:            str
    language_id:      int
    rental_rate:      float
    length:           int
    film_id:          Optional[int] = None
    description:      Optional[str] = None
    rating:           str           = 'G'
    rental_duration:  int           = 3
    replacement_cost: float         = 19.99

    def __str__(self):
        return (f'Film(id={self.film_id}, title={self.title}, '
                f'rate=${self.rental_rate}, rating={self.rating})')

    @classmethod
    def from_row(cls, row) -> 'FilmEntity':
        return cls(
            film_id=row[0],
            title=row[1],
            description=row[2],
            language_id=row[3],
            rental_duration=row[4],
            rental_rate=float(row[5]),
            length=row[6],
            replacement_cost=float(row[7]),
            rating=row[8]
        )


# ══ PRUEBA RÁPIDA ══════════════════════════════════
if __name__ == '__main__':
    c = CountryEntity(country='República Dominicana', country_id=1)
    ci = CityEntity(city='Santo Domingo', country_id=1, city_id=1)
    f = FilmEntity(title='El Padrino', language_id=1,
                   rental_rate=3.99, length=175, film_id=1)

    print('\n── Entidades creadas ──')
    print(c)
    print(ci)
    print(f)