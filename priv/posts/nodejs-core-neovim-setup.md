---
title: Node.js Core - Neovim Setup
date: 2022-10-09 13:00
tags: vim,nodejs,tips,en-US
---

# Node.js Core - Neovim setup

Frequently, I'm asked about my setup when working on the Node.js codebase.
To save everyone's time, I wrote this quick blog post.

It's important to mention all recommendations are personal preferences,
you can achieve the same behaviour using different tools.

Currently, I'm a [Linux Mint](https://linuxmint.com/) user, but likely this
tutorial will work for any Unix-based system. These are the pre-requisites:

1. Neovim + [coc.nvim](https://github.com/neoclide/coc.nvim)
2. Node.js (`git clone git@github.com:nodejs/node.git`)
3. [ccls](https://github.com/MaskRay/ccls)

> _In case you are looking for a Neovim configuration, you can use [mine](https://github.com/RafaelGSS/dotfiles)._

## Enabling ccls LSP

Once you have `coc.nvim` installed, you should be able to run `:CoCConfig` to
open the `coc-settings.json`.

This file handles all the `CoC` configurations. In this section, we're
configuring only the language server. For detailed information, check
the [coc documentation](https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file).

Include the following _languageserver_ option to this file:

```json
{
  "languageserver": {
    "ccls": {
      "command": "ccls",
      "filetypes": [
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cc"
      ],
      "rootPatterns": [
        "compile_commands.json",
        ".ccls",
        ".root",
        ".git/"
      ],
      "initializationOptions": {
        "cacheDirectory": "/tmp/ccls"
      }
    },
  }
}
```

This configuration will enable the `ccls` [LSP(Language Service Provider)](https://microsoft.github.io/language-server-protocol/)
over Node.js C++ Files. Note that _rootPatterns_ array contains `compile_commands.json`.
This is the **compilation database** the that will be generated in the next step.

## Generating Node.js Compilation Database

Building Node.js for the first time is not a fast operation. Personally, I suggest using:

* [Ninja builds](https://github.com/nodejs/node/blob/main/doc/contributing/building-node-with-ninja.md) and
* [ccache](https://github.com/nodejs/node/blob/main/BUILDING.md#speeding-up-frequent-rebuilds-when-developing)

To reduce the build time.

A _compilation database_ is a JSON file named `compile_commands.json` that consists
of an array of _command objects_ where each object specifies a way in which
a translation unit is compiled into the project. In other terms, The LSP needs a
file that indicates all the includes and references each file has in order to
provide actions such as _go-to-definition_, and _go-to-implementation_.

To generate this file you need to include the `-C` argument to the _configure_ command.

```console
$ ./configure -C
# you can pass any further flag
$ ./configure -C --debug-node

$ make -j6
```

It will generate a `compile_commands.json` under `out/Release/` or `out/Debug/`
(depending on the compilation method). Create a _symbolic link_ pointing the
Node.js root folder

```console
ln -s ./out/Release/compile_commands.json .
```

After that, restart your `nvim` and watch the magic happen.

## The first CCLS Run may take a while

Don’t worry if your machine starts to work heavy on the `ccls`.
Dashboards similar to the below image are expected:

![htop showing ccls using all the CPU's](https://res.cloudinary.com/rafaelgss/image/upload/v1657247209/blog/nodejs-neovim/FWtFMs6XwAMFySe_ylimg6.jpg)

_That’s just the price you pay for a simple go-to._

## References

* [Joyee](https://joyeecheung.github.io/blog/about/) wrote [this blog](https://joyeecheung.github.io/blog/2018/12/31/tips-and-tricks-node-core)
post in 2018. This is still a good reference.
* The [ccls/coc.nvim](https://github.com/MaskRay/ccls/wiki/coc.nvim) wiki is a good starting point.
