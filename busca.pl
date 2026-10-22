% busca.pl - Busca em Largura (Aula 7) com conjunto de estados ja vistos
%
% Fronteira = lista de caminhos [Estado | CaminhoAteEle] (caminho invertido)
% Vistos    = estados que ja estao na fronteira ou ja foram explorados
% Diferente da versao dos slides, que so evita repetir estados do proprio
% caminho, aqui nenhum estado entra duas vezes na fronteira.

% solucao_bl(+Inicial, -Caminho): Caminho = [Meta, ..., Inicial]
solucao_bl(Inicial, Caminho) :-
    nb_setval(expandidos, 0),
    bl([[Inicial]], [Inicial], Caminho).

bl([[E | Cam] | _], _, [E | Cam]) :-
    meta(E), !.
bl([[E | Cam] | Resto], Vistos, Solucao) :-
    conta_expansao,
    findall([S, E | Cam],
            ( s(E, S), \+ memberchk(S, Vistos) ),
            Novos),
    findall(S, member([S | _], Novos), NovosEstados),
    append(Vistos, NovosEstados, Vistos2),
    append(Resto, Novos, Fronteira2),       % FIFO: sucessores no FINAL
    bl(Fronteira2, Vistos2, Solucao).
% Fronteira vazia: nenhuma clausula casa com bl([], _, _) -> a busca FALHA

conta_expansao :-
    nb_getval(expandidos, N),
    N1 is N + 1,
    nb_setval(expandidos, N1).
