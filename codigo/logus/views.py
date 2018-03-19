# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render, get_object_or_404, redirect

from decimal import *

from .models import *

from .datatables import *

from .forms import *

# Create your views here.

from django.forms.models import inlineformset_factory
#from django.core.urlresolvers import *
from django.urls import *
from django.db import transaction
from django.views.generic import CreateView, UpdateView, DeleteView, ListView, TemplateView
from django.db.models.functions import Lower


# Imports para APIs (Serializers)
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import viewsets, status
from django.http import Http404
from .serializers import *

from django.contrib import messages

from dal import autocomplete

from django.contrib.auth.mixins import PermissionRequiredMixin


home = TemplateView.as_view(template_name='logus/index.html')


def erro_pagina(request):
        data = {}
        return render(request,'logus/erro_pagina.html', data)


# API-Produtos
class APIProdutoList(APIView):

    def get(self, request):
        produtos = Produto.objects.all()
        serializer = ProdutoSerializer(produtos, many=True)
        return Response(serializer.data)

    def post(self):
        pass

class APIProdutoDetail(APIView):

    def get_object(self, pk):
        try:
            return Produto.objects.get(pk=pk)
        except Produto.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        produto = self.get_object(pk)
        serializer = ProdutoSerializer(produto)
        return Response(serializer.data)

# API-Entradas
class APIEntradaList(APIView):

    def get(self, request):
        entradas = Entrada.objects.all()
        serializer = EntradaSerializer(entradas, many=True)
        return Response(serializer.data)

    def post(self):
        pass

class APIEntradaDetail(APIView):

    def get_object(self, pk):
        try:
            return Entrada.objects.get(pk=pk)
        except Entrada.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        entrada = self.get_object(pk)
        serializer = EntradaSerializer(entrada)
        return Response(serializer.data)

# API-Fornecedores
class APIFornecedorList(APIView):

    def get(self, request):
        fornecedores = Fornecedor.objects.all()
        serializer = FornecedorSerializer(fornecedores, many=True)
        return Response(serializer.data)

    def post(self):
        pass

class APIFornecedorDetail(APIView):

    def get_object(self, pk):
        try:
            return Fornecedor.objects.get(pk=pk)
        except Fornecedor.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        fornecedor = self.get_object(pk)
        serializer = FornecedorSerializer(fornecedor)
        return Response(serializer.data)


### (NOVO)

class ProdutoList(PermissionRequiredMixin, ListView):
    permission_required = 'logus.list_produto'

    model = Produto
    context_object_name = 'dados'
    paginate_by = 10
    #ordering = ['fornecedor','-id']
    ordering = ['-id']

    def get_queryset(self):
        dados = Produto.objects.all().order_by(Lower('descricao'),)
        q = self.request.GET.get('q')

        # Buscar por fornecedor
        if q is not None:
            dados = dados.filter(descricao__icontains=q)
        return dados

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(ProdutoList, self).handle_no_permission()

class ProdutoCreate(PermissionRequiredMixin, CreateView):
    permission_required = 'logus.add_produto'

    model = Produto
    success_url = reverse_lazy('produto-lista')
    form_class = ProdutoForm

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(ProdutoCreate, self).handle_no_permission()

class ProdutoUpdate(PermissionRequiredMixin, UpdateView):
    permission_required = 'logus.change_produto'

    model = Produto
    success_url = reverse_lazy('produto-lista')
    form_class = ProdutoForm

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(ProdutoUpdate, self).handle_no_permission()

class ProdutoDelete(PermissionRequiredMixin, DeleteView):
    permission_required = 'logus.delete_produto'

    model = Produto
    success_url = reverse_lazy('produto-lista')

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(ProdutoDelete, self).handle_no_permission()



###################


class FornecedorList(PermissionRequiredMixin, ListView):
    permission_required = 'logus.list_fornecedor'

    model = Fornecedor
    context_object_name = 'dados'

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(FornecedorList, self).handle_no_permission()


class FornecedorCreate(PermissionRequiredMixin, CreateView):
    permission_required = 'logus.add_fornecedor'

    model = Fornecedor
    success_url = reverse_lazy('fornecedor-lista')
    form_class = FornecedorForm

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(FornecedorCreate, self).handle_no_permission()


class FornecedorUpdate(PermissionRequiredMixin, UpdateView):
    permission_required = 'logus.change_fornecedor'

    model = Fornecedor
    success_url = reverse_lazy('fornecedor-lista')
    form_class = FornecedorForm

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(FornecedorUpdate, self).handle_no_permission()


class FornecedorDelete(PermissionRequiredMixin, DeleteView):
    permission_required = 'logus.delete_fornecedor'

    model = Fornecedor
    success_url = reverse_lazy('fornecedor-lista')

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(FornecedorDelete, self).handle_no_permission()

###################


class EntradaList(PermissionRequiredMixin, ListView):
    permission_required = 'logus.list_entrada'
    #queryset = Entrada.objects.extra(select={'lower_fornecedor':'Lower(fornecedor)'}).order_by('lower_fornecedor')
    #queryset = Entrada.objects.order_by("fornecedor","-id")
    #queryset = Entrada.objects.order_by(Lower('fornecedor'))    
    model = Entrada
    context_object_name = 'dados'
    #paginate_by = 10
    #ordering = ['fornecedor','-id']
    #ordering = ['-id']

    def get_queryset(self):
        dados = Entrada.objects.all().order_by('-id')[:10]
        #dados = Entrada.objects.all().order_by('-id')
        q = self.request.GET.get('q')

        if q is not None:
            if q == 'T':
                dados = Entrada.objects.all()
            else: 
                dados = Entrada.objects.all().order_by('-id')[:int(q)]

        return dados    

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(EntradaList, self).handle_no_permission()


class EntradaItensEntradaCreate(PermissionRequiredMixin, CreateView):
    permission_required = 'logus.add_entrada'

    model = Entrada
    form_class = EntradaForm
    template_name = 'logus/entrada_form.html'
    success_url = reverse_lazy('entrada-lista') 
    

    def get_context_data(self, **kwargs):
        data = super(EntradaItensEntradaCreate, self).get_context_data(**kwargs)
        if self.request.POST:
            data['itensentradas'] = ItensEntradaFormSet(self.request.POST)
        else:            
            data['itensentradas'] = ItensEntradaFormSet()
        return data

    def form_valid(self, form):
        context = self.get_context_data()
        itensentradas = context['itensentradas']
        with transaction.atomic():           
            self.object = form.save()

            if itensentradas.is_valid():
                itensentradas.instance = self.object
                itensentradas.save()
            else: # Código adicional 
                transaction.set_rollback(True)                
                context.update ({'itensentradas': itensentradas})                 
                return self.render_to_response (context)

        return super(EntradaItensEntradaCreate, self).form_valid(form)

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(EntradaItensEntradaCreate, self).handle_no_permission()


class EntradaItensEntradaUpdate(PermissionRequiredMixin, UpdateView):
    permission_required = 'logus.change_entrada'

    model = Entrada
    form_class = EntradaForm
    template_name = 'logus/entrada_form.html'
    
    success_url = reverse_lazy('entrada-lista')

    def get_context_data(self, **kwargs):
        data = super(EntradaItensEntradaUpdate, self).get_context_data(**kwargs)

        if self.request.POST:
            data['itensentradas'] = ItensEntradaFormSet(self.request.POST, instance=self.object)            
        else:
            data['itensentradas'] = ItensEntradaFormSet(instance=self.object)
        return data

    def form_valid(self, form):
        context = self.get_context_data()
        itensentradas = context['itensentradas']
        with transaction.atomic():
            self.object = form.save()

            if itensentradas.is_valid():
                itensentradas.instance = self.object
                itensentradas.save()
            else: # Código adicional
                transaction.set_rollback(True)                
                context.update ({'itensentradas': itensentradas}) 
                return self.render_to_response (context)

        return super(EntradaItensEntradaUpdate, self).form_valid(form)

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(EntradaItensEntradaCreate, self).handle_no_permission()


class EntradaDelete(PermissionRequiredMixin, DeleteView):
    permission_required = 'logus.delete_entrada'

    model = Entrada
    success_url = reverse_lazy('entrada-lista')

    def handle_no_permission(self):
        # add custom message
        messages.error(self.request, 'Você não tem permissão')
        return super(EntradaDelete, self).handle_no_permission()


###################
#AUTOCOMPLETE
class FornecedorAutocomplete(autocomplete.Select2QuerySetView):
    def get_queryset(self):
        # Don't forget to filter out results depending on the visitor !
        #if not self.request.user.is_authenticated():
        #    return Fornecedor.objects.none()

        qs = Fornecedor.objects.all().order_by(Lower('nome'))

        if self.q:
            qs = qs.filter(nome__istartswith=self.q).order_by(Lower('nome'))

        return qs

class ProdutoAutocomplete(autocomplete.Select2QuerySetView):
    def get_queryset(self):
        # Don't forget to filter out results depending on the visitor !
        #if not self.request.user.is_authenticated():
        #    return Fornecedor.objects.none()

        qs = Produto.objects.all().order_by(Lower('descricao'))

        if self.q:
            qs = qs.filter(descricao__istartswith=self.q).order_by(Lower('descricao'))

        return qs


####################