FROM ubuntu:20.04 AS build-env

RUN apt-get update &&\  
    apt-get install -y curl unzip git &&\ 
    apt install -y protobuf-compiler &&\
    apt-get clean
   
ENV PATH="$HOME/.local/bin:${PATH}"

RUN git clone --depth=1 https://github.com/flutter/flutter.git -b stable

ENV PATH="/flutter/bin:${PATH}"

WORKDIR /app

COPY pubspec.* ./

RUN protoc --version \ 
    flutter channel stable &&\
    flutter config --no-enable-android \
    --no-enable-linux-desktop \
    --no-enable-windows-desktop \
    --no-enable-macos-desktop \
    --no-enable-windows-uwp-desktop \
    --no-enable-ios &&\
    flutter config --enable-web &&\
    flutter precache &&\
    flutter pub get &&\
    flutter pub global activate protoc_plugin &&\
    flutter doctor -v

COPY . .

ENV PATH="$HOME/.pub-cache/bin:${PATH}"

RUN flutter build web --release 
