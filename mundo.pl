% mundo.pl - regras do quintal
% Historia: um cachorro sai do lado do dono, busca a bolinha e a devolve.
% Cachorros e gatos bravos guardam uma zona (a propria celula e as 4 vizinhas).
% Para atravessar a zona, o cachorro entrega o item que acalma aquele animal:
% osso para cachorro, espinha de peixe para gato. O item se gasta e o animal
% fica deitado, roendo, para sempre. Mas com a bolinha na boca, nenhum cachorro
% (bravo ou acalmado) deixa passar: ele roubaria a bolinha. Gatos nao ligam.
% Os fatos do cenario atual sao criados por carregar/1 (cenarios.pl):
%   tamanho(L, A), dono(X, Y), muro(X, Y), animal(Id, X, Y, Tipo), item(Id, X, Y, Nome)
%
% Estado: estado(X, Y, Boca, Feitos)
%   Boca   = itens que o cachorro carrega (lista ordenada, pode repetir)
%   Feitos = ids dos itens ja pegos e dos animais ja acalmados (conjunto ordenado)
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

% R4 - Atravessar: todo animal bravo cuja zona contem a celula precisa ser
%      acalmado; cada um consome um item da boca
atravessa(X, Y, Boca, Feitos, Boca2, Feitos2) :-
    findall(Id-Tipo, ( zona(X, Y, Id, Tipo), \+ memberchk(Id, Feitos) ), L),
    sort(L, Bravos),
    acalma_todos(Bravos, Boca, Feitos, Boca2, Feitos2).

acalma_todos([], Boca, Feitos, Boca, Feitos).
acalma_todos([Id-Tipo | Resto], Boca, Feitos, Boca2, Feitos2) :-
    acalma(Item, Tipo),
    selectchk(Item, Boca, Boca1),          % entrega o item: ele se gasta
    ord_add_element(Feitos, Id, Feitos1),  % o animal fica roendo
    acalma_todos(Resto, Boca1, Feitos1, Boca2, Feitos2).

% R5 - Coleta: entrar numa celula com item ainda nao pego coloca-o na boca
coleta(X, Y, Boca, Feitos, Boca2, Feitos2) :-
    item(Id, X, Y, Nome),
    \+ memberchk(Id, Feitos), !,
    msort([Nome | Boca], Boca2),
    ord_add_element(Feitos, Id, Feitos2).
coleta(_, _, Boca, Feitos, Boca, Feitos).

% R6 - Bolinha: carregando a bolinha, o cachorro nunca entra na zona de outro
%      cachorro, nem de um acalmado (ele roubaria a bolinha para brincar).
%      Gatos nao se interessam pela bolinha.
seguro_com_bolinha(X, Y, Boca) :-
    memberchk(bolinha, Boca), !,
    \+ zona(X, Y, _, cachorro).
seguro_com_bolinha(_, _, _).

% R7 - Sucessor: UMA regra geral para todos os estados
s(estado(X, Y, B, F), estado(X2, Y2, B2, F2)) :-
    movimento(_, DX, DY),
    X2 is X + DX,
    Y2 is Y + DY,
    livre(X2, Y2),
    seguro_com_bolinha(X2, Y2, B),
    atravessa(X2, Y2, B, F, B1, F1),
    coleta(X2, Y2, B1, F1, B2, F2).

% R8 - Meta: estar de volta ao dono COM a bolinha
meta(estado(X, Y, Boca, _)) :-
    dono(X, Y),
    memberchk(bolinha, Boca).

% Posicao e boca de um estado (primeiros argumentos)
posicao(Estado, X, Y) :-
    arg(1, Estado, X),
    arg(2, Estado, Y).

boca(Estado, Boca) :-
    arg(3, Estado, Boca).

feitos(Estado, Feitos) :-
    arg(4, Estado, Feitos).

% Nome da acao entre dois estados consecutivos
acao(E1, E2, Nome) :-
    posicao(E1, X, Y),
    posicao(E2, X2, Y2),
    DX is X2 - X,
    DY is Y2 - Y,
    movimento(Nome, DX, DY).

% Estado inicial: ao lado do dono, boca vazia, nada feito
estado_inicial(estado(X, Y, [], [])) :-
    dono(X, Y).
