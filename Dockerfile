# pull official base image
FROM python:3.8.1-alpine

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies for building
RUN set -eux \
    && apk add --no-cache --virtual .build-deps build-base \
        libressl-dev libffi-dev gcc musl-dev python3-dev \
        postgresql-dev \
    && apk add --no-cache curl

# install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -


ENV PATH="/root/.local/bin:$PATH"

# copy pyproject.toml and poetry.lock
COPY pyproject.toml poetry.lock* /usr/src/app/

# install dependencies
RUN poetry install --no-root --no-dev

# copy project files
COPY . /usr/src/app/
