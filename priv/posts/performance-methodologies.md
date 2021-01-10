---
title: Performance Methodologies
date: 2020-12-29 18:00
tags: performance,article,en-US
---

# Performance Methodologies

I've spent a good time studying _performance_ methodologies. Like everything in CS (Computer Science);

> _Performance is a field where the more you know, the more you don't know_.

Most applications tend to focus on correctness over performance. The shift towards performance only occurs once it becomes a problem.
Once it becomes problem, one rarely has time to dedicate towards improving it. This article aims to show you that **there is no magic solution**.
A lot of work should be done in early phases of development. This article will consider the reader having the role of  Performance Engineer or having to "act" as one.

Prior starting performance analysis, you **must**  understand your application architecture. Any analysis requires clear boundaries and a full understanding of dependencies and third-party services.

A diagram of your software architecture is a great starting point.

> The foundation of your software should be resilient to achieve better results.

## Monitoring

Today, a big part of the market is adopting distributed systems. As we've come to learn, such systems adds a lot of complexity to your architecture in exchange for scalability and availability (resilience).

It also adds more components to your list of dependencies. Therefore, you should monitor these dependencies to have better visibility when things deviate from a happy path.

Each part of the architecture (or software) needs individual monitoring that helps us go back in time and answer some of these questions:
When started the software performing worse?
During what timing window are we seeing most access/traffic?
How our devices are working on a specific date? Like I/O latency, DNS resolution
These questions will help to choose the right performance methodology to apply.

## Known-Unknowns

![Known Unknowns](/images/performance-analysis/diagram-known-unknowns.png)

> _This section is a reference to the book [System Performance](https://www.goodreads.com/book/show/18058001-systems-performance) by the author Brendan Gregg._

In performance analysis we can split information into three types:
Know-Knows: These are things you know, for instance, you know that you should be checking CPU utilization **and** you know that the value is 10% on average.
Know-Unknows: There are things that you know that you do not know. You know that an increase in API response time can be related to a third-party component, but you don't have metrics showing it.
Unknown-Unknowns: These are things you are unaware of not knowing. Confusing? For instance: you may not know that DNS resolution can become heavy I/O latency, so you are not checking them (because you didn't know).

While creating architecture diagrams,  _unknowns-unknowns_  obviously aren't mappable since you don't know about them.

> Usually there is a lot of unknown-unknows and at least, is your job as a researcher in this field transform the `unknown-unknowns` into `know-unknows`.

The Diagram above map `known-knowns` (Green box) and `known-unknows` (Red box)

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

### USE

Utilization, Saturation and Errors (USE) is an methodology that **should be used early in performance investigation**. For every resource, check the utilization, saturation, and errors:

- **Resource**: all physical server functional components (CPU, busses, ...)
- **Utilization**: for a set time interval, the percentage of time that the resource was busy servicing work. While busy, the resource may **still be able to accept more work**.
- **Saturation**: Extra work, often waiting on a queue. Are jobs that service cannot deal at moment.

![Workflow with USE Methodology](/images/performance-analysis/workflow-use.png)

However, this could be counter-intuitive, a short burst of high utilization can cause saturation and performance issues, even though the overall utilization is low over a long interval. CPU utilization, for example, **can vary dramatically from second to second, so a 5-minute average may disguise short periods of 100% utilization and therefore saturation**.

Note: The saturation could not be easier to identify.

The first step is to create a list of resources:

- **CPUs:** sockets, cores, hardware threads (virtual CPUs)
- **Main memory**: DRAM
- **Network interfaces**: Ethernet ports
- **Storage devices**: disks
- **Controllers**: storage, network
- **Interconnects**: CPU, memory, I/O

The USE method is most effective for resources that suffer performance degradation under high utilization or saturation, leading to bottlenecks. Fortunately, they are not common system bottlenecks, as they are typically designed to provide an excess of throughput. Unfortunately, if they are the problem, can be difficult to solve.

After you get the list of resources, try to create some metrics for it:

![List of resources to create metric](/images/performance-analysis/list-resources-use.png)

The process of elimination is good for us. Eliminate a possible resource bottleneck may help us to focus on another resource limiting our scope.

### Drill Down

The process can involve digging down through deeper layers of the software stack, to hardware if necessary, to find the root cause of the issue. Particularly, I try to apply this methodology whenever that I can; It's hard to apply it without a big picture of your software, but when you get more experience on it, should be easier.

> Analysis (Monitoring) is the base of all! Without it, we can't fix any bug.

Such deeper analysis may involve the creation of custom tools and inspection of source code (if available). Here is where most of the drilling takes place, peeling away layers of the software stack as necessary to find the root cause.

For instance, let's imagine an application that after a month in production environment has begun to perform poorly.

**Five Whys**

1. A database has performing poorly for some queries. Why?
2. It's delayed by disk I/O due to memory paging. Why?
3. Database memory usage has grown too large. Why?
4. The allocator is consuming more memory than expected. Why?
5. The allocator has a memory fragmentation issue.

This is a good real sample extracted from [System Performance](https://www.goodreads.com/book/show/18058001-systems-performance) book. There is not limit to go deep into _Why?_, but, one has to when the software is performing well.

![Five why - Drill Down](/images/performance-analysis/5-whys.png)


### Scientific Method

The _scientific method_ studies the _unknown_ by making hypotheses and testing them. The `unknown` here can mean the `unknown-unknown` as discussed in [`Know-Unknows`](#know-unknowns) section.

Every _scientific method_ consists:

1. Formulation of a question?
2. Hypothesis
3. Prediction
4. Testing
5. Analysis

> For more information about how _scientific methods_, see [here](https://en.wikipedia.org/wiki/Scientific_method)

First, define a question based on performance problem; for instance: _Why does my application have degraded throughput?_.
After, you hypothesize what the cause of poor performance may be, _CPU Miss rate_. Then you construct a test to prove your theory, on this case I would recommend `Valgrind`.
The results collected by _Testing_ step is analyzed and then you have a better idea of what's happening.

**Note:** Create a hypothesis is not lucky, you should have a clear understanding of your software architecture. A versioning of architectural changes is as important as.

![Scientific Method Steps](/images/performance-analysis/scientific-method-steps.png)
