FROM bitwalker/alpine-elixir-phoenix:1.13.1

# Initial setup
# Set exposed ports
EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get --only prod
RUN mix compile

# Same with npm deps
RUN mix assets.deploy

ADD . .

USER root

CMD ["mix", "phx.server"]
