from django import forms

from django.utils.translation import ugettext_lazy as _

from .models import *

# Profile
from django.forms import ModelForm, inlineformset_factory

from dal import autocomplete

from django.forms.formsets import formset_factory


class ProdutoForm(ModelForm):
    class Meta:
        model = Produto
        fields = '__all__'
        exclude = ['estoque']

        widgets = {
            'descricao': forms.TextInput(attrs={'class': 'form-control'}),
            'valor': forms.TextInput(attrs={'class': 'form-control'}),            
        }
        labels = {
            'descricao': _('Descrição'),
            'valor': _('Valor'),            
        }

class FornecedorForm(ModelForm):
    class Meta:
        model = Fornecedor
        fields = '__all__'

        widgets = {
            'nome': forms.TextInput(attrs={'class': 'form-control'}),
            'email': forms.TextInput(attrs={'class': 'form-control'}),
            'fone1': forms.TextInput(attrs={'class': 'form-control'}),
            'fone2': forms.TextInput(attrs={'class': 'form-control'}),
            'tipo': forms.Select(attrs={'class': 'form-control'}),            
        }
        labels = {
            'nome': _('Nome'),
            'email': _('EMAIL'),
            'fone1': _('Telefone 1'),
            'fone2': _('Telefone 2'),
            'tipo': _('Tipo'),            
        }


class EntradaForm(forms.ModelForm):

    #fornecedor = forms.ModelChoiceField(
    #    queryset=Fornecedor.objects.all(),
    #    widget=autocomplete.ModelSelect2(url='fornecedor-autocomplete')
    #)
    

    class Meta:
        model = Entrada
        fields = ('fornecedor', 'data', 'valortotal')
        
        exclude = ()

        widgets = {                         
            'fornecedor': autocomplete.ModelSelect2(attrs={'data-placeholder': 'Digite as iniciais...', }, url='fornecedor-autocomplete'),
            'data': forms.DateInput(attrs={'class': 'form-control datepicker'}),            
            'valortotal': forms.TextInput(attrs={'class': 'form-control decimal-mask', 'readonly': True}),            
        }
        labels = {
            'fornecedor': _('Fornecedor'),
            'data': _('Data'),
            'valortotal': _('Valor Total'),                
        }        
    
        #model = Entrada
        #fields = ('__all__')
        #widgets = {
        #    'fornecedor': autocomplete.ModelSelect2(url='fornecedor-autocomplete')
        #}


class ItensEntradaForm(forms.ModelForm):

    #produto = forms.ModelChoiceField(
    #    queryset=Produto.objects.all(),
    #    widget=ProdutoSelect2Widget,
    #)


    def clean(self):
        cleaned_data = super(ItensEntradaForm, self).clean()
        
        try:
            vt = float(cleaned_data.get("quantidade"))
        except:
            vt = 0

        if vt > 100:
            msg = "Quantidade muito alta!... (TESTE DE VALIDAÇÃO!)"
            self.add_error('quantidade', msg)

    def __init__(self, *args, **kwargs):
       super(ItensEntradaForm, self).__init__(*args, **kwargs)
       self.fields['valort'].widget.attrs['readonly'] = True 	#Campo somente de leitura
       self.fields['valoru'].widget.attrs['readonly'] = True 	#Campo somente de leitura
       #self.fields['quantidade'].widget.attrs['step'] = any 	#Sem step
       self.fields['valoru'].widget.attrs['step'] = any 	#Sem step
       self.fields['valort'].widget.attrs['step'] = any 	#Sem step


    class Meta:
        model = ItensEntrada        
        ##fields = '__all__'   
        exclude = ()
        widgets = {             
            'produto': autocomplete.ModelSelect2(attrs={'data-placeholder': 'Digite as iniciais...', }, url='produto-autocomplete'),
            'quantidade': forms.NumberInput(attrs={'step': 'any',}) #Sem step
        }
	

ItensEntradaFormSet = inlineformset_factory(Entrada, ItensEntrada, form=ItensEntradaForm, extra=0, min_num=1, validate_min=True)