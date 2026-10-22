# O Cachorro e a Bolinha

Trabalho 1 de Inteligencia Artificial (UFSCar, 2026/2): um agente que planeja,
por busca em espaco de estados, como buscar a bolinha e devolve-la ao dono
num quintal com muros, cachorros e gatos bravos, ossos e espinhas de peixe.

## Como rodar

Requer SWI-Prolog 9 ou superior.

    swipl main.pl
    ?- rodar(e).        % cenario principal: mapa, caminho e plano em portugues
    ?- rodar(f).        % cenario sem solucao
    ?- comparar(e).     % Busca em Largura x Busca em Profundidade

Cenarios: `a` a `g` (ver `cenarios.pl`). Um mapa novo pode ser passado direto
na consulta:

    ?- carregar_mapa(["D..C..b", "o......"]), resolver.

## Legenda dos mapas

    D dono    # muro    . livre    C cachorro bravo    G gato bravo
    b bolinha    o osso (acalma cachorros)    e espinha (acalma gatos)

## Passo a passo (tags)

| Tag | O que entra |
| --- | --- |
| passo-1 | estrutura inicial |
| passo-2 | o quintal: mapas em ASCII e carregamento |
| passo-3 | o cachorro anda: movimentos e regra de sucessor |
| passo-4 | ele planeja: Busca em Largura ate a bolinha |
| passo-5 | ele explica: plano em linguagem natural |
| passo-6 | ida e volta: a boca entra no estado |
| passo-7 | animais bravos, osso e espinha (o item ainda nao se gasta) |
| passo-8 | o item se gasta: animais acalmados entram no estado |
| passo-9 | cachorros roubam a bolinha: a volta pode ser diferente da ida |
| passo-10 | comparacao entre Busca em Largura e em Profundidade |

Para ver o projeto em um passo: `git checkout passo-7` (volte com `git checkout main`).
