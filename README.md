
![Cabeçalho](https://www.pngarts.com/files/1/Header-PNG-High-Quality-Image.png)
# Miniprojeto a22004275

Este projeto foi realizado por Rodrigo Francisco Félix Barata, aluno 22004275.


# 🖼️ Screenshots
<div class = "row">
<img src="https://i.postimg.cc/yNgGDGfT/Screenshot-20230309-153456.png" style="width:30%" alt="Dashboard" title="Dashboard">
<img src="https://i.postimg.cc/QdnPxDqt/Screenshot-20230309-153518.png" style="width:30%" alt="Listagem de avaliações" title="Listagem de avaliações">
<img src="https://i.postimg.cc/MpGNSHVN/Screenshot-20230309-153533.png" style="width:30%" alt="Registo de avaliação" title="Registo de avaliação">
<img src="https://i.postimg.cc/wT2ZZLyD/Screenshot-20230309-153550.png" style="width:30%" alt="Detalhes da avaliação" title="Detalhes da avaliação">
<img src="https://i.postimg.cc/dtwg541q/Screenshot-20230309-153601.png" style="width:30%" alt="Edição de avaliação" title="Edição de avaliação">
<img src="https://i.postimg.cc/kMxkNk71/Screenshot-20230309-153623.png" style="width:30%" alt="Dealer" title="Dealer">
</div>

# 🔬 Funcionalidades
Introdução das funcionalidades implementadas

## Criação de uma avaliação
No ecrã de registo é possível criar avaliações à nossa lista tendo em conta os seguintes acampos:

-   Um campo de texto para inserir o nome da disciplina.
-   Um dropdown para selecionar o tipo de avaliação.
-   Um seletor de data e hora usando a biblioteca OmniDateTimePicker.
-   Um slider para selecionar a dificuldade da avaliação.
-   Um campo de texto para inserir observações adicionais sobre a avaliação.
-   Um botão para limpar o formulário.
-   Um botão para enviar o formulário.
-   O ecrã também apresenta uma mensagem de feedback (SnackBar) na parte inferior do mesmo quando o utilizador não preenche todos os campos obrigatórios ou adiciona com sucesso uma nova avaliação.

O código inclui a lógica para validar o formulário, limpar os campos e enviar uma solicitação HTTP para obter a miniatura da imagem da disciplina inserida. A miniatura é obtida usando a API Contextual Web Search.

## Listagem das avaliações
Este ecrã representa uma lista de avaliações, onde cada avaliação é exibida em um cartão com informações como disciplina, tipo de avaliação, data e hora, dificuldade e uma imagem. Além disso, cada cartão pode ser deslizado para a esquerda para ser eliminado (caso seja de uma avaliação futura) e clicado para exibir mais detalhes numa página separada. Se não houver avaliações registadas, uma mensagem a informar que nenhuma avaliação foi encontrada será apresentada.

## Detalhes da avaliação
A página "Detalhes" apresenta informações sobre uma avaliação específica. A interface exibe os detalhes de uma avaliação, como data e hora da avaliação, a disciplina, a dificuldade da avaliação de forma gramatical informal e observações adicionais sobre a avaliação.

Além disso, a página oferece a opção de editar ou eliminar a avaliação, apenas se a avaliação for realizada no futuro.

A página também possui um botão para partilhar os detalhes da avaliação por meio de terceiros ("dealer")

## Edição de uma avaliação
As features de edição são basicamente a habilidade de editar as informações de uma avaliação. O botão flutuante é usado para iniciar a edição da avaliação. Quando a avaliação estiver a ser editada, o ícone do botão flutuante é alterado para um ícone de fecho.

## Eliminação de uma avaliação
O processo de eliminação de uma avaliação ocorre quando o utilizador clica no ícone de "lixo" na barra de ferramentas da aplicação. É apresentado um diálogo de confirmação com duas opções: "Sim" e "Não".

Se o utilizador clicar em "Não", o diálogo simplesmente é fechado e nada mais acontece. Se o utilizador clicar em "Sim", a avaliação é removida da aplicação. Depois da avaliação ser removida com sucesso, uma mensagem de confirmação é exibida na parte inferior do ecrã usando uma SnackBar. A mensagem é: "O registo de avaliação selecionado foi eliminado com sucesso.".

Por fim, o diálogo de confirmação é fechado e o ecrã de detalhes é destruído, voltando ao ecrã anterior.
> Uma avaliação também poderá ser eliminada ao deslizar da direita para a esquerda na listagem de avaliações.

## Dashboard
Esta páginaé o ecrã inicial da aplicação. Algumas das funcionalidades são:

-   Exibe uma lista de avaliações que acontecerão nos próximos 7 dias
-   Calcula e exibe uma sugestão de estudo com base nas avaliações próximas
-   Mostra a média das dificuldades das avaliações dos próximos 7 dias e 7 a 14 dias
-   Usa gráficos circulares elegantes para mostrar as médias

## Dealer
A funcionalidade de partilha encontra-se na página de detalhes da avaliação e permite que o utilizador partilhe informações sobre uma avaliação, como disciplina, data e hora, dificuldade e observações (se houver). Isso é feito usando o pacote "share_plus", que permite que o utilizador partilhe informações através de diferentes aplicações, como e-mail, SMS, WhatsApp, entre outros. Quando o utilizador clica no ícone de partilha na barra de ferramentas da página, o método _share é chamado e uma mensagem é criada com as informações da avaliação.

>O dealer pode ser testado ao abrir o detalhe de uma avaliação e clicar no ícone de partilha que se encontra no canto superior esquerdo da página.

# 📝 Autoavaliação
16 valores.  
![Rodapé](https://www.seekpng.com/png/full/977-9771328_wave-footer-illustration.png)
