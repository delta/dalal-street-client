#!/bin/bash

rm -rf proto_build/
mkdir proto_build

protoc --proto_path=proto/ --dart_out=grpc:proto_build proto/*.proto
protoc --proto_path=proto/ --dart_out=grpc:proto_build proto/actions/*.proto
protoc --proto_path=proto/ --dart_out=grpc:proto_build proto/datastreams/*.proto
protoc --proto_path=proto/ --dart_out=grpc:proto_build proto/models/*.proto
