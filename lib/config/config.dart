import 'dart:convert';

import 'package:flutter/services.dart';

/// The host and port configuration for the gRPC server
class GrpcConfig {
  final String host;
  final int port;

  const GrpcConfig({required this.host, required this.port});

  GrpcConfig.fromJson(Map json)
      : host = json['host'],
        port = json['port'];

  String get url {
    return port == 443 ? 'https://$host/' : 'http://$host:$port/';
  }
}

late GrpcConfig mobileConfig;
late GrpcConfig webConfig;
late String tlsCert;

Future<void> readConfig() async {
  final jsonString = await rootBundle.loadString('config.json');
  final jsonMap = jsonDecode(jsonString);

  mobileConfig = GrpcConfig.fromJson(jsonMap['mobile']);
  webConfig = GrpcConfig.fromJson(jsonMap['web']);
  tlsCert = jsonMap['TLScert'];
}
