---
title: Microsservicos Autonomos - Outbox Pattern
date: 2020-02-15 22:40
tags: microservices,article
---

# Microsservicos Autonomos - Outbox Pattern

Em uma arquitetura de microsserviços boa parte de sua complexidade está na consistência dos dados, ou seja qual a melhor forma
de comunicar os microsserviços de forma que um consiga dados do outro? Como expor em um single endpoint a relaçao entre um recurso e outro?
Como lidar com 2PC/Saga? Veja isso e mais ~no Domingo Espetacular~ nesse artigo.

Bom, antes de adentrarmos nas nuances da solução para as perguntas acima, vamos entender qual é realmente o problema enfrentado.

## O Contexto

Quando se utiliza uma arquitetura voltada para microsserviços, normalmente o primeiro fato que nos vem a cabeça é separar os serviços por domínio,
ou seja, tomando como exemplo um ecommerce, poderiamos ter um microsserviço de **Users** e outro de **Orders**. Portanto, vamos imaginar esse cenário.

// IMAGEM
## O Problema

Imagina uma situação onde é necessário retornar a relação entre **users** e **orders**, normalmente terá em mente dois possíveis meios:
- Relizar dois requests (um para capturar usuários e outro para capturar as orders de cada um.)
- Criar um BFF (Backend For Front-end) que faça o passo acima

// Imagem dos passos acima

Porém, e se nossa regra de negócio for que para cada **novo user** precisemos criar uma **nova order**?

// E se eu disser que voce pode lidar com isso sem a comunicacao direta entre microsserviços?

// o problema

// a ideia da solucao

// a solucao + POC
