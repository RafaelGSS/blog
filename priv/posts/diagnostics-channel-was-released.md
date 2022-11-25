---
title: Diagnostics Channel was released!
date: 2020-12-24 11:00
tags: performance,nodejs,article,en-US
---

# Diagnostics Channel

The Node.js v15 landed a feature that should help a lot of [APM][] vendors.
The `diagnostics_channel` has the objective to have a centralized channel of events between modules.

As stated in the blog release:

> _`diagnostics_channel` is a new experimental module that provides an API to create named channels to report arbitrary
message data for diagnostics purposes.
With `diagnostics_channel`, Node.js core and module authors can publish contextual data about what they are doing at a
given time. This could be the _hostname_ and querystring of a MySQL query, for example.
Just create a named channel with `dc.channel(name)` and call `channel.publish(data)` to send the data to all listeners
in that channel._

This feature is similar to [`EventEmmiter`](https://nodejs.org/api/events.html#events_class_eventemitter),
however, `diagnostics_channel` has less overhead than publishing a string-named event to an EventEmitter has.
More info about in the _Why use this module instead of EventEmmiter_ section.

Usually, APM vendors monkey patch every key module to capture the information which `diagnostics_channel` simply
publishes as events.
Monkey patching generally creates many additional costly closures and can be fragile so it's much safer to rely on more
intentional events.

Monkey patching has two major problems:
1. Creating closures around everything makes everything slow
2. It's also very fragile patches that can easily miss something and break the functionality.

With _diagnostics_channel_, it should never break the publishing API and the overhead should be extremely minimal.

## Usage examples

This snippet create a subscriber to the `root.caughtError` channel.

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

It allows us to measure bottlenecks in our code:

```js
const dc = require('diagnostics_channel')
const channel = dc.channel('mysql.query')

channel.subscribe({ timeElapsed, query } => {
  if (timeElapsed > process.env.QUERY_THRESHOLD) {
    console.warn('Query slow: ', query, timeElapsed)
  }
})
```

Actually, most of the database modules already emit the warning on query slow if you set on the settings.
This example is just to show you the main usage of this module.

After key modules support `diagnostics_channel` we will be able to have a better observability/tracing of our
application without adding a lot of complexity to our Node.js code.
Of course, this feature sounds better for APM Vendors.

## Why use this module instead of EventEmmiter?

`EventEmitter` has an extra cost on every single publish to look up the handler set by the string event name.
That's not a huge deal for just a single run, but in a high-frequency scenario where the logic might be repeated
thousands, or even millions, of times per second, it adds up fast.
Additionally, the lookup cost always happens with `EventEmitter` while with `diagnostics_channel` it only happens when
something is actually listening to that specific channel.
The intent is for there to be hundreds or even thousands of these channels being reported to at any given time while
there might be only a few of those channels being actively observed at any given time.
The majority of the time there would be nothing to publish to so it's been intentionally designed to do nothing at all
in that case. This design makes it much more suitable as a data firehose whereas a typical `EventEmitter` is really only
suited to a more _limited_ set of events.

> `diagnostics_channel` was created to publish/receive billions of events per second.

To clarify the above statement in fewer words:

```js
class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter();

myEmitter.emit('event1');
```

`myEmitter` can publish **any** event name, so obviously the lookup takes more time than `diagnostics_channel` approach. 

## What next?

`diagnostics_channel` is still a experimental module. Since this module is just an API to provide information out-of-box the community should adopt it in their library, it means, add support to this feature in most library around nodejs ecossytem.

For instance, [`Fastify`](http://fastify.io/) already support `diagnostics_channel` through plugin
[`fastify-diagnostics-channel`](https://github.com/fastify/fastify-diagnostics-channel).

## Acknowledgment

Thanks to [@Qard](http://stephenbelanger.com/) that's spend time working on it and made the review of this quick introduction.

[APM]: https://en.wikipedia.org/wiki/Application_performance_management
