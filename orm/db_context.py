# orm/db_context.py
# DbContext: capa de acceso a datos del ORM.
# Única clase que conoce el motor de BD (MySQL).

import mysql.connector
from typing import List, Any, Optional
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from config import get_config


class DbContext:
    """
    Clase base del ORM. Gestiona conexión y operaciones SQL.
    Patrón Unit of Work: agrupa operaciones en transacciones.
    """

    def __init__(self):
        self._conn   = mysql.connector.connect(**get_config())
        self._cursor = self._conn.cursor()

    def execute(self, sql: str, params: tuple = ()) -> 'DbContext':
        """Ejecuta INSERT, UPDATE o DELETE. Retorna self (fluent API)."""
        self._cursor.execute(sql, params)
        return self

    def fetchall(self, sql: str, params: tuple = ()) -> List[Any]:
        """Ejecuta SELECT y retorna todas las filas."""
        self._cursor.execute(sql, params)
        return self._cursor.fetchall()

    def fetchone(self, sql: str, params: tuple = ()) -> Optional[Any]:
        """Ejecuta SELECT y retorna la primera fila."""
        self._cursor.execute(sql, params)
        return self._cursor.fetchone()

    def last_id(self) -> int:
        """Retorna el ID del último INSERT."""
        return self._cursor.lastrowid

    def commit(self) -> None:
        """Confirma la transacción actual."""
        self._conn.commit()

    def rollback(self) -> None:
        """Revierte la transacción si algo falla."""
        self._conn.rollback()

    def close(self) -> None:
        """Cierra cursor y conexión."""
        self._cursor.close()
        self._conn.close()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type:
            self.rollback()
        else:
            self.commit()
        self.close()
        return False


class SakilaDbContext(DbContext):
    """Contexto específico de Sakila."""

    def get_tables(self) -> List[str]:
        rows = self.fetchall('SHOW TABLES')
        return [r[0] for r in rows]

    def row_count(self, table: str) -> int:
        row = self.fetchone(f'SELECT COUNT(*) FROM {table}')
        return row[0] if row else 0


# ══ PRUEBA RÁPIDA ══════════════════════════════════
if __name__ == '__main__':
    with SakilaDbContext() as ctx:
        tablas = ctx.get_tables()
        print(f'\n[OK] Conectado. Tablas en sakila: {len(tablas)}')
        for t in tablas:
            print(f'  {t}')