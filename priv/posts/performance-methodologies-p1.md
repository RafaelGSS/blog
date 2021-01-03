---
title: Performance Methodologies
date: 2020-12-29 18:00
tags: performance,article,en-US
---

# Performance Methodologies

I've spent a good time studying _Performance_ methodologies and is fair to say that like everything on CS (Computer Science):

> _Performance is a field where the more you know, the more you don't know_.

Most applications tend to focus on correctness instead of performance, it's common to care about performance when it becomes a problem.
Usually, when it happens you don't have so much time to work on it and this article will show you that: **there is no magic solution**.
A lot of work should be done before, this article will consider the reader as a Performance Engineer or someone that must perform work as one.

Before any performance analysis, you **must** understand the application architecture. It should be performed with clear paths of dependencies and third-party services.

Have a clear diagram of software architecture is a great start to move forward.

> The foundation of your software should be resilient to achieve better results.

// DIAGRAM Image

## Monitoring

Today, a big part of the market is going to follow distributed systems, as we know, that adds a lot of complexity to your architecture in exchange for scalability (resilience).

Also, it adds more components as dependency or dependents. Therefore, you should monitor these components to have better visibility when the world is burning.

We need to monitor every part of Software and Architecture, which will help when we go back to historical metrics to answer some of these questions:
When the software performance is decreasing?
When is the peak of the software access?
How our devices are working on a specific date? Like I/O latency, DNS resolution
These questions will help to choose the right performance methodology to apply.

## Known-Unknowns

> _This section is a reference to [System Performance](https://www.goodreads.com/book/show/18058001-systems-performance) book by Brendan Gregg._

In performance analysis we can split information into three types:
Know-Knows: These are things you know, for instance, you know that you should be checking CPU utilization **and** you know that the value is 10% on average.
Know-Unknows: There are things that you know that you do not know. You know that an increase in API response time can be related to a third-party component, but you don't have metrics showing it.
Unknown-Unknowns: These are things you do not know you do not know.  Confused? Let me elaborate, you may not know that DNS resolution can become heavy I/O latency, so you are not checking them (because you don't know).
// Explain more about (unknown-unknows can't have visibility because as we know, we don't know these topics)
// Is normal to have unknown-unknowns (at least, is your job as a researcher in this field)


// Reference Brendan Greg book

## Observability Tools

### Tracing

### Profiling

// Reference to Node CPU Profiler

## Methodologies

// USE
// Drill-down
// Scientific Method

## CPU Cache

### Go further in details

// Place here the reference to CPU Usage peak. (aggregate by 5min and 1min)
