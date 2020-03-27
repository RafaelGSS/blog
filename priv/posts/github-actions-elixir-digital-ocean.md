---
title: Github Actions + Digital Ocean + Elixir ❤️
date: 2020-01-19 18:00
tags: devops,article
---

# Github Actions + Digital Ocean + Elixir = ❤️

Hoje realizei um experimento com o novo ~~não tão novo assim~~ CI do Github: [Github Actions](https://github.com/features/actions),
implementando no meu blog (sim, este que você está lendo).

O projeto está [aqui](https://github.com/rafaelgss/blog),

Portanto, realizei esse teste com:

- Droplet simples no DigitalOcean ($5 doleta)
- Elixir + Phoenix
- Docker + DockerHub - Github Actions

Bom, para esse experimento, decidi utilizar docker para facilitar o desenvolvimento/deploy e a facilidade de escalar no K8s.
Claro, esse blog jamais terá a necessidade de utilizar algum orquestrador de containers, mas, vale a boa prática.

Antes de esmiuçar neste expertimento, vale deixar claro algumas coisas:

1. Foi um teste realizado em ~3h.
2. Há downtime - o tempo de matar o container e subi-lo. e.g: _docker kill blog_prod_.
3. Há uma configuração prévia no nginx que vou deixar no final do artigo.
4. Não haveria a necessidade de utilizar DockerHub, mas gosto da portabilidade que ele me trás.

## First of all

Vamos criar um Dockerfile para realizar o build na pipeline.

> No projeto tenho um Dockerfile para desenvolvimento e um para produção (prod.dockerfile), e nesse artigo
vou mostrar o `prod.dockerfile`

sem adentrarmos muito no Dockerfile, temos os seguintes comandos:

```sh
ENV PORT=4000 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=${SECRET_KEY_BASE} \
    DATABASE_URL=${DATABASE_URL}

CMD ["mix", "phx.server"]
```

No qual passamos uma variavel de ambiente sensível para o build (SECRET_KEY_BASE, DATABASE_URL).

## Go to Action

Então, em um breve resumo precisamos que; _Ao realizar um push para **master** façamos o build da nova imagem e enviamos para o nosso repositório **DockerHub**.
Após isso, deveremos entrar na droplet, e subir o container na porta esperada pelo nginx (4000)._

Algumas informações relevantes a considerar:

1. Precisamos enviar de alguma forma **segura** a credencial de acesso ao banco de dados e a secret key do Phoenix
2. Para realizar o push para o repositório precisamos ter realizado o login no docker.

Portanto, vamos criar nosso arquivo `actions` dentro de `.github/workflows/actions.yml` e adicionar o seguinte comando:

```sh
on:
  push:
    branches:
      - master
```

Para especificarmos que este _action_ deverá ser rodado quando for realizado algum push para a branch **master**

E então criaremos nosso primeiro _job_:

```sh
...

jobs:

  build:
    name: Build, push
    runs-on: ubuntu-latest
    steps:

    - name: Checkout master
      uses: actions/checkout@master
```

Definimos um job `build` com o nome de _Build, push_ que rodará em uma imagem `ubuntu`.
Após isso, criamos nosso primeiro step: `actions/checkout@master` que é responsável por fazer o pull da master.

Vamos seguir com os steps...
```sh
    steps:
    ...

    - name: Build container image
      run: docker build -t rafaelgss/projects:blog-latest -f prod.dockerfile .

    - name: Docker Login
      env:
        DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

    - name: Push image to Docker Hub
      run: docker push rafaelgss/projects
```

Bem... adicionamos uma sequência interessante de steps agora, sendo elas:

1. Build da imagem de produção (_prod.dockerfile_) com a tag.
2. Login no DockerHub
3. Push da imagem para o DockerHub

Perceba, que no passo 2 utilizamos `${{ secrets.* }}`, essas são as secrets definidas no projeto em questão, é ali
que iremos guardar toda informação sensível de forma "segura".

![Exemple of Secrets in Github](/images/secrets-example-github.png)

Bom, com isso conseguimos buildar e enviar a imagem para o DockerHub... Agora, vamos ao passo principal o **deploy**!
Primeiro, vamos criar um novo job, e chama-lo de `Deploy` e adjusta-lo para que o mesmo só seja rodado após o _BUILD_

```sh
  deploy:
    needs: build
    name: Deploy
    runs-on: ubuntu-latest
```

E então, vamos adicionar nossos steps:
```sh
    steps:

    - name: executing remote ssh commands using key
      uses: appleboy/ssh-action@master
      env:
        VIRTUAL_HOST: 'blog.rafaelgss.com.br'
        SECRET_KEY_BASE: ${{ secrets.SECRET_KEY_BASE }}
        DATABASE_URL: ${{ secrets.DATABASE_URL }}
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.key }}
        port: ${{ secrets.PORT }}
        envs: VIRTUAL_HOST,SECRET_KEY_BASE,DATABASE_URL
        script: |
          docker pull rafaelgss/projects:blog-latest
          docker kill blog_prod
          docker rm blog_prod
          docker run -d -p 4000:4000 --name blog_prod -e VIRTUAL_HOST="$VIRTUAL_HOST" -e SECRET_KEY_BASE="$SECRET_KEY_BASE" -e DATABASE_URL="$DATABASE_URL" -t rafaelgss/projects:blog-latest
```

Neste único step, criamos uma conexão ssh com nosso droplet e executamos oque está em `script` em sua respectiva sequência.

1. Relizamos o pull da imagem feita no job anterior
2. Matamos o container em execução no momento (se houver) -- Por isso o downtime.
3. Removemos o container pré-estabelecido
4. Subimos um novo container com a nova imagem, passando as variáveis de ambiente necessárias (salvas em Secrets)

Isso é tudo! Nosso `action.yml` ficou assim:

```sh
on:
  push:
    branches:
      - master

jobs:

  build:
    name: Build, push
    runs-on: ubuntu-latest
    steps:

    - name: Checkout master
      uses: actions/checkout@master

    - name: Build container image
      run: docker build -t rafaelgss/projects:blog-latest -f prod.dockerfile .

    - name: Docker Login
      env:
        DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

    - name: Push image to Docker Hub
      run: docker push rafaelgss/projects

  deploy:
    needs: build
    name: Deploy
    runs-on: ubuntu-latest
    steps:

    - name: executing remote ssh commands using key
      uses: appleboy/ssh-action@master
      env:
        VIRTUAL_HOST: 'blog.rafaelgss.com.br'
        SECRET_KEY_BASE: ${{ secrets.SECRET_KEY_BASE }}
        DATABASE_URL: ${{ secrets.DATABASE_URL }}
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.key }}
        port: ${{ secrets.PORT }}
        envs: VIRTUAL_HOST,SECRET_KEY_BASE,DATABASE_URL
        script: |
          docker pull rafaelgss/projects:blog-latest
          docker kill blog_prod
          docker rm blog_prod
          docker run -d -p 4000:4000 --name blog_prod -e VIRTUAL_HOST="$VIRTUAL_HOST" -e SECRET_KEY_BASE="$SECRET_KEY_BASE" -e DATABASE_URL="$DATABASE_URL" -t rafaelgss/projects:blog-latest

```

## Nginx - Docker

Deixo aqui a config do nginx que usei:

```conf
upstream phoenix_upstream {
    server 127.0.0.1:4000;
}

server {

        listen [::]:80;
        listen 80;

        server_name blog.rafaelgss.com.br;

        location ~ ^/(.*)$ {
                proxy_pass         http://phoenix_upstream/$1;
        }

        location / {
                #try_files $uri $uri/ =404;
                proxy_pass         http://phoenix_upstream;
                proxy_redirect     off;
                proxy_set_header   Host $host;
                proxy_set_header   X-Real-IP $remote_addr;
                proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header   X-Forwarded-Host $server_name;
        }
}
```
