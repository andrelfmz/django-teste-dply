# -*- coding: utf-8 -*-
# Generated by Django 1.9 on 2017-11-11 20:33
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0002_auto_20171111_1640'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='offer',
            name='geo',
        ),
        migrations.DeleteModel(
            name='Offer',
        ),
        migrations.DeleteModel(
            name='OfferGeo',
        ),
    ]
