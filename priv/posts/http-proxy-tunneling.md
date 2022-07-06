---
title: HTTP Proxy Tunneling
date: 2020-07-10 15:40
tags: network,en-US
---

## HTTP Proxy Tunneling

### How much do you trust your HTTP Proxy Client?

Most developers have at least heard about HTTP Proxy and some of them use it on a daily basis. HTTP Local Proxy such as:

* [MiTM Proxy](https://mitmproxy.org/)
* [HTTP Toolkit Proxy](https://httptoolkit.tech/)

They are excellent ways to intercept and debug HTTP requests made from your local environment. I strongly suggest checking them out.

Nevertheless, most don’t know **precisely** how HTTP proxies work under the hood. If you attend an interview and the interviewer _for some weird reason_ asks you to implement a simple **proxy client (forward proxy)**, would you be able to do it?

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


### Firstly, what is an HTTP Proxy, and why would someone use it?

A Proxy is a gateway (intermediary) between the client (you) and the requested server. If you are using an HTTP Proxy, all the HTTP Traffic flows through the proxy to the requested endpoint.

![alt_text](images/image1.png "image_tooltip")

Usually, a proxy provides much more than forwarding HTTP requests. If you care about your privacy and security diving into the internet, a proxy can suit you. It can also speed up your network requests if the latency between your ISP and the requested server is a problem (yeah, gamers, I'm talking to you).

![alt_text](images/image2.png "image_tooltip")

The proxy can be used to intercept, inspect, modify and replay web traffic such as HTTP/1, HTTP/2, WebSockets, or any other SSL/TLS-protected protocols and this is certainly one of my favorite usage of it. If you haven’t tested it I strongly recommend it, you won’t regret it.

![alt_text](images/image3.png "image_tooltip")

### HTTP Proxy client challenges

At the beginning of this article, a snippet was shared with a strong statement:

_<span style="text-decoration:underline;">Well… This likely will work. But, this is totally **unsafe** and in this blog post, I’ll show you why.</span>_

It’s time to explain it. There are two possible ways to use a proxy server:


1. The HTTP client makes a request with an absolute URL (_GET [https://example.com/](https://example.com/)) _to the proxy server, and expects that proxy to connect upstream and perform the request.
2. The HTTP client sends a _CONNECT_ to create a tunnel to the upstream and then makes a request within that tunnel.

The first one is basically what the snippet does, and when you are using an HTTPS Proxy it would expose all the traffic to your proxy. In case you trust (with all of your heart) the proxy server, it is fine.


![alt_text](images/image4.png "image_tooltip")


Nevertheless, when the proxy server is available in a non-tls connection, it means that **all of your data is exposed** in the network. It’s not uncommon to see local proxies using HTTP without a TLS connection.

Actually, a vast piece of developers that uses Proxy to debug/intercept requests rely on an HTTP Local Proxy


![alt_text](images/image5.png "image_tooltip")


As described by the above image, even though the requested endpoint uses TLS, the request is sent to the Proxy using HTTP, which means that anybody in your **local network** can intercept and read packages. In case you are using Public Wi-Fi… I’d say you are at serious risk. 

For this reason, HTTP Tunneling is a great approach to use when building a Proxy Client.


### HTTP Proxy Tunneling

HTTP Tunneling is used to create a _tunnel_ between the origin and the destination through an intermediary (proxy). This mechanism asks the HTTP Proxy Server to forward the TCP connection to the destination using the _CONNECT_ HTTP Method.

Once the connection has been established, the proxy server pipe the TCP stream to the origin, which means, any data sent to the proxy using the established will be propagated to the destination.

This mechanism allows the client behind an HTTP Proxy (no-tls) to perform requests using TLS.


![alt_text](images/image6.png "image_tooltip")

### 
![alt_text](images/image7.png "image_tooltip")

### Ensure to use a good HTTP Client library

Normally, a developer would not write his own HTTP Client, instead, he’ll search for a library of his choice. However, one has to ensure to use of a **safe** HTTP Client library. There are several ways to validate the approach used by the library:


1. Reading the docs whether is anything explicitly written
2. Reading the source code
3. Asking the maintainers and eventually raising a PR to improve the documentation

Recently, [undici](https://github.com/nodejs/undici) (the Node.js HTTP Client) upgraded their [ProxyAgent](https://github.com/nodejs/undici/blob/main/docs/api/ProxyAgent.md) to use HTTP Tunneling. If the library your choice is not using a safe approach, please, consider changing it.

