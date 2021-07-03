---
title: Node Core - Overview Libuv P1
date: 2019-06-19 18:00
tags: nodejs,tips,pt-BR
---

# Node Core: Overview P1

Esse post é somente para explicar o funcionamento da concorrência no NodeJS, mais especificamente a Libuv

## Async

O NodeJS usa o libuv como gerenciador de async i/o. O Event Loop é sim Single Thread, porém, o libuv contem 4 Threads iniciais em seu pool. Ou seja, se fizermos 1 chamada ou 4 chamadas async daria no mesmo.

Outro ponto importante pra tocar, é que o EventLoop funciona dessa forma:
Chamada Async -> Callstack(libuv) -> Callback é chamado no EventLoop.

Como o V8 é single thread e só existe uma stack, os callbacks precisam esperar a sua vez de serem chamados. Enquanto esperam, eles ficam em um lugar chamado task queue, ou fila de tarefas. Sempre que a thread principal finalizar uma tarefa, o que significa que a stack estará vazia, uma nova tarefa é movida da task queue para a stack, onde será executada.

Linha de raciocinio EventLoop

### Macro tasks
Alguns exemplos conhecidos de macro tasks são: setTimeout, I/O e setInterval. Segundo a especificação do WHATWG, somente uma macro task deve ser processada em um ciclo do Event Loop.

### Micro tasks
Alguns exemplos conhecidos de micro tasks são as `Promises` e o `process.nextTick`. As micro tasks normalmente são tarefas que devem ser executadas rapidamente após alguma ação, ou realizar algo assíncrono sem a necessidade de inserir uma nova task na task queue.

A especificação do WHATWG diz que, após o Event Loop processar a macro task da task queue, todas as micro tasks disponíveis devem ser processadas e, caso elas chamem outras micro tasks, essas também devem ser resolvidas para que, somente então, ele chame a próxima macro task.
