# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-11-13 17:10
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0006_itensentrada__valort'),
    ]

    operations = [
        migrations.RenameField(
            model_name='itensentrada',
            old_name='_valort',
            new_name='valort',
        ),
    ]
