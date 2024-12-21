% 5.1
% I 

visualiza([]):- !.

visualiza([H|Lista]):- 
    writeln(H), visualiza(Lista).


% II

visualizaLinha(Lista):- visualizaLinha(Lista, 0).

visualizaLinha([], _):- !.

visualizaLinha([H|Lista], Contador):- Contador1 is Contador + 1, 
     write(Contador1), write(": "), write(H), nl, visualizaLinha(Lista, Contador1).


% 5.2
% III 


insereObjecto((L,_), Tabuleiro, _):- length(Tabuleiro, Tamanho), (0>=L; L>Tamanho), !.
insereObjecto((_,C), [H|_], _):- length(H, Tamanho), (0>=C; C>Tamanho), !.

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elemento), Elemento = Obj, !.

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elemento), \+Elemento = Obj.



% IV

insereVariosObjectos([], _, []).

insereVariosObjectos([(L,C)|ListaCoords], Tabuleiro, [Obj|ListaObjs]):- 
    insereObjecto((L,C), Tabuleiro, Obj), insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs).
    

% V

inserePontosVolta(Tabuleiro, (L,C)):- 
    L_Cima is L-1, L_Baixo is L+1, C_Esq is C-1, C_Dir is C+1,
    PontosVolta = [(L_Cima, C_Esq), (L_Cima, C), (L_Cima, C_Dir), (L, C_Esq), (L, C_Dir), (L_Baixo, C_Esq), 
    (L_Baixo, C), (L_Baixo, C_Dir)],
    Objs = [p, p, p, p, p, p, p, p], %é possível fazer utilizando insereObjecto e uma recursão
    insereVariosObjectos(PontosVolta, Tabuleiro, Objs).


% VI 

inserePontos(_, []):- !.

inserePontos(Tabuleiro, [Coord|ListaCoord]):- 
    insereObjecto(Coord, Tabuleiro, p), inserePontos(Tabuleiro, ListaCoord).


% 5.3
% VII

objectosEmCoordenadas([], _, []):- !.

objectosEmCoordenadas([(L,C)|ListaCoords], Tabuleiro, [Elemento|ListaObjs]):-
    nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elemento), objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs).


% VIII

igual_Elem(Tabuleiro, Objecto, Coord):-
    objectosEmCoordenadas([Coord], Tabuleiro, Obj_Coord), nth1(1, Obj_Coord, Elem),
    Objecto =@= Elem.

coordObjectos(Objecto, Tabuleiro, ListaCoords, LCO, Num):-
    include(igual_Elem(Tabuleiro, Objecto), ListaCoords, LCO_Deso), sort(LCO_Deso, LCO),
    length(LCO, Num).
    

% IX

igual(X):-
    X =@= _.

coordenadasVars(Tabuleiro, ListaVars):- 
    objectosEmCoordenadas(ListaVars, Tabuleiro, Obj_Coord), maplist(igual, Obj_Coord).

% X

% 2 estrelas

fechaListaCoordenadas(Tabuleiro, ListaCoord):- 
    coordObjectos(e, Tabuleiro, ListaCoord, LCO, _), length(LCO, 2), delete(ListaCoord, LCO, Resultado), 
    inserePontos(Tabuleiro, Resultado), !.

% 1 estrela
fechaListaCoordenadas(Tabuleiro, ListaCoord):-
    coordObjectos(e, Tabuleiro, ListaCoord, Estrelas, _), coordObjectos(_, Tabuleiro, ListaCoord, ListaVars, _), 
    length(Estrelas, 1),
    length(ListaVars, 1), ListaVars = [(L, C)], insereObjecto((L, C), Tabuleiro, e),
    inserePontosVolta(Tabuleiro, (L,C)), !.  

% 0 estrelas

fechaListaCoordenadas(Tabuleiro, ListaCoord):- 
    coordObjectos(e, Tabuleiro, ListaCoord, Estrelas, _), length(Estrelas, 0),  
    coordObjectos(_, Tabuleiro, ListaCoord, ListaVars, _), length(ListaVars, 2), 
    insereVariosObjectos(ListaVars, Tabuleiro, [e, e]),
    ListaVars = [(L, C), (L2, C2)], inserePontosVolta(Tabuleiro, (L,C)), inserePontosVolta(Tabuleiro, (L2,C2)), !.

fechaListaCoordenadas(_, _).



% XI

fecha(_, []):- !.

fecha(Tabuleiro, [H|T]):- 
    fechaListaCoordenadas(Tabuleiro, H), fecha(Tabuleiro, T).
    
