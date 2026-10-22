% main.pl - ponto de entrada do projeto "O Cachorro e a Bolinha"
% Uso: swipl main.pl

:- ensure_loaded(mundo).
:- ensure_loaded(cenarios).
:- ensure_loaded(busca).
:- ensure_loaded(saida).
:- ensure_loaded(testes).

ola :- writeln('Projeto carregado com sucesso.').
