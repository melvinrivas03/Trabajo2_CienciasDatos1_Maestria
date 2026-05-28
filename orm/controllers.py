# orm/controllers.py
# Controllers: lógica de negocio en arquitectura MVC.

from orm.models  import CountryModel, CityModel, FilmModel
from orm.entities import CountryEntity, CityEntity, FilmEntity
from typing import List, Optional


class CountryController:
    def __init__(self):
        self.model = CountryModel()

    def list_countries(self, limit: int = 20) -> List[CountryEntity]:
        countries = self.model.get_all(limit)
        print(f'\n──── {len(countries)} Países ────')
        for c in countries:
            print(f'  [{c.country_id:>4}] {c.country}')
        return countries

    def create_country(self, name: str) -> CountryEntity:
        name = name.strip().title()
        if len(name) < 2:
            raise ValueError('El nombre debe tener al menos 2 caracteres.')
        entity = CountryEntity(country=name)
        result = self.model.add(entity)
        print(f'[OK] País creado: {result}')
        return result

    def update_country(self, cid: int, new_name: str) -> bool:
        existing = self.model.get_by_id(cid)
        if not existing:
            print(f'[ERROR] No existe país con ID {cid}')
            return False
        existing.country = new_name.strip().title()
        self.model.update(existing)
        print(f'[OK] Actualizado: {existing}')
        return True

    def delete_country(self, cid: int) -> bool:
        result = self.model.delete(cid)
        if result:
            print(f'[OK] País {cid} eliminado.')
        return result

    def search_country(self, fragment: str) -> List[CountryEntity]:
        results = self.model.search(fragment)
        print(f'\nBúsqueda "{fragment}": {len(results)} resultado(s)')
        for c in results:
            print(f'  {c}')
        return results


class CityController:
    def __init__(self):
        self.model         = CityModel()
        self.country_model = CountryModel()

    def list_cities(self, country_id: int = None) -> List[CityEntity]:
        cities = (self.model.get_by_country(country_id)
                  if country_id else self.model.get_all())
        print(f'\n──── {len(cities)} Ciudades ────')
        for c in cities:
            print(f'  [{c.city_id:>4}] {c.city} (pais_id={c.country_id})')
        return cities

    def create_city(self, city_name: str, country_id: int) -> CityEntity:
        country = self.country_model.get_by_id(country_id)
        if not country:
            raise ValueError(f'No existe el país con ID {country_id}')
        entity = CityEntity(city=city_name.strip().title(), country_id=country_id)
        result = self.model.add(entity)
        print(f'[OK] Ciudad creada: {result}')
        return result


class FilmController:
    def __init__(self):
        self.model = FilmModel()

    def list_films(self, limit: int = 10, rating: str = None):
        films = (self.model.get_by_rating(rating)
                 if rating else self.model.get_all(limit))
        print(f'\n──── {len(films)} Películas ────')
        for f in films:
            print(f'  [{f.film_id:>4}] {f.title:<40} ${f.rental_rate} | {f.rating}')
        return films

    def create_film(self, title: str, language_id: int = 1,
                    rental_rate: float = 2.99, length: int = 90,
                    rating: str = 'G') -> FilmEntity:
        entity = FilmEntity(
            title=title.strip(), language_id=language_id,
            rental_rate=rental_rate, length=length, rating=rating
        )
        result = self.model.add(entity)
        print(f'[OK] Película creada: {result}')
        return result
    
    # ══ PRUEBA RÁPIDA ══════════════════════════════════
if __name__ == '__main__':
    print('\n── CountryController ──')
    ctrl = CountryController()
    ctrl.list_countries(5)

    print('\n── FilmController ──')
    film_ctrl = FilmController()
    film_ctrl.list_films(5)
    