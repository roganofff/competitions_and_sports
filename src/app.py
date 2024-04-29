"""CRUD API for competitions, sports and stages."""
import os

from flask import Flask, request
from psycopg2.sql import SQL, Literal

import db_query
import http_codes as code
from db import connect

DEFAULT_PORT = 5001

app = Flask(__name__)
app.json.ensure_ascii = False

connection = connect()
connection.autocommit = True


@app.route('/')
def main_page() -> tuple[str, int]:
    """Welcome page handler.

    Returns:
        tuple[str, int]: HTML body and success code 200.
    """
    return '<p>This is the main page for crud hw.</p>', code.OK


@app.get('/competitions')
def get_competitions() -> tuple[str, int]:
    """Get request for all competitons, sports and stages.

    Returns:
        tuple[str, int]: JSON body and success code 200.
    """
    with connection.cursor() as cursor:
        cursor.execute(db_query.GET_COMPETITIONS)
        return cursor.fetchall(), code.OK


@app.post('/competitions/create')
def create_competition() -> tuple[str, int]:
    """Post request for new competition.

    Returns:
        tuple[str, int]: JSON body conatining ID of created competition and success code 201.
    """
    body = request.json

    query = SQL(db_query.INSERT_COMPETITION).format(
        comp_name=Literal(body['comp_name']),
        comp_start=Literal(body['comp_start']),
        comp_end=Literal(body['comp_end']),
    )

    with connection.cursor() as cursor:
        cursor.execute(query)
        return cursor.fetchone(), code.CREATED


@app.put('/competitions/update')
def update_competiton() -> tuple[str, int]:
    """Put request to update values of existing entity.

    Returns:
        tuple[str, int]: empty string and success code 204 or fail code 400.
    """
    body = request.json

    query = SQL(db_query.UPDATE_COMPETITION).format(
        id_=Literal(body['id']),
        comp_name=Literal(body['comp_name']),
        comp_start=Literal(body['comp_start']),
        comp_end=Literal(body['comp_end']),
    )

    with connection.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchone()

    if not result:
        return '', code.BAD_REQUEST
    return '', code.NO_CONTENT


@app.delete('/competitions/delete')
def delete_competiton() -> tuple[str, int]:
    """Delete request for existing competition.

    Returns:
        tuple[str, int]: empty string and success code 204 or fail code 400.
    """
    id_ = Literal(request.json['id'])

    delete_competition_sports = SQL(db_query.DELETE_COMPETITION_LINKS_SPORTS).format(id_=id_)
    delete_competition_stages = SQL(db_query.DELETE_COMPETITION_LINKS_STAGES).format(id_=id_)
    delete_competition = SQL(db_query.DELETE_COMPETITION).format(id_=id_)

    with connection.cursor() as cursor:
        cursor.execute(delete_competition_sports)
        cursor.execute(delete_competition_stages)
        cursor.execute(delete_competition)
        result = cursor.fetchall()

    if not result:
        return '', code.BAD_REQUEST
    return '', code.NO_CONTENT


if __name__ == '__main__':
    app.run(port=os.environ.get('FLASK_PORT', default=DEFAULT_PORT))
