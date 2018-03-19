# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

# Register your models here.

from logus.models import *

@admin.register(Fornecedor)
class FornecedorAdmin(admin.ModelAdmin):
    list_display = ('nome','id','fone1','fone2','data_pub',)
    list_filter = ('data_pub',)
    search_fields = ('nome',)
    ordering = ('fone1',)
    date_hierarchy = 'data_pub'

@admin.register(Produto)
class ProdutoAdmin(admin.ModelAdmin):
    list_display = ('descricao','id','valor','estoque',)
    list_filter = ('valor',)
    search_fields = ('descricao',)
    ordering = ('descricao',)
    readonly_fields = ('estoque',)

class ItensEntradaInline(admin.TabularInline):
    list_display = ('produto','quantidade','valoru',)
    readonly_fields = ('valort',)
    model = ItensEntrada
    extra = 0

@admin.register(Entrada)
class EntradaAdmin(admin.ModelAdmin):
    list_display = ('fornecedor','id','data','valortotal',)
    list_filter = ('data',)
    search_fields = ('fornecedor__nome',)
    ordering = ('data',)
    inlines = (ItensEntradaInline,)
    list_per_page = 10
