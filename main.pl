% main.pl - ponto de entrada do projeto "O Cachorro e a Bolinha"
% Uso: swipl main.pl

:- ensure_loaded(mundo).
:- ensure_loaded(cenarios).
:- ensure_loaded(busca).
:- ensure_loaded(saida).

% rodar(+Nome): carrega o cenario, mostra o quintal e resolve
rodar(Nome) :-
    carregar(Nome),
    mostrar_mapa, nl,
    resolver.
