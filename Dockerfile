FROM python:alpine

LABEL maintainer="lucky.wirasakti@icloud.com"

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

COPY . .

RUN addgroup -S app && adduser -S app -G app
RUN chown -R app:app /usr/src/app
USER app

ENTRYPOINT ["sh", "entrypoint.sh"]