

% 5.1
% I 

/* 
visualiza(Lista) é verdade se lista é uma lista e a aplicação deste predicado permite escrever cada elemento
da lista Lista linha por linha. 
*/

visualiza([]):- !. % Caso base.

visualiza([H|Lista]):- % Separamos cabeça da Lista para executar a recursão.
    writeln(H), 
    visualiza(Lista).


% II

/* 
visualizaLinha(Lista) é verdade se Lista é uma lista e a aplicação desse predicado permite escrever os elementos
da lista linha por linha, indicando por ordem cada elemento com ":", o número do elemento e um espaço, seguido do 
próprio elemento.
*/

% A forma aqui utilizada é um híbrido entre a forma iterativa e recursiva. (for)

visualizaLinha(Lista):- visualizaLinha(Lista, 0). % Inicia o contador com 0.

visualizaLinha([], _):- !. % Caso base.

visualizaLinha([H|Lista], Contador):- 
     Contador1 is Contador + 1, % Aumentamos o contador.
     write(Contador1), write(": "), 
     write(H), nl, 
     visualizaLinha(Lista, Contador1).


% 5.2
% III 

/* 
insereObjecto((L, C), Tabuleiro, Obj) é verdade se Tabuleiro é um tabuleiro que após a aplicação deste predicado 
passa a ter o objecto Obj nas coordenadas (L, C), caso nestas se encontre uma variável. O predicado não deve falhar, mesmo se 
as coordenadas não fizerem parte do tabuleiro ou se já existir um objecto nas coordenas dadas.
*/

insereObjecto((L,_), Tabuleiro, _):- 
    length(Tabuleiro, Tamanho),
     (0>=L; L>Tamanho), !. % Verificando se a linha recebida faz parte do tabuleiro.
insereObjecto((_,C), [H|_], _):- 
    length(H, Tamanho), 
    (0>=C; C>Tamanho), !. % Verificando se a coluna recebida faz parte do tabuleiro.

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), % Designamos Linha como a linha na coordenada dada
     nth1(C, Linha, Elemento),  % Designamos Elemento o elemento na coluna (C) da Linha.
     Elemento = Obj, !. % Tornamos Elemento no objeto recebido (Obj).

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), 
     nth1(C, Linha, Elemento), 
     \+Elemento = Obj.



% IV

/* 
insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaCoords for uma lista de coordenadas, 
ListaObjs uma lista de objectos e Tabuleiro um tabuleiro que, após a aplicação do predicado, 
passa a ter nas coordenadas de ListaCoords os objectos deListaObjs. Estas duas listas têm o mesmo tamanho 
e devem ser percorridas ao mesmo tempo. O predicado deve falhar apenas se as listas tiverem tamanhos diferentes.
*/

insereVariosObjectos([], _, []). % Caso base.

insereVariosObjectos([(L,C)|ListaCoords], Tabuleiro, [Obj|ListaObjs]):- 
    insereObjecto((L,C), Tabuleiro, Obj), insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs). 
    % Percorremos cada elemento de ListaCoords utilizando insereObjecto. Foi usado o metodo recursivo.
    

% V

/*
inserePontosVolta(Tabuleiro, (L, C)) é verdade se Tabuleiro é um tabuleiro que, apósa aplicação do predicado, 
passa a ter pontos (p) à volta das coordenadas (L, C) (cima, baixo, esquerda, direita e diagonais).
*/

inserePontosVolta(Tabuleiro, (L,C)):- 
    L_Cima is L-1, L_Baixo is L+1, C_Esq is C-1, C_Dir is C+1, % Criamos variáveis para todas as direções
    PontosVolta = [(L_Cima, C_Esq), (L_Cima, C), (L_Cima, C_Dir), (L, C_Esq), 
    (L, C_Dir), (L_Baixo, C_Esq), (L_Baixo, C), (L_Baixo, C_Dir)], % Todas as coordenadas dos pontos na vizinhança
    Objs = [p, p, p, p, p, p, p, p], % Criamos uma lista dos pontos para usar insereVariosObjectos
    insereVariosObjectos(PontosVolta, Tabuleiro, Objs). % Adicionamos os pontos em volta


% VI 

/*
inserePontos(Tabuleiro, ListaCoord) é verdade se Tabuleiro é um tabuleiro que, após a aplicação do predicado, 
passa a ter pontos (p) em todas as coordenadas de ListaCoord. Se em alguma coordenada de ListaCoord existir 
um objecto que não seja uma variável, salta em frente.
*/

inserePontos(_, []):- !. % Caso base.

inserePontos(Tabuleiro, [Coord|ListaCoord]):- 
    insereObjecto(Coord, Tabuleiro, p), inserePontos(Tabuleiro, ListaCoord).
    % Percorremos ListaCoord adicionando cada elemento ao tabuleiro. Método recursivo.


% 5.3
% VII

/*
objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs) é verdade se ListaObjs for a lista de objectos 
(pontos, estrelas ou variáveis) das coordenadas ListaCoords no tabuleiro Tabuleiro, apresentados na mesma 
ordem das coordenadas. Neste caso, o predicado deve falhar se alguma coordenada não pertencer ao tabuleiro.
*/

objectosEmCoordenadas([], _, []):- !. % Caso base.

objectosEmCoordenadas([(L,C)|ListaCoords], Tabuleiro, [Elemento|ListaObjs]):-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Elemento), % Encontramos o Elemento e adicionamos ele a ListaObjs.
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs).


% VIII

/*
coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos) é verdade se Tabuleiro for um tabuleiro, 
Listacoords uma lista de coordenadas e ListaCoordObjs a sublista de ListaCoords que contém as coordenadas dos objectos do tipo
Objecto, tal como ocorrem no tabuleiro (o comportamento deverá ser o mesmo se o objecto pesquisado for uma variável). 
NumObjectos é o número de objectos Objecto encontrados. ListaCoordsObjs é ordenado por linha e coluna.
*/

igual_Elem(Tabuleiro, Objecto, Coord):-
    objectosEmCoordenadas([Coord], Tabuleiro, Obj_Coord), % Usamos objectosEmCoordenadas para obter o objeto nessa coordenada.
    nth1(1, Obj_Coord, Elem), % Retiramos o objecto encontrado anteriormente da lista (objectosEmCoordenadas devolve uma lista).
    Objecto =@= Elem. % Comparamos o Elemento encontrado com o Objecto recebido, sem levar em consideração a diferença na memória.

coordObjectos(Objecto, Tabuleiro, ListaCoords, LCO, Num):-
    include(igual_Elem(Tabuleiro, Objecto), ListaCoords, LCO_Deso),
    % Cada elemento de ListaCoords é avaliado pelo igual_Elem e colocado em LCO_Deso
    sort(LCO_Deso, LCO), % Organizando LCO_Deso por linhas e colunas.
    length(LCO, Num). % Número de elementos em LCO.
    

% IX

/*
coordenadasVars(Tabuleiro, ListaVars) é verdade se ListaVars forem as coordenadas das variáveis do tabuleiro Tabuleiro. 
ListaVars está organizado por linhas e colunas.
*/

% O coordLinhas2 é quase igual ao auxiliar, apenas adicionando todas as coordenadas num lista sem separação.

coordLinhas2(Num, CoordLinhas) :-  
    coordLinhas2(Num, CoordLinhas, 1, []). 

coordLinhas2(Num, CoordLinhas, N, CoordLinhas) :- N > Num, !.    
coordLinhas2(Num, CoordLinhas, N, Aux) :-  
    findall((N, C), between(1, Num, C), CoordLinhaN),
    append(Aux, CoordLinhaN, NovoAux),
    NovoN is N + 1,
    coordLinhas2(Num, CoordLinhas, NovoN, NovoAux).

coordenadasVars(Tabuleiro, ListaVars):- 
    length(Tabuleiro, TamanhoLinha), % Verificamos qual a proporção do tabuleiro.
    coordLinhas2(TamanhoLinha, CoordLinhas), % Criamos uma lista com todas as coordenadas do tabuleiro.
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
    coordObjectos(_, Tabuleiro, ListaCoord, ListaVars, _), % Encontramos a coordenada da posição livre.
    length(Estrelas, 1), % Verificamos se só é uma estrela.
    length(ListaVars, 1), % Verificamos se só é uma posição livre.
    ListaVars = [(L, C)], % Unificamos L e C com as coordenadas para removermos a lista.
    insereObjecto((L, C), Tabuleiro, e), % Inserimos a estrela na posição livre.
    inserePontosVolta(Tabuleiro, (L,C)), !. % Inserimos pontos em volta da nova estrela.

% 0 estrelas (h3)

fechaListaCoordenadas(Tabuleiro, ListaCoord):- 
    coordObjectos(e, Tabuleiro, ListaCoord, Estrelas, _), 
    length(Estrelas, 0),  % Verificamos se não tem estrela.
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

fecha(Tabuleiro, [H|T]):- 
    fechaListaCoordenadas(Tabuleiro, H), fecha(Tabuleiro, T). 
    % Fazemos uma recursão aplicando fechaListaCoordenadas para cada lista de ListaListasCoord.


