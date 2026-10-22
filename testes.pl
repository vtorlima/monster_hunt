% testes.pl - testes com plunit. Rodar com: ?- run_tests.
:- use_module(library(plunit)).

:- begin_tests(fundacao).
test(nenhum_cenario_carregado) :-
    \+ tamanho(_, _).
:- end_tests(fundacao).
