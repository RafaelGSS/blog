---
title: Node.js Core - Neovim Setup
date: 2022-07-30 11:00
tags: vim,nodejs,tips,en-US
---

# Node.js Core - Neovim setup

Frequently, I’m asked about my setup when working in the Node.js source code.
To save everyone time, I’ve decided to write this quick blog post.
It’s important to mention all of the recommendations are personal preferences, you can achieve the same behavior using different tools.

Currently, I’m using [Linux Mint](https://linuxmint.com/) as my OS(operational system), but likely this tutorial will work for any Unix-based system.
These are the pre-requisites:

1. Neovim + [coc.nvim](https://github.com/neoclide/coc.nvim)
2. Node.js (git clone git@github.com:nodejs/node.git)
3. [ccls](https://github.com/MaskRay/ccls)

> _In case you are looking for a Neovim configuration, you can use [mine](https://github.com/RafaelGSS/dotfiles). _

### Creating coc-settings.json

Once you have coc.nvim installed, you should be able to run `:CoCConfig` to open the coc-settings.json.
Add the following languageserver option into your file

```json
{
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"]
    },
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
    "bash": {
      "command": "bash-language-server",
      "filetypes": [
        "sh"
      ],
      "args": [
        "start"
      ],
      "ignoredRootPaths": [
        "~"
      ]
    }
  }
}
```

This file will enable the ccls LSP(Language Service Provider) under Node.js C++ Files. Notice inside _rootPatterns _contains_ compile_commands.json_,
this is the file that will be generated in the next step.

### Generating Node.js maps

Building Node.js for the first time is not fast. I strongly suggest using:

* [Ninja builds](https://github.com/nodejs/node/blob/main/doc/contributing/building-node-with-ninja.md)
* [ccache](https://github.com/nodejs/node/blob/main/BUILDING.md#speeding-up-frequent-rebuilds-when-developing)

The LSP needs a file that indicates all the includes and references each file has in order to provide actions such as go-to-definition, and go-to-implementation

To generate this file you need to just include the `-C` argument to the _configure_ command.

```console
$ ./configure -C
# you can pass any further flag
$ ./configure -C --debug-node

$ make -j6
```

It will generate a `compile_commands.json` under `out/Release/` or `out/Debug/` (depending on the compilation method).
Create a symbolic link to the Node.js root folder

```console
ls ./out/Release/compile_commands.json .
```

After it, restart your vim and see the magic happening.

### The first CCLS Run may take a while

Don’t worry if your machine starts to work heavy on the ccls. Dashboards similar to the below image are expected:

![htop showing ccls using all the CPU's](https://res.cloudinary.com/rafaelgss/image/upload/v1657247209/blog/nodejs-neovim/FWtFMs6XwAMFySe_ylimg6.jpg)

_That’s just the price you pay for a simple go-to._

### References

* [Joyee](https://joyeecheung.github.io/blog/about/) wrote [this blog](https://joyeecheung.github.io/blog/2018/12/31/tips-and-tricks-node-core) post in 2018, but this is still a good reference.
* The [ccls/coc.nvim](https://github.com/MaskRay/ccls/wiki/coc.nvim) wiki is a good starting point.
