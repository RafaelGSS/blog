---
title: Async/Await não é solução!
date: 2019-06-21 10:00
---

## Async/Await não é solução!

Quando você não tiver o porque utilizar `await`, não use!

Exemplo de aplicação que não é necessário o `await`:

```js
try {
  const dataPromisse = repository.getLightningByLocale(localeId, period, lightningType, source)
  const data = await dataPromisse.skip(perPage * (page - 1)).limit(perPage).toArray()
  const count = await dataPromisse.count()
  

  reply.success({ data, totalRecords, page, perPage })
} catch ({ message }) {
  reply.error({ message })
}
```

Como poderia ser melhorado:
```js
try {
  const dataPromisse = repository.getLightningByLocale(localeId, period, lightningType, source)
  const [data, totalRecords] = await Promise.all([
    dataPromisse.skip(perPage * (page - 1)).limit(perPage).toArray(),
    dataPromisse.count()]
  )
  reply.success({ data, totalRecords, page, perPage })
} catch ({ message }) {
  reply.error({ message })
}
```

Dessa forma, você utiliza concorrência no processamento. 
