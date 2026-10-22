% mundo.pl - regras do quintal
% Historia: um cachorro sai do lado do dono para buscar a bolinha.
% Os fatos do cenario atual sao criados por carregar/1 (cenarios.pl):
%   tamanho(L, A), dono(X, Y), muro(X, Y), item(Id, X, Y, Nome)
%
% Estado: estado(X, Y) = posicao do cachorro
:- dynamic tamanho/2, dono/2, muro/2, animal/4, item/4.

% Operadores: nome da acao e deslocamento (DX, DY). Y cresce para baixo.
movimento(cima,      0, -1).
movimento(baixo,     0,  1).
movimento(esquerda, -1,  0).
movimento(direita,   1,  0).

% R1 - Limites: a celula esta dentro do grid
dentro(X, Y) :-
    tamanho(L, A),
    X >= 1, X =< L,
    Y >= 1, Y =< A.

% R2 - Muro: bloqueia o movimento
livre(X, Y) :-
    dentro(X, Y),
    \+ muro(X, Y).

% R7 - Sucessor: UMA regra geral para todos os estados
s(estado(X, Y), estado(X2, Y2)) :-
    movimento(_, DX, DY),
    X2 is X + DX,
    Y2 is Y + DY,
    livre(X2, Y2).

% Posicao de um estado (os dois primeiros argumentos)
posicao(Estado, X, Y) :-
    arg(1, Estado, X),
    arg(2, Estado, Y).

% Nome da acao entre dois estados consecutivos
acao(E1, E2, Nome) :-
    posicao(E1, X, Y),
    posicao(E2, X2, Y2),
    DX is X2 - X,
    DY is Y2 - Y,
    movimento(Nome, DX, DY).

% Estado inicial: o cachorro comeca ao lado do dono
estado_inicial(estado(X, Y)) :-
    dono(X, Y).
