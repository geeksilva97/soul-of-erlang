# CM42 Brownbag - Conhecendo a linguagem Erlang

## Olá

1. Olá pessoal, sejam bem-vindos a mais uma `brownbag` aqui no canal da CodeMiner42.
2. Meu nome é Edigleysson Silva e hoje eu venho falar um pouco sobre Erlang.
3. Vamos falar um pouco do entorno da linguagem, da BEAM (que é a VM do Erlang), da OTP e da sintaxe básica da linguagem Erlang.

## What is Erlang?
1. O Erlang em si é uma linguagem de programação de propósito geral.
2. OTP (Open Telecom Platform) é o que chamamos de _runtime system_, ela possui uma série componentes que usamos na construção de aplicações Erlang.
3. É na OTP que temos componentes como:
  - gen_server
  - gen_event
  - mnesia
  - supervisor
  - etc..
4. Esses componentes são largamente utilizados na construção de aplicações Erlang/Elixir.
5. BEAM é a máquina virtual.
6. É a máquina virtual que torna simples coisas como concorrência (mas não vamos nos profundar muito nisso hoje).
7. Além do Erlang temos outras linguagens que se valem dos recursos da BEAM como o Elixir que já conhecemos, Alpaca, EPHP (e mais https://github.com/llaisdy/beam_languages
).

## Blocos básicos da linguagem Erlang
- A linguagem pode ser obtida em https://www.erlang.org/downloads
- Você pode instalar manualmente baixando do github compilando (just for fun:))
- Mas pode também instalar com o seu gerenciador de pacotes como apt-get, homebrew, etc.
- Uma vez instalada teremos acesso ao EShell que podemos executar com o comando `erl`.
- Assim abrmos um shell interativo onde podemos executar expressões Erlang.

### Variáveis e tipos de dado
- Para definirmos variáveis precisamos defini-las com letra maúscula no início (Name, Email, Message).
- Podemos definir uma string (com aspas duplas) `Name = "Edy Silva"`
- O nosso shell vai contando as expressões executadas e como podemos ver ele segue com o mesmo número.
- Isso acontece por conta que não finalizamos. Precisamos adiciona o ponto final (.) fazendo:
  ```eshell
  1> Name = "Edy".
  "Edy"
  2> 
  ```
-

### Tudo se constrói com módulos e funções

### A sintaxe é semelhante à gramatica

## Everything runs in a process

## Concurrency, distribution, fault tolerance
