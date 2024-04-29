FROM python:3.10.12

WORKDIR /flask_homework

COPY /src .
COPY requirements.txt .

RUN pip install -r requirements.txt