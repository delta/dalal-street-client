import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

/// Client channel for web platform
final _webChannel = GrpcWebClientChannel.xhr(Uri.parse('http://0.0.0.0:3000/'));

ClientChannelBase getChannel() => _webChannel;
