% 5.1
% I 

/* 
visualiza(Lista) é verdade se lista é uma lista e a aplicação deste predicado permite escrever cada elemento
da lista Lista linha por linha. 
*/

visualiza([]):- !. % Caso base.

visualiza([Elemento|Lista]):- % Separamos cabeça da Lista para executar a recursão.
    writeln(Elemento), % Escrevemos o elemento e saltamos para a linha de baixo.
    visualiza(Lista). 


% II

/* 
visualizaLinha(Lista) é verdade se Lista é uma lista e a aplicação desse predicado permite escrever os elementos
da lista linha por linha, indicando a ordem dos elementos com um número, um ":",  e um espaço, seguido do próprio
elemento.

*/

visualizaLinha(Lista):- visualizaLinha(Lista, 0). % Aumentamos o predicado, adicionando um contador.

visualizaLinha([], _):- !. % Caso base, chegamos ao fim.

visualizaLinha([Elemento|Lista], Contador):- 
     Contador1 is Contador + 1, % Aumentamos o contador.
     write(Contador1), 
     write(": "), 
     write(Elemento), nl, 
     visualizaLinha(Lista, Contador1). % Vamos escrever o resto dos elementos da lista.


% 5.2
% III 

/* 
insereObjecto((L, C), Tabuleiro, Obj) é verdade se Tabuleiro é um tabuleiro que após a aplicação deste predicado 
passa a ter o objecto "Obj" nas coordenadas "(L, C)", caso nestas se encontre uma variável. O predicado não deve falhar, 
mesmo se as coordenadas não fizerem parte do tabuleiro ou se já existir um objecto nas coordenas dadas.
*/

insereObjecto((L,_), Tabuleiro, _):- 
    length(Tabuleiro, Tamanho), % Descobrindo quantas linhas temos no tabuleiro.
     (0>=L; L>Tamanho), !. % Se a linha não fizer parte do tabuleiro apenas paramos e não falhamos.

insereObjecto((_,C), [H|_], _):- 
    length(H, Tamanho), % Descobrindo quantas colunas temos no tabuleiro.
    (0>=C; C>Tamanho), !. % Se a coluna não fizer parte do tabuleiro apenas paramos e não falhamos.

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), % Designamos Linha como a linha na coordenada dada.
     nth1(C, Linha, Elemento),  % Designamos Elemento o elemento na coluna (C) da Linha.
     Elemento = Obj, !. % Tornamos Elemento no objeto recebido.

insereObjecto((L,C), Tabuleiro, Obj):- % Caso já exista um objeto na coordenada.
     nth1(L, Tabuleiro, Linha), 
     nth1(C, Linha, Elemento), 
     not(Elemento = Obj). 


% IV

/* 
insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaCoords for uma lista de coordenadas, 
ListaObjs uma lista de objectos e Tabuleiro um tabuleiro que, após a aplicação do predicado, 
passa a ter nas coordenadas de ListaCoords os objectos de ListaObjs. Estas duas listas têm o mesmo tamanho 
e devem ser percorridas ao mesmo tempo. O predicado deve falhar apenas se as listas tiverem tamanhos diferentes.
*/

insereVariosObjectos([], _, []). % Caso base.

insereVariosObjectos([(L,C)|ListaCoords], Tabuleiro, [Obj|ListaObjs]):- 
    insereObjecto((L,C), Tabuleiro, Obj), 
    insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs). 
    % Percorremos cada elemento de ListaCoords utilizando insereObjecto. 
    

% V

/*
inserePontosVolta(Tabuleiro, (L, C)) é verdade se Tabuleiro é um tabuleiro que, apósa aplicação do predicado, 
passa a ter pontos (p) à volta das coordenadas (L, C) (cima, baixo, esquerda, direita e diagonais).
*/

inserePontosVolta(Tabuleiro, (L,C)):- 
    L_Cima is L-1, L_Baixo is L+1, C_Esq is C-1, C_Dir is C+1, % Criamos variáveis para todas as direções.
    PontosVolta = [(L_Cima, C_Esq), (L_Cima, C), (L_Cima, C_Dir), (L, C_Esq), (L, C_Dir), (L_Baixo, C_Esq), 
    (L_Baixo, C), (L_Baixo, C_Dir)], % Todas as coordenadas dos pontos na vizinhança, todas as combinações.
    Objs = [p, p, p, p, p, p, p, p], % Criamos uma lista dos pontos para usar insereVariosObjectos.
    insereVariosObjectos(PontosVolta, Tabuleiro, Objs). % Adicionamos os pontos em volta.


% VI 

/*
inserePontos(Tabuleiro, ListaCoord) é verdade se Tabuleiro é um tabuleiro que, após a aplicação do predicado, 
passa a ter pontos (p) em todas as coordenadas de ListaCoord. Se em alguma coordenada de ListaCoord existir 
um objecto que não seja uma variável, salta em frente.
*/

inserePontos(_, []):- !. % Caso base.

inserePontos(Tabuleiro, [Coord|ListaCoord]):- 
    insereObjecto(Coord, Tabuleiro, p), % insereObjecto nunca falha.
    inserePontos(Tabuleiro, ListaCoord).
    % Percorremos ListaCoord adicionando cada elemento ao tabuleiro.


% 5.3
% VII

/*
objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaObjs for a lista de objectos 
(pontos, estrelas ou variáveis) das coordenadas ListaCoords no tabuleiro Tabuleiro, apresentados na mesma 
ordem das coordenadas. Neste caso, o predicado deve falhar se alguma coordenada não pertencer ao tabuleiro.
*/

objectosEmCoordenadas([], _, []):- !. % Caso base, as listas ficaram vazias.

objectosEmCoordenadas([(L,C)|ListaCoords], Tabuleiro, [Elemento|ListaObjs]):-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Elemento), % Encontramos o Elemento e adicionamos ele a ListaObjs.
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs).


% VIII

/*
coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos) é verdade se Tabuleiro 
for um tabuleiro, Listacoords uma lista de coordenadas e ListaCoordObjs a sublista de ListaCoords 
que contém as coordenadas dos objectos do tipo Objecto, tal como ocorrem no tabuleiro. 
NumObjectos é o número de objectos Objecto encontrados. ListaCoordsObjs é ordenado por linha e coluna.

igual_Elem é um predicado auxiliar que é verdadese Tabuleiro for um tabuleiro, Objecto for um objecto
(ponto, estrela ou variável) e Coord for uma coordenada do tabuleiro. Esse predicado verifica se
o objecto na coordenada Coord é igual a Objecto.
*/

igual_Elem(Tabuleiro, Objecto, Coord):-
    objectosEmCoordenadas([Coord], Tabuleiro, Obj_Coord), % Usamos objectosEmCoordenadas para obter o objeto nessa coordenada.
    nth1(1, Obj_Coord, Elem), % Retiramos o Elemento da lista para fazer a comparação a seguir.
    Objecto =@= Elem. % Comparamos o Elemento encontrado com o Objecto recebido, apenas comparando a estrutura de ambos.

coordObjectos(Objecto, Tabuleiro, ListaCoords, LCO, Num):-
    include(igual_Elem(Tabuleiro, Objecto), ListaCoords, LCO_Deso), 
    % Cada elemento de ListaCoords é avaliado pelo igual_Elem e colocado em LCO_Deso
    sort(LCO_Deso, LCO), % Organizando LCO_Deso por linhas e colunas.
    length(LCO, Num). % Número de elementos em LCO.
    

% IX

/*
coordenadasVars(Tabuleiro, ListaVars) é verdade se ListaVars forem as coordenadas das variáveis do tabuleiro Tabuleiro. 
ListaVars está organizado por linhas e colunas.

coordLinhasMod(Num, CoordLinhas) é muito similar ao predicado CoordLinhas no Código Auxiliar, apenas com a diferença de que
as coordenadas não estão separadas, todas estão apenas numa grande lista, sendo separadas por vírgulas.
*/

coordLinhasMod(Num, CoordLinhas) :-  
    coordLinhasMod(Num, CoordLinhas, 1, []). 

coordLinhasMod(Num, CoordLinhas, N, CoordLinhas) :- N > Num, !.    
coordLinhasMod(Num, CoordLinhas, N, Aux) :-  
    findall((N, C), between(1, Num, C), CoordLinhaN),
    append(Aux, CoordLinhaN, NovoAux), % A única diferença se encontra nessa linha.
    NovoN is N + 1,
    coordLinhasMod(Num, CoordLinhas, NovoN, NovoAux).

coordenadasVars(Tabuleiro, ListaVars):- 
    length(Tabuleiro, TamanhoLinha), % Verificamos qual a proporção do tabuleiro.
    coordLinhasMod(TamanhoLinha, CoordLinhas), % Criamos uma lista com todas as coordenadas do tabuleiro.
    coordObjectos(_, Tabuleiro, CoordLinhas, ListaVars, _). % Verfiicamos qual das coordenadas do tabuleiro tem uma variável livre.

% X

/*
fechaListaCoordenadas(Tabuleiro, ListaCoord) que é verdade se Tabuleiro for um tabuleiro e ListaCoord for uma lista de coordenadas; 
após a aplicação deste predicado, as coordenadas de ListaCoord deverão ser apenas estrelas e pontos, considerando as hipóteses:

h1: sempre que a linha, coluna ou região associada à lista de coordenadas tiver 2 duas estrelas, 
enche as restantes coordenadas de pontos;

h2: sempre que a linha, coluna ou região associada à lista de coordenadas tiver uma única estrela e uma única posição livre,
insere uma estrela na posição livre e insere pontos à volta da estrela;

h3: sempre que a linha, coluna ou região associada à lista de coordenadas não tiver nenhuma estrela e tiver duas únicas posições 
livres, insere uma estrela em cada posição livre e insere pontos à volta de cada estrela inserida;

Se nenhuma das hipóteses se verificar, o tabuleiro mantém-se inalterável (o predicado não falha).
*/

% 2 estrelas (h1)

fechaListaCoordenadas(Tabuleiro, ListaCoord):- 
    coordObjectos(e, Tabuleiro, ListaCoord, LCO, _), % Procuramos as coordenadas das estrelas.
    length(LCO, 2), % Verificamos se só são 2 estrelas.
    delete(ListaCoord, LCO, Resultado), % Apagamos as coordenadas das estrelas.
    inserePontos(Tabuleiro, Resultado), !. % Adicionamos pontos nas coordenadas restantes.

% 1 estrela (h2)
fechaListaCoordenadas(Tabuleiro, ListaCoord):-
    coordObjectos(e, Tabuleiro, ListaCoord, Estrelas, _), % Encontramos a coordenada da estrela.
    length(Estrelas, 1), % Verificamos se só é uma estrela.
    coordObjectos(_, Tabuleiro, ListaCoord, ListaVars, _), % Encontramos a coordenada da posição livre.
    length(ListaVars, 1), % Verificamos se só é uma posição livre.
    ListaVars = [(L, C)], % Unificamos L e C com as coordenadas para removermos a lista, assim podemos utilizar L e C a seguir.
    insereObjecto((L, C), Tabuleiro, e), % Inserimos a estrela na posição livre.
    inserePontosVolta(Tabuleiro, (L,C)), !. % Inserimos pontos em volta da nova estrela.

% 0 estrelas (h3)

fechaListaCoordenadas(Tabuleiro, ListaCoord):- 
    coordObjectos(e, Tabuleiro, ListaCoord, Estrelas, _), 
    length(Estrelas, 0),  % Verificamos se não temos estrelas.
    coordObjectos(_, Tabuleiro, ListaCoord, ListaVars, _), 
    length(ListaVars, 2), % Verificamos se temos duas posições livres.
    insereVariosObjectos(ListaVars, Tabuleiro, [e, e]), % Adicionamos estrelas nas posições livres.
    ListaVars = [(L, C), (L2, C2)], 
    inserePontosVolta(Tabuleiro, (L,C)), 
    inserePontosVolta(Tabuleiro, (L2,C2)), !. % Inserimos pontos a volta das estrelas.

fechaListaCoordenadas(_, _). % Caso nenhuma das hipóteses se verificar.


% XI

/*
fecha(Tabuleiro, ListaListasCoord) que é verdade se Tabuleiro for um tabuleiro e ListaListasCoord for uma lista de listas 
de coordenadas. Após a aplicação deste predicado, Tabuleiro será o resultado de aplicar o predicado anterior
a cada lista de coordenadas.
*/

fecha(_, []):- !. % Caso base.

fecha(Tabuleiro, [Lista|ListaListasCoord]):- 
    fechaListaCoordenadas(Tabuleiro, Lista), 
    fecha(Tabuleiro, ListaListasCoord). 
    % Fazemos uma recursão aplicando fechaListaCoordenadas para cada lista de ListaListasCoord.


% XII

/*
encontraSequencia(Tabuleiro, N, ListaCoords, Seq) é verdade se Tabuleiro for um tabuleiro, ListaCoords for uma lista 
de coordenadas e N o tamanho de Seq, que é uma sublista de ListaCoords que verifica o seguinte:
1) as suas coordenadas representam posições com variáveis;
2) as suas coordenadas aparecem seguidas (numa linha, coluna ou região);
3)Seq pode ser concatenada com duas listas, uma antes e uma depois, eventualmente vazias ou com pontos nas coordenadas respectivas,
permitindo obter ListaCoords. De notar que se houver mais variáveis na sequência que N o predicado deve falhar.


A ordem dos predicados apresentados é indicado por um número, mostrando uma ordem de leitura recomendada para o entendimento do
código.
*/

encontraSequencia(Tabuleiro, N, ListaCoords, Seq):- % (1) 
    coordObjectos(_, Tabuleiro, ListaCoords, _, Num), % Descobrimos quantas variáveis livres temos.
    coordObjectos(e, Tabuleiro, ListaCoords, _, Num_Estrelas), % Descobrimos quantas variáveis estrelas temos.
    Num == N, % Só acharemos uma sequência se o número de variáveis livres for N.
    Num_Estrelas == 0, % Não podemos ter nenhuma estrela nas coordenadas.
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs), 
    % Obtemos a lista de objetos e passamos para o predicado, assim não sendo necessário sempre repetir essa etapa.
    encontraSequencia(Tabuleiro, N, ListaCoords, Seq, ListaObjs, 0). 
    % Adicionamos a lista de objetos e um contador ao predicado.

encontraSequencia(_, N, _, [], _, N):- !. % (5)
    % Caso o contador atinja o valor N, significa que achamos uma sequência válida. 

encontraSequencia(_, N, [Coord|T1], [Coord|Seq], [Obj|T], Contador):- % Caso o objeto seja uma variável. (2)
    % Percorremos a lista das coordenadas e dos objetos ao mesmo tempo. Adicionando as coordenadas a Seq.
    var(Obj), % Verificamos se o objeto que estamos analisando é uma variável livre.
    Contador1 is Contador + 1, % Se o anterior se verificar, adicionamos 1 ao contador.
    encontraSequencia(_, N, T1, Seq, T, Contador1), !. % Continuamos o processo removendo a cabeça das listas.

encontraSequencia(_, N, [_|T1], Seq, [Obj|T], Contador):- % Caso o objeto não seja uma variável. (3)
    not(var(Obj)), % Verificamos se não é uma variável.
    Contador == 0, 
    % Verificamos se o contador ainda é 0, ou seja, não encontramos nenhuma variável livre ainda.
    encontraSequencia(_, N, T1, Seq, T, Contador), !. % Continuamos analisando as nossas listas.

encontraSequencia(_, _, _, _, [Obj|_], Contador):- % (4)
    % Caso o objeto não seja uma variável, mas já encontramos alguma variável livre.
    not(var(Obj)), % Verificamos se não é uma variável.
    Contador \== 0, % Verificamos se o contador já não é mais 0.
    fail. % O predicado falhará, pois significa que as variáveis livres não estão seguidas.


% XIII

/*
aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]), que é verdade se Tabuleiro for um tabuleiro e 
[(L1, C1), (L2, C2), (L3, C3)] for uma lista de coordenadas (por exemplo, uma sequência calculada anteriormente). 
Após a aplicação deste predicado, Tabuleiro será o resultado de colocar uma estrela (e) em (L1, C1) e (L3, C3) e os
obrigatórios pontos (p) à volta de cada estrela.
*/


aplicaPadraoI(Tabuleiro, [(L1, C1), _, (L3, C3)]):- 
    insereVariosObjectos([(L1, C1), (L3, C3)], Tabuleiro, [e, e]), % Inserimos as estrelas na coordenadas.
    inserePontosVolta(Tabuleiro, (L1, C1)), 
    inserePontosVolta(Tabuleiro, (L3, C3)). % Adicionamos pontos a volta.


% XIV

/*
aplicaPadroes(Tabuleiro, ListaListaCoords) que é verdade se Tabuleiro for um tabuleiro, ListaListaCoords for uma lista 
de listas com coordenadas; após a aplicação deste predicado ter-se-ão encontrado sequências de tamanho 3 e 
aplicado o aplicaPadraoI/2, ou então ter-se-ão encontrado sequências de tamanho 4 e aplicado o aplicaPadraoT/2.
*/

aplicaPadroes(_, []):- !. % Caso base, ListaListaCoords chegou ao fim.

aplicaPadroes(Tabuleiro, [ListaCoords|ListaListaCoords]):-
    (encontraSequencia(Tabuleiro, 3, ListaCoords, SeqI), aplicaPadraoI(Tabuleiro, SeqI);
    encontraSequencia(Tabuleiro, 4, ListaCoords, SeqT), aplicaPadraoT(Tabuleiro, SeqT)),
    % Se acharmos uma sequência válida para N = 3, aplicamos aplicaPadraoI. Mesmo processo para aplicaPadraoT.
    % Ou faremos um ou o outro.
    aplicaPadroes(Tabuleiro, ListaListaCoords), !. % Continuamos analisando ListaListaCoords.

aplicaPadroes(Tabuleiro, [_|ListaListaCoords]):- % Caso não achemos nenhuma sequência válida.
    aplicaPadroes(Tabuleiro, ListaListaCoords). % Saltamos essa lista e continuamos analisando ListaListaCoords.

% XV

/*
resolve(Estruturas, Tabuleiro) é verdade se Estrutura for uma estrutura e Tabuleiro for um tabuleiro que resulta de aplicar 
os predicados aplicaPadroes/2 e fecha/2 até já não haver mais alterações nas variáveis do tabuleiro.

Esse predicado utiliza quase como "chaves" para os predicados. O processo apenas entrará em alguns predicados quando
tiver um certo valor na última parte do predicado. 
O predicado que utilizará as chaves será o resvolve_Tabuleiro(Tabuleiro, CT, Chave) que é verdadeiro se
Tabuleiro for um tabuleiro, CT for a lista de todas as coordenadas construídas pela Estrutura recebida e
chave é um número que permitirá entrar em determinados predicados (sempre 0 ou 1).

Novamente a ordem de leitura dos predicados será apresentada por um número.
*/

resolve_Tabuleiro(_, _, 1):- !. % Como a chave é 1, significa que podemos parar. (3)

resolve_Tabuleiro(Tabuleiro, CT, 0):- % (2)
    copy_term(Tabuleiro, Copia_Tab), % Criamos um clone de Tabuleiro antes de aplicarmos aplicaPadroes e fecha.
    aplicaPadroes(Tabuleiro, CT),
    fecha(Tabuleiro, CT), % Aplicamos aplicaPadroes e fecha.
    Copia_Tab =@= Tabuleiro, 
    % Caso o tabuleiro modificado seja igual (em estrutura) antes de aplicar os predicados, já podemos parar.
    resolve_Tabuleiro(Tabuleiro, CT, 1), !. % Alteramos a chave para a 1.

resolve_Tabuleiro(Tabuleiro, CT, 0):- % (4)
    % Só chegamos nesse predicado se o anterior falhou, ou seja, ainda precisamos modificar mais o tabuleiro.
    aplicaPadroes(Tabuleiro, CT), 
    fecha(Tabuleiro, CT), 
    % Aplicamos aplicaPadroes e fecha, pois as modificações no último predicado não ficaram guardadas
    % devido ao resultado ter sido falso.
    resolve_Tabuleiro(Tabuleiro, CT, 0). % Deixamos a chave como 0 e repetimos o predicado anterior.

resolve(Estrutura, Tabuleiro):- % (1)
    coordTodas(Estrutura, CT), % Descobrimos todas as coordenadas do tabuleiro.
    resolve_Tabuleiro(Tabuleiro, CT, 0). % Chamamos resolve_Tabuleiro com chave 0.