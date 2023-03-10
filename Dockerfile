# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
# RUN dart pub run build_runner build


# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/vpn-telegram-bot.source.dart -o bin/server
RUN touch /bin/logs.log

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM ubuntu
RUN apt-get update
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY /config.yaml ./
COPY /layouts.yaml ./

# Start server.
EXPOSE 8083
CMD ["/app/bin/server"]
