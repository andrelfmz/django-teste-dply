# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-12-06 17:37
from __future__ import unicode_literals

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0020_auto_20171206_1525'),
    ]

    operations = [
        migrations.AddField(
            model_name='itensentrada',
            name='valort',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10, verbose_name='Subtotal'),
        ),
        migrations.AlterField(
            model_name='entrada',
            name='data',
            field=models.DateField(default=datetime.datetime(2017, 12, 6, 15, 37, 44, 908344)),
        ),
    ]
