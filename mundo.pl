% mundo.pl - regras do quintal
% Historia: um cachorro sai do lado do dono para buscar a bolinha.
% Os fatos do cenario atual sao criados por carregar/1 (cenarios.pl):
%   tamanho(L, A), dono(X, Y), muro(X, Y), item(Id, X, Y, Nome)
:- dynamic tamanho/2, dono/2, muro/2, animal/4, item/4.
