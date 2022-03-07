import 'dart:convert';

import 'package:flutter/services.dart';

/// The host and port configuration for the gRPC server
class GrpcMobileConfig {
  final String host;
  final int port;

  const GrpcMobileConfig({required this.host, required this.port});

  GrpcMobileConfig.fromJson(Map json)
      : host = json['host'],
        port = json['port'];
}

class GrpcWebConfig {
  final String url;

  GrpcWebConfig(this.url);

  GrpcWebConfig.fromJson(Map json) : url = json['url'];
}

late GrpcMobileConfig mobileConfig;
late GrpcWebConfig webConfig;

Future<void> readConfig() async {
  final jsonString = await rootBundle.loadString('config.json');
  final jsonMap = jsonDecode(jsonString);

  mobileConfig = GrpcMobileConfig.fromJson(jsonMap['mobile']);
  webConfig = GrpcWebConfig.fromJson(jsonMap['web']);
}
