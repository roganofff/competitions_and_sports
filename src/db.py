"""This module provides connection to the database."""
import os

import psycopg2
from dotenv import load_dotenv
from psycopg2.extensions import connection
from psycopg2.extras import RealDictCursor

load_dotenv()


def connect() -> connection:
    """Connect to the database.

    Returns:
        connection: an instance of connection class.
    """
    credentials = {
        'host': os.getenv('POSTGRES_HOST'),
        'port': os.getenv('POSTGRES_PORT'),
        'user': os.getenv('POSTGRES_USER'),
        'database': os.getenv('POSTGRES_DBNAME'),
        'password': os.getenv('POSTGRES_PASSWORD'),
    }

    return psycopg2.connect(
        **credentials,
        cursor_factory=RealDictCursor,
    )
