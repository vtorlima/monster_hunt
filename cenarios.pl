% cenarios.pl - mapas dos cenarios e carregamento
% Legenda: D dono (o cachorro sai e volta aqui)   # muro   . livre
%          C cachorro bravo   G gato bravo
%          b bolinha   o osso (acalma cachorros)   e espinha (acalma gatos)

% ---------- Cenarios ----------
cenario(a, ["........",           % campo aberto
            "D......b",
            "........"]).

cenario(b, ["...#....",           % a bolinha caiu atras do muro
            "D..#..b.",
            "...#....",
            "...#....",
            "........"]).

cenario(c, ["...#....",           % a bolinha caiu num cercado fechado
            "D..#.###",
            "...#.#b#",
            "...#.###",
            "...#...."]).

cenario(d, ["D....#....",         % um cachorro bravo guarda o atalho
            ".....C...b",
            ".o...#....",
            ".....#....",
            ".........."]).

cenario(g, ["D....##........",    % dois cachorros guardam a passagem; ha um osso so
            ".....CC........",
            ".o...##........",
            ".....##.....b..",
            ".....##.e......",
            "......G........",
            ".....##........"]).

% ---------- Carregamento ----------
% carregar(+Nome): carrega um cenario pelo nome (configuracao "nas regras")
carregar(Nome) :-
    cenario(Nome, Linhas),
    carregar_mapa(Linhas).

% carregar_mapa(+Linhas): carrega um mapa ASCII (configuracao "na consulta")
carregar_mapa(Linhas) :-
    Linhas = [Primeira | _],
    string_length(Primeira, L),
    verifica(forall(member(Lin, Linhas), string_length(Lin, L)),
             'todas as linhas precisam ter o mesmo tamanho'),
    limpar,
    length(Linhas, A),
    assertz(tamanho(L, A)),
    forall(nth1(Y, Linhas, Linha),
           ( string_chars(Linha, Cs),
             forall(nth1(X, Cs, C), celula(C, X, Y)) )),
    verifica(aggregate_all(count, dono(_, _), 1), 'precisa haver exatamente um D'),
    verifica(aggregate_all(count, item(_, _, _, bolinha), 1), 'precisa haver exatamente uma bolinha').

limpar :-
    retractall(tamanho(_, _)),
    retractall(dono(_, _)),
    retractall(muro(_, _)),
    retractall(animal(_, _, _, _)),
    retractall(item(_, _, _, _)).

% simbolo(?Caractere, ?Tipo): tabela da legenda (usada para ler e para desenhar)
simbolo('#', muro).
simbolo('D', dono).
simbolo('C', animal(cachorro)).
simbolo('G', animal(gato)).
simbolo(b,   item(bolinha)).
simbolo(o,   item(osso)).
simbolo(e,   item(espinha)).

% celula(+Caractere, +X, +Y): cria o fato correspondente ao simbolo
celula('.', _, _) :- !.
celula(C, X, Y) :- simbolo(C, Tipo), !, cria(Tipo, X, Y).
celula(C, X, Y) :-
    format("Cenario invalido: simbolo '~w' desconhecido em (~w,~w)~n", [C, X, Y]),
    fail.

cria(muro,         X, Y) :- assertz(muro(X, Y)).
cria(dono,         X, Y) :- assertz(dono(X, Y)).
cria(animal(Tipo), X, Y) :- novo_id(Tipo, Id), assertz(animal(Id, X, Y, Tipo)).
cria(item(Nome),   X, Y) :- novo_id(Nome, Id), assertz(item(Id, X, Y, Nome)).

% novo_id(+Tipo, -Id): bolinha1, osso1, cachorro1, cachorro2, ... na ordem de leitura
novo_id(Tipo, Id) :-
    aggregate_all(count, ( animal(_, _, _, Tipo) ; item(_, _, _, Tipo) ), N0),
    N is N0 + 1,
    atom_concat(Tipo, N, Id).

verifica(Condicao, _) :- call(Condicao), !.
verifica(_, Msg) :- format("Cenario invalido: ~w~n", [Msg]), fail.
