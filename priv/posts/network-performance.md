---
title: Network Performance in Real-world
date: 2021-08-29 22:40
tags: performance,article,en-US
---

## Network Performance in Real-world

Everybody knows or must know the famous statement: "Network is not reliable". In fact, it's true, however, it doesn't means that you shouldn't optimize it.

If you got here by yourself, likely you understand why performance matters in the business. Otherwise, I recommend you to read the first section of my previous blog post [Performance Methodologies](https://blog.rafaelgss.com.br/performance-methodologies).

In this post, I'm going to talk a little more about the impacts of performance in the business. Mainly about network performance, however, keep in touch that probably I will talk about other fields of optimization in further posts.

The network latency is the room that is up to several optimizations, but first what's latency and how this affects the customer experience?

> Latency is the time elapsed from a package by a client to a receiver.

Before any performance optimization, we should define clearly our goal and the boundaries. This step is valuable to understand the client's perception around the speed.

The average human reaction time is around 200 milliseconds following [Human Benchmark](https://humanbenchmark.com/) Project, that's a pretty interesting project, and following the *["Mental chronometry"](https://en.wikipedia.org/wiki/Mental_chronometry):*

![Representation of the stages of processing in a typical reaction time paradigm. (Mental chronometry)](https://res.cloudinary.com/rafaelgss/image/upload/v1631498465/blog/network-performance/mental-chronometry_gphfvj.png)

> *"Human response times on simple reaction time tasks are usually on the order of 200 ms. The processes that occur during this brief time enable the brain to perceive the surrounding environment, identify an object of interest, decide an action in response to the object, and issue a motor command to execute the movement. These processes span the domains of perception and movement, and involve perceptual decision making and motor planning. Many researchers consider the lower limit of a valid response time trial to be somewhere between 100 and 200 ms, which can be considered the bare minimum of time needed for physiological processes such as stimulus perception and for motor responses."*

![Human Reaction time graph by humanbenchmark.com](https://res.cloudinary.com/rafaelgss/image/upload/v1631498464/blog/network-performance/reaction-time_a7lody.png)

And it's also confirmed by the book HTTP Network Performance - Ilya Grigorik:

> *"Once the 300 milliseconds delay threshold is exceeded, the interaction is often reported as "sluggish" and at the 1000 milliseconds barrier, many users have already performed a mental context switch while waiting for the response. The conclusion is simple: to deliver the best experience and keep our users engaged in the task at hand, we need to be fast!"*

In business, it transposes usually to a better conversation rate:

- Mobify found that decreasing their homepage's load time by 100 milliseconds resulted in a 1.11% uptick in session-based conversion.
- Retailer AutoAnything experienced a 12-13% increase in sales after cutting page load time by 50%.
- Walmart discovered that improving page load time by one second increased conversions by 2%

![User perception in milliseconds](https://res.cloudinary.com/rafaelgss/image/upload/v1631498465/blog/network-performance/reaction-summary_jipmf1.png)

## Common issues

In the network, there are several cases that can affect the latency:

- The route that your ISP uses to reach the server
- The distance between the application server and the client
- The client local network (wi-fi)
- ... (Longlist)

// TODO: Add an image to above list

> Your 802.11g client and router may be capable of reaching X Mbps, but the moment
your neighbor, who is occupying the same WiFi channel, starts streaming an HD video
over WiFi, your bandwidth is cut in half, or worse. Your access point has no say in this arrangement, and that is a feature, not a bug! — WiFi 2.4ghz

## Client Bandwidth is not enough!

Most of people tends to believe that the reason of delay is often the client bandwidth, in fact, it helps for sure, but as you will see, it's not a determinant factor of improvement. 

![https://www.afasterweb.com/2015/05/17/the-latency-effect/](https://res.cloudinary.com/rafaelgss/image/upload/v1631498464/blog/network-performance/bandwidth-latency_m1ttev.png)

Once the client reaches 5Mbps approximately, they may not see too much improvement in page load time, on other hand, reducing latency will **always** improve the loading time.

This happens because the majority of latency is caused by Three-Way Handshake in HTTP/1.1.

In fact, the vast majority of traffic around the web is still HTTP/1.1, and it means that for every communication between client-server the workflow performs Three-Way Handshake and it introduces a full roundtrip of latency (RTT).

![Roundtrip](https://res.cloudinary.com/rafaelgss/image/upload/v1631498465/blog/network-performance/three-way_dkthsx.png)

A common way to measure the RTT is: 

```bash
$ ping -c 10 SERVER
...
rtt min/avg/max/mdev = 195.933/197.576/198.423/0.912 ms
```

Cloudflare or another proxy will hide the real RTT, the result performed by `ping` is only to Cloudflare servers, in those cases, I recommend you to ping directly the webserver IP if available.

## Improve

Well, at this point I'll assume that the reader understands what is the impact of performance in applications and has set up their boundaries and goals.

Obviously, the application monitor is up to the reader to define, it is out of context for this article, so make sure that before any optimization you have the proper tools to measure it. 

> Remember: The best TCP communication optimization is avoid to send unnecessary packages.

- Domain sharing for fetch resources by browser (limited to 6 connections by domain)
- Request pipelining
- Webpage Test recommendation

### Improving HTTP/1.1 communication

Besides the TCP Normal workflow, the are are few adjustments up to do in order to optimize the HTTP/1.1 communication.

- Use Connection Keep-Alive. By default in HTTP/1.1 the connection keep-alive is enabled by default, but if you are using HTTP/1.0 or prior (really!) make sure to enable the keep-alive. The keep-alive was back-ported to HTTP/1.0 and enabled by the header `Connection: Keep-Alive`. TCP Connection reuse is critical to improving performance.
- Send fewer bits (Sorry JSON API Spec lovers)
- Increase TCP CWND (Initial Congestion Window) — WHY?
- Use CDN's to locate the bits closer to the client.
- Upgrade the server kernel to the latest version.
- Compress transferred data properly.

## HTTP/2

// TODO: Differences between HTTP 1 AND 2

## References

// TODO

// TODO: Usecase from [HTTP Network Stuffs](https://www.notion.so/HTTP-Network-Stuffs-de6cb819fd0044729ae6ce0a52f858e3)
