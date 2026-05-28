# metrics.py
# Métricas descriptivas: media, rango, desviación, varianza y covarianza.

import pandas as pd
import mysql.connector
from config import get_config


def get_conn():
    return mysql.connector.connect(**get_config())


def load_df(query: str) -> pd.DataFrame:
    """Ejecuta un query y retorna un DataFrame de pandas."""
    conn = get_conn()
    df = pd.read_sql(query, conn)
    conn.close()
    return df


def descriptive_metrics(df: pd.DataFrame, col: str) -> dict:
    """Calcula las 5 métricas descriptivas requeridas."""
    s = df[col].dropna()
    return {
        'columna':    col,
        'n':          len(s),
        'media':      round(float(s.mean()), 4),
        'rango':      round(float(s.max() - s.min()), 4),
        'desviacion': round(float(s.std()), 4),
        'varianza':   round(float(s.var()), 4),
    }


def covariance(df: pd.DataFrame, col1: str, col2: str) -> float:
    """Covarianza entre dos columnas numéricas."""
    return round(float(df[[col1, col2]].cov().loc[col1, col2]), 4)

def run_film_metrics():
    """Calcula y muestra métricas sobre la tabla film."""
    df = load_df('SELECT rental_rate, length, rental_duration FROM film')
    print('\n====== MÉTRICAS DESCRIPTIVAS — Tabla: film ======')
    for col in ['rental_rate', 'length', 'rental_duration']:
        m = descriptive_metrics(df, col)
        print(f'\n  Columna    : {m["columna"]} (n={m["n"]})')
        print(f'  Media      : {m["media"]}')
        print(f'  Rango      : {m["rango"]}')
        print(f'  Desviación : {m["desviacion"]}')
        print(f'  Varianza   : {m["varianza"]}')
    print(f'\n  Covarianza(rental_rate, length): {covariance(df, "rental_rate", "length")}')

if __name__ == '__main__':
    run_film_metrics()