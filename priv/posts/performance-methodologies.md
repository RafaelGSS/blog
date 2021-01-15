---
title: Performance Methodologies
date: 2020-12-29 18:00
tags: performance,article,en-US
---

# Performance Methodologies

Poor performance costs the software industry millions of dollars annually in lost revenue, decreased productivity, increased development and hardware costs, and damaged customer
relations.

Most applications tend to focus on correctness over performance. The shift towards performance only occurs once it becomes a problem.
Once it becomes problem, one rarely has time to dedicate towards improving it. This article aims to show you that **there is no magic solution**.
A lot of work should be done in early phases of development. This article will consider the reader having the role of  Performance Engineer or having to "act" as one.

The reality is that some companies devotees of "agile" methodology, adopt the same order to every software development process: Idea -> MVP -> Feature -> "Refactor". One only needs some time in this methodology to understand that it's not quite like that.
The result is that, somewhere near the end of the project, performance issues appear.

> _Performance is a field where the more you know, the less you understand_.

Regardless of the source, when a performance issue appears it should be fixed immediately and there are few ways: fix the problem in the source (or at least understand it) or spending money on hardware resources. The second path in some time will lead to the same problem.

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

> `unknown-unknows` are common. It is your job as a performance engineer to transform the `unknown-unknowns` into `know-unknows`.

The Diagram above map `known-knowns` (Green box) and `known-unknows` (Red box)

## Observability Tools

As previously mentioned, achieving observability in our software/architecture is fundamental to perform performance improvements. In this section, I'll walk through a few tools that are great for this purpose.

### Tracing

Tracing collects per-event data for analysis. Normally, tracing tools are not enabled by default since it adds CPU overhead to capture and send/store the data.

Logging (including system logs) can be seen as low-frequency tracing that is enabled by default.

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

This section will describe three of the most used methodologies. Apply a methodology when performance issues start showing up; there is no rule about choosing the best approach.
Previous experience with your software architecture will likely be the best way to make a decision.

### USE

Utilization, Saturation and Errors (USE) is an methodology that **should be used early in performance investigation**. For every resource, check the utilization, saturation, and errors:

- **Resource**: server components (CPU, buses, ...)
- **Utilization**: for a set time interval, the percentage of time that the resource was busy servicing work. While busy, the resource may **still be able to accept more work**.
- **Saturation**: additional work to be done, likely waiting in a queue. Jobs that cannot be dealt with instantly.

![Workflow with USE Methodology](/images/performance-analysis/workflow-use.png)

Its important to consider that it can be counter-intuitive; a short burst of high utilization can introduce saturation and performance issues even though the overall utilization is low over a long interval. CPU utilization **can change dramatically from second to second** so a 5-minute average may disguise short periods of 100% utilization and therefore lead to saturation.

Note: The saturation could not be easier to identify.

The first step is to create a list of resources:

- **CPUs:** sockets, cores, hardware threads (virtual CPUs)
- **Main memory**: DRAM
- **Network interfaces**: Ethernet ports
- **Storage devices**: disks
- **Controllers**: storage, network
- **Interconnects**: CPU, memory, I/O

> Virtual resources are fundamentally different than dedicated hardware. Especially as your resources are both shared and intentionally throttled. Some - if not all - cloud providers make their money by overselling and betting on idle processes.

The USE method is most effective for resources that suffer performance degradation under high utilization or saturation, leading to bottlenecks. Fortunately, they are not common system bottlenecks, as they are typically designed to provide an excess of throughput. Unfortunately, if they are the problem, can be difficult to solve.

After you get the list of resources, try to create some metrics for it:

![List of resources to create metric](/images/performance-analysis/list-resources-use.png)

The process of elimination is good for us. Eliminate a possible resource bottleneck may help us to focus on another resource limiting our scope.

### Drill Down

The process iterates through deeper layers of the software stack – even to hardware if necessary – to find the root cause of the issue. I try to to apply this methodology in every part of the software stack. It's usually harder to do so  without having the bigger picture; but as you get more experienced you start recognizing recurring issues.

> Collecting and monitoring metrics is fundamental. Without it, we cannot fix the bugs the components cause.

Such deeper analysis may involve the creation of custom tools and inspection of source code (if available). Here is where most of the drilling takes place, peeling away layers of the software stack as necessary to find the root cause.

Imagine an application that after a month in an production environment has begun to perform poorly.

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
Second, build a hypothesis about what the cause of poor performance may be. _CPU Miss rate_? Write a test to prove your theory by for instance using `Valgrind`.
Collect results from your previous step and analyze how it behaves over time. It will give you a better idea of what components are connected and ultimately affected.

**Note:** Shaping a hypothesis requires a clear understanding of your software architecture. Versioning your architectural changes can play a key role in understanding sudden changes.

![Scientific Method Steps](/images/performance-analysis/scientific-method-steps.png)

## Real-World Examples

Usually, when a system boots the memory usage starts to grow as the operating system uses available memory to cache file system improving performance.
A system may report that it has only 10 MB of available memory when it actually has 10 GB of file system cache that can be reclaimed by applications immediately when needed.

A common source of confusion is the endless growth of heap. It's not a memory leak, the `free()` in most allocators doesn't return memory to the operating system; rather, it keeps it ready to serve future allocations.

> This means the process resident memory will only ever grow, which is normal.

Based on the last statement, let's think about the following _ticket_:

> _"The application suddenly starts to performing bad after an upgrade of memory (RAM) by 8gb to 128gb. This upgrade was done 6 hours ago."_

Main memory utilization can be calculated as used memory versus total memory. Memory used by the file system cache can be treated as unused, as it is available for reuse by applications.

The ticket already shows one of the great starting point, the memory.

> Minor page faults happen when the CPU is trying to access a virtual memory address which is not in its small, fast TLB cache and, as results, it has to lookup a larger (and slower) mapping table stored in know DRAM address.

// Perform Scientific Method

## Acknowledgement

Thanks to [@jbergstroem](https://github.com/jbergstroem)
