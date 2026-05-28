# Caso Práctico 2 — Ciencias de Datos 1
**INF-8237-C2 | Maestría en Ciencia de Datos e IA | UASD**

> CRUD y ORM nativo en Python sobre la base de datos Sakila (MySQL 9.7).
> Arquitectura MVC con DbContext, Entity, Model y Controller.

---

## Tabla de Contenidos
- [Caso Práctico 2 — Ciencias de Datos 1](#caso-práctico-2--ciencias-de-datos-1)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Descripción](#descripción)
  - [Tecnologías](#tecnologías)
  - [Instalación](#instalación)
  - [Configuración](#configuración)
  - [Uso](#uso)
  - [Arquitectura MVC](#arquitectura-mvc)
  - [Estructura del Proyecto](#estructura-del-proyecto)
  - [Errores Comunes](#errores-comunes)
  - [Contribución](#contribución)
  - [Licencia](#licencia)
  - [Autores](#autores)

---

## Descripción
Este proyecto implementa un sistema CRUD completo y un ORM nativo en Python
sobre la base de datos de ejemplo **Sakila** de MySQL. Incluye:
- 10 consultas SQL con evidencias
- UNIQUE CONSTRAINTS para integridad referencial
- CRUD modular para Country, City y Film
- Importación y exportación CSV/JSON
- Métricas descriptivas (media, rango, desviación, varianza, covarianza)
- ORM propio con arquitectura MVC

---

## Tecnologías
| Herramienta | Versión |
|---|---|
| Python | 3.14 |
| MySQL | 9.7 |
| MySQL Workbench | 8.x |
| mysql-connector-python | 9.7.0 |
| pandas | 3.0.3 |
| numpy | 2.4.6 |

---

## Instalación

**1. Clona el repositorio:**
```bash
git clone https://github.com/melvinrivas03/Trabajo2_CienciasDatos1_Maestria.git
cd Trabajo2_CienciasDatos1_Maestria
```

**2. Instala las dependencias:**
```bash
pip install -r requirements.txt
```

**3. Carga Sakila en MySQL Workbench:**
- Descarga sakila-db.zip desde https://dev.mysql.com/doc/index-other.html
- Ejecuta `sakila-schema.sql` primero
- Ejecuta `sakila-data.sql` después

---

## Configuración

Crea un archivo `.env` en la raíz del proyecto con estas variables:

```env
# Configuración de conexión a MySQL
DB_USER=root
DB_PASSWORD=tu_contraseña_aqui
```

> ⚠️ Nunca compartas tu archivo `.env`. Ya está incluido en `.gitignore`.

---

## Uso

**Ejecutar la aplicación principal:**
```bash
python main.py
```

**Resultado esperado:**


**Ejecutar solo las métricas:**
```bash
python metrics.py
```

**Resultado esperado:**


**Ejecutar CRUD básico:**
```bash
python crud_basic.py
```

**Exportar datos a CSV y JSON:**
```bash
python import_export.py
```
Genera archivos en la carpeta `output/`:


---

## Arquitectura MVC

**Capas del sistema:**

| Capa | Archivo | Responsabilidad |
|---|---|---|
| Router | `main.py` | Menú y enrutamiento |
| Controller | `orm/controllers.py` | Lógica de negocio y validaciones |
| Model | `orm/models.py` | List\<Entity\> + operaciones CRUD |
| Entity | `orm/entities.py` | Mapeo 1:1 con tablas MySQL |
| DbContext | `orm/db_context.py` | Conexión y transacciones |
| Config | `config.py` | Parámetros de conexión |

---

## Estructura del Proyecto

---

## Errores Comunes

| Error | Causa | Solución |
|---|---|---|
| `No module named 'mysql'` | Conector no instalado | `pip install mysql-connector-python` |
| `Access denied for user root` | Contraseña incorrecta | Verifica `.env` y `config.py` |
| `Unknown database sakila` | Sakila no cargada | Ejecuta los scripts SQL en Workbench |
| `No module named 'config'` | Ruta incorrecta | Ejecuta desde la raíz del proyecto |
| `No module named 'orm'` | Módulo no reconocido | Usa `python -m orm.models` en lugar de `python orm/models.py` |
| `Duplicate entry` al INSERT | UNIQUE constraint activo | Normal — usa `INSERT IGNORE` |
| MySQL vacío al abrir PC | Servicio detenido | Ejecuta `net start MySQL97` en PowerShell como administrador |

---

## Contribución

1. Haz fork del repositorio
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Realiza tus cambios y haz commit: `git commit -m "agrega nueva funcionalidad"`
4. Sube la rama: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

---

## Licencia

Este proyecto es de uso académico — **INF-8237-C2, UASD**.
Libre para usar con fines educativos citando la fuente.

---

## Autores

| Nombre | GitHub |
|---|---|
| Melvin H. Rivas G. | [@melvinrivas03](https://github.com/melvinrivas03) |

---

*Proyecto desarrollado para la Maestría en Ciencia de Datos e Inteligencia Artificial — UASD, 2026.*