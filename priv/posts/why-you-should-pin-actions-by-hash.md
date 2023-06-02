---
title: Why you should pin your GH Actions by hash
date: 2023-06-03 12:00
tags: security,article,en-US
---

# Why you should pin your Github Actions by commit-hash

Supply chain attacks in now something new, we've heard a lot of it and maximum we can do
if mitigation as we can. However, this kind of attack will always exist. That said
it's important to know all the attack vectors and what you can do to secure your environment.

One of the initiatives of the Node.js Security WG (Working Group) for 2023 is to improve the
OSSF Scorecard and this task required to change all the Node.js actions to be pinned by commit-hash.
The reason is pretty simple, commit-hash as immutable while tags aren't not.

For instance, it's prety common to have the following action as part of your application CI:

```yml
jobs:

  build:
    name: Build, push
    runs-on: ubuntu-latest
    steps:

    - name: Checkout master
      uses: actions/checkout@v3.5.2
```

And use `dependabot`/`renovatebot` to keep those actions up-to-date.
However, using the release tag can be dangerous for your environment.

Let's assume that someone malicous took over of the `actions/checkout` package.
The package is now compromised and can interact with the whole CI by querying environment
variables used by other jobs, writing to a shared directory that a later job processe,
perform remote calls, inject malicious code to the production binary and many more.

// Image

What most developers assume, is that once you pin the action by the release tag, they are safe, since
any new change will require a new release. That's fundamentaly wrong. Release tags such as v3.5.2
are **mutable** and an bad actor can override it. For educational reasons, I wrote two repositories:

1. bad-action - It's a github action to simulate a someone taking over the package
2. using-bad-action - It's a project that uses the above action as the name suggests.

The later contains a `.github/workflows/main.yml` using the `bad-action` in the version v1.0.1:

```yaml
on:
  workflow_dispatch:

jobs:
  example_job:
    runs-on: ubuntu-latest
    steps:
      - uses: RafaelGSS/bad-action@v1.0.1
```

For this practical example `workflow_dispatch` will be used, but the same applies to `on: [push, pull_request]`
and so on.

Therefore, when the action is executed "Hello world" is print in console.

// Image

// Image2


Now, let's imagine the bad actor took over the repository and changed the "Hello world" to "Hello darkness my old friend"
and instead of creating a new release, it overrides the v1.0.1 one.

```console
echo "echo \"Hello darkness my old friend\"" > run.sh
git add run.sh
git commit -m "dangerous commit"
git push origin :refs/tags/v1.0.1
git tag -fa v1.0.1
git push origin main --tags
```

Hence, if the action is executed again without the need of changing anything in the source code it will print:
"Hello darkness my old friend" and that's how your environment can be exploited using release tags.

## Solution


// Dependabot/Renovate bot

// Mention Security WG initiative
