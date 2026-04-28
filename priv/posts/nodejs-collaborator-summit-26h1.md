---
title: Node.js Collaborator Summit 26H1
date: 2026-04-27 22:40
tags: nodejs,article,en-US
---

# Node.js Collaborator Summit 26H1

For those who could not attend the latest Node.js Collaborator Summit, I put together a summary of the main technical and governance discussions. As we move into the 2026–2027 cycle, the project covered topics such as AI-assisted contributions, release scheduling, collaborator health, security, and observability.

Below is a breakdown of the sessions, following the summit schedule.

## 1. Next-10 & Collaborator Health Survey

The collaborator survey highlighted a growing tension between project growth and maintainer burnout.

* Our active collaborator count stands at 91, with notable growth in South America and Africa. Among users, `watch` mode is the most popular stable feature, while `require(ESM)` and TypeScript support lead experimental usage.
* A recurring concern was the volume of low-quality AI-generated PRs. Some collaborators reported that reviewing these contributions can take a significant portion of their time, along with challenges around peer interactions and dispute resolution.

Thanks to Jacob Smith and Marco Ippolito for hosting the session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=OcysOfNeQaY&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=1)

## 2. Transition to an Annual Release Schedule

Starting with Node.js 27, the project is planning to move from two major releases per year to a single annual major release.

* Major releases would occur every April, with version numbers aligned to the calendar year (e.g., Node 27 in 2027).
* The LTS phase would begin every October. This change aims to reduce the maintenance burden from four active release lines to at most three, improving the efficiency of security backports.
* There is still discussion around the naming of the April–October phase. Alternatives such as “Preview” or “RC” were considered, but there was no strong consensus to replace “Alpha”.

Source: [Youtube Recording](https://www.youtube.com/watch?v=Gl9c1VLGgpw&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=2)

## 3. New Streams API

An experimental `node:stream/iter` module is being explored to address performance limitations in current stream implementations.

* The design is based on language-level primitives such as async iterables and `Uint8Array`, avoiding more complex abstractions like event emitters or state machines.
* Early benchmarks show identity transforms running significantly faster than current web streams. In more realistic scenarios (e.g., file-to-compression), improvements of around 20–25% were observed.
* Backpressure is stricter by default: if a consumer is not reading, the writer throws an error instead of buffering indefinitely.

Thanks to James Snell for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=Gl9c1VLGgpw&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=3)

## 4. Rethinking Collaboratorship: The Code Owners Model

There is ongoing discussion about decoupling technical permissions from the broad “Collaborator” role to lower the barrier to entry and better reflect subsystem expertise.

* The scope of “Collaborator” would be narrowed to specific teams or subsystems.
* Subsystem ownership would become more explicit, with approvals required from domain experts.
* A new “Maintainer” role is proposed for project-wide authority.
* Manual PR landing would be restricted to the TSC and releasers, with most merges going through the commit queue.

Thanks to Jacob Smith for hosting the sessions.

Sources:
[Day 1](https://www.youtube.com/watch?v=1xQQ0iWRaaY&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=6)
[Day 2](https://www.youtube.com/watch?v=kWGD9Er1ueQ&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=10)

## 5. OpenTelemetry in Core

There is ongoing discussion on how to integrate OpenTelemetry (OTel) support without increasing the size or complexity of the core binary.

* Most maintainers prefer a minimal approach: exposing low-level hooks rather than bundling the full OTel SDK.
* Moving telemetry serialization to native code could reduce the overhead seen in current JavaScript-based tracing implementations.

Thanks to Chengzhong Wu for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=6)

## 6. Policy on AI Contributions

The project is converging on a position where human accountability remains essential.

* Fully machine-generated contributions without clear human ownership are generally discouraged.
* AI-assisted workflows are acceptable, especially for debugging and documentation, but contributions are evaluated based on trust in the author and code quality.
* Some contributors rely on AI for accessibility, so policies need to remain flexible.

Thanks to Jacob Smith for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=7)

## 7. Userland Migrations

Adoption is progressing steadily:

* Deprecations from Node 23.x are about 90% covered.
* Deprecations from Node 24.x are roughly 75% covered.

Once coverage is complete, migration bundles will be published, including an LTS bundle. The main bottleneck remains reviews that require subject-matter experts.

Thanks, Jacob Smith and Bruno Rodrigues, for hosting this session.

## 8. Stabilization of module customization hooks / vm.Module

As `module.register()` is being deprecated, the focus is shifting to `module.registerHooks()`.

* A userland ponyfill is being explored to ease migration.
* Automation tools may be introduced to assist ecosystem transitions.
* A redesigned `vm` module API is under discussion, aiming to address long-standing issues and align better with WebAssembly and ESM evolution.

Thanks to Joyee Cheung for hosting this session.

## 9. Libuv V2

Libuv v2 aims to modernize the codebase after more than a decade of v1.

* Windows handles would be used directly instead of file descriptors.
* `fs_event` polling is being removed in favor of native platform mechanisms.
* Error handling will become more consistent across platforms.
* There are implications for native add-ons that interact directly with libuv internals.

Thanks to Santiago Gimeno for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=8)

## 10. Native Virtual File System (VFS)

A large PR is under review to introduce a native VFS.

* Goals include enabling Single Executable Applications (SEA) without extracting files and improving test performance through virtualized file systems.
* The system supports overlay mode, allowing virtual files to shadow real ones.
* Concerns remain around debugging, particularly stack traces referencing virtual paths.

Thanks to Matteo Collina for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=10)

## 11. Security: Triage Automation and VEX

The security team is seeing a sharp increase in AI-generated vulnerability reports.

* Many reports are not directly exploitable, but still require manual triage.
* Work on VEX (Vulnerability Exploitability eXchange) files is nearing completion, helping tools distinguish between real and non-impacting vulnerabilities.
* There is discussion about moving Medium and Low severity reports to a public workflow, reserving private handling for High and Critical issues.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=11)

## 12. Observability & node:metrics

New observability primitives are being introduced via `node:metrics` and `node:tracing`.

* “Bounded Channels” help correlate start and end events more clearly.
* The system is designed as a low-level event stream that external tools (e.g., Prometheus, OpenTelemetry) can consume.

Thanks to Stephen Belanger for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=ZHycC57Iv8o&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=12)

## Extra: OpenJS Security Stewardship Program

The OpenJS Foundation is exploring a more sustainable funding model for security work.

* A proposed 50/50 split allocates funds between researcher bounties and maintainer work.
* Sponsors may gain early access to certain security reports.

Thanks to Robin Ginn for hosting this session.

Source: [Youtube Recording](https://www.youtube.com/watch?v=Vr2nrYENzSg&list=PLfMzBWSH11xZhA93H_9ulECtLVWtSm6zy&index=4)
