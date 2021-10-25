import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

/// Client channel for non-web platforms
final _channel = ClientChannel('0.0.0.0', port: 3000);

ClientChannelBase getChannel() => _channel;
