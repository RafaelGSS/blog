---
title: Node.js 2023 Year in An Article
date: 2024-02-21 16:00
tags: nodejs,article,en-US
---

# Node.js 2023 Year in An Article

Two months into 2024, I've decided to summarize the achievements in the Node.js space from 2023. As always, this list is curated by me, so I may overlook some pull requests due to the vast amount of work completed by Node.js collaborators and areas where I need more context, such as WASI.

Node.js is rapidly evolving, and it can be challenging for regular users to stay updated with the latest changes. Even as someone who works on the project, it's possible to overlook certain commits. Therefore, this article aims to spotlight major changes and discussions occurring within the Node.js landscape in 2023.

For reference, `2641` commits were made to `nodejs/node#main` in 2023. Although this information might seem more trivial than crucial, I find it interesting to compare historical data. For instance, this is the commit count on `main` for the past 10 years.

```console
Between Jan 1 2023 ~ Jan 1 2024 = 2641
Between Jan 1 2022 ~ Jan 1 2023 = 2629
Between Jan 1 2021 ~ Jan 1 2022 = 2683
Between Jan 1 2020 ~ Jan 1 2021 = 3390
Between Jan 1 2019 ~ Jan 1 2020 = 3953
Between Jan 1 2018 ~ Jan 1 2019 = 4720
Between Jan 1 2017 ~ Jan 1 2018 = 4609
Between Jan 1 2016 ~ Jan 1 2017 = 3081
Between Jan 1 2015 ~ Jan 1 2016 = 2261
Between Jan 1 2014 ~ Jan 1 2015 = 1052
```

> 💡 I use a tiny project I created called [`nodejs-stats`](https://github.com/RafaelGSS/nodejs-stats/) to retrieve such information


It’s quite impressive to see that a mature project such as Node.js keeps evolving significantly over the years. Unfortunately, I don't have historical data, but I strongly suspect Node.js welcomed a significant number of first-time contributors this year. This is possibly due to initiatives like Grace Hopper's Day and various workshops. For instance, the 'Your First Node.js Contribution' workshop was conducted by my team at NodeConfEU 2023. I'm confident other members also consistently assist new contributors to the project — If you are looking forward to giving your first contribution to the Node.js project, feel free to contact me. I’m doing [live streams](https://www.twitch.tv/rafaelgss) assisting people through the Node.js codebase.

## Node.js Release

In 2023, **102** releases from different release lines were made (including security releases) 

```console
$ git log --all --grep=', Version' --pretty=format:"%cs,%aN,%s" --since='Jan 1 2023' --before='Jan 1 2024' | wc -l
102
```

The year started with 4 active release lines:

1. Node.js 14
2. Node.js 16
3. Node.js 18
4. Node.js 19

Node.js 14, 16 and Node.js 19 are now End-of-Life(EOL) and Node.js 18 is under Maintenance Mode, meaning there are no more regular releases to this version.

The year finalized with the following active release lines:

1. Node.js 18 (Maintenance)
2. Node.js 20 (LTS)
3. Node.js 21 (Current)

Hence, if you aren’t using any of these versions, please, upgrade.

During the Node.js Collaborator Summit in Dublin (NodeConfEU), we analyzed the download stats of Node.js binaries and it illustrates our opinion that users don’t update their binaries as fast as they must.

![Node.js Download Stats][]

As the graph shows, even an EOL version still receives a significant number of downloads and this is dangerous to Node.js users as they will use a vulnerable version at some point. Hence, one theory that comes to our mind is that our release schedule is too fast. [A new proposal](https://github.com/nodejs/Release/issues/953) is under discussion and still needs to be evaluated by the releasers team, but it suggests reducing the major release to one per year instead of two per year.

When examining the graph above, particularly focusing on the y-axis, one might infer that Node.js downloads reached a peak of approximately 60 million on March 23. However, this interpretation is misleading as it does not account for NodeSource distribution statistics, which primarily consist of production binaries and do not include downloads from inactive release lines, such as Node.js 8, 10, 12, and so on. To gain a deeper understanding of Node.js distribution mechanisms, I encourage you to explore the intricacies outlined in the "[Node By Numbers 2021~2022](https://nodesource.com/blog/node-by-numbers-2021-2022)" article, as delving into this topic exceeds the scope of this article.

### Active work on the Canary-In-The-Gold-Mine (CITGM)

[`@nodejs/releasers`](https://github.com/orgs/nodejs/teams/releasers) play one of the most crucial roles in the Node.js space. They ensure the reliability of the versions you receive on your machine. To achieve this goal, we utilize a comprehensive suite of tests across all supported architectures, and we run specific tests depending on the changes, such as V8. Additionally, for each release, we execute CITGM (Canary-In-The-Gold-Mine), which essentially fetches all modules listed in `lookup.json` and runs their test suite with the new binary prospect. If any issues arise, we investigate them, and sometimes, we reach out to the module author for guidance.

CITGM, however, requires a powerful set of machines to run all tests properly. Unfortunately, we are a bit limited in that regard, leading to some concurrency errors between tests. This is because certain tests need to run in parallel; otherwise, CITGM would take years to finish. Another challenge is ensuring that the modules listed inside `lookup.json` are up-to-date. Occasionally, a module becomes archived or may never support newer versions of Node.js, or they may simply be unreliable (which is quite common).

Therefore, it’s not uncommon to see initiatives like:

- [Declaring bankruptcy of CITGM modules](https://github.com/nodejs/citgm/pull/959)
- [Drop skipped modules](https://github.com/nodejs/citgm/pull/1036)

Otherwise, we might find ourselves dealing with an unreliable CITGM, thus leaving us blind to potential breaking changes.

### The new direction of the Node.js project

> To clarify, I want to emphasize that I am not speaking on behalf of the project; this article represents solely my perspective.
> 

Having been a member of the project for quite some time, and [since 2022](https://github.com/nodejs/node/pull/45691), a member of the Technical Steering Committee (TSC), I've observed that the project is now more susceptible to major changes than ever before. As a result — not so related — new dependencies are being integrated into the core, and new built-in modules are being developed. This broadens the scope of Node.js as a platform. However, in my view, this new approach may lead to concerns regarding maintenance and potential attack vectors. On the flip side, it also empowers developers and diminishes the risk of using malicious libraries, despite the performance implications of executing operations on the native side. For your reference, I've been closely monitoring the binary size of Node.js across various versions, and it's evident that the addition of new dependencies and features directly impacts the binary size.

![Binary size per version][]

Unless you're operating within an exceptionally constrained environment, 100MiB shouldn't raise significant concerns.

## New Dependencies

Node.js vendor dependencies into its binary:

```bash
{
  node: '21.6.0',
  acorn: '8.11.3',
  ada: '2.7.4',
  ares: '1.20.1',
  base64: '0.5.1',
  brotli: '1.1.0',
  cjs_module_lexer: '1.2.2',
  cldr: '44.0',
  icu: '74.1',
  llhttp: '9.1.3',
  modules: '120',
  napi: '9',
  nghttp2: '1.58.0',
  nghttp3: '0.7.0',
  ngtcp2: '0.8.1',
  openssl: '3.0.12+quic',
  simdjson: '3.6.3',
  simdutf: '4.0.8',
  tz: '2023c',
  undici: '5.28.2',
  unicode: '15.1',
  uv: '1.47.0',
  uvwasi: '0.0.19',
  v8: '11.8.172.17-node.19',
  zlib: '1.3.0.1-motley-40e35a7'
}
```

In 2023, 3 new dependencies were released to Node.js:

1. [Ada](https://github.com/ada-url/ada) - A WHATWG-compliant and fast URL parser written in modern C++”
2. [simdutf](https://github.com/simdutf/simdutf) - Unicode routines (UTF8, UTF16, UTF32) parser
3. [simdjson](https://github.com/simdjson/simdjson) - A library that uses commonly available SIMD instructions and micro parallel algorithms to parse JSON efficiently

All these libraries are focused on performance, enabling Node.js to reach new peaks of improvements as you can see in the [“State of Node.js Performance 2023”](https://blog.rafaelgss.dev/state-of-nodejs-performance-2023).

### The cost of OpenSSL 3.0.x over QUIC

Since version 16, Node.js uses a fork of `openssl` from [`quictls`](https://github.com/quictls/openssl) team. This was required as an initial step to bring QUIC protocol to Node.js. However, OpenSSL version 3.0.x is significantly slower than OpenSSL 3.2.x. There are two points where moving to OpenSSL 3.2.x will be difficult from a Node.js perspective:

1. It doesn’t fully support QUIC — Although Node.js doesn’t ship QUIC support (yet).
2. OpenSSL 3.2.x isn’t a Long-Term-Support (LTS) line — Having a release line that might contain a vulnerability after its End-of-Life is a no-go for LTS lines in Node.js.

If want some context, check [#51152](https://github.com/nodejs/node/issues/51152). In terms of performance, you can use my repository [`nodejs-bench-operations`](https://github.com/RafaelGSS/nodejs-bench-operations) as a reference for `crypto` operations:

| Node.js 16.20.2 - OpenSSL 1.x | ops/sec | samples |
| --- | --- | --- |
| crypto.createVerify('RSA-SHA256') | 30,337 | 98 |
| crypto.verify('RSA-SHA256') | 29,001 | 94 |

| Node.js 18.18.2 - OpenSSL 3.x | ops/sec | samples |
| --- | --- | --- |
| crypto.createVerify('RSA-SHA256') | 3,599 | 86 |
| crypto.verify('RSA-SHA256') | 3,638 | 87 |

## Constantly Performance Evolution

As mentioned in the ["State of Node.js Performance 2023"](https://blog.rafaelgss.dev/state-of-nodejs-performance-2023), Node.js continues to evolve steadily in terms of performance. This section will not delve into specific numerical data (which will be provided in detail in the State of Node.js Performance 2024), but rather highlight initiatives and PRs that have demonstrated clear advancements in the performance realm.

One notable improvement is the upgrade of `libuv` to version `1.45.0`. In this release, `IO_URING` was enabled on Linux, resulting in an 8x throughput increase for file system operations such as `read`, `write`, `fsync`, `fdatasync`, `stat`, `fstat`, and `lstat`. More details can be found in the corresponding pull request: [libuv/libuv#3952](https://github.com/libuv/libuv/pull/3952).

Additionally, in 2023, we introduced Ada as a new URL parser for Node.js, which is now available in all active release lines (18, 20, and 21). Further information can be found in the pull request: [nodejs/node#46410](https://github.com/nodejs/node/pull/46410).

Two important regressions were identified over 2023:

1. AsyncHooks
2. WebStreams

These features are crucial for certain use cases in Node.js. For example, if you utilize `fetch()`, you might rely on WebStreams, or if you employ any Application Performance Monitoring (APM) tool, you should be leveraging AsyncHooks via `AsyncLocalStorage`.

An initiative that started in January, documented in issue [#46265](https://github.com/nodejs/node/issues/46265), proposes an alternative implementation of `AsyncLocalStorage` without relying on AsyncHooks, which was identified as a bottleneck at the time. Some related work has been carried out in pull requests [#46387](https://github.com/nodejs/node/pull/46387) and [#48528](https://github.com/nodejs/node/pull/48528).

WebStreams were identified as a bottleneck in the `fetch` function in 2022, as highlighted in [this issue comment](https://github.com/nodejs/undici/issues/1203#issuecomment-1100969210). Since then, we've been consistently enhancing its usage in `undici` through several PRs, such as:

- [nodejs/node#46086](https://github.com/nodejs/node/pull/46086)
- [nodejs/node#47956](https://github.com/nodejs/node/pull/47956)

For those interested in monitoring the performance of Node.js, I highly recommend keeping an eye on the [nodejs/performance](https://github.com/nodejs/performance) repository and attending their meetings. Be sure to follow the `performance` label to stay updated on PRs like [nodejs/node#49745](https://github.com/nodejs/node/pull/49745) and [nodejs/node#49834](https://github.com/nodejs/node/pull/49834), which aim to enhance the performance of regular Node.js streams.

### A native benchmark module to Node.js

In 2023, Node.js *almost* got a built-in benchmark module. [I wrote a pull request with a colleague](https://github.com/nodejs/node/pull/50768) (Vinicius Lourenco) that adds an experimental benchmark module to Node.js: `require('node:benchmark')`

While this pull request got significant traction, we didn’t pursue the work for some reasons:

- Benchmarks are hard, and micro-benchmarks are even harder. They are hard to evaluate, and hard to prove their accuracy since there are different strategies to measure them — See my [Preparing and Evaluating Benchmarks article](https://blog.rafaelgss.dev/preparing-and-evaluating-benchmarks) for more context — At the time I had limited bandwidth to work on different areas of Node.js and I couldn’t extend the research on this topic.
- Some Node.js collaborators shared some concerns and as I said previously, at the time, I didn’t have much bandwidth to elaborate and jump into a deep conversation.

However, it doesn’t mean we gave up! We’ve published the module as `bench-node` on npmjs — I know, we didn’t find a better name yet.  Check it out and give a star ⭐ https://github.com/RafaelGSS/bench-node/.

## Enhancing Node.js Security

Security is the area I have spent most of my time in 2023. I had a contract with OpenSSF to work full-time on the development and improvement of the security of Node.js. In this section, I will show briefly all the topics we’ve discussed, features implemented, workflows and so on. It's really important to say a big thank you to everyone on the Node.js Security Team for helping out with past and current projects. And a shutout to the Node.js Triage team for helping me go through all the HackerOne reports. A special thank you goes to [Tobias Nießen](https://github.com/tniessen) for working so hard to find and fix problems in the core of Node.js.

### The Node.js Permission Model

Let’s start with probably the major security achievement of 2023 in my — completely biased — opinion. [The Node.js Permission Model](https://nodejs.org/api/permissions.html#permission-model). This initiative started a long time ago with Anna Henningsen and James Snell, but it wasn’t ready yet and [I’ve re-implemented it in 2022/2023](https://github.com/nodejs/node/pull/44004). If want to understand the intrinsic behind this feature, I gave a talk at NodeConf EU about it: [The Journey of the Node.js Permission Model](https://www.youtube.com/watch?v=9ntgUiQocTU).

Technically, this *experimental* feature allows you to restrict access to environment resources such as:

- File system (more specifically, `fs` module) - read/write
- Inspector protocol
- Worker threads
- Child process and
- Native add-ons

The usage is quite simple, start the Node.js process with `--experimental-permission` and pass the `--allow-*` flags. For example, I want to give *read-only* access to the entry point of my application

```console
$ node --experimental-permission --allow-fs-read=./index.js index.js
```

Hence, if you attempt to read/write from other paths it should throw an error:

```js
// index.js
const fs = require('fs')
const data = fs.readFileSync('/etc/passwd')
console.log(data.toString())
```

```console
node:fs:581
  return binding.open(
                 ^

Error: Access to this API has been restricted
    at Object.openSync (node:fs:581:18)
    at Object.readFileSync (node:fs:460:35)
    at Object.<anonymous> (/home/rafaelgss/index.js:3:17)
    at Module._compile (node:internal/modules/cjs/loader:1378:14)
    at Module._extensions..js (node:internal/modules/cjs/loader:1437:10)
    at Module.load (node:internal/modules/cjs/loader:1212:32)
    at Module._load (node:internal/modules/cjs/loader:1028:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:142:12)
    at node:internal/main/run_main_module:28:49 {
  code: 'ERR_ACCESS_DENIED',
  permission: 'FileSystemRead',
  resource: '/etc/passwd'
}

Node.js v21.6.1
```

Furthermore can be found in the [official documentation](https://nodejs.org/api/permissions.html#process-based-permissions).

### Handling more Security Releases

 In 2023, we’ve released more security releases, mostly due to the fact we are more proactive in terms of third-party CVEs. In 2022, several initiatives were created by the [Security Team](https://github.com/nodejs/security-wg) as described by [Alpha-Omega Node.js Report 2022](https://openjsf.org/blog/node-js-security-progress-report-looking-forward-to-2023) and the result of these initiatives are shown in 2023. Initiatives such as automation of updates, and automation of Node.js release impacts our team's time-to-action. 

With the recent addition of the Permission Model, we have noticed people also discovered another experimental security feature that has existed in Node.js since version [11.8.0](https://github.com/nodejs/node/pull/25687). The policy mechanism. This feature fits in what we call: module-based permission and we have fixed several vulnerabilities in this feature over 2023.

- [February 2024 Security Release](https://nodejs.org/en/blog/vulnerability/february-2024-security-releases)
- [October 2023 Security Release](https://nodejs.org/en/blog/vulnerability/october-2023-security-releases)
- [August 2023 Security Release](https://nodejs.org/en/blog/vulnerability/august-2023-security-releases)
- [June 2023 Security Release](https://nodejs.org/en/blog/vulnerability/june-2023-security-releases)

Still, on the reports side, some clarifications were made in our [Threat Model](https://github.com/nodejs/node/blob/main/SECURITY.md#the-nodejs-threat-model). Experimental features such as the *Permission Model* and *Policy* can attach severity at the same level as any stable feature. Therefore, when reviewing a Node.js Security Release, check if the vulnerability affects you. Very often we are patching a ‘High’ vulnerability that affects only users of that feature.

## Website Update

In 2023, there was talk about giving the Node.js website a fresh look, as discussed [here](https://github.com/nodejs/nodejs.org/discussions/5131). We talked about it a few times in TSC meetings and also shared the idea at Node.js Collab Summits. It's a big job that involves many steps, and I want to give a big shout-out to the whole [`@nodejs/website`](https://github.com/orgs/nodejs/teams/nodejs-website) for their hard work on this. See below:

![Website new design 1][]

![Website new design 2][]

Upcoming Download page:

![Website new design 3][]

Draft PR: [nodejs/nodejs.org#6353](https://github.com/nodejs/nodejs.org/pull/6353)

## Features

Several features were released in 2023. It’s quite difficult to iterate and elaborate on each one of them in a single article. Therefore, this article will list some important features that have arrived and feel free to dig into it more!

- Single Executable Apps (*experimental*) -  This feature has landed on Node.js 19 but got more eyes after [Node.js 20.0.0 release](https://nodejs.org/en/blog/announcements/v20-release-announce#preparing-single-executable-apps-now-requires-injecting-a-blob). This feature allows the distribution of a Node.js application conveniently to a system that does not have Node.js installed. It’s important to mention, that we are still developing it, so it’s also an *experimental* feature that I highly suggest you try out!
- Built-in .env support (*experimental*) - [Released with Node.js 20.6.0](https://nodejs.org/en/blog/release/v20.6.0#built-in-env-file-support), this feature aims to provide an official mechanism to read environment variables from a configuration file. It was a common approach to rely on the `dotenv` package or similar. After this version, you can use it directly on Node.js without the need to install a new package for that. Furthermore can be found in the [—env-file docs](https://nodejs.org/api/cli.html#--env-fileconfig).
- WebSocket Client (*experimental*) - [The Node.js 21.0.0 release](https://nodejs.org/en/blog/announcements/v21-release-announce#built-in-websocket-client) included another experimental feature. A built-in WebSocket Client (behind a flag) arises with this release. This is enabled through the flag: `--experimental-websocket` and follows the [WHATWG WebSocket Spec](https://websockets.spec.whatwg.org/).
- Test runner (*stable)* - Although this feature wasn’t released in 2023, in the last year several features were included in this API. [Including marking this module as *stable*](https://github.com/nodejs/node/pull/46983).
    - Support to function mocking was added in [#45326](https://github.com/nodejs/node/pull/45326).
    - Support for time (MockTimers API) mocking was added in [#47775](https://github.com/nodejs/node/pull/47775).
    - Test runner reports in [#45712](https://github.com/nodejs/node/pull/45712).
    - Support to shards in [#48639](https://github.com/nodejs/node/pull/48639).
    - And more! Check the API documentation to discover this feature capability.
- In the diagnostics field, some important PRs were added to the core:
    - Support to GC Profile ([#46255](https://github.com/nodejs/node/pull/46255)). With this PR you can use the `v8.GCProfiler` to retrieve metrics of the Garbage Collector (GC). This was available only through `perf_hooks`, this API provides a direct way to retrieve this information.
    - New Tracing Channel API through `dianostics_channel` ([#44943](https://github.com/nodejs/node/pull/44943)) - It provides a new API to trace operations (sync/promises) through a collection of channels to express a single traceable action. This is a long-term initiative that aims to provide necessary observability to Node.js applications without sacrificing performance and reliability by monkey-patching internals.
    - Support to [V8 Maglev Compiler](https://v8.dev/blog/maglev) (Reference: [#50590](https://github.com/nodejs/node/issues/50690)) - V8 released a new compiler called Maglev between 2022 and 2023. This was first supported in Node.js through a build flag (`—v8-enable-maglev`) in [#50692](https://github.com/nodejs/node/pull/50692), then we enabled it by default on January 24 ([#51350](https://github.com/nodejs/node/pull/50692)). However, it’s a *semver-major* PR, which implies you only will receive this PR that enables it by default in Node.js 22 - Scheduled for 2024-04-23.
- Some important updates were made to HTTP and WHATWG Spec :
    - We have moved `fetch` stability to: ‘stable’.
    - We have enabled the `autoSelectFamily` by default and it caused some systems to break (*semver-major*). Reference: https://github.com/nodejs/node/pull/46790
    - `Duplex.from()` now supports WebStreams. See: https://github.com/nodejs/node/pull/46190
    - `finished()` was implemented in Readable and Writable Streams. See: https://github.com/nodejs/node/pull/46205
    - In 2022, [after a Performance analysis on why `fetch` is slow](https://github.com/nodejs/undici/issues/1203#issuecomment-1100969210), we have identified *WebStreams* as one of the major bottlenecks of this HTTP Client. In 2023, several updates were made to make WebStreams more efficient. Including the re-usage of state errors, which improved the performance of `fetch` by 23% (in a specific benchmark). See https://github.com/nodejs/node/pull/46086

## Support me!

First, I want to express my gratitude to my employer [NodeSource](https://nodesource.com/) for sponsoring my work on the Node.js runtime. It's also worth noting that I continue to contribute to open-source projects in my free time out of love for the community. If my work has positively impacted you and you'd like to express your appreciation, consider sponsoring me on [GitHub](https://github.com/sponsors/RafaelGSS) 💚.

[Node.js Download Stats]: https://res.cloudinary.com/rafaelgss/image/upload/v1684174137/blog/nodejs-year-in-an-article/download-stats.png
[Binary size per version]: https://res.cloudinary.com/rafaelgss/image/upload/v1684174137/blog/nodejs-year-in-an-article/binary-size.png
[Website new design 1]: https://res.cloudinary.com/rafaelgss/image/upload/v1684174137/blog/nodejs-year-in-an-article/website-1.png
[Website new design 2]: https://res.cloudinary.com/rafaelgss/image/upload/v1684174137/blog/nodejs-year-in-an-article/website-2.png
[Website new design 3]: https://res.cloudinary.com/rafaelgss/image/upload/v1684174137/blog/nodejs-year-in-an-article/website-3.png
