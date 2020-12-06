---
title: Github Actions + Digital Ocean + Elixir ❤️
date: 2020-01-19 18:00
tags: devops,article,en-US
---

# Github Actions + Digital Ocean + Elixir = ❤️

Today I performed an experiment with the new ~~not so new~~ CI from Github: [Github Actions](https://github.com/features/actions),
implementing on my blog (yes, the one you are reading).

The project has [here](https://github.com/rafaelgss/blog),

So, I ran this test with:

- Simple Droplet on DigitalOcean ($5)
- Elixir + Phoenix
- Docker + DockerHub - Github Actions

Well, for this experiment, I decided to use `docker` to facilitate the development/deploy and the the ease of scaling on K8s.
Of course, this blog will never have the need to use any container orchestrator, but, it is good practice.

Before to check out this experiment, is worth to make some things clear:

1. It was a test performed in ~3h.
2. There is downtime - the time to kill the `container` and move it up. e.g: `docker kill blog_prod`.
3. There is a previous configuration in `nginx` that I'll leave at end of article. 
4. Don't has necessity to use DockerHub, but I like the portability that it brings me.

## First of all

Let's create a Dockerfile to perform the build on pipeline.

> In the project I've a Dockerfile for development and one for production (prod.dockerfile), and in this article I'll show the `prod.dockerfile`

to summarize the Dockerfile, we've the following commands:

```sh
ENV PORT=4000 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=${SECRET_KEY_BASE} \
    DATABASE_URL=${DATABASE_URL}

CMD ["mix", "phx.server"]
```

Which we pass an sensible environment variable to build the Dockerfile (SECRET_KEY_BASE, DATABASE_URL).

## Go to Action

So, in brief summary we need that: _When perform a push to **master** we build the new image and send it to our repository at **DockerHub**.
After that, we should enter on _droplet_ and move the container up on the expected port by nginx (4000)_.

Some relevants information to consider:

1. We should send in some security way the credentials to access the database and the secret_key of Phoenix.
2. To perform the push to repository we must realize the login on docker. 

Therefore, let's create our file `actions` into `.github/workflows/actions.yml` and add the follow command:

```sh
on:
  push:
    branches:
      - master
```

To specific that this _action_ should be run when any push is made to the **master** branch.

And we've to create our first _job_:

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

We defined a `build` job called _Build, push_ that will run in a `ubuntu` system.
After that, we created our first step: `actions/checkout@master` that is responsible to make the pull from master.

Let's continue with our steps...
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
Well... we add a interesting sequency of steps now, which is:

1. Build da imagem de produção (_prod.dockerfile_) com a tag.
2. Login no DockerHub
3. Push da imagem para o DockerHub

1. Production build image (_prod.dockerfile_) with the tag.
2. Login on DockerHub
3. Image push to DockerHub

Note that in step 2 we use `${{ secrets.* }}`, These are the secrets defined in the project in question, that's where
that we will store all sensitive information in a "safe" way.

![Exemple of Secrets in Github](/images/secrets-example-github.png)

Well, we were able to build and send the iamge to the DockerHub... Now, let's go to the main step, the **deploy**!
First one, create a new job and call it `Deploy` and set it to run after the _BUILD_.

```sh
  deploy:
    needs: build
    name: Deploy
    runs-on: ubuntu-latest
```

And so, create our steps:
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

In this single step, we create an ssh connection with our droplet and execute what is in `script` in its sequence.

1. We performed the image pull made in the previous job.
2. We kill the container in execution (if any) -- Because of that, there is downtime.
3. Remove the previous container.
4. Move up the new container with a new image, passing the environment variable needed (stored in Secrets)

This is all! Our `action.yml` looks like this:

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

The Nginx configuration

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
