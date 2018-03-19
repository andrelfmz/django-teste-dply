# -*- coding: utf-8 -*-
import os
from settings import *

DEBUG = False

ALLOWED_HOSTS = [
    '*',
]

DATABASES = { 
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'postgres',
        'PASSWORD': 'example',
        'HOST': 'db', # Link do Container
        'PORT': '',
    }   
}

# DEPLOY c/ GUNICORN e para rodar o CollectStatic
STATIC_ROOT = os.path.join(BASE_DIR, "static")