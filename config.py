# config.py
import os

DB_CONFIG = {
    'host':     'localhost',
    'port':     3306,
    'database': 'sakila',
    'user':     'root',
    'password': os.environ.get('DB_PASSWORD', ''),
}

def get_config() -> dict:
    return DB_CONFIG
