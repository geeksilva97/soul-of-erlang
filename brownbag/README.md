# CM42 Brownbag - Conhecendo a linguagem Erlang

## Olá

1. Olá pessoal, sejam bem-vindos a mais uma `brownbag` aqui no canal da CodeMiner42.
2. Meu nome é Edigleysson Silva e hoje eu venho falar um pouco sobre Erlang.
3. Vamos falar um pouco do entorno da linguagem, da BEAM (que é a VM do Erlang), da OTP e da sintaxe básica da linguagem Erlang.

## O que é Erlang/OTP?
1. O Erlang em si é uma linguagem de programação de propósito geral. É uma linguagem funcional em sua essência e faz uso de conceitos como imutabilidade.
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
  ```erl
  1> Name = "Edy".
  "Edy"
  2> 
  ```
- Acabamos de criar uma variável com o valor "Edy". Se quiseremos alterar o seu valor... não conseguimos.
- Se tentarmos receberemos uma exception dizendo que o pattern matching falhou.
- Isso é o que podemos chamar de imutabilidade.
- Num primeiro momento podemos pensar que necessitaremos de muitas variáveis para performar tarefas simples por causa desse comportamento, onde não podemos dar rebind em variáveis.
- No entanto, devido a construção sobre recursividade, isso não é problema, e na verdade tende a facilitar a depuração.
- Uma variável `X` não vai mudar seu valor, tenha certeza disso.
- Temos também outros tipos de dados. Alguns mais comuns, outros específicos e característicos desse ecossistema.
  - Numbers, que podem ser inteiros ou de ponto flutuante
  - Atoms, podemos definir como uma constante, sempre começa com letra minúscula e por isso que variáveis não podem ser iniciadas da mesma forma, pois o Erlang entende isso como um átomo. Se eventuamente for preciso um átomo iniciaod com letra maiúscula pode-se usar aspas simples (') para definir `'MyAtom'`.
  - Boolean, true e false, que são na verdade atomos
  - Fun, funções anônimas
  - Tuple, estrutura com número fixo de itens
  - List, estrutura com número variável de itens
  - Map, estrutura associação chave/valor

### A sintaxe é semelhante à gramatica
- Como vimos toda expessão Erlang deve terminar com um ponto final (.). Tal qual terminamos uma frase.
- Outros símbolos que fazemos uso são vírgulas (,) e ponto e vírgula (;).
- Usamos vírgula para separar expresões dentro de uma função. Exemplo:

    ```erl
    MyFun = fun() ->
    io:format("Hello~n"), % there is another expression
    timer:sleep(1000), % there is another expression
    io:format("CodeMiner42~n") % nothing here the period goes in the most external block
    end. % the period (.) goes here
    ```
- Usamos ponto e vírgula para separar clausulas, cenários. Como na estrutura *case* por exemplo:

    ```erl
      case 1+1 of 
        0 ->
          io:format("Neutral result"), % add commas because we have another expression in this clause
          "The result is zero";
        1 -> "The result is one";
        2 -> "The result is two" % no clause or expression after
      end.
    ```

### Tudo se constrói com módulos e funções
- O EShell é muito útil e muito bom, mas não é suficiente.
- Afinal perdemos tudo ao encerrá-lo.
- Em aplciações reais preciamos ter nosso código em arquivos, para que possamos organizá-los.
- Podemos por nosso código Erlang em arquivos com a extensão `.erl`.
- Cada arquivo será um módulo com suas respectivas funções.
- Essas funções por sua vez são retornadas para que possam ser utilizadas.
- É uma espécie de encapsulamento. Quem é do JS (pra fugir o pouco do exmplo do elixir) vai perceber algo semelhante com o uso da palavra reservada *export*.

## Tudo roda em um processo
- Esse um ponto interessante e que faz com que a mágica aconteca.
- Primeiro é preciso deixar claro que um processo Erlang é diferente de um processo do sistema operacional.
- Antes de tudo processos Erlang são bem mais leves, aplicações Erlang costumam ter milhares deles.
- Esses processos executam as tarefas. Existem formas diferentes de iniciar um processo Erlang uma das mais simples é passando uma função anonima como:

  ```erl
  Pid = spawn(fun() ->
    receive
      Message ->
        io:format("I received the message~n"),
        io:format("Now I'm prepared to die.")
    end
  end).
  ```

- Os processos não compartilham estado (isso nunca é bom) e só se comunicam por mensagens.
- No processo que iniciamos acima temos a instrução receive que fica aguardando por mensagens que chegam.
- O receive já recebe e trata as mensagens.
- Caso contrário as mensagens ficam em uma mailbox e podem ser lidas posteriormente.
- Quando disse que tudo em erlang é um processo eu falei sério.
- Esse EShell por si só é um processo. Podemos ver isso executando `self()`. Isso vai nos retornar um PID do processo atual.
- Nesse caso, o PID do EShell. Podemos ter mais detalhes do processo executando 

  ```erl
  1> process_info(self()).
  ```
- Os processos se comunicam por mensagens podemos enviar mensagens com o operador *!* de modo que façamos `PID ! Message` (eg. Pid ! "My message");
- Podemos inclusive mandar mensagens para nós mesmos

  ```erl
  1> self() ! {message, "Self message"}.
  ```

- Podemos ver as mensagens com

  ```erl
  process_info(self(), messages).
  ```
- Para esse caso especial do EShell podemos ler da mailbox com a função `flush()`. Em processos que não o EShell precisamos sim do *receive*.

## Demos

### Concorrência
- Link: https://github.com/geeksilva97/soul-of-erlang/tree/main/demos/math_demo
- Nessa demo temos um server (mal implementado) que recebe requisições para fazer uma soma de algarismos.
- Por exemplo, se eu forneco como parâmetro 4 o server faz a soma 1 + 2 + 3 + 4 = 10
- O que essa simples aplicação faz é inciar um processo para receber as requisições e para cada requisição um novo processo é iniciado.
- Assim podemos fazer concorrentemente o cálculo dos valores.

  ```erl
  1> c(calculator).
  {ok, calculator}
  2> Pid = calculator:run()
  The process <0.87.0> started computing the sum from 1 to 9999999
  The process <0.89.0> started computing the sum from 1 to 999999
  The process <0.90.0> started computing the sum from 1 to 10
  The process <0.91.0> started computing the sum from 1 to 100
  The process <0.92.0> started computing the sum from 1 to 1000
  The process <0.93.0> started computing the sum from 1 to 10000
  The process <0.94.0> started computing the sum from 1 to 10000
  The process <0.95.0> started computing the sum from 1 to 99999999
  Erro: "Something went wrong" [<0.88.0>]
  <0.86.0>
  The process <0.90.0> executed with the result 55
  The process <0.91.0> executed with the result 5050
  The process <0.92.0> executed with the result 500500
  The process <0.94.0> executed with the result 50005000
  The process <0.93.0> executed with the result 50005000
  The process <0.89.0> executed with the result 499999500000
  The process <0.87.0> executed with the result 49999995000000
  The process <0.95.0> executed with the result 4999999950000000

  3> Pid ! {do_calc, 100000000},
  3> Pid ! {do_calc, 1000},
  3> Pid ! {do_calc, 13},
  3> Pid ! {do_calc, 100077}.
  ```
- É possível ver que conseguimos computar os valores de forma concorrente.
- Mesmo um demorando um pouco mais isso não interfere na execução dos outros.
- O valor 13 em especial lança uma exception, mas não interfere nos outros.

### Tolerância a falhas
- Um dos conceitos importantes aqui são supervisores, que é quem fica de olho nos processo inciados e têm o poder de reiniá-los quando algo der errado.
- Nessa demo iniciamos um supervisor com dois filhos.

  ```erl
  1> {ok, Pid} = ch_sup:start_link().
  {ok,<0.107.0>}

  2> supervisor:which_children(Pid).
  [{ch4,<0.109.0>,worker,[ch4]},{ch3,<0.108.0>,worker,[ch3]}]

  3> exit(pid(0,109,0), kill). 
  =SUPERVISOR REPORT==== 21-Mar-2022::23:27:32.215682 ===
    supervisor: {<0.107.0>,ch_sup}
    errorContext: child_terminated
    reason: killed
    offender: [{pid,<0.109.0>},
               {id,ch4},
               {mfargs,{ch4,start_link,[]}},
               {restart_type,permanent},
               {significant,false},
               {shutdown,brutal_kill},
               {child_type,worker}]

   true

  4> supervisor:which_children(Pid).
  [{ch4,<0.113.0>,worker,[ch4]},{ch3,<0.108.0>,worker,[ch3]}]
  ```
- Matamos o processo e o supervisor já recebe a informação.
- Esse supervisor tem uma estratégia de restart de one_for_one que restarta o processo que morreu.
- Podemos ver que o PID agora é outro.

### Distribução
