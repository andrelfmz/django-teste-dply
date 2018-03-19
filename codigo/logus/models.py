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


from django.contrib.auth.models import User

# Create your models here.

class Fornecedor(models.Model):

    TIPO_PESSOA = (
        ('F', 'Física'),
        ('J', 'Jurídica'),
    )

    nome = models.CharField(max_length=100)
    email = models.EmailField()
    fone1 = models.CharField('telefone 1',max_length=20)
    fone2 = models.CharField('telefone 2',max_length=20)
    data_pub = models.DateField('data do cadastro',auto_now_add=True)
    tipo = models.CharField(max_length=1,choices=TIPO_PESSOA)

    class Meta:
        ordering = ['nome']
        verbose_name = 'fornecedor'
        verbose_name_plural = 'fornecedores'
        permissions = (("list_fornecedor", "Permitir listar fornecedores"),)

    def __str__(self):
        return self.nome

    def save(self, *args, **kwargs):        
        self.nome = self.nome.upper() #Salvar com caixa alta
        super(Fornecedor, self).save(*args, **kwargs)

class Produto(models.Model):
    descricao = models.CharField(max_length=50)
    valor = models.DecimalField(max_digits=10,decimal_places=2,validators=[MinValueValidator(Decimal('0.00'))])
    estoque = models.DecimalField(max_digits=10,decimal_places=3,default=0)

    class Meta:
        ordering = ['descricao']
        verbose_name = 'produto'
        verbose_name_plural = 'produtos'
        permissions = (("list_produto", "Permitir listar produtos"),)

    def __str__(self):
        return self.descricao

    def save(self, *args, **kwargs):        
        self.nome = self.descricao.upper() #Salvar com caixa alta
        super(Produto, self).save(*args, **kwargs)


class Entrada(models.Model):
    fornecedor = models.ForeignKey(Fornecedor,on_delete=models.CASCADE,related_name='fornecedores')
    #data = models.DateField(default=datetime.datetime.now())
    data = models.DateField(default=timezone.now, blank=True)
    valortotal = models.DecimalField('Valor total',max_digits=10,decimal_places=2,default=0)

    def __str__(self):
        return '%s (%s)' % (self.id, self.fornecedor) 

    class Meta:
        verbose_name = 'entrada'
        verbose_name_plural = 'entradas'
        permissions = (("list_entrada", "Permitir listar entradas"),)


    #itens = models.ManyToManyField('ItensEntrada')
    #itens = models.ManyToManyField('entrada',through='ItensEntrada')
    ##itens = models.ManyToManyField('produto',through='ItensEntrada',through_fields=('entrada','produto'))
   
    #@cached_property
    #def get_total(self):
    #    total = 0.0
    #    for item in ItensEntrada.objects.filter(entrada=self.id):
    #        total += float(item.valort)
    #    return total
    
    #@cached_property
    ##def get_total(self):        
    ##    total = Decimal(ItensEntrada.objects.values('valoru', 'quantidade').filter(entrada=self.id).aggregate(total=Sum(F('valoru') * F('quantidade')))['total']) or Decimal('0.00')
        #total = ItensEntrada.objects.values('valoru', 'quantidade').filter(entrada=self.id).aggregate(total=ExpressionWrapper(Sum(F('valoru') * F('quantidade')), output_field=DecimalField()))['total']
    ##    return total


    ##def save(self, *args, **kwargs):        
        #self.valortotal = self.get_total()
        #print([e.produto.estoque for e in item.objects.all()])
        #self.itens.objects.all().aggregate(vt=Sum('valor'))
        #self.valortotal = vt
        ##super(Entrada, self).save(*args, **kwargs)



class ItensEntrada(models.Model):
    entrada = models.ForeignKey(Entrada,on_delete=models.CASCADE,)
    produto = models.ForeignKey(Produto,on_delete=models.CASCADE,)
    quantidade = models.DecimalField(max_digits=10,decimal_places=3,default=0.000)
    valoru = models.DecimalField('Valor Unitário',max_digits=10,decimal_places=2,default=0.00)
    valort = models.DecimalField('Subtotal',max_digits=10,decimal_places=2,default=0.00)    
    

    ##@property
    ##def get_valort(self):
    ##    return self.valoru * self.quantidade

    ##valort = get_valort

    ##def save(self, *args, **kwargs):
    ##    #self.valort = self.valoru * self.quantidade
    ##    super(ItensEntrada, self).save(*args, **kwargs)
