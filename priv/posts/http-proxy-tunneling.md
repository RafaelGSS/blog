---
title: HTTP Proxy Tunneling
date: 2022-07-10 15:40
tags: network,en-US
---

# HTTP Proxy Tunneling

### _How much do you trust your HTTP Proxy Client?_

Most developers have at least heard about HTTP Proxy and some of them use it on a daily basis.
They are excellent ways to intercept and debug HTTP requests made from your local environment.
I strongly suggest checking them out.

There are a large number of HTTP Proxy available in the market/community. My personal preference are:

* [MiTM Proxy](https://mitmproxy.org/)
* [HTTP Toolkit Proxy](https://httptoolkit.tech/)

Nevertheless, most developers don’t know **precisely** how HTTP Proxy works under the hood.
By the way, is totally acceptable not to know that.
But, let's assume you attend an interview and the interviewer _for some weird reason_ asks you to implement a simple **HTTP proxy client (forward proxy)**,
would you be able to do it?

The vast majority would end up with an implementation pretty similar to this:

```js
const http = require('http')

http.get({
  hostname: 'localhost', // proxy url
  port: 8000, // proxy port
  path: 'https://example.com/', // requested server
  headers: {
    host: 'example.com'
  }
}, (res) => {
  console.log(res.statusCode) // 200
})
```

Well… This likely will work. But, this is totally **unsafe** and in this blog post, I’ll show you why.

> This is a longer explanation of a security advisory that `undici` received in version `v5.5.0`.
Further information at [GHSA-pgw7-wx7w-2w33](https://github.com/nodejs/undici/security/advisories/GHSA-pgw7-wx7w-2w33). It was fixed in `undici@5.5.1`.

## Firstly, what is Proxy, and why would someone use it?

A Proxy is a gateway (intermediary) between the client (you) and the requested server. If you are using an HTTP Proxy, all the HTTP Traffic flows through the proxy to the requested endpoint.

![Proxy image example](https://res.cloudinary.com/rafaelgss/image/upload/v1657154318/blog/http-tunnel/image7_vmhdch.png)

Usually, a proxy provides much more than forwarding HTTP requests. If you care about your privacy and security diving into the internet, a proxy can suit you. It can also speed up your network requests if the latency between your ISP(Internet Service Provider) and the requested server is a problem.

![Proxy example hops latency](https://res.cloudinary.com/rafaelgss/image/upload/v1657154317/blog/http-tunnel/image1_nsh2pj.png)

The proxy can be used to intercept, inspect, modify and replay web traffic such as HTTP/1, HTTP/2, Web Sockets, or any other SSL/TLS-protected protocols and this is certainly one of my favorite usage of it and this is the one we'll focus in the post. If you haven’t tested it I strongly recommend it, you won’t regret it.

![Proxy example intercepting requests](https://res.cloudinary.com/rafaelgss/image/upload/v1657154318/blog/http-tunnel/image5_ia7hs0.png)

## HTTP Proxy client challenges

At the beginning of this article, a snippet was shared with a strong statement:

_<span style="text-decoration:underline;">Well… This likely will work. But, this is totally **unsafe** and in this blog post, I’ll show you why.</span>_

It’s time to explain it. There are two possible ways to use a proxy server:

1. The HTTP client makes a request with an absolute URL (_GET [https://example.com/](https://example.com/)) _to the proxy server, and expects the proxy connects to the upstream and perform the request.
2. The HTTP client sends an HTTP _CONNECT_ to create a tunnel to the _upstream_ and then makes a request within that tunnel.

The first one is basically what the snippet does, and when you are using an _HTTPS Proxy_ it would expose all the traffic to your proxy. In case you trust (with all of your heart) the proxy server, it is fine.

![Proxy HTTPS example](https://res.cloudinary.com/rafaelgss/image/upload/v1657154319/blog/http-tunnel/image4_cbbi4c.png)

Nevertheless, when the proxy server is available in a non-TLS connection, it means that **all of your data is exposed** in the network. It’s not uncommon to see local proxies using _HTTP_ without a _TLS_ connection.
Actually, a vast piece of developers that uses an _HTTP Proxy_ to debug/intercept requests rely on an HTTP Local Proxy.

![Proxy MiTM attack example](https://res.cloudinary.com/rafaelgss/image/upload/v1657154318/blog/http-tunnel/image2_q0xfdv.png)

As described by the above image, even though the requested endpoint uses a TLS connection, **the request is sent to the Proxy using HTTP**, which means that anybody in your **local network** can intercept and read packages. In case you are using Public Wi-Fi… I’d say you are at serious risk.

For scientific reasons, you can use [Wireshark](https://www.wireshark.org/) to sniff the local network while performing an HTTPS Request using the `ProxyAgent` from `undici@5.5.0`:

```js
# undici-mitm.mjs
import { ProxyAgent } from 'undici'
const proxyUrl = 'http://localhost:8000' // default address for HTTPToolkit
const dispatcher = new ProxyAgent({ uri: proxyUrl })

await fetch("https://example.com", {
  dispatcher,
  method: 'POST',
  body: JSON.stringify({
    user: 'rafaelgss',
    password: 'mysecurepassword'
  })
})
```

Run it with:

```sh
$ node undici-mitm.mjs
```

It will work like a charm, you'll be able to intercept and visualize the request in the `HTTPToolkit` if you want

![HTTPToolkit Example request](https://res.cloudinary.com/rafaelgss/image/upload/v1657372957/blog/http-tunnel/Selection_566_wt32yr.png)

All properly correct, right? **Wrong**!

Using the following _query_ on Wireshark will show that even requesting a TLS endpoint, you are leaking everything in your local network.

```
http.host contains example.com
```

![Wireshark leak example](https://res.cloudinary.com/rafaelgss/image/upload/v1657375228/blog/http-tunnel/Selection_567_lopkmz.png)

For this reason, _HTTP Tunneling_ is a great approach to use when building an HTTP Proxy Client.

## HTTP Proxy Tunneling

HTTP Tunneling is used to create a _tunnel_ between the origin and the destination through an intermediary (proxy). This mechanism asks the HTTP Proxy Server to forward the TCP connection to the destination using the _CONNECT_ HTTP Method.
Once the connection has been established, the proxy server pipe the TCP stream to the origin, which means, any data sent to the proxy using the established connection will be propagated to the destination.
This mechanism allows the client behind an HTTP Proxy (no-TLS) to perform requests using TLS.

![Proxy connection example](https://res.cloudinary.com/rafaelgss/image/upload/v1657154318/blog/http-tunnel/image3_lr8sdh.png)

![Proxy HTTP example tunnel](https://res.cloudinary.com/rafaelgss/image/upload/v1657154318/blog/http-tunnel/image6_qpio6b.png)

## Ensure to use a good HTTP Client library

Normally, a developer would not write his own HTTP Client, instead, he’ll search for a library of his choice. However, one has to ensure to a **safe** HTTP Client library. There are several ways to validate the approach used by the library:

1. Reading the docs whether is anything explicitly written.
2. Reading the source code.
3. Asking the maintainers and eventually raising a PR to improve the documentation.

As said previously, [undici](https://github.com/nodejs/undici) (the Node.js HTTP Client) upgraded their [`ProxyAgent`](https://github.com/nodejs/undici/blob/main/docs/api/ProxyAgent.md) to use _HTTP Tunneling_. If the library your choice is not using a safe approach, please, consider changing it.

## Acknowledgment

[Matteo Collina](https://github.com/mcollina), [Simone Busoli](https://github.com/simoneb), and [Paolo Insogna](https://github.com/shogunpanda) for reviewing it.
