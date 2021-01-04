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

On architecture diagram creation is obvious to say that _unknowns-unknowns_  is not mappable, after all, you don't know.

> Usually there is a lot of unknown-unknows and at least, is your job as a researcher in this field transform the `unknown-unknowns` into `know-unknows`.

## Observability Tools

As previously mentioned, has observability in our software/architecture is fundamental to perform performance improvements. In this section, I'll briefly show you great tools to use in applications.

### Tracing

Tracing collects per-event data for analysis. Normally, Tracing tools are not enabled by default, since it adds CPU overhead to capture the data.

Logging (include system log) can be categorized as low-frequency tracing that is enabled by default.

Some common tools:

**system-wide**:
- `tcpdump`: network packet tracing
- `perf`: Linux Performance Events (tracing static and dynamic probes)

**per-process**:
- `strace`: system call tracing
- `USDT` (Userland Statically Defined Tracing)
- `DTrace`: observability framework that includes a programming language and a tool.

TracePoints is a great way to observe your software in the production environment. You can use USDT (dynamic probes) or static tracepoints.
For further information check the _useful links_ section.

### Profiling

Profiling characterizes the target by collecting a set of samples of snapshots. CPU usage is a common example where samples are taken of the stack trace to characterize the code paths that are consuming CPU cycles.

**Note**: For further information about Profiling CPU, I've made a blog post doing CPU Profiling in a Node.js application. [Check here](https://blog.rafaelgss.com.br/node-cpu-profiler).

Tools:

- `perf`: Linux Performance Events (profiling)
- `cachegrind`: a Valgrind sub tool, can profile hardware cache usage and be visualized using `kcachegrind`

> `/proc` is a file system interface for kernel statistics, it contains directories where each directory is named after the **PID** of the process. These directories contain a number of files containing information and statistics about each process mapped from kernel data structures.

![Julia Evans - Comic /proc](https://pbs.twimg.com/media/DZ3HpVXXkAEgxpc?format=jpg&name=large) - [reference](https://twitter.com/b0rk/status/981159808832286720/photo/1)

## Methodologies

This section will describe three of most used methodologies. Apply a methodology due performance issues is needed, and there is no rule to choose the best approach,
I would say that past experiences and knowledge in the software definitely will help with that.

// USE
// Drill-down
// Scientific Method

## CPU Cache

### Go further in details

// Place here the reference to CPU Usage peak. (aggregate by 5min and 1min)
