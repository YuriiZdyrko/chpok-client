# ./Dockerfile

# Starting from the official Elixir 1.3.2 image:
# https://hub.docker.com/_/elixir/
FROM elixir:1.4.2
MAINTAINER David Anguita <david@davidanguita.name>

# Install hex
RUN mix local.hex --force

RUN mkdir -p /app

COPY . /app

EXPOSE 8080

# Set /app as workdir
WORKDIR /app

CMD ["mix", "run", "--no-halt"]
