#!/bin/bash

# Juntar arquivos estaticos
echo Juntando arquivos estaticos
exec python /code/manage.py collectstatic --noinput 

# Iniciar o Gunicorn
echo Iniciando o Gunicorn
exec gunicorn logusweb.wsgi:application \
     --bind 0.0.0.0:8000 \
     --workers 3
