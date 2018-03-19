from rest_framework import serializers
from django.utils.formats import number_format
from .models import *

# Funcao para buscar o resultado de Choices (Ex. F/J -  Física / Jurídica)
class ChoicesSerializerField(serializers.SerializerMethodField):
    """
    A read-only field that return the representation of a model field with choices.
    """

    def to_representation(self, value):
        # sample: 'get_XXXX_display'
        method_name = 'get_{field_name}_display'.format(field_name=self.field_name)
        # retrieve instance method
        method = getattr(value, method_name)
        # finally use instance method to return result of get_XXXX_display()
        return method()


class ProdutoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Produto
        # fields = ('descricao','valor')
        fields = '__all__'


class EntradaSerializer(serializers.ModelSerializer):
    
    fornecedor = serializers.CharField(source='fornecedor.nome')
    valortotal = serializers.SerializerMethodField('valortotal_formatado')

    class Meta:
        model = Entrada          
        fields = '__all__'

    def valortotal_formatado(self, obj):
        if obj.valortotal:
            return number_format(obj.valortotal)
        else: 
            return None

class FornecedorSerializer(serializers.ModelSerializer):

    tipo = ChoicesSerializerField()

    class Meta:
        model = Fornecedor          
        fields = '__all__'
        #fields = ('id', 'nome','email')