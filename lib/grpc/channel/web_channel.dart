import 'package:dalal_street_client/config.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

/// Client channel for web platform
final _webChannel = GrpcWebClientChannel.xhr(Uri.parse(grpcConfig.url));

Future<ClientChannelBase> getChannel() async => _webChannel;
