---
title: Announcing bench-node
date: 2025-01-02 16:40
tags: nodejs,benchmarking,en-US
---

# Announcing bench-node

I’m excited to announce the release of bench-node, a Node.js benchmarking library
designed to measure operations per second (ops/sec) for small, focused blocks of
JavaScript code. Originally, this project was intended for inclusion in Node.js
core, but microbenchmark accuracy is a complicated topic—so, after many
discussions and the need for more time, we decided to make it available as a
standalone tool in my own repository. We’ve already been using bench-node to
provide performance data in “The State of Node.js Performance” report and to
power the “nodejs-bench-operations” GitHub repository.

If you like, please star it: https://github.com/RafaelGSS/bench-node.

## Why bench-node?

JavaScript engines (like V8) use Just-In-Time (JIT) compilation and other
optimizations that can make quick microbenchmark results misleading. Rather than
risk having dead code optimized away, bench-node explicitly instructs V8 not to
optimize the tested code (using a snippet like `%NeverOptimizeFunction(DoNotOptimize)`).
This produces stable comparisons for small snippets of code, but be aware that no
microbenchmark can fully match real-world behavior—production workloads often
trigger additional JIT optimizations and garbage collection pauses that can’t be
perfectly captured.

## Quick Start

Install bench-node:

```console
$ npm install bench-node
```

Then create a file (e.g., `my-benchmark.js`):

```js
const { Suite } = require('bench-node');

const suite = new Suite();

suite.add('Using delete property', () => {
  const data = { x: 1, y: 2, z: 3 };
  delete data.y;
  data.x;
  data.y;
  data.z;
});

suite.run();
```

Run it with:

```console
$ node --allow-natives-syntax my-benchmark.js
```

You’ll see ops/sec measurements in your console, plus metadata on min/max times
and V8 flags. For convenience, try the bench-node-cli tool:

```console
npx bench-node-cli my-benchmark.js
```

This lets you run a benchmark script without installing bench-node locally.

## Features

- **Multiple Reporters**: Text, chart, HTML, JSON -- choose your favorite format.
- **Plugins**: Extend functionality to force optimizations or collect custom
  metrics.
- **Setup and Teardown**: Manage pre/post tasks without spoiling core timing
  data.
- **Worker Threads**: Optionally isolate benchmarks for more accurate results.

## What’s Next?

While bench-node helps ensure consistent comparisons for simple code blocks,
it’s still a microbenchmark tool. Real workloads can differ greatly. For a deeper
look into common pitfalls, see the “Writting JavaScript Mistakes” section in the
docs. If you have questions or feedback, open an issue in the repo—I’d love to
hear how bench-node works for you.

Happy benchmarking!
