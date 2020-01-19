---
title: Github Actions + Digital Ocean + Elixir
date: 2020-01-19 18:00
---

# Github Actions + Digital Ocean + Elixir = ❤️

Hoje realizei um experimento com o novo ~não tão novo assim~ CI do Github: [Github Actions](https://github.com/features/actions),
implementando no meu blog (sim, este que você está lendo).

O projeto está [aqui](https://github.com/rafaelgss/blog),

Portanto, realizei esse teste com:

- Droplet simples no DigitalOcean ($5 doleta)
- Elixir + Phoenix
- Docker + Dockerhub
- Github Actions

Bom, para esse experimento, decidi utilizar docker para facilitar o desenvolvimento/deploy e a facilidade de escalar no K8s.
Claro, esse blog jamais terá a necessidade de utilizar algum orquestrador de containers, mas, vale a boa prática.

Antes de esmiuçar esse expertimento, vale deixar claro algumas coisas:

1. Foi um teste realizado em ~3h.
2. Há downtime - o tempo de matar o container e subi-lo. e.g: _docker kill blog_prod_.
3. Há uma configuração prévia no nginx que vou deixar no final do artigo.


## Step by Step

// TODO
