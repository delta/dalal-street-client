# Flutter Client for Dalal Street

## Prerequisites

- Flutter >2.12 [Download Link](https://flutter.dev/docs/get-started/install)
- Protocol Buffer Compiler [Download Link](https://grpc.io/docs/protoc-installation/)

## Check Prerequisites

- Run if you have installed all the required flutter dependencies with

  ```bash
  flutter doctor -v
  ```

- Ensure protoc compiler version is 3+

  ```bash
  protoc --version
  ```

- Dart plugin for the protocol compiler

  - Install the protocol compiler plugin for Dart (`protoc-gen-dart`)

  ```bash
  flutter pub global activate protoc_plugin
  ```

  - Update PATH so that the protoc compiler can find the plugin

## Setup

- Clone the repository
  ```bash
  git clone https://github.com/delta/dalal-street-client.git
  ```
- Install dependencies

  ```bash
  flutter pub get
  ```

- Setup submodules

  ```bash
  git submodule init
  git submodule update
  ```

- Generate proto files

  ```bash
  ./build_proto.sh
  ```

- Running the server

  - Run `cp config.example.json config.json`

  - Fill in the server configuration(host, port etc) in **config.json**.

  - Connect your device and run

  ```bash
  flutter run
  ```

## Dev Guidelines

- For each feature proper Tests should be written before creating pull requests
- Comment as much as possible
- Please follow this format `[type]:commit message` for committing your code.
- Example `[feat]: Initial Commit`
