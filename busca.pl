% busca.pl - Busca em Largura e em Profundidade (Aula 7)
%
% As duas usam o mesmo motor e o mesmo conjunto de estados ja vistos;
% so muda onde os sucessores entram na fronteira:
%   largura      -> no FINAL  (fila, FIFO): completa e admissivel
%   profundidade -> no INICIO (pilha, LIFO): completa aqui (espaco finito),
%                   mas NAO admissivel: o plano pode nao ser o mais curto
%
% Fronteira = lista de caminhos [Estado | CaminhoAteEle] (caminho invertido)
% Vistos    = estados que ja estao na fronteira ou ja foram explorados

solucao_bl(Inicial, Caminho) :- busca(largura, Inicial, Caminho).
solucao_bp(Inicial, Caminho) :- busca(profundidade, Inicial, Caminho).

% busca(+Estrategia, +Inicial, -Caminho): Caminho = [Meta, ..., Inicial]
busca(Estrategia, Inicial, Caminho) :-
    nb_setval(expandidos, 0),
    busca(Estrategia, [[Inicial]], [Inicial], Caminho).

busca(_, [[E | Cam] | _], _, [E | Cam]) :-
    meta(E), !.
busca(Estrategia, [[E | Cam] | Resto], Vistos, Solucao) :-
    conta_expansao,
    findall([S, E | Cam],
            ( s(E, S), \+ memberchk(S, Vistos) ),
            Novos),
    findall(S, member([S | _], Novos), NovosEstados),
    append(Vistos, NovosEstados, Vistos2),
    junta(Estrategia, Resto, Novos, Fronteira2),
    busca(Estrategia, Fronteira2, Vistos2, Solucao).
% Fronteira vazia: nenhuma clausula casa -> a busca FALHA

junta(largura,      Resto, Novos, F) :- append(Resto, Novos, F).
junta(profundidade, Resto, Novos, F) :- append(Novos, Resto, F).

conta_expansao :-
    nb_getval(expandidos, N),
    N1 is N + 1,
    nb_setval(expandidos, N1).
