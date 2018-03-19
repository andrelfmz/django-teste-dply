var $produtos = $('#produtos');    

$('#listar-produto').click(function() {
    $.ajax({
        type: 'GET',
        url: '/produtos/'+$('#produto').val(),
        success: function(produtos) {
            $produtos.append('<li><b>Descrição:</b> '+ produtos.descricao +' - <b>Valor:</b> '+ produtos.valor + '</li>');     
            $('.status').html($('#produto').val());
        }
    });
});

$('#listar-produtos').click(function() {
    $.ajax({
        type: 'GET',
        url: '/produtos/',        
        success: function(produtos) {
            $produtos.empty(); //Limpar todos
            $.each(produtos, function(i, produto) {
                $produtos.append('<li><b>Descrição:</b> '+ produto.descricao +' - <b>Valor:</b> '+ produto.valor + '</li>');
            });
        }        
    });
});




