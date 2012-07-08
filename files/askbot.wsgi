#!/usr/bin/python
import os
import sys

os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
