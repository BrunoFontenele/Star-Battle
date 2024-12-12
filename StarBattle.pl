% I 

visualiza([]).

visualiza([H|Lista]):- 
    writeln(H), visualiza(Lista).


% II

visualizaLinha(Lista):- visualizaLinha(Lista, 0).

visualizaLinha([], _).

visualizaLinha([H|Lista], Contador):- Contador1 is Contador + 1, 
     write(Contador1), write(H), visualizaLinha(Lista, Contador1).


% III 

insereObjecto((L,C), Tabuleiro, Obj):-
     nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elemento), Elemento = Obj. %isso ajuda em algo? (!)

insereObjecto((L,C), Tabuleiro, Obj):-
    nth1(L, Tabuleiro, Linha), nth1(C, Linha, Elemento), dif(Obj, Elemento).

insereObjecto((L,C), Tabuleiro, _):-
    nth1(L, Tabuleiro, Linha), \+nth1(C, Linha, _).

insereObjecto((L,C), Tabuleiro, _):-
    \+nth1(L, Tabuleiro, Linha), nth1(C, Linha, _).