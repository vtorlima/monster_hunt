% saida.pl - impressao do quintal e do plano em linguagem natural

% ---------- Mapa ----------
% mostrar_mapa: imprime o cenario carregado em ASCII (~ = zona de animal bravo)
mostrar_mapa :-
    mostrar_mapa([]).

% mostrar_mapa(+Marcas): idem, desenhando marcas X-Y-Simbolo nas celulas livres
mostrar_mapa(Marcas) :-
    tamanho(L, A),
    forall(between(1, A, Y),
           ( forall(between(1, L, X),
                    ( desenho(X, Y, Marcas, S), write(S) )),
             nl )).

desenho(X, Y, _, S) :- dono(X, Y), !, simbolo(S, dono).
desenho(X, Y, _, S) :- muro(X, Y), !, simbolo(S, muro).
desenho(X, Y, _, S) :- animal(_, X, Y, T), !, simbolo(S, animal(T)).
desenho(X, Y, _, S) :- item(_, X, Y, N), !, simbolo(S, item(N)).
desenho(X, Y, M, S) :- memberchk(X-Y-S, M), !.
desenho(X, Y, _, '~') :- zona(X, Y, _, _), !.
desenho(_, _, _, '.').

% mostrar_caminho(+Plano): o quintal com o plano marcado
%   > celula usada so na ida   < so na volta   + nas duas
mostrar_caminho(Plano) :-
    findall(X-Y-S,
            ( member(E, Plano), posicao(E, X, Y), marca(Plano, X, Y, S) ),
            Marcas0),
    sort(Marcas0, Marcas),
    mostrar_mapa(Marcas),
    writeln('(> ida   < volta   + ida e volta)').

marca(Plano, X, Y, S) :-
    ( passou(Plano, X, Y, ida)   -> Ida = sim ; Ida = nao ),
    ( passou(Plano, X, Y, volta) -> Volta = sim ; Volta = nao ),
    simbolo_marca(Ida, Volta, S).

passou(Plano, X, Y, Trecho) :-
    member(E, Plano),
    posicao(E, X, Y),
    boca(E, Boca),
    ( memberchk(bolinha, Boca) -> Trecho = volta ; Trecho = ida ).

simbolo_marca(sim, nao, '>').
simbolo_marca(nao, sim, '<').
simbolo_marca(sim, sim, '+').

% ---------- Plano em linguagem natural ----------
% resolver: roda a busca a partir do estado inicial e conta o resultado
resolver :-
    estado_inicial(Inicial),
    (   solucao_bl(Inicial, Invertido)
    ->  reverse(Invertido, Plano),
        nb_getval(expandidos, N),
        mostrar_caminho(Plano), nl,
        imprime_plano(Plano),
        length(Plano, T), Acoes is T - 1,
        format("~nBolinha devolvida em ~w acoes. Estados expandidos: ~w.~n", [Acoes, N])
    ;   nb_getval(expandidos, N),
        format("Falha: nao ha como trazer a bolinha de volta ao dono (~w estados expandidos).~n", [N])
    ).

imprime_plano(Plano) :-
    Plano = [Inicial | _],
    posicao(Inicial, X, Y),
    item(_, BX, BY, bolinha),
    format("O cachorro esta ao lado do dono em (~w,~w). A bolinha caiu em (~w,~w).~n", [X, Y, BX, BY]),
    imprime_passos(Plano, 1).

imprime_passos([_], _).
imprime_passos([E1, E2 | Resto], N) :-
    acao(E1, E2, Acao),
    texto_acao(Acao, Texto),
    posicao(E2, X, Y),
    format("~t~w~3|. anda para ~w ate (~w,~w)", [N, Texto, X, Y]),
    eventos(E1, E2),
    nl,
    N1 is N + 1,
    imprime_passos([E2 | Resto], N1).

% eventos(+Antes, +Depois): o que acontece ao entrar na nova celula
eventos(E1, E2) :-
    posicao(E1, X1, Y1),
    posicao(E2, X2, Y2),
    boca(E1, B1),
    forall(( zona(X2, Y2, Id, Tipo), \+ zona(X1, Y1, Id, _) ),
           ( acalma(Item, Tipo), nome_item(Item, NomeItem),
             format(" e passa pelo ~w bravo mostrando ~w", [Tipo, NomeItem]) )),
    boca(E2, B2),
    forall(( member(I, B2), \+ memberchk(I, B1) ),
           ( nome_item(I, Nome), format(" e pega ~w", [Nome]) )),
    ( meta(E2) -> write(' e devolve a bolinha ao dono') ; true ).

nome_item(bolinha, 'a bolinha').
nome_item(osso,    'o osso').
nome_item(espinha, 'a espinha de peixe').

texto_acao(cima,     'cima').
texto_acao(baixo,    'baixo').
texto_acao(esquerda, 'a esquerda').
texto_acao(direita,  'a direita').
