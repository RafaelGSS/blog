FROM elixir:1.9.0

ARG IMAGE_ENVIRONMENT=dev

ENV MIX_ENV $IMAGE_ENVIRONMENT
# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install node
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs


COPY . /app
WORKDIR /app
# RUN mix deps.get --force

EXPOSE 4000
# CMD ["mix", "phx.server"]
