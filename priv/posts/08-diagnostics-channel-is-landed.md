---
title: Diagnostics Channel is landed!
date: 2020-12-24 11:00
tags: performance,nodejs,article,en-US
---

# Diagnostics Channel

In `node` v15 was landed a feature that should help a lot of APM vendors. `diagnostics_channel` has the objective to have a centralized channel of events between modules.

As blog release says:

> _`diagnostics_channel` is a new experimental module that provides an API to create named channels to report arbitrary message data for diagnostics purposes.
With `diagnostics_channel`, Node.js core and module authors can publish contextual data about what they are doing at a given time. This could be the hostname and query string of a mysql query, for example. Just create a named channel with dc.channel(name) and call channel.publish(data) to send the data to any listeners to that channel._

This feature is similar to [`EventEmmiter`](https://nodejs.org/api/events.html#events_class_eventemitter), however is optimized enough to propagate data synchronous.

APM Vendors usually does `monkey-patch` of every key modules for publish information. In `diagnostics_channel` world, we can avoid it in favor of events.

## Usage

That is a simple api, let's see some examples:

This one is a subscriber to `root.caughtError` channel.

```js
const dc = require('diagnostics_channel')
const channel = dc.channel('root.caughtError')

channel.subscribe({ error }) => {
  console.error('One error was propagated through dc', error)
})
```

> But, when it will be called?

Well, in some part of your application (even libraries used) this event should be called:

```js
const dc = require('diagnostics_channel')
const channel = dc.channel('root.caughtError')

async function exampleFunction() {
  try {
    await throwableFunction()
  } catch (e) {
    channel.publish({ error: e })
  }
}
```

Or, let's do a more reasonable example, we want to measure time elapsed of each query performed:

```js
// module mysql.js
const dc = require('diagnostics_channel')
const channel = dc.channel('mysql.query')

MySQL.prototype.query = async function query(queryString, values, callback) {
  const start = Date.now() // You can do it with perf_hooks as well
  await this.doQuery(queryString, values, callback);
  const end = Date.now()

  // Broadcast query information whenever a query is done
  channel.publish({
    query: queryString,
    host: this.hostname,
    timeElapsed: end - start,
  })
}
```

It able us to measure bottlenecks in our code:

```js
const dc = require('diagnostics_channel')
const channel = dc.channel('mysql.query')

channel.subscribe({ timeElapsed, query } => {
  if (timeElapsed > process.env.QUERY_THRESHOLD) {
    console.warn('Query slow: ', query, timeElapsed)
  }
})
```

Actually, most of database modules already emit the warning on query slow if you set on the settings. This example is just to show you the main usage of this module.

## Why use this module instead of EventEmmiter?

## What next?

// Talk about modules adopting this channel and reference fastify-diagnostics-channel
