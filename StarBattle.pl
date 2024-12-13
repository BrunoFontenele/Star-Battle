% I 

visualiza([]):- !.

visualiza([H|Lista]):- 
    writeln(H), visualiza(Lista).


% II

visualizaLinha(Lista):- visualizaLinha(Lista, 0).

visualizaLinha([], _):- !.

visualizaLinha([H|Lista], Contador):- Contador1 is Contador + 1, 
     write(Contador1), write(": "), write(H), nl, visualizaLinha(Lista, Contador1).


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
    PontosVolta = [(L_Cima, C_Esq), (L_Cima, C), (L_Cima, C_Dir), (L, C_Esq), (L, C_Dir), (L_Baixo, C_Esq), (L_Baixo, C), (L_Baixo, C_Dir)],
    Objs = [p, p, p, p, p, p, p, p], %é possível fazer utilizando insereObjecto e uma recursão
    insereVariosObjectos(PontosVolta, Tabuleiro, Objs).

% VI 

inserePontos(_, []):- !.

inserePontos(Tabuleiro, [Coord|ListaCoord]):- 
    insereObjecto(Coord, Tabuleiro, p), inserePontos(Tabuleiro, ListaCoord).

% VII