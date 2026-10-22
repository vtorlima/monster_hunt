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

% resolver: roda a busca a partir do estado inicial e mostra o resultado
resolver :-
    estado_inicial(Inicial),
    (   solucao_bl(Inicial, Invertido)
    ->  reverse(Invertido, Plano),
        length(Plano, T), Acoes is T - 1,
        nb_getval(expandidos, N),
        format("Plano encontrado: ~w acoes, ~w estados expandidos.~n", [Acoes, N]),
        forall(member(E, Plano), format("  ~w~n", [E]))
    ;   nb_getval(expandidos, N),
        format("Falha: o cachorro nao consegue chegar a bolinha (~w estados expandidos).~n", [N])
    ).
