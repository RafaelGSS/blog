---
title: Fastify, Why another JavaScript Framework?
date: 2019-07-26 10:00
tags: nodejs,fastify,article,en-US
---

# Fastify, Why another JavaScript framework?

An introduction to the concepts and motivations behind the framework.

![Fastify brand image](https://cdn-images-1.medium.com/max/4800/0*my2MwgjbxHWLU45c.png)

All of us know that the JavaScript ecosystem is builtin by several frameworks.
In this article, I'll show you a framework called **Fastify** and why it's taken my attention.

[Fastify](https://github.com/fastify/fastify) is a web framework for Node.js focused in **performance** and **low [overhead](https://en.wikipedia.org/wiki/Overhead_(computing))**,
making it a great choice for those who are developing an architecture based on [microservices](https://en.wikipedia.org/wiki/Microservices).

We're working to let the [documentation](https://github.com/fastify/fastify#documentation) even better. So, if you find any mistake, feel free to send a PR.

## Benchmarks

![Benchmark showing Fastify faster than its competitors](https://cdn-images-1.medium.com/max/2000/1*O9vo3b_G0gf8PM1xpaZl0w.png)

Here comparing the **http-router** of others frameworks:

* find-my-way — _(Fastify)_
* [routr](https://github.com/yahoo/routr) — _(Yahoo INC)_
* koa-router — _(Koa)_
* express — _(Express)_

![Comparison between http-routers](https://cdn-images-1.medium.com/max/2000/1*8Ist58BSMOFPHnl-VPYsAA.png)

That's because [find-my-way](https://github.com/delvedor/find-my-way) uses an algorithm called [radix tree](https://en.wikipedia.org/wiki/Radix_tree)
under the hood to perform the routing, this is an exceptional performance factor compared to the others http-routers.
I'll talk about the algorithm itself in a future post.

More information about benchmarks can be found on the [Fastify website](https://www.fastify.io/benchmarks/), and [the Nearform blog post](https://www.nearform.com/blog/reaching-ludicrous-speed-with-fastify/).

## In Fastify, Everything is a plugin!

Your routes, your utilities, everything is a plugin! Fastify uses an awesome design to avoid high coupling and thus make the asynchronous bootstrap of the plugins. Thanks to [Avvio](https://github.com/mcollina/avvio)!

So, show the code!

First of all, let's install Fastify:

```console
$ npm i -S fastify
```

And now, let's create the `index.js` with our plugins:

<script src="https://gist.github.com/RafaelGSS/e951398544cf06e8538774d546d091c1.js"></script>

As you can see in the above script:

* **Row 1** - Initialize the Fastify.
* **Row 3** - We create a [**Decorator**](https://github.com/fastify/fastify/blob/master/docs/Decorators.md) (more about it bellow) and add a property called: *configuration.
* **Row 8** - Register the _plugin1.js_.
* **Row 10** - Register the _plugin2.js_.
* **Row 12** - Initialize the http-router of Fastify to accept HTTP connections on port 3000.

And now our plugins:

<script src="https://gist.github.com/RafaelGSS/55653247c21ec4397cf4abd9438baecd.js"></script>

At plugins, we receive the current context (Fastify instance) to work from this scope.

The Fastify provides us an API with several functionalities, among them (used in the code above): `fastify.register`.
This API creates **a new scope** to encapsulate our plugin. Which will receive as dependency injection:

1. *fastify* — Fastify instance in the current context.
2. *opts* — options from register.
3. *next* — Callback as any handler on express.

And `fastify.decorate`. The _decorate_ API has the power to define an attribute to the **current instance** of Fastify.
That's the encapsulation, the changes will not spread to their parents, only to their children.
This feature allows us to obtain plugin inheritance along with the encapsulation, in this way, able to build a Direct Acyclic Graph([DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph)).

> Note that, in `plugin2.js` at line 5, it printed **undefined** because that context passed to the plugin does not contain that property. Encapsulation!

> __“But, what if I need to add a property in the same context?”_

The Fastify provides a plugin for that: [_fastify-plugin_](https://www.npmjs.com/package/fastify-plugin).

## Why encapsulation is so important?

Fastify due to it's encapsulation model avoids cross dependencies ([Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns)).
Therefore, it helps the maintenance/debugging of your application.

Following this model, we can break our application into several microservices at any time without having to refactor the
entire project.

## Schema Validation?

Validating the request parameters and documenting it at same time would be awesome, uh?

By default, Fastify makes use of [Ajv](https://github.com/epoberezkin/ajv) for parameter validation and alongside the
plugin [fastify-swagger](https://github.com/fastify/fastify-swagger) one can document while validating the data.

![](https://res.cloudinary.com/rafaelgss/image/upload/v1657392914/blog/fastify/giphy_ak1hii.gif)

Let's do an API with validation/documentation as an example.

First, we'll install our dependencies:

```sh
npm i -S fastify-swagger
```

And so:

<script src="https://gist.github.com/RafaelGSS/ca3b91e54cf653afc8ff0e309094c30d.js"></script>

This is an fairly simple example just to show the plugins feature of Fastify and it's standard validation with `Ajv`
(you can use the schema compiler that you want, [Joi](https://github.com/hapijs/joi) is a good one).
So, let's go to the most important row:

* *Row 15*: We register the route and associate a schema, and this structure above tell us that we're expecting a
parameter in the query named `anyParam` which it's type is *number* and this same field is required.
So, at route */* we expect a param of name *anyParam* of numeric type.

Therefore, if you start your server and go to */docs*, you will see your route is already documented with
[_Swagger_](https://swagger.io/). If you want to customize it further, read the [documentation](https://github.com/fastify/fastify-swagger).

Now, let's test the validation without passing the required param *anyParam*:

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:3000/
```

It will return

```json
{
  "statusCode":400,
  "error":"Bad Request",
  "message":"querystring should have required property 'anyParam'"
}
```

Therefore, it's validating property your required parameter. Now, we'll send it, but as the wrong type (string):

```sh
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=stringQualquer
```

It will return

```json
{
  "statusCode":400,
  "error":"Bad Request",
  "message":"querystring.anyParam should be number"
}
```

As you can, the type is also validated. Finally, let's send the correct request:

```sh
curl -i -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -X GET [http://localhost:3000/](http://localhost:3000/)?anyParam=10
```

```json
{"ok":true}
```

Excellent, schema validated and documented!

## Final considerations

I hope I got your curiosity about Fastify a little bit, and that you don't follow the old [herd behavior](https://en.wikipedia.org/wiki/Herd_behavior), and use *express* for everything.

Social networks: [Github](https://github.com/RafaelGSS), [Twitter](https://twitter.com/_rafaelgss).
