# main.py
# Router: menú interactivo que conecta toda la arquitectura MVC.

import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from orm.controllers import CountryController, CityController, FilmController
from import_export   import export_to_csv, import_from_csv, export_to_json, import_from_json
from metrics         import run_film_metrics

country_ctrl = CountryController()
city_ctrl    = CityController()
film_ctrl    = FilmController()


def menu():
    while True:
        print('\n' + '='*50)
        print(' SAKILA ORM — Ciencias de Datos 1')
        print(' MySQL + Python + MVC')
        print('='*50)
        print(' 1. Países     → CRUD')
        print(' 2. Ciudades   → CRUD')
        print(' 3. Películas  → CRUD')
        print(' 4. Exportar   → CSV y JSON')
        print(' 5. Importar   → CSV y JSON')
        print(' 6. Métricas   → Estadísticas descriptivas')
        print(' 0. Salir')
        print('='*50)
        op = input(' Opción: ').strip()
        if   op == '1': menu_countries()
        elif op == '2': menu_cities()
        elif op == '3': menu_films()
        elif op == '4': menu_export()
        elif op == '5': menu_import()
        elif op == '6': run_film_metrics()
        elif op == '0': print('¡Hasta luego!'); break
        else: print('[!] Opción inválida.')


def menu_countries():
    print('\na) Listar  b) Crear  c) Actualizar  d) Eliminar  e) Buscar')
    s = input('Opción: ').strip().lower()
    if s == 'a':
        country_ctrl.list_countries()
    elif s == 'b':
        country_ctrl.create_country(input('Nombre del país: '))
    elif s == 'c':
        country_ctrl.update_country(int(input('ID: ')), input('Nuevo nombre: '))
    elif s == 'd':
        country_ctrl.delete_country(int(input('ID a eliminar: ')))
    elif s == 'e':
        country_ctrl.search_country(input('Fragmento a buscar: '))


def menu_cities():
    print('\na) Listar  b) Por país  c) Crear')
    s = input('Opción: ').strip().lower()
    if s == 'a':
        city_ctrl.list_cities()
    elif s == 'b':
        city_ctrl.list_cities(country_id=int(input('ID del país: ')))
    elif s == 'c':
        city_ctrl.create_city(input('Nombre ciudad: '), int(input('ID del país: ')))


def menu_films():
    print('\na) Listar  b) Por clasificación  c) Crear')
    s = input('Opción: ').strip().lower()
    if s == 'a':
        film_ctrl.list_films()
    elif s == 'b':
        film_ctrl.list_films(rating=input('Clasificación (G/PG/PG-13/R/NC-17): ').upper())
    elif s == 'c':
        film_ctrl.create_film(
            input('Título: '),
            rental_rate=float(input('Precio renta: ')),
            length=int(input('Duración (min): ')),
            rating=input('Clasificación: ').upper()
        )


def menu_export():
    os.makedirs('output', exist_ok=True)
    for t in ['country', 'city', 'film']:
        export_to_csv(t,  f'output/{t}.csv')
        export_to_json(t, f'output/{t}.json')
    print('[OK] Archivos en carpeta output/')


def menu_import():
    import_from_csv( 'output/country.csv',  'country')
    import_from_json('output/country.json', 'country')


if __name__ == '__main__':
    menu()