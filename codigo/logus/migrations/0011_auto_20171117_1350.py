# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-11-17 15:50
from __future__ import unicode_literals

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0010_auto_20171117_1350'),
    ]

    operations = [
        migrations.AlterField(
            model_name='entrada',
            name='data',
            field=models.DateField(default=datetime.datetime(2017, 11, 17, 13, 50, 53, 870100)),
        ),
    ]
