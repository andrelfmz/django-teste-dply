# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-12-06 13:03
from __future__ import unicode_literals

import datetime
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0017_auto_20171204_1541'),
    ]

    operations = [
        migrations.AlterField(
            model_name='entrada',
            name='data',
            field=models.DateField(default=datetime.datetime(2017, 12, 6, 11, 3, 3, 404093)),
        ),
        migrations.AlterField(
            model_name='entrada',
            name='valortotal',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10, verbose_name='Valor total'),
        ),
        migrations.AlterField(
            model_name='itensentrada',
            name='entrada',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='logus.Entrada'),
        ),
        migrations.AlterField(
            model_name='itensentrada',
            name='valort',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10, verbose_name='Subtotal'),
        ),
        migrations.AlterField(
            model_name='itensentrada',
            name='valoru',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=10, verbose_name='Valor Unitário'),
        ),
    ]