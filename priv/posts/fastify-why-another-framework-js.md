---
title: Fastify, Why another Javascript Framework?
date: 2019-07-26 10:00
tags: nodejs,article,en-US
---

# Fastify, why another Javascript framework?

An intruduction to the concepts and motivations behind the framework.

![Fastify brand image](https://cdn-images-1.medium.com/max/4800/0*my2MwgjbxHWLU45c.png)

All of us know that the Javascript ecosystem is builtin by several frameworks. In this article, I'll show you a framework called **Fastify** and why it's taken my attention.

[**Fastify**](https://github.com/fastify/fastify) is a web framework for Node.js focused in **performance** and **low [overhead](https://en.wikipedia.org/wiki/Overhead_(computing))**, making it a great choice for you who are developing an architecture based on [microservices](https://en.wikipedia.org/wiki/Microservices).

We're working to let the [documentation](https://github.com/fastify/fastify#documentation) even better. So, if you find any mistake, feel free to send a PR.

## Benchmarks

![Gráfico de Benchmark — Testes feitos com Node 8.4 — [reference](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)](https://cdn-images-1.medium.com/max/2000/1*O9vo3b_G0gf8PM1xpaZl0w.png)*Gráfico de Benchmark — Testes feitos com Node 8.4 — [reference](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)*

Here comparing the **http-router** of others frameworks:

* find-my-way — **(Fastify)**

* [routr](https://github.com/yahoo/routr) — (**Yahoo INC**)

* koa-router — (**Koa**)

* express — (**Express**)

![Comparação entre http-router — [reference](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)](https://cdn-images-1.medium.com/max/2000/1*8Ist58BSMOFPHnl-VPYsAA.png)*Comparação entre http-router — [reference](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/)*

That's because [find-my-way](https://github.com/delvedor/find-my-way) uses an algorithm called [radix tree](https://en.wikipedia.org/wiki/Radix_tree) under the hood to perform the routing, this is an excepcional performance factor compared to the others http-routes. I'll let to talk about the algorithm itself, in a future post.

You can verify more about the benchmarks [here](https://www.fastify.io/benchmarks/), and [here](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/).

## In Fastify, Everything is a plugin!

That's right! Your routes, your utilities, every piece is a plugin! Fastify uses a awesome design to avoid high coupling and thus make the asynchronous bootstrap of the plugins. Thanks to [Avvio](https://github.com/mcollina/avvio)!

So, show the code!

First of all, let's install Fastify:
```sh
npm i -S fastify
```

And now, let's create the `index.js` with our plugins:

<script src="https://gist.github.com/RafaelGSS/e951398544cf06e8538774d546d091c1.js"></script>

As you can see at this above script:

* **Linha 1** — Initializing the Fastify.
* **Linha 3** — We create a [**Decorator**](https://github.com/fastify/fastify/blob/master/docs/Decorators.md) (more about it bellow) and add a property called: *configuration.
**Linha 8** — Register the plugin1.js.
**Linha 10** - Register the plugin2.js.
**Linha 12** - Initializing the http-router of Fastify to accept HTTP connection on port 3000.

And now our plugins:

<script src="https://gist.github.com/RafaelGSS/55653247c21ec4397cf4abd9438baecd.js"></script>

At plugins, we receive the current context (Fastify instance) to work from this scope.

The Fastify provides us an API with serveral funcionalities, among them (used in the code above):

**Register —** The Fastify create **a new scope** to encapsulate your plugin. In which will receive as dependency injection:

1. *fastify* — Fastify instance at current context.

1. *opts* — options from register.

1. *next* — Callback as any handler on express.

**Decorate** — Has the power to define an attribute to the **current instance** of Fastify. That's the encapsulation, the changes will not spread to their parents, only for their children! This feature allows us to obtain plugin inheritance along with the encapsulation, in this way, able to build a Direct Acyclic Graph [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph).

> Note that, in `plugin2.js` at line 5, it printed **undefined** because that context passed to the plugin does not contain that property. Encapsulation!
> # — __“But, what if I need to add a property in the same context?”__ — The Fastify provide a plugin for that: [**fastify-plugin**](https://www.npmjs.com/package/fastify-plugin).

## Why encapsulation is so important?

Fastify due to it's encapsulation model avoids cross dependencies ([Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns)). Therefore, it help the manutention/debugging of your application.

Following this model, we can break our application into several microservices at any time without having to refactor your entire project.

## Schema Validation?

Validate the request parameters and document it at same time is a nice world, right?

By default Fastify makes use of [Ajv](https://github.com/epoberezkin/ajv) for parameter validation and alongside the plugin [fastify-swagger](https://github.com/fastify/fastify-swagger) you document while validating the data.

![](https://res.cloudinary.com/rafaelgss/image/upload/v1657392914/blog/fastify/giphy_ak1hii.gif)

Let's do an API with validation/documentation as example.
First, we'll install our dependencies:

```sh
npm i -S fastify-swagger
```

And so:

<script src="https://gist.github.com/RafaelGSS/ca3b91e54cf653afc8ff0e309094c30d.js"></script>

This is an easy example just to show the plugins feature of Fastify and it's standard validation with `Ajv` (you can use the schema compiler that you want, [Joi](https://github.com/hapijs/joi) is a good one). So, let's go to the most important line:

* **Line 15:** We register the route and associate a schema, and this structure above tell us that we're expecting a parameter in the query named `anyParam` which it's type is *number* and this same field is required. So, at route */* we expect a param of name *anyParam* of numeric type. Nós registramos a rota e adicionamos um schema, e essa estrutura acima nos diz que estamos esperando um paramêtro na query com o nome de *anyParam* no qual seu tipo é *number* e esse mesmo campo é obrigatório. Ou seja, na rota *’/’* esperamos um parâmetro de nome *anyParam* do tipo numérico.

Let's test! Start your server — node index.js and go to */docs*

Done! Your route is already documented with [Swagger](https://swagger.io/) and if you want customize futher, read the [documentation](https://github.com/fastify/fastify-swagger).

Now, let's test the validation without pass required param *anyParam*:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:3000/
```

It's return:

```json
{
  "statusCode":400,
  "error":"Bad Request",
  "message":"querystring should have required property 'anyParam'"
}
```

It's validated your required parameter! Now, we'll send it, but as string type:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=stringQualquer
```

And gets:

```json
{
  "statusCode":400,
  "error":"Bad Request",
  "message":"querystring.anyParam should be number"
}
```

It's validated the parameter type! Finally, let's send the correct request:

```sh
curl -i -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=10
```

```json
{"ok":true}
```

Excellent, schema validated and documented!

![](https://cdn-images-1.medium.com/max/2000/1*LXYBULSDZT9a-aNpxQf1Sg.gif)

## Final considerations

I hope I got your curiosity about Fastify a little bit, and that you don't follow the old [herd behavior](https://en.wikipedia.org/wiki/Herd_behavior), and use **Express** for everything.

Social networks: [Github](https://github.com/RafaelGSS), [Twitter](https://twitter.com/_rafaelgss).
