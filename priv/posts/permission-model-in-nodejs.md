---
title: Permission Model in Node.js
date: 2023-03-08 10:00
tags: security,article,en-US,nodejs
---

# Introducing Node.js Permission Model

Node.js is a powerful, event-driven, server-side platform for building scalable network applications.
With its ease of use and wide range of features, it has become a popular choice for developers across the globe.
However, as with any powerful tool, it is important to consider security concerns and ways to mitigate potential risks.

That's where the [Node.js Permission Model][] comes in.
This mechanism allows you to restrict access to specific resources during program execution, giving you greater control
over the actions your code can perform. In this blog post, we'll explore this feature in detail, including the available
permissions, CLI arguments, API arguments, and roadmap.

> The Permission Model mechanism was [previously researched][] by [James Snell][] and [Anna Henningsen][], and then [after 2 years of battle][issue],
[I implemented it][pr].

Developers should use the `--experimental-permission` feature in Node.js to improve the security and reliability of their
applications. With this feature, they can restrict access to specific resources during program execution, such as
file system operations, child process spawning, and worker thread creation. By doing so, developers can prevent their
applications from accessing or modifying sensitive data or running potentially harmful code.

Additionally, the `--experimental-permission` feature provides an API that allows developers to deny or check permissions
at runtime, providing more flexibility and control over their applications.

> Before start, I would like to give a big shoutout to the [Node.js Security WG][], to [Nearform][] and
[OpenJS Foundation][] that made this feature real.

## Constraints

Before we dive into the specifics of the [Node.js Permission Model][], it's important to note that there are certain
constraints to be aware of. First and foremost, this permission model is not bulletproof.
We assume that the user trusts the running code. Just because you are using the permission model, it doesn't mean you can
run non-trusted code. The [Node.js Security WG][] built and amazing material about [Node.js Security best practices][],
therefore, if you are interested on this topic consider reading it.

Despite these constraints, the `--experimental-permission` feature is highly beneficial for developers who prioritize
security and reliability. It adds a low/no overhead when disabled and low overhead when enabled,
making it a highly efficient and effective solution for controlling resource access during program execution

## API Design

The Node.js Permission Model is a mechanism to restrict access to specific resources during the program execution.
The API exists behind a flag `--experimental-permission` which when enabled, will restrict access to all available permissions.

Currently, the available permissions are:

* File System - manageable through `--allow-fs-read` and `--allow-fs-write` flags
* Child Process - manageable through `--allow-child-process` flag
* Worker Threads - manageable through `--allow-worker` flag

Therefore, when starting a Node.js process with `--experimental-permission`, the ability to access the filesystem,
spawn process and, create worker\_threads or use native addons will be restricted.

**The CLI Arguments**

To allow access to the filesystem, use the `--allow-fs-read` and `--allow-fs-write` flags.
The valid arguments for both flags are:

* `*` - To allow all operations to given scope (read/write).
* Paths delimited by comma (,) to manage reading/writing operations.

Example:

- `--allow-fs-read=/tmp/` - It will allow `FileSystemRead` access to the `/tmp/` folder
- `--allow-fs-read=/tmp/,/home/.gitignore` - It allows `FileSystemRead` access to the `/tmp/` folder **and** the `/home/.gitignore` file — Relative paths are NOT supported.

> Due to the PrefixRadixTree (fs_permission) lookup, relative paths are not supported. For this reason, the `possiblyTransformPath` was needed. I do have plans to create a pretty similar `path.resolve` on the C++ side so the `possiblyTransformPath` won't be needed, but I'll do it in a second iteration.

You can also mix both arguments:

- `--allow-fs-write=* --allow-fs-read=/tmp/` - It will allow `FileSystemRead` access to the `/tmp/` folder **and** allow **all** the `FileSystemWrite` operations.
**Note**: It accepts wildcard parameters as well. For instance: `--allow-fs-write=/home/test*` will allow everything that matches the wildcard. e.g: `/home/test/file1` / `/home/test2`

### The API Arguments

A new property `permission` was added to the `process` module. The property contains two functions:

- `deny(scope [,parameters])`

API Call to *deny* permissions at runtime. e.g

```jsx
process.permission.deny('fs') // deny permissions to ALL fs operations

process.permission.deny('fs.out') // deny permissions to ALL FileSystemWrite operations
process.permission.deny('fs.out', '/home/rafaelgss/protected-folder') // deny FileSystemWrite permissions to the protected-folder
process.permission.deny('fs.in') // deny permissions to ALL FileSystemRead operations
process.permission.deny('fs.in', '/home/rafaelgss/protected-folder') // deny FileSystemRead permissions to the protected-folder
```

- `has(scope [,parameters])`

API Call to check permissions at runtime. e.g:

```jsx
process.permission.has('fs.out') // true
process.permission.has('fs.out', '/home/rafaelgss/protected-folder') // true

process.permission.deny('fs.out', '/home/rafaelgss/protected-folder')

process.permission.has('fs.out') // true
process.permission.has('fs.out', '/home/rafaelgss/protected-folder') // false
```

### What's next?

// TODO: mention permission model roadmap

[Node.js Permission Model]: https://nodejs.org/api/permissions.html#permission-model
[previously researched]: https://www.nearform.com/blog/adding-a-permission-system-to-node-js/
[James Snell]: https://github.com/jasnell
[Anna Henningsen]: https://github.com/addaleax
[pr]: https://github.com/nodejs/node/pull/44004
[issue]: https://github.com/nodejs/security-wg/issues/791
