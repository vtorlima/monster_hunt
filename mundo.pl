% mundo.pl - regras do quintal
% Historia: um cachorro sai do lado do dono, busca a bolinha e a devolve.
% Cachorros e gatos bravos guardam uma zona (a propria celula e as 4 vizinhas).
% So atravessa a zona quem tem o item que acalma o animal: osso para cachorro,
% espinha de peixe para gato.
% Os fatos do cenario atual sao criados por carregar/1 (cenarios.pl):
%   tamanho(L, A), dono(X, Y), muro(X, Y), animal(Id, X, Y, Tipo), item(Id, X, Y, Nome)
%
% Estado: estado(X, Y, Boca)
%   Boca = itens que o cachorro carrega (lista ordenada)
:- dynamic tamanho/2, dono/2, muro/2, animal/4, item/4.

% Operadores: nome da acao e deslocamento (DX, DY). Y cresce para baixo.
movimento(cima,      0, -1).
movimento(baixo,     0,  1).
movimento(esquerda, -1,  0).
movimento(direita,   1,  0).

% Qual item acalma qual tipo de animal
acalma(osso,    cachorro).
acalma(espinha, gato).

% R1 - Limites: a celula esta dentro do grid
dentro(X, Y) :-
    tamanho(L, A),
    X >= 1, X =< L,
    Y >= 1, Y =< A.

% R2 - Muro: bloqueia o movimento
livre(X, Y) :-
    dentro(X, Y),
    \+ muro(X, Y).

% R3 - Zona de um animal: a celula dele e as 4 vizinhas
zona(X, Y, Id, Tipo) :-
    animal(Id, X, Y, Tipo).
zona(X, Y, Id, Tipo) :-
    animal(Id, AX, AY, Tipo),
    movimento(_, DX, DY),
    X =:= AX + DX,
    Y =:= AY + DY.

% R4 - Atravessar: so entra na zona de um animal quem tem na boca o item
%      que acalma aquele tipo de animal
pode_passar(X, Y, Boca) :-
    forall(zona(X, Y, _, Tipo),
           ( acalma(Item, Tipo), memberchk(Item, Boca) )).

% R5 - Coleta: entrar numa celula com item coloca-o na boca
coleta(X, Y, Boca, Boca2) :-
    item(_, X, Y, Nome), !,
    ord_add_element(Boca, Nome, Boca2).
coleta(_, _, Boca, Boca).

% R7 - Sucessor: UMA regra geral para todos os estados
s(estado(X, Y, B), estado(X2, Y2, B2)) :-
    movimento(_, DX, DY),
    X2 is X + DX,
    Y2 is Y + DY,
    livre(X2, Y2),
    pode_passar(X2, Y2, B),
    coleta(X2, Y2, B, B2).

% R8 - Meta: estar de volta ao dono COM a bolinha
meta(estado(X, Y, Boca)) :-
    dono(X, Y),
    memberchk(bolinha, Boca).

% Posicao e boca de um estado (primeiros argumentos)
posicao(Estado, X, Y) :-
    arg(1, Estado, X),
    arg(2, Estado, Y).

boca(Estado, Boca) :-
    arg(3, Estado, Boca).

% Nome da acao entre dois estados consecutivos
acao(E1, E2, Nome) :-
    posicao(E1, X, Y),
    posicao(E2, X2, Y2),
    DX is X2 - X,
    DY is Y2 - Y,
    movimento(Nome, DX, DY).

% Estado inicial: o cachorro comeca ao lado do dono, de boca vazia
estado_inicial(estado(X, Y, [])) :-
    dono(X, Y).
