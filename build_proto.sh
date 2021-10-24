#!/bin/bash

rm -rf ./lib/proto_build
mkdir ./lib/proto_build

protoc --proto_path=proto/ --dart_out=grpc:lib/proto_build proto/*.proto
protoc --proto_path=proto/ --dart_out=grpc:lib/proto_build proto/actions/*.proto
protoc --proto_path=proto/ --dart_out=grpc:lib/proto_build proto/datastreams/*.proto
protoc --proto_path=proto/ --dart_out=grpc:lib/proto_build proto/models/*.proto
