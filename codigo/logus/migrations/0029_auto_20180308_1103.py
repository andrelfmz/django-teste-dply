# Generated by Django 2.0.1 on 2018-03-08 14:03

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('logus', '0028_auto_20180308_1039'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='fornecedor',
            options={'ordering': ['nome'], 'permissions': (('list_fornecedor', 'Permitir listar fornecedores'),), 'verbose_name': 'fornecedor', 'verbose_name_plural': 'fornecedores'},
        ),
    ]
