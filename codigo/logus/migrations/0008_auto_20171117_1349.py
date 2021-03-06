# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2017-11-17 15:49
from __future__ import unicode_literals

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0007_auto_20171113_1510'),
    ]

    operations = [
        migrations.AlterField(
            model_name='entrada',
            name='data',
            field=models.DateField(default=datetime.datetime(2017, 11, 17, 13, 49, 22, 144158)),
        ),
        migrations.AlterField(
            model_name='entrada',
            name='itens',
            field=models.ManyToManyField(through='logus.ItensEntrada', to='logus.Entrada'),
        ),
        migrations.AlterField(
            model_name='entrada',
            name='valortotal',
            field=models.DecimalField(decimal_places=2, max_digits=10, verbose_name='Valor total'),
        ),
    ]
