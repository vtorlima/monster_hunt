% saida.pl - impressao do quintal

% mostrar_mapa: imprime o cenario carregado em ASCII
mostrar_mapa :-
    tamanho(L, A),
    forall(between(1, A, Y),
           ( forall(between(1, L, X),
                    ( desenho(X, Y, S), write(S) )),
             nl )).

desenho(X, Y, S) :- dono(X, Y), !, simbolo(S, dono).
desenho(X, Y, S) :- muro(X, Y), !, simbolo(S, muro).
desenho(X, Y, S) :- item(_, X, Y, N), !, simbolo(S, item(N)).
desenho(_, _, '.').
