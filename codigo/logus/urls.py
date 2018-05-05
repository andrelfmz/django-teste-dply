from django.conf.urls import include, url
from . import views
from .datatables import *

from rest_framework.urlpatterns import format_suffix_patterns


from rest_framework.routers import DefaultRouter

from django.contrib.auth import views as auth_views

router = DefaultRouter()
router.register(r'fornecedores', FornecedorViewSet)
router.register(r'entradas', EntradaViewSet)


urlpatterns = [
        
    #Home
    url(r'^$', views.home, name='home'),
    
    #Entrada (NOVO)
    url(r'entrada/$', views.EntradaList.as_view(), name='entrada-lista'),    
    url(r'entrada/add/$', views.EntradaItensEntradaCreate.as_view(), name='entrada-add'),    
    url(r'entrada/(?P<pk>[0-9]+)/edit/$', views.EntradaItensEntradaUpdate.as_view(), name='entrada-update'),
    url(r'entrada/(?P<pk>[0-9]+)/delete/$', views.EntradaDelete.as_view(), name='entrada-delete'),

    #Produto
    url(r'produto/$', views.ProdutoList.as_view(), name='produto-lista'),
    url(r'produto/add/$', views.ProdutoCreate.as_view(), name='produto-add'),
    url(r'produto/(?P<pk>[0-9]+)/edit/$', views.ProdutoUpdate.as_view(), name='produto-update'),
    url(r'produto/(?P<pk>[0-9]+)/delete/$', views.ProdutoDelete.as_view(), name='produto-delete'),
    url(r'produto/autocomplete/$', views.ProdutoAutocomplete.as_view(), name='produto-autocomplete'),

    #Fornecedor
    url(r'fornecedor/$', views.FornecedorList.as_view(), name='fornecedor-lista'),         
    url(r'fornecedor/add/$', views.FornecedorCreate.as_view(), name='fornecedor-add'),
    url(r'fornecedor/(?P<pk>[0-9]+)/edit/$', views.FornecedorUpdate.as_view(), name='fornecedor-update'),
    url(r'fornecedor/(?P<pk>[0-9]+)/delete/$', views.FornecedorDelete.as_view(), name='fornecedor-delete'),
    url(r'fornecedor/autocomplete/$', views.FornecedorAutocomplete.as_view(), name='fornecedor-autocomplete'),

    #(API's)
    #Produtos
    url(r'^api/produtos/$', views.APIProdutoList.as_view()),
    url(r'^api/produtos/(?P<pk>[0-9]+)/$', views.APIProdutoDetail.as_view()),
    #Entradas
    url(r'^api/entradas/$', views.APIEntradaList.as_view()),
    url(r'^api/entradas/(?P<pk>[0-9]+)/$', views.APIEntradaDetail.as_view()),
    #Fornecedores    
    url(r'^api/fornecedores/$', views.APIFornecedorList.as_view()),
    url(r'^api/fornecedores/(?P<pk>[0-9]+)/$', views.APIFornecedorDetail.as_view()),

    #API's Datatables
    url(r'^api2/', include(router.urls)),
 
]

#urlpatterns = format_suffix_patterns(urlpatterns)