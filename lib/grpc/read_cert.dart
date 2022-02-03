import 'package:dalal_street_client/config/config.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<int>> readServerCert() async {
  final byte = await rootBundle.load(tlsCert);
  return byte.buffer.asUint8List();
}
