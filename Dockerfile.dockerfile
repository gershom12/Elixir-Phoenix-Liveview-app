FROM elixir:1.15.0-alpine as build

# Set working directory
WORKDIR /app

# Install dependencies and compile the application
RUN mix do deps.get, deps.compile

COPY . .

RUN mix release

# Production runtime image
FROM alpine:3.17.0

RUN apk add --no-cache libstdc++ bash

WORKDIR /app
COPY --from=build /app/_build/prod/rel/markdown_editor ./
CMD ["bin/markdown_editor", "start"]

EXPOSE 4000
