# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models
from django.db.models import Sum
from django.utils import timezone
from django.db.models import Q

#import datetime
from django.utils.functional import cached_property
from django.db.models import Sum, F, DecimalField, ExpressionWrapper
from decimal import *
from django.core.validators import MinValueValidator
from model_utils import Choices

from .models import *
from .serializers import *

from rest_framework import viewsets, status
from rest_framework.response import Response
from django.http import Http404

# Create your models here.


# DataTable REST: Fornecedores
class FornecedorViewSet(viewsets.ModelViewSet):
    queryset = Fornecedor.objects.all()
    serializer_class = FornecedorSerializer

    def list(self, request, **kwargs):
        try:
            fornecedor = query_fornecedores_by_args(**request.query_params)
            serializer = FornecedorSerializer(fornecedor['items'], many=True)
            result = dict()
            result['data'] = serializer.data
            result['draw'] = fornecedor['draw']
            result['recordsTotal'] = fornecedor['total']
            result['recordsFiltered'] = fornecedor['count']
            return Response(result, status=status.HTTP_200_OK, template_name=None, content_type=None)

        except Exception as e:
            return Response(e, status=status.HTTP_404_NOT_FOUND, template_name=None, content_type=None)


def query_fornecedores_by_args(**kwargs):

    ORDER_COLUMN_CHOICES = Choices(
        ('0', 'id'),
        ('1', 'nome'),
        ('2', 'email'),
        ('3', 'tipo'),
    )

    draw = int(kwargs.get('draw', None)[0])
    length = int(kwargs.get('length', None)[0])
    start = int(kwargs.get('start', None)[0])
    search_value = kwargs.get('search[value]', None)[0]
    order_column = kwargs.get('order[0][column]', None)[0]
    order = kwargs.get('order[0][dir]', None)[0]

    order_column = ORDER_COLUMN_CHOICES[order_column]
    # django orm '-' -> desc
    if order == 'desc':
        order_column = '-' + order_column

    queryset = Fornecedor.objects.all()
    total = queryset.count()

    if search_value:
        queryset = queryset.filter(Q(id__icontains=search_value) |
                                        Q(nome__icontains=search_value) |
                                        Q(email__icontains=search_value))

    count = queryset.count()
    queryset = queryset.order_by(order_column)[start:start + length]
    return {
        'items': queryset,
        'count': count,
        'total': total,
        'draw': draw
    }


# DataTable REST: Entradas
class EntradaViewSet(viewsets.ModelViewSet):
    queryset = Entrada.objects.all()
    serializer_class = EntradaSerializer

    def list(self, request, **kwargs):
        try:
            entrada = query_entradas_by_args(**request.query_params)
            serializer = EntradaSerializer(entrada['items'], many=True)
            result = dict()
            result['data'] = serializer.data
            result['draw'] = entrada['draw']
            result['recordsTotal'] = entrada['total']
            result['recordsFiltered'] = entrada['count']
            return Response(result, status=status.HTTP_200_OK, template_name=None, content_type=None)

        except Exception as e:
            return Response(e, status=status.HTTP_404_NOT_FOUND, template_name=None, content_type=None)


def query_entradas_by_args(**kwargs):

    ORDER_COLUMN_CHOICES = Choices(
        ('0', 'id'),
        ('1', 'fornecedor'),
        ('2', 'valortotal'),
        ('3', 'data'),
    )

    draw = int(kwargs.get('draw', None)[0])
    length = int(kwargs.get('length', None)[0])
    start = int(kwargs.get('start', None)[0])
    search_value = kwargs.get('search[value]', None)[0]
    
    # Tratamento de DATAS para o Filtro (Converter para o Formato: yyyy-mm-dd)
    search_value_date = search_value.replace('/','-') #Substituir separador
    data_vetor = search_value_date.split('-') # Montar array
    cont = 0
    for n in data_vetor[::-1]:  # Percorrer Array de "trás para frente"
        if cont == 0:            
            search_value_date = n
        else:
            search_value_date = search_value_date + '-' + n
        cont += 1


    order_column = kwargs.get('order[0][column]', None)[0]
    order = kwargs.get('order[0][dir]', None)[0]

    order_column = ORDER_COLUMN_CHOICES[order_column]
    # django orm '-' -> desc
    if order == 'desc':
        order_column = '-' + order_column

    queryset = Entrada.objects.all()
    total = queryset.count()

    if search_value:
        queryset = queryset.filter(Q(id__icontains=search_value) |
                                        Q(fornecedor__nome__icontains=search_value) |
                                        Q(valortotal__icontains=search_value) |
                                        Q(data__icontains=search_value_date))

    count = queryset.count()
    queryset = queryset.order_by(order_column)[start:start + length]
    return {
        'items': queryset,
        'count': count,
        'total': total,
        'draw': draw
    }