---
title: Fastify, Porque outro framework JS?
date: Jul 26, 2019
---

# Fastify, Porque outro framework JS?

Uma introdução aos conceitos e motivações por trás do framework.

![Fastify brand image](https://cdn-images-1.medium.com/max/4800/0*my2MwgjbxHWLU45c.png)

Todos sabemos que o ecossistema Javascript é formado por diversos frameworks (*possivelmente enquanto você está lendo esse artigo, um novo framework js é criado*). E neste artigo irei apresentar um framework chamado **Fastify**, e o porque ele chamou minha atenção.

[**Fastify**](https://github.com/fastify/fastify) é um framework web para Node.js com foco em **performance** e **baixo [overhead](https://en.wikipedia.org/wiki/Overhead_(computing))**, sendo assim uma ótima escolha pra você que está desenvolvendo uma arquitetura baseada em [microservices](https://en.wikipedia.org/wiki/Microservices).

Estamos trabalhando bastante para deixar a [documentação](https://github.com/fastify/fastify#documentation) ainda melhor… Portanto, se encontrar algum erro, mande um PR. 😁

E ah… uns de seus patrocinadores é a empresa: [NearForm](https://www.nearform.com/).

## Benchmarks

![Gráfico de Benchmark — Testes feitos com Node 8.4 — [referência](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)](https://cdn-images-1.medium.com/max/2000/1*O9vo3b_G0gf8PM1xpaZl0w.png)*Gráfico de Benchmark — Testes feitos com Node 8.4 — [referência](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)*

Aqui comparando o* http-router* de alguns frameworks:

* find-my-way — **(Fastify)**

* [routr](https://github.com/yahoo/routr) — (**Yahoo INC**)

* koa-router — (**Koa**)

* express — (**Express**)

![Comparação entre http-router — [referência](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)](https://cdn-images-1.medium.com/max/2000/1*8Ist58BSMOFPHnl-VPYsAA.png)*Comparação entre http-router — [referência](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)*

Isso porque [find-my-way](https://github.com/delvedor/find-my-way) usa um algoritmo chamado [radix tree](https://en.wikipedia.org/wiki/Radix_tree) internamente para realizar o roteamento, isso é um fator excepcional de performance comparado aos outros http-routes. Vou deixar pra falar sobre o algoritmo em si, em um post futuro.

Você pode conferir mais sobre benchmarks [aqui](https://www.fastify.io/benchmarks/), e [nesse](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/) post sensacional.

## No Fastify, tudo é um plugin!

Isso mesmo! Suas rotas, seus utilitários, tudo é um plugin! Fastify utiliza um incrível design para evitar um alto acoplamento, e assim fazer o **bootstrap assíncrono** dos plugins. Graças ao [Avvio](https://github.com/mcollina/avvio), amém!

Bom… vamos codar!

Primeiro de tudo, vamos instalar o Fastify:
```sh
npm i -S fastify
```

E agora vamos criar nosso index.js juntamente com nossos plugins:

<script src="https://gist.github.com/RafaelGSS/e951398544cf06e8538774d546d091c1.js"></script>

Como você podem ver nesse snippet index.js acima:

* **Linha 1** — Instanciamos o Fastify.
* **Linha 3** — Criamos um [**Decorator**](https://github.com/fastify/fastify/blob/master/docs/Decorators.md) (mais sobre ele abaixo) e adicionamos uma propriedade chamada: *configuration.
**Linha 8** — Registramos o plugin1.js.
**Linha 10** - Registramos o plugin2.js.
**Linha 12** - Inicializamos o http-router do Fastify para aceitar conexões HTTP na porta 3000.

E agora nossos plugins:

<script src="https://gist.github.com/RafaelGSS/55653247c21ec4397cf4abd9438baecd.js"></script>

Nos plugins, recebemos o contexto atual (instância Fastify) para podermos trabalhar a partir deste escopo.

O Fastify provê uma API no qual consta com diversas funcionalidades, dentre elas (usadas no código acima):

**Register —** O Fastify cria **um novo scopo** encapsulando seu plugin. No qual receberá como injeção de dependência:

1. *fastify — *Instância fastify no contexto atual.

1. *opts* — opções passadas pelo Register

1. *next* — Assim como qualquer handler no Express.

**Decorate** — Tem o poder de definir um atributo a **instância atual** do Fastify. Por isso o encapsulamento, as mudanças não se propagarão para seus ancestrais, somente para seus filhos! Essa feature nos permite obter herança de plugins junto ao encapsulamento, e desse modo, podemos criar um gráfico acíclico direto ([DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph)).
> Perceba que, no plugin2.js e na linha 5, ele printou **undefined** porque aquele contexto passado ao plugin, não contém aquela propriedade. Encapsulamento!
> # — __“Mas e se eu usar adicionar uma propriedade no mesmo contexto?”__ — O Fastify provê um plugin pra isso: [**fastify-plugin**](https://www.npmjs.com/package/fastify-plugin).

## Porque encapsulamento é tão importante ?!

Fastify devido ao seu modelo de encapsulação evita dependências cruzadas ([Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns)). Portanto, facilita a manutenção/depuração da sua aplicação.

Seguindo esse modelo, podemos quebrar nossa aplicação em vários microserviços a qualquer momento sem precisar refatorar todo seu projeto.

## Validação de Schema ?

Validar os parâmetros da requisição e ainda documentar parece bom né?!

O Fastify por padrão faz uso do [Ajv](https://github.com/epoberezkin/ajv) para validação de parâmetros, e junto ao plugin [fastify-swagger](https://github.com/fastify/fastify-swagger) você documenta enquanto valida os dados.

<iframe src="https://medium.com/media/623d47fcd337825013d008952fdd8079" frameborder=0></iframe>

Vamos fazer uma API com validação/documentação como exemplo.
Primeiro vamos instalar nossas dependências:

```sh
npm i -S fastify-swagger
```

E então:

<iframe src="https://medium.com/media/aea8e965500546aecfed89074f112c80" frameborder=0></iframe>

Esse snippet é simples, somente para mostrar a funcionalidade dos plugins do fastify e sua validação padrão com Ajv (Lembrando, você pode usar o schema compiler que você quiser, [Joi](https://github.com/hapijs/joi) é um bom exemplo disso). Então, vamos a descrição da linha mais importante:

* **Linha 15:** Nós registramos a rota e adicionamos um schema, e essa estrutura acima nos diz que estamos esperando um paramêtro na query com o nome de *anyParam* no qual seu tipo é *number* e esse mesmo campo é obrigatório. Ou seja, na rota *’/’* esperamos um parâmetro de nome *anyParam* do tipo numérico.

Vamos testar! Suba seu servidor — node index.js e vá para a página */docs*

Feito! Sua rota já está documentada com o [Swagger](https://swagger.io/) e caso queira personalizar mais, leia a [documentação](https://github.com/fastify/fastify-swagger).

Agora vamos testar a validação sem passar o argumento obrigatório *anyParam*:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:3000/
```

E então iremos receber o seguinte retorno:

    {
      "statusCode":400,
      "error":"Bad Request",
      "message":"querystring should have required property 'anyParam'"
    }


Validou nosso parâmetro obrigatório! Agora vamos manda-lo, porém do tipo ‘string’:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=stringQualquer
```

E recebemos:

    {
      "statusCode":400,
      "error":"Bad Request",
      "message":"querystring.anyParam should be number"
    }

Validou o tipo do parâmetro! Agora finalmente, vamos mandar o request certo, e verificar seu retorno:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=10
```

    {"ok":true}

Pronto! Schema validado e documentado!

![](https://cdn-images-1.medium.com/max/2000/1*LXYBULSDZT9a-aNpxQf1Sg.gif)

## Considerações finais

Espero ter alimentado um pouco sua curiosidade sobre o Fastify, e que vocês não sigam o velho [comportamento de manada](https://www.bbc.com/portuguese/brasil-42243930), e use **Express** pra tudo hehehe.

Redes sociais: [Github](https://github.com/RafaelGSS), [Twitter](https://twitter.com/_rafaelgss).
