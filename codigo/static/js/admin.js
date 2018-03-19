if (typeof jQuery === "undefined") {
    throw new Error("Carregar JQuery antes deste arquivo.");
}

$.Admin = {};

//DataTables
$.Admin.table = {
    init: function() {
        var $btnRemove = $('.btn-remove');

        /*
        //Auto detect dates (dd/mm/yyyy) for sorting
        $.fn.dataTableExt.aTypes.unshift(
            function ( sData )
            {
                if (sData !== null && sData.match(/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/(19|20|21)\d\d$/))
                {
                    return 'date-uk';
                }
                return null;
            }
        );
        */

        //Sort dates (dd/mm/yyyy)
        jQuery.extend( jQuery.fn.dataTableExt.oSort, {
            "date-uk-pre": function ( a ) {
                if (a == null || a == "") {
                    return 0;
                }
                var ukDatea = a.split('/');
                return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
            },

            "date-uk-asc": function ( a, b ) {
                return ((a < b) ? -1 : ((a > b) ? 1 : 0));
            },

            "date-uk-desc": function ( a, b ) {
                return ((a < b) ? 1 : ((a > b) ? -1 : 0));
            }
        } );


       
        

        //Tabela DataTable
        dTable = $('#lista-database').DataTable({            
                      
            "columnDefs": [
                { "orderable": false, "targets": -1 },
                { "orderable": false, "targets": -2 }
            ],         
            "order": [[ 0, "desc" ]],
            "dom" : 'ltipr',
            "language" : {
                "sEmptyTable": "Nenhum registro encontrado",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
                "sInfoFiltered": "(Filtrados de _MAX_ registros)",
                "sInfoPostFix": "",
                "sInfoThousands": ".",
                "sLengthMenu": "Mostrar _MENU_ resultados por página",
                "sLoadingRecords": "Carregando...",
                "sProcessing": "Processando...",
                "sZeroRecords": "Nenhum registro encontrado",
                "sSearch": "Pesquisar",
                "oPaginate": {
                    "sNext": "Próximo",
                    "sPrevious": "Anterior",
                    "sFirst": "Primeiro",
                    "sLast": "Último"
                },
                "oAria": {
                    "sSortAscending": ": Ordenar colunas de forma ascendente",
                    "sSortDescending": ": Ordenar colunas de forma descendente"
                },
            }
        });


        //Parametros para o DataTable
        tabelaopcoes = $('#lista-database2').attr('value');
        console.log(tabelaopcoes);

        tabelaopcoes = tabelaopcoes.split(':');

        tabela = tabelaopcoes[0];
        console.log(tabela);


        campo1 = $('#campo1').attr('value'); 
        campo2 = $('#campo2').attr('value'); 
        campo3 = $('#campo3').attr('value'); 
        campo4 = $('#campo4').attr('value'); 

        

        opcoes = tabelaopcoes[1].toUpperCase();
        console.log(opcoes);

        dTable2 = $('#lista-database2').DataTable({
                                
            //"pagingType": "input", //Paginacao com opcao de informar a pagina desejada
            "responsive": true,     //Ativar modo responsivo (Redimensiona de acordo com o tamanho da Janela)
            "processing": true,     //Ativar Mensagem de Processamento
            "serverSide": true,     //Processar consulta no Servidor
            "stateSave": true,      //Salvar o Estado da Pagina
            "stateSaveParams": function (settings, data) {                
                $('#search-bar2').val(data.search.search);
            },
                      
            "ajax": {  
                "url": "/api2/"+tabela,                
                "type": "GET",                
            },     
            "columns": [       
                { "data": campo1 },
                { "data": campo2 },    
                { "data": campo3 },
                { "data": campo4 },
                { "data": null,
                  "render": function ( data, type, row, meta ) {                   
                    cont = 0;
                    opcoes_str='';
                    for (var n in opcoes) {  //Percorrer Array de "trás para frente"            
                        if (cont > 0) { //Se tiver mais de uma opcao, colocar espaçamento
                            opcoes_str = opcoes_str +'&nbsp;&nbsp';
                        }
                        if (opcoes[n] == 'E') { //Se Editar
                            opcoes_str = opcoes_str + '<a id="btn_edit" href="' + row.id +'/edit" style="text-decoration:none" class="btn-sm btn-primary"><span class="glyphicon glyphicon-edit"></span> Editar</a>';
                        }
                        if (opcoes[n] == 'D' && row.tipo != 'Física') { //Se Deletar
                            opcoes_str = opcoes_str + '<a id="btn_delete" href="' + row.id +'/delete" style="text-decoration:none" class="btn-sm btn-danger"><span class="glyphicon glyphicon-minus-sign"></span> Deletar</a>';
                        }
                        cont++;
                    }
                    return opcoes_str;
                   },
                  }
            ],

            "columnDefs": [
                { "orderable": false, "targets": -1 },
                //{ "orderable": false, "targets": -2 },
                { "targets": 0, "render": function ( data, type, row, meta ) {
                    return '<a href="'+data+'/edit">'+data+'</a>'; } },   
                //{ "targets": 2, "className": "text-right"}, 
            ],
    
            "order": [[ 0, "desc" ]],            
            "dom" : 'ltipr',
            "language" : {
                "sEmptyTable": "Nenhum registro encontrado",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
                "sInfoFiltered": "(Filtrados de _MAX_ registros)",
                "sInfoPostFix": "",
                "sInfoThousands": ".",
                "sLengthMenu": "Mostrar _MENU_ resultados por página",
                "sLoadingRecords": "Carregando...",
                "sProcessing": "Aguarde ... Processando Dados no Servidor...",
                "sZeroRecords": "Nenhum registro encontrado",
                "sSearch": "Pesquisar",
                "oPaginate": {
                    "sNext": "Próximo",
                    "sPrevious": "Anterior",
                    "sFirst": "Primeiro",
                    "sLast": "Último"
                },
                "oAria": {
                    "sSortAscending": ": Ordenar colunas de forma ascendente",
                    "sSortDescending": ": Ordenar colunas de forma descendente"
                },


            }

            


        });

        //Recarregar Datatables a cada 30 Segundos
        //setInterval( function () {
        //    dTable2.ajax.reload();
        //}, 30000 );


        $('#lista-database2').on( 'click', 'a', function () {            
            class_name = $(this).attr('class');
            dado = dTable2.cell( $(this).parent('td'), 0 ).data();
            tipo = dTable2.cell( $(this).parent('td'), 3 ).data();

        } );



        //Campo de busca - Pressionando ENTER
        $('#search-bar2').keypress(function(event) {
            if (event.key === "Enter") {
                dTable2.search($(this).val()).draw();
            }
        });
        
        //Campo de busca
        $('#search-bar').keyup(function(){
            dTable.search($(this).val()).draw();
        });



        //Mudar o background do tr quando remover for selecionado
        $('body').on('change', '.lista-remove input[type=checkbox]', function(event){
            if(this.checked){
                $(this).parents('tr').addClass("delete-row");
            }else{
                $(this).parents('tr').removeClass("delete-row");
            }
            $btnRemove.show()
        });

        //Perguntar antes de remover items da database
        $btnRemove.on('click',function(event){
            event.preventDefault();
            var form = $(this).parents('form');
            $.Admin.messages.msgRemove("Os items selecionados serão removidos permanentemente da Base de Dados.");
            $('#btn-sim').one('click', function(){
                form.submit();
            });
        });

        //Fazer a linha da table um link para a detail view
        $('body').on('click', '.clickable-row:not(.popup)', function(event){
            if(!$(event.target).is("input, label, i, .prevent-click-row")){
                window.document.location = $(this).data("href");
            }
        });
        
    },
}



//Calculos Entradas
$.Admin.entradaForm = {
    init: function() {
        
        $('.formset').formset({            
            formTemplate: '#formset-template',                        
            prefix: 'itensentrada_set',
            addText: ' Adicionar',
            addCssClass: 'btn btn-sm btn-success glyphicon glyphicon-plus-sign',            
            deleteText: ' Remover',
            deleteCssClass: 'btn btn-sm btn-danger glyphicon glyphicon-minus-sign',            
            added: function(row) {                

                //$('.status').html('Novo item adicionado! '+$(row).attr('class'));
                $(row).find('input[name*="quantidade"]').val('0.000');           
                $(row).find('input[name*="valoru"]').val('0.00');
                $(row).find('input[name*="valort"]').val('0.00');
                $(row).find('select[name*="produto"]').prop('selectedIndex', 0);
                
                
            },
            removed: function(row) {   
                //$(".table").find('input[name*="quantidade"]').select();       
                $("#id_valortotal").select();               
            },            
            
        });


        $('.table').on("keyup change", 'input[name^="itensentrada"]', function (event) {                
            $("#titulo").css({'background-color' : '#FFFFBB'});
            calcularLinha($(this).closest("tr"));
            calcularTotalGeral();           
        });

        $('div').on("focus change click", 'input[name="valortotal"]', function (event) {                        
            calcularTotalGeral();   
            $('.status').html('Teste valor total');
        });
      
        $(".table").on("focus click", 'input[name^="itensentrada"]', function (event) {                
            $(this).css({'background-color' : '#FFFFBB'});
            calcularLinha($(this).closest("tr"));
            calcularTotalGeral();                
        });

        $(".table").on("blur", 'input[name^="itensentrada"]', function (event) {                
            $(this).css({'background-color' : 'transparent'});
        });

        var $produtos = $('#produtos');
        $(".table").on("change", 'select[name^="itensentrada"]', function (event) { 
            var id = "#"+$(this).attr('id');
            var id_valoru = id.replace('produto','valoru');
            var id_quantidade = id.replace('produto','quantidade');                

            $.ajax({
                type: 'GET',
                url: '/api/produtos/'+$(this).val(),
                success: function(produtos) {
                    //$produtos.append('<li><b>Descrição:</b> '+ produtos.descricao +' - <b>Valor:</b> '+ produtos.valor + '</li>');     
                    $('#teste').val(produtos.valor);
                    $('#teste2').val(id_valoru);
                    $(id_valoru).val(produtos.valor);
                    if (produtos.valor === undefined) {
                        $(id_quantidade).val('0.000');
                    }  else {
                        if ((parseInt($(id_quantidade).val()) == 0) || ($(id_quantidade).val() == '')) $(id_quantidade).val('1');                                          
                    } 
                    $(id_quantidade).select();                    
                }            
            });                   
        });


        function calcularLinha(linha) {        
            var quantidade = linha.find('input[name*="quantidade"]').val();
            var valor = linha.find('input[name*="valoru"]').val();
            if (isNaN(Number(quantidade))) quantidade = 0;
            if (isNaN(Number(valor))) valor = 0;
            linha.find('input[name*="valort"]').val((quantidade * valor).toFixed(2));
        //$(".status").css({'background-color' : '#0000BB'});
        //$('.status').html(quantidade - valor);
        }

        function calcularTotalGeral() {
            var total = 0;        
            $(".table").find('input[name*="valort"]').each(function () {
                //if $(this).parent("tr").is(':visible') 
                //$('#teste2').val($(this).parent().parent().attr('class'));
                if ($(this).parent().parent().is(':visible')) total += +$(this).val();
            });
            //$('.status').html(total);
            $("#id_valortotal").val(total.toFixed(2));            
        }     


    }
}




$(function () {   
    $.Admin.table.init();
    //$.Admin.entrada.init();
    
    setTimeout(function () { $('.page-loader-wrapper').fadeOut(); }, 50);
});