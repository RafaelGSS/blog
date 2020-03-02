---
title: Microsservicos Autonomos - Outbox Pattern
date: 2020-02-15 22:40
tags: microservices,article
---

# Microsservicos Autonomos - Outbox Pattern

Em uma arquitetura de microsserviços boa parte de sua complexidade está na consistência dos dados, ou seja qual a melhor forma
de comunicar os microsserviços de forma que um consiga dados do outro? Como expor em um single endpoint a relaçao entre um recurso e outro?
Como lidar com 2PC/Saga? Veja isso e mais ~~no Domingo Espetacular~~ neste artigo.

Bom, antes de adentrarmos nas nuances da solução para as perguntas acima, vamos entender qual é realmente o problema enfrentado.

## O Contexto

Quando se utiliza uma arquitetura voltada para microsserviços, normalmente o primeiro fato que nos vem a cabeça é separar os serviços por domínio,
ou seja, tomando como exemplo um ecommerce, poderiamos ter um microsserviço de **Users** e outro de **Orders**. Portanto, vamos imaginar esse cenário.

![Contexto](/images/microsservicos-autonomos/context.png)
## O Problema

Imagine uma situação onde é necessário retornar a relação entre **users** e **orders**. Normalmente haverá dois possíveis meios:

- Realizar dois requests (um para capturar usuários e outro para capturar as orders de cada um.)
- Criar um BFF (Backend For Front-end) que faça o passo acima

![Opções](/images/microsservicos-autonomos/options.png)

Porém, e se nossa regra de negócio for que para cada **novo user** precisemos criar uma **nova order**?

> Mas isso é fácil, é só propagar um evento no message broker quando criar um usuário

Boa! Mas, se o processo de criar uma _order_ falhar, o usuário também deve ser removido...

> É só usar o Pattern Saga

![Saga](/images/microsservicos-autonomos/saga.png)

Bom, se você precisar concatenar outros serviços nessa regra sua arquitetura vai ficar com uma complexidade exponencial.
Pra isso existe o **Pattern Outbox**; ao decorrer desse artigo, vamos entender porque lidar com consistência eventual é bom e te permite escalar
em um domínio cheio de regras de negócio.

Lembre-se: Um dos principais conceitos de microsserviços é a resiliência, portanto, se seu serviço depende de outros para "funcionar", não há uma arquitetura de microsserviços,
e sim uma **arquitetura microlítica** como chamo carinhosamente.

## Teorema CAP

Este Teorema afirma que é impossível que o armazenamento de dados distribuídos forneça simultaneamente mais de duas das três garantias seguintes:

- Consistência
- Disponibilidade
- Partição tolerante a falhas

### Consistência

Uma garantia que cada nó em um cluster distribuído retorne a escrita mais rescente. Consistência refere-se a cada cliente ter a mesma visualização dos dados.
Existem vários tipos de modelos de consistência. A consistência no CAP (usada para provar o teorema) refere-se à linearizabilidade ou consistência sequencial, uma forma muito forte de consistência.

### Disponibilidade

Cada nó que não falha retorna uma resposta para **todas** as solicitações de leitura e escrita em um período de tempo razoável.
Para se considerar disponível, todos os nós (em ambos os lados de uma partição de rede) **devem** responder em um curto espaço de tempo.

### Partição tolerante a falhas

Um sistema que é _"partição tolerante a falhas"_ pode sustentar quaisquer quantidade de falhas na rede que não resulta em uma falha na rede completa.
Os dados são replicados entre os nós/rede para manter o sistema ativo por interrupções intermitentes.
Ao lidar com sistemas distribuídos modernos, a Tolerância de Partição não é uma opção, **é uma necessidade**. Portanto, temos que _negociar_ entre consistência e disponibilidade.

//optando pela melhor combinação

// caso do youtube

// o problema

// a ideia da solucao

// a solucao + POC
