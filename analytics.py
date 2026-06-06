# analytics.py
# Visualizaciones descriptivas sobre la base de datos Sakila.

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import mysql.connector
from config import get_config


def plot_film_metrics():
    """Genera 4 gráficas descriptivas sobre la tabla film."""
    conn = mysql.connector.connect(**get_config())
    df = pd.read_sql(
        'SELECT rental_rate, length, replacement_cost, rating FROM film',
        conn
    )
    conn.close()

    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    fig.suptitle(
        'Análisis Descriptivo — Tabla Film | Sakila MVC/ORM',
        fontsize=16, fontweight='bold'
    )

    # Gráfica 1: Distribución del precio de renta
    sns.histplot(df['rental_rate'], kde=True, ax=axes[0, 0], color='steelblue')
    axes[0, 0].set_title('Distribución del Precio de Renta')
    axes[0, 0].set_xlabel('Precio (USD)')
    axes[0, 0].set_ylabel('Frecuencia')

    # Gráfica 2: Boxplot de duración por clasificación
    sns.boxplot(data=df, x='rating', y='length', ax=axes[0, 1],
                palette='Set2', order=['G', 'PG', 'PG-13', 'R', 'NC-17'])
    axes[0, 1].set_title('Duración por Clasificación (rating)')
    axes[0, 1].set_xlabel('Clasificación')
    axes[0, 1].set_ylabel('Duración (min)')

    # Gráfica 3: Dispersión duración vs precio de renta
    sns.scatterplot(data=df, x='length', y='rental_rate',
                    ax=axes[1, 0], color='green', alpha=0.4)
    axes[1, 0].set_title('Correlación: Duración vs Precio de Renta')
    axes[1, 0].set_xlabel('Duración (min)')
    axes[1, 0].set_ylabel('Precio de Renta (USD)')

    # Gráfica 4: Conteo de películas por clasificación
    sns.countplot(data=df, x='rating', ax=axes[1, 1],
                  palette='muted', order=['G', 'PG', 'PG-13', 'R', 'NC-17'])
    axes[1, 1].set_title('Cantidad de Películas por Clasificación')
    axes[1, 1].set_xlabel('Clasificación')
    axes[1, 1].set_ylabel('Cantidad')

    plt.tight_layout()
    plt.savefig('output/film_analytics.png', dpi=150)
    plt.show()
    print('[OK] Gráfica guardada en output/film_analytics.png')


if __name__ == '__main__':
    plot_film_metrics()