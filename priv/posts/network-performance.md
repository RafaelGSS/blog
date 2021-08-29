---
title: Network Performance in Real world
date: 2021-08-29 22:40
tags: performance,article,en-US
---

## Network Performance in Real world

// TODO: why performance matters (add reference to Performance Methodologies)

**Performance matters!** 

> We are not accustomed to measuring our everyday encounters in milliseconds, but studies have shown that most of us will reliably report a perceptible "lag" once a delay of over 100-200 milliseconds is introduced into the system
Once the 300 milliseconds delay threshold is exceeded, the interaction is often reported as "sluggish" and at the 1000 milliseconds barrier, many users have already performed a mental context switch while waiting for the response. The conclusion is simple: to deliver the best experience and keep our users engaged in the task at hand, we need to be fast!

| Delay | User perception |
| - | - |
| 0 ~ 100 ms | Instant |
| 100 ~ 300 ms | Small perceptible delay |
| 300 ~ 1000 ms | Machine is working |
| 1,000+ ms | Likely mental context switch |
| 10,000+ ms | Task is abandoned |

Network latency is the room that is up to several optimizations.

// TODO: What's latency?

// TODO: How to monitor latency?
// Clients to Server
// Server to Server

// TODO: Bandwidth doesn't matters? Latency x Bandwidth

// TODO: Usecase from [HTTP Network Stuffs](https://www.notion.so/HTTP-Network-Stuffs-de6cb819fd0044729ae6ce0a52f858e3) 

> Your 802.11g client and router may be capable of reaching 54 Mbps, but the moment
your neighbor, who is occupying the same WiFi channel, starts streaming an HD video
over WiFi, your bandwidth is cut in half, or worse. Your access point has no say in this arrangement, and that is a feature, not a bug!
