FROM python:3.8.1-alpine

WORKDIR /usr/src

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN set -eux \
    && apk add --no-cache --virtual .build-deps build-base \
        libressl-dev libffi-dev gcc musl-dev python3-dev \
        postgresql-dev \
    && apk add --no-cache curl bash

RUN pip install --upgrade pip \
    && pip install cryptography==3.3.2 \
    && pip install uvicorn  # Instala uvicorn globalmente

RUN pip install poetry==1.8.1

ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml poetry.lock* /usr/src/

RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-dev

COPY . /usr/src/

EXPOSE 8000
