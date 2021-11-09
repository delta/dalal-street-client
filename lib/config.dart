import 'dart:convert';

import 'package:flutter/services.dart';

/// The host and port configuration for the gRPC server
class GrpcConfig {
  final String host;
  final int port;

  const GrpcConfig({required this.host, required this.port});

  String get url => 'http://$host:$port/';
}

late GrpcConfig grpcConfig;

Future<void> readConfig() async {
  final jsonString = await rootBundle.loadString('config.json');
  final jsonMap = jsonDecode(jsonString);

  grpcConfig = GrpcConfig(
    host: jsonMap['host'],
    port: jsonMap['port'],
  );
}
