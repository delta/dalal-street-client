import 'package:flutter/services.dart' show rootBundle;

Future<List<int>> readServerCert() async {
  final byte = await rootBundle.load('assets/tls_keys/dev/server.crt');
  return byte.buffer.asUint8List();
}
